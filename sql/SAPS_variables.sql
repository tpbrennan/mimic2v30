drop materialized view tbrennan.saps_variables_mimic2v30;
create materialized view tbrennan.saps_variables_mimic2v30 as

with saps_variables as (
  select * from tbrennan.saps_labvars_mimic2v30
  union
  select * from tbrennan.saps_chartvars_mimic2v30
)
select * from saps_variables order by subject_id;
