-- MOHAMMAD M. GHASSEMI
-- FEB 2015
-- GHASSEMI@MIT.EDU
CREATE TABLE SS_DAILY_RAW_NEURO AS
WITH ss_raw_neuro as (
  SELECT
    icud.subject_id,
    icud.icustay_id,
    icud.seq as icustay_day,
    ce.gcs_total as value1num,
    case 
      when (ce.gcs_total >= 13 and ce.gcs_total <= 14) then 1 
      when (ce.gcs_total >= 10 and ce.gcs_total <= 12) then 2 
      when (ce.gcs_total >= 6 and ce.gcs_total <= 9) then 3
      when (ce.gcs_total < 6) then 4
      else 0 end
    as neurological_score
  FROM
    GCS_MAP_MORNIN ce,
    icustay_population icud
  WHERE ce.subject_id = icud.subject_id
  AND ce.shifted_time >= icud.icustay_day_intime
  AND ce.shifted_time <= icud.icustay_day_outtime
)
--select * from ss_raw_neuro where subject_id = 21;
,ss_daily_raw_neuro as (
  SELECT
    subject_id,
    icustay_id,
    icustay_day,
    max(neurological_score) as neurological_score
  FROM
    ss_raw_neuro
  GROUP BY subject_id, icustay_id, icustay_day
)

SELECT * FROM SS_DAILY_RAW_NEURO;