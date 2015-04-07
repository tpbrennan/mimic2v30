with mimic2v30_sapsi as (
  select distinct subject_id, 
    hadm_id,
    icustay_id,
    first_value(sapsi) over (partition by icustay_id order by seq) sapsi_first_new,
    max(sapsi) over (partition by icustay_id) sapsi_max_new,
    min(sapsi) over (partition by icustay_id) sapsi_min_new
    from tbrennan.sapsi_mimic2v30
    order by icustay_id
)
--select count(*) from mimic2v30_sapsi;--14,711

, mimic2v26_sapsi as (
  select distinct subject_id,
    hadm_id,
    icustay_id,
    sapsi_first,
    sapsi_max,
    sapsi_min
    from mimic2v26.icustay_detail
    order by icustay_id
)
--select count(*) from mimic2v26_sapsi; --40,426

, sapsi_match as (
  select distinct n.subject_id,
    n.hadm_id,
    n.icustay_id,
    n.sapsi_first_new - o.sapsi_first as sapsi_first_err,
    n.sapsi_max_new - o.sapsi_max as sapsi_max_err,
    n.sapsi_min_new - o.sapsi_min as sapsi_min_err
    from mimic2v30_sapsi n
    left join mimic2v26_sapsi o 
      on n.icustay_id = o.icustay_id
    order by n.icustay_id
)
--select count(*) from sapsi_match; -- 14,711 matches
select * from match;
