
with compare_sapsi as (
  select fs.*,
    id.sapsi_first old_sapsi_first,
    id.sapsi_min old_sapsi_min,
    id.sapsi_max old_sapsi_max
    from tbrennan.mimic2v30_sapsi fs
    join mimic2v26.icustay_detail id
      on fs.subject_id = id.subject_id
     and fs.hadm_id = id.hadm_id
     order by fs.subject_id
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


