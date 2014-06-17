drop materialized view tbrennan.mimic2v30_sapsi;

--create materialized view tbrennan.mimic2v30_sapsi as 

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
--select count(distinct subject_id) from final_sapsi; -- 12411 subjects
--select count(distinct icustay_id) from final_sapsi; -- 12411 subjects, 13969 icustays

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
