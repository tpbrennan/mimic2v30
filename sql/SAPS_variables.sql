drop materialized view tbrennan.saps_variables_mimic2v30;
--create materialized view tbrennan.saps_variables_mimic2v30 as

with all_icustay_days as (

  select icud.subject_id,
          icud.hadm_id,
          icud.icustay_id,
          icud.icu_los,
          idays.seq,
          idays.begintime,
          idays.endtime,
          round(extract(hour from idays.endtime - idays.begintime)+ 
            extract(minute from idays.endtime - idays.begintime)/60,2) lod
   from tbrennan.mimic3_adults icud
   join mimic2v30.icustay_days idays 
      on icud.icustay_id = idays.icustay_id
  order by icustay_id
      
)
--select * from all_icustay_days where lod > 12;
--select count(distinct icustay_id) from all_icustay_days; --50,172 icustays_id

/*
, pivot_begintime as
  (select *
   from (select subject_id, hadm_id, icustay_id, seq, begintime from all_icustay_days) 
     pivot (min(begintime) for seq in ('1' as begintime))
  )
--select * from pivot_begintime;
  
, pivot_endtime as
  (select *
   from (select subject_id, hadm_id, icustay_id, seq, endtime from all_icustay_days) 
     pivot (min(endtime) for seq in ('1' as endtime))
  )
--select * from pivot_endtime;

, icustay_days_in_columns as
  (select b.subject_id,
          b.hadm_id,
          b.icustay_id,
          b.begintime,
          e.endtime
   from pivot_begintime b
   join pivot_endtime e on b.icustay_id=e.icustay_id
  )
--select * from icustay_days_in_columns;
*/

, AgeParams as (
   select s.subject_id, 
          s.hadm_id,
          s.icustay_id,
          s.seq,
          s.lod,
          'AGE' as category,
          d.age_admit valuenum
    from all_icustay_days s
    join tbrennan.mimic3_adults d
      on s.icustay_id = d.icustay_id
    where lod > 12     
)
--select * from AgeParams;

, ChartedParams as
  -- Group each c.itemid in meaningful category names
  -- also perform some metric conversion (temperature, etc...)
  (select s.subject_id, 
          s.hadm_id,
          s.icustay_id,
          s.seq,
          s.lod,
          case
            when c.itemid in (220045, 211) 
              and c.time between s.begintime and s.endtime then 'HR'
            when c.itemid in (676, 677, 678, 679, 227054, 223762, 223761) 
              and c.time between s.begintime and s.endtime then 'TEMPERATURE'
            when c.itemid in (51, 455, 225309, 2293) 
              and c.time between s.begintime and s.endtime then 'SYSABP'  -- Invasive/noninvasive BP
            when c.itemid in (781,225624,1162,3737,227000,5876,227001) 
              and c.time between s.begintime and s.endtime then 'BUN'
            when c.itemid in (227013,198,226755)
              and c.time between s.begintime and s.endtime then 'GCS'
          end as category,
          case
            when c.itemid in (678, 679, 227054, 223761) then (5/9)*(c.value1num-32)
            else c.value1num
          end as valuenum
   from all_icustay_days s
   join mimic2v30.chartevents c 
     on s.icustay_id = c.icustay_id
   where c.time between s.begintime and s.endtime
     and ((c.itemid in (211) and c.value1num between 10 and 250)
          or (c.itemid in (676, 677, 223762) and c.value1num between 15 and 45)
          or (c.itemid in (678, 679, 223761, 227054) and (5/9)*(c.value1num-32) between 15 and 45)
          or (c.itemid in (51,455,225309, 2293) and c.value1num between 20 and 300)
          or (c.itemid in (781,225624,1162,3737,227000,5876,227001) and c.value1num between 1 and 100)   
          or (c.itemid in (227013,198,226755) and c.value1num between 2 and 15)
         )
     and c.value1num is not null
     and lod > 12
  )
--select * from ChartedParams;

, LabParams as
  -- Group each c.itemid in meaningful category names
  -- also perform some metric conversion (temperature, etc...)
  (select s.subject_id, 
          s.hadm_id,
          s.icustay_id,
          s.seq,
          s.lod,
          case
            when c.itemid in (50383,50029)
              and c.charttime between s.begintime and s.endtime then 'HCT'
            when c.itemid in (51326,50468,50316) 
              and c.charttime between s.begintime and s.endtime then 'WBC'
            when c.itemid in (50112,50936,50006) 
              and c.charttime between s.begintime and s.endtime then 'GLUCOSE'  
            when c.itemid in (50803,50022,50172,50025) 
              and c.charttime between s.begintime and s.endtime then 'HCO3'
            when c.itemid in (50009,50821,50976,50149)  
              and c.charttime between s.begintime and s.endtime then 'POTASSIUM'
            when c.itemid in (50989,50823,50159,50012) 
              and c.charttime between s.begintime and s.endtime then 'SODIUM'
            when c.itemid in (51011,50177) 
              and c.charttime between s.begintime and s.endtime then 'BUN'
            when c.itemid in (50090,50916) 
              and c.charttime between s.begintime and s.endtime then 'CREATININE'
          end as category,
          valuenum
   from all_icustay_days s
   join mimic2v30.labevents c 
     on s.icustay_id = c.icustay_id
   where c.charttime between s.begintime and s.endtime
   and ((c.itemid in (50383,50029) -- 'HCT'
          and c.valuenum between 5 and 100) -- 0 <> 390
        or (c.itemid in (51326,50468,50316) -- 'WBC'
          and c.valuenum*1000 between 5 and 2000000) -- 0 <> 1,250,000
        or (c.itemid in (50112,50936,50006)-- 'GLUCOSE'  
          and c.valuenum between 0.5 and 1000) -- -251 <> 3555
        or (c.itemid in (50803,50022,50172,50025)--'HCO3'
          and c.valuenum between 2 and 100) -- 0 <> 231
        or (c.itemid in (50009,50821,50976,50149)-- 'POTASSIUM'
          and c.valuenum between 0.5 and 70) -- 0.7	<> 52
        or (c.itemid in (50989,50823,50159,50012)-- 'SODIUM'
          and c.valuenum between 50 and 300) -- 1.07 <>	1332
        or (c.itemid in (51011,50177) -- 'BUN'
          and c.valuenum between 1 and 100) -- 0 <> 280
        or (c.itemid in (50090,50916) -- 'CREATININE'
          and c.valuenum between 0 and 30) -- 0	<> 73
     )
     and c.valuenum is not null
     and lod > 12
  )
--select * from LabParams;

, UrineParams as
  -- Group each c.itemid in meaningful category names
  -- also perform some metric conversion (temperature, etc...)
  (select s.subject_id, 
          s.hadm_id,
          s.icustay_id,         
          s.seq,
          s.lod,
          case
            when c.charttime between s.begintime and s.endtime then 'URINE'
           end as category,
          c.value volume
   from all_icustay_days s
   join mimic2v30.ioevents c 
    on s.icustay_id=c.icustay_id
   where c.charttime between s.begintime and s.endtime
     and c.itemid in ( 40056,40057,40058,40070,40086,40095,40097,40097,40406,
      40429,40474,40535,40652,40716,41923,42367,42508,42511,42677,42811,42860,43054,46181 )
     and c.value is not null   
     and lod > 12
  )
--select * from UrineParams;

-- Needs to be updated to 2v30
, daily_urine as
  (select distinct subject_id, 
          hadm_id,
          icustay_id, 
          seq,
          lod,
          category,
          sum(volume) over (partition by subject_id, hadm_id, icustay_id) valuenum 
   from UrineParams
  )
--select * from daily_urine;

, VentilatedRespParams as (
  select distinct s.subject_id,
         s.hadm_id,
         s.icustay_id,
         s.seq,
         s.lod,
         case
           when c.itemid in (38,39,40,141,444,535,543,544,545,619,639,654,681,682,
     683,684,720,721,722,732,1209,1651,1660,1672,1864,1865,2049,2065,2069,
     2400,2402,2420,2534,2988,3003,3050,3083,3605,3681,3689,5593,20002,224684,
     224685,224686,224688,224689,224695,224696,224697,227565,227566) then 'VENTILATED_RESP'
           --when p.starttime between s.begintime and s.endtime then 'VENTILATED_RESP'
         end as category,          
         case
           when c.itemid in (38,39,40,141,444,535,543,544,545,619,639,654,681,682,
     683,684,720,721,722,732,1209,1651,1660,1672,1864,1865,2049,2065,2069,
     2400,2402,2420,2534,2988,3003,3050,3083,3605,3681,3689,5593,20002,224684,
     224685,224686,224688,224689,224695,224696,224697,227565,227566) then 1 
     else 0 
     end as valuenum   -- force invalid number
    from all_icustay_days s
    join mimic2v30.chartevents c on s.icustay_id=c.icustay_id
    --join mimic2v30.procedureevents p on s.hadm_id=p.hadm_id
    where (c.time between s.begintime and s.endtime
     --and c.itemid in (543, 544, 545, 619, 39, 535, 683, 720, 721, 722, 732)
     and c.itemid in (38,39,40,141,444,535,543,544,545,619,639,654,681,682,
     683,684,720,721,722,732,1209,1651,1660,1672,1864,1865,2049,2065,2069,
     2400,2402,2420,2534,2988,3003,3050,3083,3605,3681,3689,5593,20002,224684,
     224685,224686,224688,224689,224695,224696,224697,227565,227566))
    -- or (p.starttime between s.begintime and s.endtime and lower(p.label) like 'Intubation')
     and lod > 12
)
--select * from VentilatedRespParams;

, SpontaneousRespParams as (
  -- Group each c.itemid in meaninful category names
  -- also performin some metric conversion (temperature, etc...)
  select distinct s.subject_id, 
         s.hadm_id,
         s.icustay_id,    
         s.seq,
         s.lod,
         case
           when c.time between s.begintime and s.endtime then 'SPONTANEOUS_RESP'
         end as category,         
         c.value1num as valuenum
    from all_icustay_days s
    join mimic2v30.chartevents c 
      on s.icustay_id=c.icustay_id
   where c.time between s.begintime and s.endtime
     and (c.itemid in (220210,618,653,3603,219,1635,8113,1884,615) and c.value1num between 2 and 80)     
     and c.value1num is not null
     and lod > 12
)
--select * from SpontaneousRespParams;

, all_params as
  (select * from AgeParams
   union
   select * from ChartedParams
   union
   select * from LabParams
   union
   select * from daily_urine
   union
   select * from VentilatedRespParams
   union
   select * from SpontaneousRespParams
  )
select * from all_params;

