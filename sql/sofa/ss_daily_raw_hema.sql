--SELECT * FROM MIMIC2V26.D_LABITEMS WHERE LOINC_CODE LIKE '777-3';
--SELECT * FROM MIMIC2V30.LABEVENTS WHERE LOINC_CODE LIKE '777-3';

CREATE TABLE SS_DAILY_RAW_HEMA AS
WITH ss_raw_hema as (
  SELECT
    icud.subject_id,
    icud.icustay_id,
    icud.seq as icustay_day,
    case 
      when le.value < 20 then 4
      when le.value < 50 then 3
      when le.value < 100 then 2
      when le.value < 150 then 1
      else 0
    end as hematologic_score
  from
    icustay_population icud,
    mimic2v30.labevents le
  where le.subject_id = icud.subject_id
  AND le.charttime >= icud.icustay_day_intime
  AND le.charttime <= icud.icustay_day_outtime
  AND le.itemid in (51278)
)
--select * from ss_raw_hema;

,ss_daily_raw_hema as (
  SELECT
    subject_id,
    icustay_id,
    icustay_day,
    max(hematologic_score) as hematologic_score
  from
    ss_raw_hema
  GROUP BY subject_id, icustay_id, icustay_day
)

SELECT * FROM ss_daily_raw_hema;