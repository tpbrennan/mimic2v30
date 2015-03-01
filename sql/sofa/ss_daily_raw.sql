-- MOHAMMAD M. GHASSEMI
-- FEB 2015
-- GHASSEMI@MIT.EDU
CREATE TABLE DAILY_SOFA_SCORE AS
WITH ss_daily_raw as (
  SELECT DISTINCT
    icud.subject_id,
    icud.icustay_id,
    icud.icustay_day,
    NVL(resp.respiratory_failure,0) respiratory_failure,
    NVL(neuro.neurological_score,0) neurological_score,
    case
    when (NVL(abp.cardiovascular_score_abp,0) > NVL(press.cardiovascular_failure_pres,0)) then NVL(abp.cardiovascular_score_abp,0)
    else NVL(press.cardiovascular_failure_pres,0) end as cardiovascular_score_final,
    NVL(hep.hepatic_score,0) hepatic_score,
    NVL(hema.hematologic_score,0) hematologic_score,
    NVL(renal.renal_score,0) renal_score
  FROM
    my_icustay_days icud
  FULL OUTER JOIN ss_daily_raw_hepatic hep
  ON (icud.icustay_id = hep.icustay_id AND icud.icustay_day = hep.icustay_day)
  
  FULL OUTER JOIN ss_daily_raw_hema hema
  ON (icud.icustay_id = hema.icustay_id AND icud.icustay_day = hema.icustay_day)
  
  FULL OUTER JOIN ss_daily_raw_abp abp
  ON (icud.icustay_id = abp.icustay_id AND icud.icustay_day = abp.icustay_day)
  
  FULL OUTER JOIN ss_daily_raw_press press
  ON (icud.icustay_id = press.icustay_id AND icud.icustay_day = press.icustay_day)
 
  FULL OUTER JOIN ss_daily_raw_neuro neuro
  ON (icud.icustay_id = neuro.icustay_id AND icud.icustay_day = neuro.icustay_day)
  
  FULL OUTER JOIN ss_daily_raw_resp resp
  ON (icud.icustay_id = resp.icustay_id AND icud.icustay_day = resp.icustay_day)
  
  FULL OUTER JOIN ss_daily_raw_renal renal
  ON (icud.icustay_id = renal.icustay_id AND icud.icustay_day = renal.icustay_day)
)

SELECT be.*, 
       be.respiratory_failure + be.neurological_score + be.cardiovascular_score_final + be.hepatic_score + be.hematologic_score + be.renal_score AS SOFA_TOTAL  
FROM ss_daily_raw be;