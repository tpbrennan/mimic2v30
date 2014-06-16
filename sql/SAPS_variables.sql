drop materialized view tbrennan.saps_variables_mimic2v30;
create materialized view tbrennan.saps_variables_mimic2v30 as

with saps_variables as (
  select * from tbrennan.saps_labvars_mimic2v30
  union
  select * from tbrennan.saps_chartvars_mimic2v30
)
select * from saps_variables order by subject_id;


select subject_id, hadm_id, icustay_id, seq, lod, category, to_number(valuenum) from tbrennan.saps_labvars_mimic2v30 where valuenum is not null
union
select subject_id, hadm_id, icustay_id, seq, lod, category, valuenum from tbrennan.saps_chartvars_mimic2v30;


  case when length(trim(translate(valuenum,' -.0123456789',' '))) > 0 then to_number(valuenum)
  else valuenum
  end as valuenum
