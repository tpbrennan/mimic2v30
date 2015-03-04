/*
  saps_create_24hr_minmax.sql

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
--create materialized view sapsi_icustays as
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
     --and dp.subject_id<1000
    
)

--select * from icustays;
--select count(distinct icustay_id) from icustays; -- 52524


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
  and gcs.shifted_time between s.begintime and s.endtime
)

--select * from ChartedParams1
--union
--select * from GCSParams;


, UrineParams as
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
     
     c.itemid in (40056,226559,43176,40070,40095,
40716,40474,40086,40058,40057,40429,40097,40652,40652,45928,44205,42508,42811,
44758,42043,42677,43967,43463,42120,42363,
42860,42464,44133,42367,44926,43520,42131,41923,43054,44254,46181,44707,46178,42766, 46749, 42593, 43058, 46805, 45968, 42511, 44507)
--     
--     c.itemid in (40056,226559,43176,40070,40095,40066,40062,
--40716,40474,40086,40058,40057,227489,40406,40289,40429,226631,40097,43172,
--43374,40652,40652,45928,44205,43432,43523,42508,44168,42523,43590,42811,
--44758,43538,42043,42677,43967,43463,43655,42120,42363,43381,43366,43366,
--42860,42464,44133,42367,44685,44926,43520,43349,43356,42131,43380,43380,
--45305,45305,41923,44753,40535,43812,43174,43577,43373,43375,43054,44254,
--43634,45842,43334,43857,43348,43988,46181,44707,43639,46178,42069,43813)
     and c.value is not null
    and c.value <2000
     
  )

--select count(distinct icustay_id) from UrineParams;  --45172
  
--select * from UrineParams where icustay_id=1123 and icustay_day=1;

--select * from UrineParams order by icustay_id, starttime;
-- use itemid = 40056 as an example, icustay_id=1123 and icustay_day=1
-- Needs to be updated to 2v30
, daily_urine as
  (select distinct subject_id, 
          --hadm_id,
          icustay_id,
          icustay_day,
          --seq,
          --lod,
          category,
          sum(volume) over (partition by subject_id, icustay_id, icustay_day) as valuenum 
   from UrineParams
  )
  
select * from daily_urine where valuenum=13010;
select max(valuenum), median(valuenum) from daily_urine order by 2;