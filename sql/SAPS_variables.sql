--create materialized view raw_saps_variables as

with all_icustay_days as
  (select icud.subject_id,
          icud.hadm_id,
          icud.icustay_id,
          idays.seq,
          idays.begintime,
          idays.endtime
   from tbrennan.mimic3_adults icud
   join mimic2v30.icustay_days idays 
      on icud.
   where icud.icustay_los > 3
     and idays.seq <= 3
--     and icud.subject_id < 100
  )
--select * from all_icustay_days;

, pivot_begintime as
  (select *
   from (select subject_id, hadm_id, icustay_id, seq, begintime from all_icustay_days) 
     pivot (min(begintime) for seq in ('1' as begintime_day1))
  )
--select * from pivot_begintime;
  
, pivot_endtime as
  (select *
   from (select subject_id, hadm_id, icustay_id, seq, endtime from all_icustay_days) 
     pivot (min(endtime) for seq in ('1' as endtime_day1))
  )
--select * from pivot_endtime;

, icustay_days_in_columns as
  (select b.subject_id,
          b.hadm_id,
          b.icustay_id,
          b.begintime_day1,
          e.endtime_day1
   from pivot_begintime b
   join pivot_endtime e on b.icustay_id=e.icustay_id
  )
--select * from icustay_days_in_columns;

, ChartedParams as
  -- Group each c.itemid in meaningful category names
  -- also perform some metric conversion (temperature, etc...)
  (select s.subject_id, 
          s.hadm_id,
          s.icustay_id,         
          case
            when c.itemid in (211) and c.charttime between s.begintime_day1 and s.endtime_day1 then 'HR_day1'
            when c.itemid in (676, 677, 678, 679) and c.charttime between s.begintime_day1 and s.endtime_day1 then 'TEMPERATURE_day1'
            when c.itemid in (51, 455) and c.charttime between s.begintime_day1 and s.endtime_day1 then 'SYSABP_day1'  -- Invasive/noninvasive BP
            when c.itemid in (781) and c.charttime between s.begintime_day1 and s.endtime_day1 then 'BUN_day1'
          end as category,
          case
            when c.itemid in (678, 679) then (5/9)*(c.value1num-32)
            else c.value1num
          end as valuenum
   from icustay_days_in_columns s
   join mimic2v26.chartevents c on s.icustay_id=c.icustay_id
   where c.charttime between s.begintime_day1 and s.endtime_day1
     and ((c.itemid in (211) and c.value1num between 10 and 250)
          or (c.itemid in (676, 677) and c.value1num between 15 and 45)
          or (c.itemid in (678, 679) and (5/9)*(c.value1num-32) between 15 and 45)
          or (c.itemid in (51,455) and c.value1num between 20 and 300)
          or (c.itemid in (781) and c.value1num between 1 and 100)          
         )
     and c.value1num is not null
  )
select * from ChartedParams;

, LabParams as
  -- Group each c.itemid in meaningful category names
  -- also perform some metric conversion (temperature, etc...)
  (select s.subject_id, 
          s.hadm_id,
          s.icustay_id,         
          case
            when c.itemid in (50383) and c.charttime between s.begintime_day1 and s.endtime_day1 then 'HCT_day1'
            when c.itemid in (50316, 50468) and c.charttime between s.begintime_day1 and s.endtime_day1 then 'WBC_day1'
            when c.itemid in (50006, 50112) and c.charttime between s.begintime_day1 and s.endtime_day1 then 'GLUCOSE_day1'  
            when c.itemid in (50022, 50025, 50172) and c.charttime between s.begintime_day1 and s.endtime_day1 then 'HCO3_day1'
            when c.itemid in (50009, 50149) and c.charttime between s.begintime_day1 and s.endtime_day1 then 'POTASSIUM_day1'
            when c.itemid in (50012, 50159) and c.charttime between s.begintime_day1 and s.endtime_day1 then 'SODIUM_day1'
            when c.itemid in (50177) and c.charttime between s.begintime_day1 and s.endtime_day1 then 'BUN_day1'
            when c.itemid in (50090) and c.charttime between s.begintime_day1 and s.endtime_day1 then 'CREATININE_day1'
          end as category,
          valuenum
   from icustay_days_in_columns s
   join mimic2v26.labevents c on s.icustay_id=c.icustay_id
   where c.charttime between s.begintime_day1 and s.endtime_day1
     and ((c.itemid in (50383) and c.valuenum between 5 and 80)
          or (c.itemid in (50316, 50468) and c.valuenum*1000 between 100 and 200000)
          or (c.itemid in (50006, 50112) and c.valuenum between 0.5 and 1000)
          or (c.itemid in (50022, 50025, 50172) and c.valuenum between 2 and 100)
          or (c.itemid in (50009, 50149) and c.valuenum between 0.5 and 20)
          or (c.itemid in (50012, 50159) and c.valuenum between 50 and 300)
          or (c.itemid in (50177) and c.valuenum between 1 and 100)
          or (c.itemid in (50090) and c.valuenum between 0 and 30)
         )
     and c.valuenum is not null
  )
--select * from LabParams;

, UrineParams as
  -- Group each c.itemid in meaningful category names
  -- also perform some metric conversion (temperature, etc...)
  (select s.subject_id, 
          s.hadm_id,
          s.icustay_id,         
          case
            when c.charttime between s.begintime_day1 and s.endtime_day1 then 'URINE_day1'
           end as category,
          c.volume
   from icustay_days_in_columns s
   join mimic2v26.ioevents c on s.icustay_id=c.icustay_id
   where c.charttime between s.begintime_day1 and s.endtime_day1
     and c.itemid in ( 651, 715, 55, 56, 57, 61, 65, 69, 85, 94, 96, 288, 405, 428, 473, 2042, 2068, 2111, 2119, 2130, 1922, 2810, 2859, 3053, 3462, 3519, 3175, 2366, 2463, 2507, 2510, 2592, 2676, 3966, 3987, 4132, 4253, 5927 )         
     and c.volume is not null   
  )
--select * from UrineParams;

, daily_urine as
  (select subject_id, 
          hadm_id,
          icustay_id, 
          category,
          sum(volume) as valuenum
   from UrineParams
   group by subject_id, hadm_id, icustay_id, category
  )
--select * from daily_urine;

, VentilatedRespParams as (
  select s.subject_id,
         s.hadm_id,
         s.icustay_id,
         case
           when c.charttime between s.begintime_day1 and s.endtime_day1 then 'VENTILATED_RESP_day1'
         end as category,          
         -1 as valuenum   -- force invalid number
    from icustay_days_in_columns s
    join mimic2v26.chartevents c on s.icustay_id=c.icustay_id
   where c.charttime between s.begintime_day1 and s.endtime_day1
     and c.itemid in (543, 544, 545, 619, 39, 535, 683, 720, 721, 722, 732)
)
--select * from VentilatedRespParams;

, SpontaneousRespParams as (
  -- Group each c.itemid in meaninful category names
  -- also performin some metric conversion (temperature, etc...)
  select s.subject_id, 
         s.hadm_id,
         s.icustay_id,    
         case
           when c.charttime between s.begintime_day1 and s.endtime_day1 then 'SPONTANEOUS_RESP_day1'
         end as category,         
         c.value1num as valuenum
    from icustay_days_in_columns s
    join mimic2v26.chartevents c on s.icustay_id=c.icustay_id
   where c.charttime between s.begintime_day1 and s.endtime_day1
     and (c.itemid in (219, 615, 618) and c.value1num between 2 and 80)     
     and c.value1num is not null
)
--select * from SpontaneousRespParams;

, all_params as
  (select * from ChartedParams
   union
   select * from LabParams
   union
   select * from daily_urine
   union
   select * from VentilatedRespParams
   union
   select * from SpontaneousRespParams
  )
--select * from all_params;

, pivot_final_data as
  (select *
   from (select * from all_params) 
     pivot (avg(valuenum) for category in   -- taking average values per day
      ('HR_day1' as HR_day1, 
       'TEMPERATURE_day1' as TEMPERATURE_day1,
       'SYSABP_day1' as SYSABP_day1,
       'BUN_day1' as BUN_day1,
       'HCT_day1' as HCT_day1,
       'WBC_day1' as WBC_day1,
       'GLUCOSE_day1' as GLUCOSE_day1,
       'HCO3_day1' as HCO3_day1,
       'POTASSIUM_day1' as POTASSIUM_day1,
       'SODIUM_day1' as SODIUM_day1,
       'CREATININE_day1' as CREATININE_day1,
       'URINE_day1' as URINE_day1,
       'VENTILATED_RESP_day1' as VENTILATED_RESP_day1,
       'SPONTANEOUS_RESP_day1' as SPONTANEOUS_RESP_day1,
      ))  
  )
select * from pivot_final_data;


