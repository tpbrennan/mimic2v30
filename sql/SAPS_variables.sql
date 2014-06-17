drop materialized view tbrennan.mimic2v30_saps_variables;
create materialized view tbrennan.mimic2v30_saps_variables as

with saps_variables as (
  select * from tbrennan.saps_labvars_mimic2v30
  union
  select * from tbrennan.saps_chartvars_mimic2v30
)
select * from saps_variables order by subject_id;
