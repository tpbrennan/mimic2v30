drop materialized view tbrennan.saps_labvars_mimic2v30;
create materialized view tbrennan.saps_labvars_mimic2v30 as


with hct as (

select s.subject_id, 
          s.hadm_id,
          s.icustay_id,
          s.seq,
          s.lod,
          case when c.itemid in (51243,50809)
              and c.charttime between s.begintime and s.endtime then 'HCT' 
          end as category,
          to_number(value) valuenum
   from tbrennan.mimic2v30_days s
   join mimic2v30.labevents c on s.subject_id = c.subject_id
   where c.charttime between s.begintime and s.endtime
   and c.itemid in (51243,50809)
   and c.value is not null
   and length(trim(translate(c.value,' -.0123456789',' '))) is null

)
--select * from hct;
          
, wbc as (

select s.subject_id, 
          s.hadm_id,
          s.icustay_id,
          s.seq,
          s.lod,
          case when c.itemid in (51327,51326)
              and c.charttime between s.begintime and s.endtime then 'WBC' 
          end as category,
          to_number(value) valuenum
   from tbrennan.mimic2v30_days s
   join mimic2v30.labevents c on s.subject_id = c.subject_id
   where c.charttime between s.begintime and s.endtime
   and c.itemid in (51327,51326)
   and c.value is not null
   and length(trim(translate(c.value,' -.0123456789',' '))) is null

)
--select * from wbc;        
              

, glucose as (
select s.subject_id, 
          s.hadm_id,
          s.icustay_id,
          s.seq,
          s.lod,
          case when c.itemid in (50936)
              and c.charttime between s.begintime and s.endtime then 'GLUCOSE' 
          end as category,
          to_number(value) valuenum
   from tbrennan.mimic2v30_days s
   join mimic2v30.labevents c on s.subject_id = c.subject_id
   where c.charttime between s.begintime and s.endtime
   and c.itemid in (50936)
   and c.value is not null
   and length(trim(translate(c.value,' -.0123456789',' '))) is null

)
--select * from glucose; 

, hco3 as (
select s.subject_id, 
          s.hadm_id,
          s.icustay_id,
          s.seq,
          s.lod,
          case when c.itemid in (50886,50803,50802)
              and c.charttime between s.begintime and s.endtime then 'HCO3' 
          end as category,
          to_number(value) valuenum
   from tbrennan.mimic2v30_days s
   join mimic2v30.labevents c on s.subject_id = c.subject_id
   where c.charttime between s.begintime and s.endtime
   and c.itemid in (50886,50803,50802)
   and c.value is not null
   and length(trim(translate(c.value,' -.0123456789',' '))) is null

)
--select * from hco3;

, potassium as (
select s.subject_id, 
          s.hadm_id,
          s.icustay_id,
          s.seq,
          s.lod,
          case when c.itemid in (50976,50821)
              and c.charttime between s.begintime and s.endtime then 'POTASSIUM' 
          end as category,
          to_number(value) valuenum
   from tbrennan.mimic2v30_days s
   join mimic2v30.labevents c on s.subject_id = c.subject_id
   where c.charttime between s.begintime and s.endtime
   and c.itemid in (50976,50821)
   and c.value is not null
   and length(trim(translate(c.value,' -.0123456789',' '))) is null
)
--select * from potassium;
  

, sodium as (
select s.subject_id, 
          s.hadm_id,
          s.icustay_id,
          s.seq,
          s.lod,
          case when c.itemid in (50989,50823)
              and c.charttime between s.begintime and s.endtime then 'SODIUM' 
          end as category,
          to_number(value) valuenum
   from tbrennan.mimic2v30_days s
   join mimic2v30.labevents c on s.subject_id = c.subject_id
   where c.charttime between s.begintime and s.endtime
   and c.itemid in (50989,50823)
   and c.value is not null
   and length(trim(translate(c.value,' -.0123456789',' '))) is null
   
)
--select * from sodium;
  
  
, bun as (
select s.subject_id, 
          s.hadm_id,
          s.icustay_id,
          s.seq,
          s.lod,
          case when c.itemid in (51011)
              and c.charttime between s.begintime and s.endtime then 'BUN' 
          end as category,
          to_number(value) valuenum
   from tbrennan.mimic2v30_days s
   join mimic2v30.labevents c on s.subject_id = c.subject_id
   where c.charttime between s.begintime and s.endtime
   and c.itemid in (51011)
   and c.value is not null
   and length(trim(translate(c.value,' -.0123456789',' '))) is null
   
)
--select * from bun;

, creatinine as (
select s.subject_id, 
          s.hadm_id,
          s.icustay_id,
          s.seq,
          s.lod,
          case when c.itemid in (50916)
              and c.charttime between s.begintime and s.endtime then 'CREATININE' 
          end as category,
          to_number(value) valuenum
   from tbrennan.mimic2v30_days s
   join mimic2v30.labevents c on s.subject_id = c.subject_id
   where c.charttime between s.begintime and s.endtime
   and c.itemid in (50916)
   and c.value is not null
   and length(trim(translate(c.value,' -.0123456789',' '))) is null
   
)
--select * from creatinine;

           
, assemble as (
    select * from hct
    union
    select * from wbc
    union
    select * from glucose
    union
    select * from hco3
    union 
    select * from potassium
    union 
    select * from potassium
)
select * from assemble;
where 
  (category = 'HCT' and valuenum between 5 and 100)
  or
  (category = 'WBC' and valuenum between 5 and 1000000)
  or
  (category = 'GLUCOSE' and valuenum between 0.5 and 1000)
  or
  (category = 'HCO3' and valuenum  between 2 and 100)
  or 
  (category = 'POTASSIUM' and valuenum  between 0.5 and 70)
  or
  (category = 'SODIUM' and valuenum between 50 and 300) 
  or 
  (category = 'BUN' and valuenum between 1 and 100) 
  or 
  (category = 'CREATININE' and valuenum between 0 and 30);

