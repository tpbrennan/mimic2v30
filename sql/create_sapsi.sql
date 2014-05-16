drop materialized view tbrennan.sapsi_mimic2v30;

--create materialized view tbrennan.sapsi_mimic2v30 as 

with SummaryValues as (
  -- find the min and max values for each category and calc_dt
  select distinct subject_id,
    hadm_id,
    icustay_id, 
    seq,
    lod,
    category,
    min(valuenum) over (partition by subject_id, icustay_id, seq, category) min_valuenum, 
    max(valuenum) over (partition by subject_id, icustay_id, seq, category) max_valuenum
   from tbrennan.saps_variables_mimic2v30
)
--select * from SummaryValues;
--select count(distinct icustay_id) from SummaryValues; --50,172 icustay_id

, CalcSapsParams as (
  -- find the SAPS parameter for summary values each category on each day
  select subject_id, 
         hadm_id,
         icustay_id, 
         seq,
         lod,
         category,
         min_valuenum,
         tbrennan.get_saps_for_parameter(category, min_valuenum)
            as min_valuenum_score,
         max_valuenum,
         tbrennan.get_saps_for_parameter(category, max_valuenum)
            as max_valuenum_score
   from SummaryValues
)
--select * from CalcSapsParams;

, SAPSparameter as (
  -- determine maximum SAPS parameter for each category
  select subject_id, 
         hadm_id,
         icustay_id, 
         seq,
         lod,
         category,
         case
          when min_valuenum_score >= max_valuenum_score then
              min_valuenum_score
          else
              max_valuenum_score
         end as param_score
    from CalcSapsParams
    order by subject_id, icustay_id, category
) 
--select * from SAPSparameter;--1,925,124 rows inserted

, pivotparams as (
  
  select *
   from (select * from SAPSparameter) 
     pivot (median(param_score) for category in (
        'AGE' as age,
        'HR' as hr,
        'TEMPERATURE' as temp,
        'SYSABP' as sysabp,
        'VENTILATED_RESP' as vent_resp,
        'SPONTANEOUS_RESP' as spon_resp,
        'BUN' as bun,
        'HCT' as hct,
        'WBC' as wbc,
        'GLUCOSE' as glucose,
        'POTASSIUM' as k,
        'SODIUM' as na,
        'HCO3' as hco3,
        'GCS' as gcs,
        'URINE' as urine
        ))
        
)
--select * from pivotparams;

, calc_saps_score as (
  -- calculate SAPS score for everyday in ICU
  select distinct d.subject_id, 
         d.hadm_id,
         d.icustay_id, 
         d.seq,
         lod,
         sum(param_score) over (partition by subject_id, icustay_id, seq) sapsi,
         count(*) over (partition by subject_id, icustay_id, seq) param_count
    from sapsparameter d
    where d.param_score is not null
      and d.param_score >= 0
      order by subject_id
)
--select * from calc_saps_score; --

, final_sapsi as (
  select distinct subject_id,
    hadm_id,
    icustay_id,
    first_value(sapsi) over (partition by subject_id, icustay_id order by seq) sapsi_first,
    min(sapsi) over (partition by subject_id, icustay_id) sapsi_min,
    max(sapsi) over (partition by subject_id, icustay_id) sapsi_max
    from calc_saps_score
    order by subject_id
)


, compare_sapsi as (
  select fs.*,
    id.sapsi_first old_sapsi_first,
    id.sapsi_min old_sapsi_min,
    id.sapsi_max old_sapsi_max
    from final_sapsi fs
    left join mimic2v26.icustay_detail id
      on fs.subject_id = id.subject_id
     and fs.hadm_id = id.hadm_id
)
--select * from compare_sapsi;

, mortality as (
  select cs.*,
    ad.HOSPITAL_EXPIRE_FLG
    from compare_sapsi cs 
    join mornin.v30_admissions ad 
      on cs.subject_id = ad.subject_id
     and cs.hadm_id = ad.hadm_id
)
select * from mortality;


, detailed_saps as (
  -- onle select SAPS scores
  select cs.subject_id,
         cs.hadm_id,
         cs.icustay_id,
         cs.seq,
         cs.lod,
         cs.sapsi,
         cs.param_count,
         p.age,
         p.hr,
         p.temp,
         p.sysabp,
         p.vent_resp,
         p.spon_resp,
         p.bun,
         p.hct,
         p.wbc,
         p.glucose,
         p.k,
         p.na,
         p.hco3,
         p.gcs,
         p.urine
    from calc_saps_score cs
    join pivotparams p
      on cs.subject_id = p.subject_id 
     and cs.icustay_id = p.icustay_id
     and cs.seq = p.seq
    order by subject_id, icustay_id, seq
)
--select count(distinct icustay_id) from final_saps;
