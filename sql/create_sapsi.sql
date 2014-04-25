drop materialized view tbrennan.sapsi_mimic2v30;

create materialized view tbrennan.sapsi_mimic2v30 as 

with SummaryValues as (
  -- find the min and max values for each category and calc_dt
  select distinct subject_id,
    hadm_id,
    icustay_id, 
    seq, 
    category,
    min(valuenum) over (partition by subject_id, icustay_id, seq, category) min_valuenum, 
    max(valuenum) over (partition by subject_id, icustay_id, seq, category) max_valuenum
   from tbrennan.saps_variables_mimic2v30
)
--select * from SummaryValues;


, CalcSapsParams as (
  -- find the SAPS parameter for summary values each category on each day
  select subject_id, 
         hadm_id,
         icustay_id, 
         seq, 
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

, calc_saps_score as (
  -- calculate SAPS score for everyday in ICU
  select distinct d.subject_id, 
         d.hadm_id,
         d.icustay_id, 
         d.seq,
         sum(param_score) over (partition by subject_id, icustay_id, seq) sapsi,
         count(*) over (partition by subject_id, icustay_id, seq) param_count
    from sapsparameter d
    where d.param_score is not null
      and d.param_score >= 0
)
--select * from calc_saps_score;


, final_saps as (
  -- onle select SAPS scores
  select subject_id,
         hadm_id,
         icustay_id,
         seq,
         sapsi
    from calc_saps_score
    where param_count = 13
    order by subject_id, icustay_id, seq
)
select * from final_saps;
