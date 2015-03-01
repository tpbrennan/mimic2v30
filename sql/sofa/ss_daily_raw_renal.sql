-- MOHAMMAD M. GHASSEMI
-- FEB 2015
-- GHASSEMI@MIT.EDU
CREATE TABLE SS_DAILY_RAW_RENAL AS
WITH ss_raw_renal_creat as (
  SELECT
    icud.subject_id,
    icud.icustay_id,
    icud.seq,
    icud.icustay_day_outtime,
    'CREATININE',
    le.valuenum,
--    le.valueuom,
    case 
      when (le.value >= 1.2 and le.value < 2.0) then 1 
      when (le.value >= 2.0 and le.value < 3.5) then 2 
      when (le.value >= 3.5 and le.value < 5.0) then 3
      when (le.value >= 5.0) then 4
      else 0 end
    as renal_score
  FROM
    mimic2v30.labevents le,
    icustay_population icud
  WHERE le.subject_id = icud.subject_id
  AND le.charttime >= icud.icustay_day_intime
  AND le.charttime <= icud.icustay_day_outtime
  AND le.itemid = 50916
)
--select * from ss_raw_renal_creat;--161

,
ss_raw_renal_urine as (
  SELECT
    icud.subject_id,
    icud.icustay_id,
    icud.seq,
    icud.icustay_day_outtime,
    'URINE',
    SUM(ie.value),
    case 
      when (SUM(ie.value) >= 200 and SUM(ie.value) < 500) then 3
      when (SUM(ie.value) <  200) then 4
      else 0 end
    as renal_score
  FROM
    mimic2v30.ioevents ie,
    icustay_population icud
  WHERE ie.subject_id = icud.subject_id
    AND ie.charttime >= icud.icustay_day_intime
    AND ie.charttime <= icud.icustay_day_outtime
    AND ie.itemid IN ( 40652, 
                  40716, 
                  40056, 
                  40057, 
                  40058, 
                  40062, 
                  40066, 
                  40070, 
                  40086, 
                  40095, 
                  40097, 
                  40289, 
                  40406, 
                  40429, 
                  40474, 
                  42043, 
                  42069, 
                  42112, 
                  42120, 
                  42131, 
                  41923, 
                  42811, 
                  42860, 
                  43054, 
                  43463, 
                  43520, 
                  43176, 
                  42367, 
                  42464, 
                  42508, 
                  42511, 
                  42593, 
                  42677, 
                  43967, 
                  43988, 
                  44133, 
                  44254, 
                  45928,
                  226627,
                  227489,
                  226631) 
GROUP BY icud.subject_id, icud.icustay_id, icud.seq, icud.icustay_day_outtime, 'URINE'
)

--select * from ss_raw_renal_urine union select * from ss_raw_renal_creat;

, ss_daily_raw_renal as (
select
    subject_id,
    icustay_id,
    seq as ICUSTAY_DAY,
    icustay_day_outtime,
    MAX(renal_score) as renal_score
FROM (
      select * from ss_raw_renal_urine--122
      union
      select * from ss_raw_renal_creat
      )
GROUP BY subject_id, icustay_id, seq, icustay_day_outtime
)

select * from ss_daily_raw_renal;