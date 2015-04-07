drop materialized view tbrennan.saps_labvars_mimic2v30;
--create materialized view tbrennan.saps_labvars_mimic2v30 as

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
   join mimic2v30b.labevents c on s.subject_id = c.subject_id
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
          --to_number(c.value) valuenum,
          COALESCE(TO_NUMBER(REGEXP_SUBSTR(c.value, '^\d+(\.\d+)?')), 0) valuenum
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
          --to_number(value) valuenum
          COALESCE(TO_NUMBER(REGEXP_SUBSTR(c.value, '^\d+(\.\d+)?')), 0) valuenum
   from tbrennan.mimic2v30_days s
   join mimic2v30.labevents c on s.subject_id = c.subject_id
   where c.charttime between s.begintime and s.endtime
   and c.itemid in (50989,50823)
   and c.value is not null
   and length(trim(translate(c.value,' -.0123456789',' '))) is null
   
)
--select * from sodium where valuenum > 0;
  
  
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
    select * from hct where valuenum between 5 and 100
    union
    select * from wbc where valuenum between 5 and 1000000
    union
    select * from glucose where valuenum between 0.5 and 1000
    union
    select * from hco3 where valuenum between 2 and 100
    union 
    select * from potassium where valuenum  between 0.5 and 70
    union 
    select * from sodium where valuenum between 50 and 300
    union 
    select * from bun where valuenum between 1 and 100
    union 
    select * from creatinine where valuenum between 0 and 30
)
select * from assemble;
