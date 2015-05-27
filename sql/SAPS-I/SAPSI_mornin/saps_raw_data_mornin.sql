/*
  saps_raw_data_mornin.sql

  Created on   : Oct 2014 by Mornin Feng
  Last updated :
     $Author: Mornin Feng $
     $Date: 2014 Dec 2nd  $
     $Rev: $

 Valid for MIMIC II database schema version 3.0.
 Must run on brp2 server

 Creates the minimum and maximum values for each of the SAPS I
 parameters for each 24hr of each ICUStay for adult patients.

*/

--drop table mornin.v30_sapsi_raw_data;
--create table mornin.v30_sapsi_raw_data as
WITH icustays as (
  select distinct dp.subject_id, icue.icustay_id, dob, intime,-- outtime,
         round(extract (day from intime - dob)/365,3) as age,
         begintime, endtime, seq as icustay_day
    from mimic2v30.icustayevents icue,
         mimic2v30.d_patients dp,
         mimic2v30.icustay_days icu
   where dp.subject_id = icue.subject_id
     and icue.icustay_id = icu.icustay_id
     and (months_between(intime, dp.dob) / 12) >= 15 -- Adults
    -- and dp.subject_id<100
    
)

--select * from icustays;
--select count(distinct icustay_id) from icustays; -- 52524

/**************************************************************************************************/
/***************  age     ********************/
/**************************************************************************************************/
, AgeParams as
(select subject_id
, icustay_id
, icustay_day
, 'AGE' as category
, age as valuenum
from icustays
)

--select * from AgeParams;



/**************************************************************************************************/
/***************   Parameters from chartevents     ********************/
/**************************************************************************************************/


, ChartedParams1 as
  -- Group each c.itemid in meaningful category names
  -- also perform some metric conversion (temperature, etc...)
  (select s.subject_id, 
          --s.hadm_id,
          s.icustay_id,
          s.icustay_day,
          --s.begintime,
          --c.time,
          --s.endtime,
          case
            when c.itemid in (220045, 211) 
              and c.time between s.begintime and s.endtime then 'HR'
            
            when c.itemid in (676, 677, 678, 679, 3652, 3655, 226329, 223761, 223762, 227054) 
              and c.time between s.begintime and s.endtime then 'TEMPERATURE'
            
            when c.itemid in (51, 442, 455, 225309, 220179, 220050, 227243, 224167, 6701, 3313) 
              and c.time between s.begintime and s.endtime then 'SYSABP'  

           when c.itemid in (227013,198,226755)
              and c.time between s.begintime and s.endtime then 'GCS'
              
           when c.itemid in (219, 618, 614, 615, 653,1884, 220210, 3603, 224689, 224690)
              and c.time between s.begintime and s.endtime then 'SPONTANEOUS_RESP'

          end as category,
          case
            when c.itemid in (678, 679, 3652, 227054, 223761) then round((5/9)*(c.value1num-32),3) -- conversion from F to C
            else c.value1num
          end as valuenum
   from icustays s
   join mimic2v30.chartevents c 
     on s.icustay_id = c.icustay_id
   where c.time between s.begintime and s.endtime
     and (
          (c.itemid in (211, 220045) and c.value1num between 10 and 250) --HR
          or 
          (c.itemid in (51, 442, 455, 225309, 220179, 220050, 227243, 224167, 6701, 3313) and c.value1num between 20 and 300) -- SYSABP
          or
          (c.itemid in (676, 677, 3655, 226329, 223762) and c.value1num between 15 and 45) -- TEMP CELSIUS
          or 
          (c.itemid in (678, 679, 3652, 227054, 223761) and (5/9)*(c.value1num-32) between 15 and 45) -- TEMP FARENHEIT
          or 
          (c.itemid in (227013,198,226755) and c.value1num between 2 and 15) -- GCS 198 is the v26 itemid
          or 
          (c.itemid in (219, 618, 614, 615, 653,1884, 220210, 3603, 224689, 224690) and c.value1num between 2 and 80) -- SPONTANEOUS_RESP
          
          
         )
     and c.value1num is not null
  )
--select * from ChartedParams1;

--select count(distinct icustay_id) from ChartedParams1;--50057

-- needs more work

, GCSParams as
(select s.subject_id
, s.icustay_id
--, s.hadm_id
, s.icustay_day
, 'GCS' as category
, gcs.gcs_total as valuenum
--, s.begintime
--, gcs.shifted_time
--, s.endtime
from icustays s
join mornin.gcs_map_mornin gcs
  on gcs.subject_id=s.subject_id 
  and gcs.gcs_total is not null
  and gcs.shifted_time between s.begintime and s.endtime
)

, ChartedParams as
(
select * from ChartedParams1
union
select * from GCSParams
)
--select * from ChartedParams;

--select * from ChartedParams
--union
--select * from AgeParams;

/**************************************************************************************************/
/***************   Ventilation     ********************/
/**************************************************************************************************/
, ventilation1 as
(select distinct s.subject_id
, s.icustay_id
, s.icustay_day
, 'VENTILATION' as category
, 1 as valuenum
--, s.begintime as icu_begintime
--, s.endtime as icu_endtime
--, vent.starttime as startime
--, vent.endtime as endtime
from icustays s 
join lcp_ventilation vent on s.subject_id= vent.subject_id
  and vent.endtime >=vent.starttime+1/24
  and (vent.starttime between s.begintime and s.endtime
  or vent.endtime between s.begintime and s.endtime
  or (vent.starttime<=s.begintime and vent.endtime>=s.endtime))
)

--select * from ventilation;
, VentParams as
(select s.subject_id
, s.icustay_id
, s.icustay_day
, 'VENTILATION' as category
, coalesce(vent.valuenum, 0) as valuenum
from icustays s
left join ventilation1 vent on s.icustay_id = vent.icustay_id and s.icustay_day = vent.icustay_day
)

--select * from ventilation;

--select * from ventilation
--union
--select * from ChartedParams;

/**************************************************************************************************/
/***************   lab variables     ********************/
/**************************************************************************************************/

, LabParams1 as
  -- Group each c.itemid in meaningful category names
  (select distinct s.subject_id, 
          s.icustay_id,
          s.icustay_day,
          case
            when lab.itemid in (51243,50809) then 'HCT'
            when lab.itemid in (51327,51326) then 'WBC'
            when lab.itemid in (50936) then 'GLUCOSE'
            when lab.itemid in (50886,50803,50802) then 'HCO3'
            when lab.itemid in (50976,50821) then 'POTASSIUM'
            when lab.itemid in  (50989,50823) then 'SODIUM'
            when lab.itemid in (51011)  then 'BUN'
            when lab.itemid in (50916) then 'CREATININE'
          end as category,
          lab.valuenum as valuenum
          ,lab.charttime
   from icustays s
   join mimic2v30b.labevents lab 
     on s.subject_id = lab.subject_id
   where 
   --lab.charttime between s.begintime and s.endtime
   lab.charttime <= s.endtime
   and 
     (
          (lab.itemid in (51243,50809) 
          and lab.valuenum between 5 and 80
          ) --HCT --47365 icustay_ids
          or
          (lab.itemid in (51327,51326) and lab.valuenum between 0.1 and 200) --WBC
           or
          (lab.itemid in (50936) and lab.valuenum between 0.5 and 1000) --GLUCOSE
           or
          (lab.itemid in (50886,50803,50802) and lab.valuenum between 2 and 100) --HCO3
           or
          (lab.itemid in (50976,50821) and lab.valuenum between 0.5 and 20) --POTASSIUM
           or
          (lab.itemid in (50989,50823) and lab.valuenum between 50 and 300) --SODIUM
           or
          (lab.itemid in (51011) and lab.valuenum between 1 and 100) --BUN
           or
          (lab.itemid in (50916) and lab.valuenum between 0 and 30) --CREATININE
      )
     and lab.valuenum is not null
  )
  
--select * from LabParams1;

, LabParams as
(select distinct subject_id
, icustay_id
, icustay_day
, category
, first_value(valuenum) over (partition by subject_id, icustay_id, icustay_day, category order by charttime desc) as valuenum
from LabParams1
)

--select * from LabParams order by 1,2,3;

--select count(distinct icustay_id) from LabParams;

--select * from ChartedParams
--union
--select * from LabParams;

/**************************************************************************************************/
/***************   urine output    ********************/
/**************************************************************************************************/

, UrineParams1 as
  -- Group each c.itemid in meaningful category names
  -- also perform some metric conversion (temperature, etc...)
  (select s.subject_id, 
          --s.hadm_id,
          s.icustay_id,         
          s.icustay_day,
          --s.lod,
          case
            when c.charttime between s.begintime and s.endtime then 'URINE'
           end as category,
          c.value volume
          ,c.uom as uom
          , c.itemid
          , c.label
          --, c.starttime
          , c.charttime
   from icustays s
   join mimic2v30.ioevents c 
    on s.icustay_id=c.icustay_id
   where c.charttime between s.begintime and s.endtime
     and 
     
     c.itemid in (40652, 
                  40716, 
                  40056, 
                  40057, 
                  40058, 
                  40062, 
                  40066, 
                  40070, 
                  40086, 
                  40095, 
                  40097, 
                  40289, 
                  40406, 
                  40429, 
                  40474, 
                  42043, 
                  42069, 
                  42112, 
                  42120, 
                  42131, 
                  41923, 
                  42811, 
                  42860, 
                  43054, 
                  43463, 
                  43520, 
                  43176, 
                  42367, 
                  42464, 
                  42508, 
                  42511, 
                  42593, 
                  42677, 
                  43967, 
                  43988, 
                  44133, 
                  44254, 
                  45928,
                  226559,
                  226627,
                  227489,
                  226631) 
     and c.value is not null
    and c.value >=0
     order by 1,2
  )

--select * from UrineParams1 where icustay_id =219;

--select count(distinct icustay_id) from UrineParams;  --45172
  
--select * from UrineParams where icustay_id=1123 and icustay_day=1;

--select * from UrineParams order by icustay_id, starttime;
-- use itemid = 40056 as an example, icustay_id=1123 and icustay_day=1
-- Needs to be updated to 2v30
, UrineParams2 as
  (select distinct subject_id, 
          --hadm_id,
          icustay_id,
          icustay_day,
          category,
          round((sum(volume) over (partition by subject_id, icustay_id, icustay_day))/1000,2) as valuenum 
   from UrineParams1
  )
  
--select * from UrineParams2 order by 1,2,3;

, UrineParams as
(select *
from UrineParams2 where valuenum between 0 and 20
)

--select * from UrineParams;

--select * from ChartedParams
--union
--select * from UrineParams;

/**************************************************************************************************/
/***************   final data   ********************/
/**************************************************************************************************/

, finalTable as
(
select * from AgeParams
union
select * from ChartedParams
union
select * from VentParams
union
select * from LabParams
union
select * from UrineParams
)

select * from finalTable;