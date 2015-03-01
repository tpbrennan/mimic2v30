-- MOHAMMAD M. GHASSEMI
-- FEB 2015
-- GHASSEMI@MIT.EDU
CREATE TABLE SS_DAILY_RAW_ABP AS
WITH min_daily_abp AS (
  SELECT
    icud.subject_id,
    icud.icustay_id,
    icud.seq as icustay_day,
    MIN(ce.value1num) as min_daily_abp_val
  FROM icustay_population icud
  JOIN mimic2v30.chartevents ce
  ON (icud.subject_id = ce.subject_id and icud.icustay_id = ce.icustay_id)
  WHERE ce.itemid in (52,456,220052)
  AND ce.TIME >= icud.icustay_day_intime
  AND ce.TIME <= icud.icustay_day_outtime
  AND   ce.value1num IS NOT NULL
  GROUP BY icud.subject_id, icud.icustay_id, icud.seq
)
--select * from min_daily_abp;
-- ABP - used in cardiovascular
, ss_daily_raw_abp as (
  SELECT
    mda.subject_id,
    mda.icustay_id,
    mda.icustay_day,
    case
      when (mda.min_daily_abp_val < 70) then 1
      else 0
      end
    as cardiovascular_score_abp
  FROM
    min_daily_abp mda
)

select * from ss_daily_raw_abp;