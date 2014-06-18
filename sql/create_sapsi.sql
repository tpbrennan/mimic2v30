drop materialized view tbrennan.mimic2v30_sapsi;

create materialized view tbrennan.mimic2v30_sapsi as 

with final_sapsi as (
  select distinct subject_id,
    hadm_id,
    icustay_id,
    first_value(seq) over (partition by subject_id, icustay_id order by seq) seq_first_sapsi,
    first_value(sapsi) over (partition by subject_id, icustay_id order by seq) sapsi_first,
    min(sapsi) over (partition by subject_id, icustay_id) sapsi_min,
    max(sapsi) over (partition by subject_id, icustay_id) sapsi_max
    from tbrennan.mimic2v30_raw_sapsi
    where param_count > 15
    order by subject_id
)
select * from final_sapsi;
--select count(distinct subject_id) from final_sapsi; -- 12411 subjects
--select count(distinct icustay_id) from final_sapsi; -- 12411 subjects, 13969 icustays

