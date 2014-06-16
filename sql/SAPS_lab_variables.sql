drop materialized view tbrennan.saps_labvars_mimic2v30;
--create materialized view tbrennan.saps_labvars_mimic2v30 as

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


, LabParams as
  -- Group each c.itemid in meaningful category names
  -- also perform some metric conversion (temperature, etc...)
  (select s.subject_id, 
          s.hadm_id,
          s.icustay_id,
          s.seq,
          s.lod,
          case
            when c.itemid in (51243,50809)
              and c.charttime between s.begintime and s.endtime then 'HCT'
              
            when c.itemid in (51327,51326)
              and c.charttime between s.begintime and s.endtime then 'WBC'
              
            when c.itemid in (50936)
              and c.charttime between s.begintime and s.endtime then 'GLUCOSE'  
              
            when c.itemid in (50886,50803,50802) 
              and c.charttime between s.begintime and s.endtime then 'HCO3'
              
            when c.itemid in  (50976,50821) 
              and c.charttime between s.begintime and s.endtime then 'POTASSIUM'
              
            when c.itemid in (50989,50823) 
              and c.charttime between s.begintime and s.endtime then 'SODIUM'
            
            when c.itemid in (51011) 
              and c.charttime between s.begintime and s.endtime then 'BUN'
            
            when c.itemid in (50916)
              and c.charttime between s.begintime and s.endtime then 'CREATININE'
          end as category,
          value
          
   from all_icustay_days s
   join mimic2v30.labevents c on s.subject_id = c.subject_id
   where c.charttime between s.begintime and s.endtime
 
   and ((c.itemid in (51243,50809) -- 'HCT'
          and c.value between 5 and 100) -- 0 <> 390
 
        or (c.itemid in  (51327,51326) -- 'WBC' 
          and c.value between 5 and 1000000) -- 0 <> 1,250,000
 
        or (c.itemid in (50936) -- 'GLUCOSE'  
          and c.value between 0.5 and 1000) -- -251 <> 3555
 
        or (c.itemid in (50886,50803,50802)--'HCO3'
          and c.value between 2 and 100) -- 0 <> 231
 
        or (c.itemid in (50976,50821) -- 'POTASSIUM'
          and c.value between 0.5 and 70) -- 0.7	<> 52
 
        or (c.itemid in (50989,50823)-- 'SODIUM'
          and c.value between 50 and 300) -- 1.07 <>	1332
 
        or (c.itemid in (51011) -- 'BUN'
          and c.value between 1 and 100) -- 0 <> 280
        
        or (c.itemid in (50916) -- 'CREATININE'
          and c.value between 0 and 30) -- 0	<> 73
     )
     and c.value is not null
  )
--select * from LabParams;

, all_params as
  (select * from LabParams )
select * from all_params;

