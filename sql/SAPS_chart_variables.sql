drop materialized view tbrennan.saps_chartvars_mimic2v30;
create materialized view tbrennan.saps_chartvars_mimic2v30 as

with AgeParams as (
   select s.subject_id, 
          s.hadm_id,
          s.icustay_id,
          s.seq,
          s.lod,
          'AGE' as category,
          d.age_admit valuenum
    from tbrennan.mimic2v30_days s
    join tbrennan.mimic2v30_admits d
      on s.subject_id = d.subject_id
     and s.icustay_id = d.icustay_id
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

          end as category,
          case
            when c.itemid in (678, 679, 3652, 227054, 223761) then (5/9)*(c.value1num-32) -- conversion from F to C
            else c.value1num
          end as valuenum
   from tbrennan.mimic2v30_days s
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
         )
     and c.value1num is not null
  )
--select * from ChartedParams;





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
   from tbrennan.mimic2v30_days s
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
     
    from tbrennan.mimic2v30_days s
    join mimic2v30.chartevents c on s.icustay_id=c.icustay_id
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
    from tbrennan.mimic2v30_days s
    join mimic2v30.chartevents c 
      on s.icustay_id=c.icustay_id
   where c.time between s.begintime and s.endtime
     and (c.itemid in (618, 614, 615, 653,1884, 220210, 3603, 224689, 224690)
     and c.value1num between 2 and 100)     
     and c.value1num is not null
)
--select * from SpontaneousRespParams;






, all_chart_params as
  (select * from AgeParams
   union
   select * from ChartedParams
   union
   select * from daily_urine
   union
   select * from VentilatedRespParams
   union
   select * from SpontaneousRespParams
  )
select * from all_chart_params;

