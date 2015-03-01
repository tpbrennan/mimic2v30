-- Liver (bilirubin) and Coagulation

--******************************************************************************
-- ONE IS IN CHARTEVENTS
-- MIMIC 2V30... 225690	Total Bilirubin	33529
-- ONE IS IN LABEVENTS 
-- MIMIC 2V26... 50889	BILIRUBIN, TOTAL	69059
-- ******************************************************************************

--SELECT * FROM MIMIC2V30.LABEVENTS WHERE loinc_code = '1975-2';
CREATE TABLE SS_DAILY_RAW_HEPATIC AS
WITH ss_daily_raw_hepatic as (
  SELECT
    icud.subject_id,
    icud.icustay_id,
    icud.seq as icustay_day,
    max(
    case
      when (le.value >= 12) then 4
      when (le.value >= 6 and le.value<=11.9) then 3
      when (le.value >= 2 and le.value<= 5.9) then 2
      when (le.value >= 1.2 and le.value<= 1.9) then 1
      else 0
    end) as hepatic_score
  from
    icustay_population icud,
    mimic2v30.labevents le
  where le.subject_id = icud.subject_id
  AND le.charttime >= icud.icustay_day_intime
  AND le.charttime <= icud.icustay_day_outtime
  AND le.itemid in (50889)
  GROUP BY icud.subject_id, icud.icustay_id, icud.seq
  ORDER BY icud.subject_id, icud.icustay_id
)

SELECT * FROM ss_daily_raw_hepatic;