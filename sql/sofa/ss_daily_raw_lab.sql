CREATE TABLE ss_daily_raw_lab AS
WITH ss_daily_raw_lab as (
  SELECT
    icud.subject_id,
    icud.icustay_id,
    icud.icustay_day,
    max(
    case
      when (le.itemid = 50170 and le.value  >= 12) then 4
      when (le.itemid = 50170 and (le.value >= 6 and  le.value<=11.9)) then 3
      when (le.itemid = 50170 and (le.value >= 2 and le.value<= 5.9)) then 2
      when (le.itemid = 50170 and (le.value >= 1.2 and le.value<= 1.9)) then 1
      else 0
    end) as hepatic_failure,
    max(
    case 
      when (le.itemid = 50428 and le.value < 20) then 4
      when (le.itemid = 50428 and le.value < 50) then 3
      when (le.itemid = 50428 and le.value < 100) then 2
      when (le.itemid = 50428 and le.value < 150) then 1
      else 0
    end) as hematologic_failure
  from
    my_icustay_days icud,
    mimic2v30.labevents le
  where le.subject_id = icud.subject_id
  AND le.charttime >= icud.icustay_day_intime
  AND le.charttime <= icud.icustay_day_outtime
  AND le.itemid = 50889
  GROUP BY icud.subject_id, icud.icustay_id, icud.icustay_day
  ORDER BY icud.subject_id, icud.icustay_id, icud.icustay_day
)
SELECT * FROM ss_daily_raw_lab;