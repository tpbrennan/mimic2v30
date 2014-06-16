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
   from tbrennan.mimic3_admits icud
   join mimic2v30.icustay_days idays 
      on icud.icustay_id = idays.icustay_id
  order by subject_id,icustay_id,seq
      
)
--select * from all_icustay_days;
--select count(distinct icustay_id) from all_icustay_days; --50,172 icustays_id



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
            
            when c.itemid in (676, 677, 678, 679, 3652, 3655, 226329, 223761, 223762, 227054) 
              and c.time between s.begintime and s.endtime then 'TEMPERATURE'
            
            when c.itemid in (51, 442, 455, 225309, 220179, 220050, 227243, 224167, 6701, 3313) 
              and c.time between s.begintime and s.endtime then 'SYSABP'  

            when c.itemid in (227013,198,226755)
              and c.time between s.begintime and s.endtime then 'GCS'

/*            
            when c.itemid in (813, 220545, 226540, 3761)
              and c.time between s.begintime and s.endtime then 'HCT'
            
            when c.itemid in (220546, 1542, 1127, 861, 4200)
              and c.time between s.begintime and s.endtime then 'WBC'
            
            when c.itemid in (807, 811, 1529, 225664, 220621, 226537, 3745, 3744, 1310, 1455, 2338) 
              and c.time between s.begintime and s.endtime then 'GLUCOSE'  
            
            when c.itemid in (3808, 3809, 3810, 4199, 223679, 225698, 227443) 
              and c.time between s.begintime and s.endtime then 'HCO3'
  
            when c.itemid in (829, 1535, 3792, 3725, 4194, 227442, 227464)  
              and c.time between s.begintime and s.endtime then 'POTASSIUM'
  
            when c.itemid in (837, 1536, 3726, 3803, 220645, 226534)
              and c.time between s.begintime and s.endtime then 'SODIUM'
  
            when c.itemid in (781, 1162, 3737, 225624) 
              and c.time between s.begintime and s.endtime then 'BUN'
  
            when c.itemid in (791, 1525, 3750, 220615) 
              and c.time between s.begintime and s.endtime then 'CREATININE'
*/

          end as category,
          case
            when c.itemid in (678, 679, 3652, 227054, 223761) then (5/9)*(c.value1num-32)
            else c.value1num
          end as valuenum
   from all_icustay_days s
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
          (c.itemid in (227013,198,226755) and c.value1num between 2 and 15) -- GCS
/*
          or 
          (c.itemid in (813, 220545, 226540, 3761) and c.value1num between 5 and 100) -- HCT
          or
          (c.itemid in (220546, 1542, 1127, 861, 4200) and c.value1num between 0 and 1000000) -- WBC
          or
          (c.itemid in (3808, 3809, 3810, 4199, 223679, 225698, 227443) and c.value1num between 2 and 100) --'HCO3'
          or
          (c.itemid in (807, 811, 1529, 225664, 220621, 226537, 3745, 3744, 1310, 1455, 2338) and c.value1num between 0.5 and 1000) -- 'GLUCOSE'  
          or
          (c.itemid in (829, 1535, 3792, 3725, 4194, 227442, 227464) and c.value1num between 0.5 and 70)-- 'POTASSIUM'
          or
          (c.itemid in (837, 1536, 3726, 3803, 220645, 226534) and c.value1num between 50 and 300) -- 'SODIUM'
          or
          (c.itemid in (781, 1162, 3737, 225624) and c.value1num between 1 and 100) -- BUN
          or
          (c.itemid in (791, 1525, 3750, 220615) and c.value1num between 0 and 30) -- CREATININE
*/
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
          s.seq,
          s.lod,
          case
            when c.itemid in (50383,51243,50029,50809)
              and c.charttime between s.begintime and s.endtime then 'HCT'
              
            when c.itemid in (50468,51327,50316,51326)
              and c.charttime between s.begintime and s.endtime then 'WBC'
              
            when c.itemid in (50112, 50936, 50006)
              and c.charttime between s.begintime and s.endtime then 'GLUCOSE'  
              
            when c.itemid in (50172,50025,50886,50803,50022,50802) 
              and c.charttime between s.begintime and s.endtime then 'HCO3'
              
            when c.itemid in  (50149,50976) 
              and c.charttime between s.begintime and s.endtime then 'POTASSIUM'
              
            when c.itemid in (50159, 50989) 
              and c.charttime between s.begintime and s.endtime then 'SODIUM'
            
            when c.itemid in (50177,51011) 
              and c.charttime between s.begintime and s.endtime then 'BUN'
            
            when c.itemid in (50090, 50916)
              and c.charttime between s.begintime and s.endtime then 'CREATININE'
          end as category,
          valuenum
          
   from all_icustay_days s
   join mimic2v30.labevents c 
     on s.icustay_id = c.icustay_id
   where c.charttime between s.begintime and s.endtime
 
   and ((c.itemid in (50383,51243,50029,50809) -- 'HCT'
          and c.valuenum between 5 and 100) -- 0 <> 390
 
        or (c.itemid in  (50468,51327,50316,51326) -- 'WBC' 
          and c.valuenum between 5 and 1000000) -- 0 <> 1,250,000
 
        or (c.itemid in (50112, 50936, 50006) -- 'GLUCOSE'  
          and c.valuenum between 0.5 and 1000) -- -251 <> 3555
 
        or (c.itemid in (50172,50025,50886,50803,50022,50802)--'HCO3'
          and c.valuenum between 2 and 100) -- 0 <> 231
 
        or (c.itemid in (50149,50976) -- 'POTASSIUM'
          and c.valuenum between 0.5 and 70) -- 0.7	<> 52
 
        or (c.itemid in (50159, 50989)-- 'SODIUM'
          and c.valuenum between 50 and 300) -- 1.07 <>	1332
 
        or (c.itemid in (50177,51011) -- 'BUN'
          and c.valuenum between 1 and 100) -- 0 <> 280
        
        or (c.itemid in (50090, 50916) -- 'CREATININE'
          and c.valuenum between 0 and 30) -- 0	<> 73
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
     and c.itemid in (40056,226559,43176,40070,40095,40066,40062,
40716,40474,40086,40058,40057,227489,40406,40289,40429,226631,40097,43172,
43374,40652,40652,45928,44205,43432,43523,42508,44168,42523,43590,42811,
44758,43538,42043,42677,43967,43463,43655,42120,42363,43381,43366,43366,
42860,42464,44133,42367,44685,44926,43520,43349,43356,42131,43380,43380,
45305,45305,41923,44753,40535,43812,43174,43577,43373,43375,43054,44254,
43634,45842,43334,43857,43348,43988,46181,44707,43639,46178,42069,43813)
     and c.value is not null   
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
           when c.itemid in (1209,141,14138,1651,1660,1672,1864,1865,20002,2049,
           2065,2069,224417,224684,224685,224686,224688,224689,224695,224696,224697,
           227565,227566,2400,2402,2420,2534,2988,3003,3050,3083,3605,3681,3689,38,
           39,40,444,535,543,544,545,5593,619,639,654,681,682,683,684,720,721,722,732)
         then 'VENTILATED_RESP'
         end as category,          
        
        case
           when c.itemid in (1209,141,14138,1651,1660,1672,1864,1865,20002,2049,
           2065,2069,224417,224684,224685,224686,224688,224689,224695,224696,224697,
           227565,227566,2400,2402,2420,2534,2988,3003,3050,3083,3605,3681,3689,38,
           39,40,444,535,543,544,545,5593,619,639,654,681,682,683,684,720,721,722,732)
        then 1 else 0 
        end as valuenum   -- force invalid number
     
    from all_icustay_days s
    join mimic2v30.chartevents c on s.icustay_id=c.icustay_id
    --join mimic2v30.procedureevents p on s.hadm_id=p.hadm_id
    where (
      c.time between s.begintime and s.endtime
      and c.itemid in (1209,141,14138,1651,1660,1672,1864,1865,20002,2049,
           2065,2069,224417,224684,224685,224686,224688,224689,224695,224696,224697,
           227565,227566,2400,2402,2420,2534,2988,3003,3050,3083,3605,3681,3689,38,
           39,40,444,535,543,544,545,5593,619,639,654,681,682,683,684,720,721,722,732))
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
     and (c.itemid in (219, 618, 614, 619, 615, 220210, 3603, 224689, 224690, 224688) and c.value1num between 2 and 80)     
     and c.value1num is not null
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

