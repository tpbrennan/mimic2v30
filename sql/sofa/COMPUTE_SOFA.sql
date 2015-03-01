--DROP MATERIALIZED VIEW DJSCOTT.SOFA_SCORES;

--CREATE MATERIALIZED VIEW DJSCOTT.SOFA_SCORES AS

With icustays as (
  SELECT
    icday.subject_id,
    icday.icustay_id,
    icday.intime AS icustay_intime,
    icday.outtime AS icustay_outtime
  FROM MIMIC2V30.ICUSTAYEVENTS icday
  WHERE icday.subject_id between 1 and 50
)
-- DONE!
--SELECT * FROM icustays;

,icustay_days as (
SELECT
  subject_id,
  icustay_id,
  icustay_intime icustay_day_intime,
  icustay_outtime icustay_day_outtime,
  rn icustay_day
FROM icustays
  MODEL PARTITION BY (subject_id,icustay_id)
  DIMENSION BY (1 rn)
  MEASURES (
    EXTRACT(DAY FROM (icustay_outtime-icustay_intime)) diff,
    icustay_intime,
    icustay_outtime,
    icustay_outtime outtimeint
    )
  ( icustay_intime[ for rn from 1 to diff[1] increment 1]=icustay_intime[1] + numtodsinterval(cv(rn)-1, 'Day'),
    icustay_outtime[ for rn from 1 to diff[1] increment 1]=case when cv(rn)=diff[1] then outtimeint[1]
                                                    else  icustay_intime[1] + numtodsinterval(cv(rn), 'Day') end  )
  order by icustay_id, icustay_day
)
--DONE!
--select * from icustay_days;

,Pao2 as (
  select 
    ce.subject_id,
    ce.icustay_id,
    ce.TIME AS CHARTTIME,
    ce.value1 AS VALUE
  from MIMIC2V30.chartevents ce
  where
    ce.itemid IN(779,220224) 
)

--DONE!
--SELECT * FROM Pao2;

,Fio2 as (
  select 
    ce.subject_id,
    ce.icustay_id,
    ce.TIME AS CHARTTIME,
    ce.value1 AS VALUE
  from MIMIC2V30.chartevents ce
  where
    ce.itemid IN(3420,223835) 
)

--DONE!
--SELECT * FROM Fio2;

,Pao2Fio2Ratio as (
  /* Get the ratio of each pao2 value with the most recent prior fi02 */
  select distinct 
         p.icustay_id, p.subject_id, icusd.icustay_day,
         to_char(icusd.icustay_day_intime, 'YYYY-MM-DD HH24:MI'),
         to_char(icusd.icustay_day_outtime, 'YYYY-MM-DD HH24:MI'),
         to_char(p.charttime , 'YYYY-MM-DD HH24:MI'),
         to_char(f.charttime , 'YYYY-MM-DD HH24:MI'),
         p.charttime p_charttime, p.value as p_value,
         first_value(f.charttime)
           over (partition by p.icustay_id, p.charttime order by f.charttime desc) as f_charttime,
         first_value(f.value)
           over (partition by p.icustay_id, p.charttime order by f.charttime desc) as f_value,
         p.value / first_value(f.value)
           over (partition by p.icustay_id, p.charttime order by f.charttime desc)
           as pao2_fio2_ratio
    from Pao2 p,
         Fio2 f,
         icustay_days icusd
   where f.icustay_id = p.icustay_id
     and f.charttime <= p.charttime
     and f.icustay_id = icusd.icustay_id
     and p.charttime >= icusd.icustay_day_intime
     and p.charttime <= icusd.icustay_day_outtime
   order by p.icustay_id, p.charttime
)

SELECT * FROM Pao2Fio2Ratio;

,p_f_daily_ratio as(
/* Get the minimum pao2/fio2 ratio for each day of ICU Stay */
select 
  subject_id,
  icustay_id,
  icustay_day,
  min (pao2_fio2_ratio) as p_f_ratio
from 
  Pao2Fio2Ratio
GROUP BY subject_id, icustay_id, icustay_day
ORDER BY subject_id, icustay_id, icustay_day
),
ss_daily_raw_resp as (
select
  subject_id,
  icustay_id,
  icustay_day,
  p_f_ratio,
  case when (p_f_ratio < 100) then 4
            when (p_f_ratio < 200) then 3
            when (p_f_ratio < 300) then 2
            when (p_f_ratio < 400) then 1
       else 0 end
  as respiratory_failure 
from p_f_daily_ratio
GROUP BY subject_id, icustay_id, icustay_day, p_f_ratio
ORDER BY subject_id, icustay_id, icustay_day
),
max_icustay_weight AS (
SELECT DISTINCT
  icud.subject_id,
  icud.icustay_id,
  MAX ( ce.value1num ) weight
FROM
  mimic2v26.chartevents ce,
  icustays icud
WHERE
  itemid         IN ( 580, 1393, 762, 1395 )
AND ce.subject_id = icud.subject_id
AND ce.charttime          >= icud.icustay_intime
AND ce.charttime          <= icud.icustay_outtime
AND ce.value1num          IS NOT NULL
AND ce.value1num          >= 30 -- Arbitrary value to eliminate 0
GROUP BY
  icud.subject_id,
  icud.icustay_id
ORDER BY
  icud.icustay_id
),
ss_daily_raw_lab as (
  SELECT
    icud.subject_id,
    icud.icustay_id,
    icud.icustay_day,
    max(
    case
      when (le.itemid = 50170 and le.valuenum >= 12) then 4
      when (le.itemid = 50170 and (le.valuenum >= 6 and  le.valuenum<=11.9)) then 3
      when (le.itemid = 50170 and (le.valuenum >= 2 and le.valuenum<= 5.9)) then 2
      when (le.itemid = 50170 and (le.valuenum >= 1.2 and le.valuenum<= 1.9)) then 1
      else 0
    end) as hepatic_failure,
    max(
    case 
      when (le.itemid = 50428 and le.valuenum < 20) then 4
      when (le.itemid = 50428 and le.valuenum < 50) then 3
      when (le.itemid = 50428 and le.valuenum < 100) then 2
      when (le.itemid = 50428 and le.valuenum < 150) then 1
      else 0
    end) as hematologic_failure
  from
    icustay_days icud,
    mimic2v26.labevents le
  where le.subject_id = icud.subject_id
  AND le.charttime >= icud.icustay_day_intime
  AND le.charttime <= icud.icustay_day_outtime
  AND le.itemid in (50170,50428)
  GROUP BY icud.subject_id, icud.icustay_id, icud.icustay_day
  ORDER BY icud.subject_id, icud.icustay_id, icud.icustay_day
),
ss_daily_raw_press as (
  SELECT
    icud.subject_id,
    icud.icustay_id,
    icud.icustay_day,
    max(case
      when ((me.itemid in (43,307) and (me.dose > 0 and me.dose <= 5)) or (me.itemid in (42,306) and me.dose > 0)) then 2
      when ((me.itemid in (43,307) and (me.dose > 5 and me.dose <= 15)) or (me.itemid in (44,119,309,47,120) and (me.dose > 0 and (me.dose/miw.weight) <= 0.1))) then 3
      when ((me.itemid in (43,307) and me.dose > 15) or (me.itemid in (44,119,309,47,120) and (me.dose/miw.weight) > 0.1)) then 4 
      else 0
      end
    ) as cardiovascular_failure_pres
  FROM
    mimic2v26.medevents me,
    max_icustay_weight miw,
    icustay_days icud 
  where miw.icustay_id = icud.icustay_id
  AND me.subject_id = icud.subject_id
  AND me.charttime >= icud.icustay_day_intime
  AND me.charttime <= icud.icustay_day_outtime
  AND me.itemid in (43,307,42,306,44,119,309,47,120)
  group by icud.subject_id, icud.icustay_id, icustay_day
),
min_daily_abp AS (
  SELECT
    icud.subject_id,
    icud.icustay_id,
    icud.icustay_day,
    MIN(ce.value1num) as min_daily_abp_val
  FROM icustay_days icud
  JOIN mimic2v26.chartevents ce
  ON (icud.subject_id = ce.subject_id)
  WHERE ce.charttime >= icud.icustay_day_intime
  AND   ce.charttime <= icud.icustay_day_outtime
  AND   ce.itemid in (52,456)
  AND   ce.value1num IS NOT NULL
  GROUP BY icud.subject_id, icud.icustay_id, icud.icustay_day
  ORDER BY icud.subject_id, icud.icustay_id, icud.icustay_day
),
ss_daily_raw_abp as (
  SELECT
    icud.subject_id,
    icud.icustay_id,
    icud.icustay_day,
    case
      when (mda.min_daily_abp_val < 70) then 1
      else 0
      end
    as cardiovascular_failure_abp
  FROM
    min_daily_abp mda,
    icustay_days icud 
  WHERE mda.icustay_id = icud.icustay_id
    AND mda.icustay_day = icud.icustay_day
),
ss_daily_raw_cardio as (
SELECT
  sdra.subject_id,
  sdra.icustay_id,
  sdra.icustay_day,
  sdra.cardiovascular_failure_abp,
  sdrp.cardiovascular_failure_pres
FROM ss_daily_raw_abp sdra
FULL OUTER JOIN ss_daily_raw_press sdrp
ON (sdra.icustay_id = sdrp.icustay_id AND sdra.icustay_day = sdrp.icustay_day)
),
ss_daily_raw_neuro as (
  SELECT
    icud.subject_id,
    icud.icustay_id,
    icud.icustay_day,
    max(case 
      when (ce.itemid = 198 and (ce.value1num >= 13 and ce.value1num <= 14)) then 1 
      when (ce.itemid = 198 and (ce.value1num >= 10 and ce.value1num <= 12)) then 2 
      when (ce.itemid = 198 and (ce.value1num >= 6 and ce.value1num <= 9)) then 3
      when (ce.itemid = 198 and (ce.value1num < 6)) then 4
      else 0 end
    ) as neurologic_failure
  FROM
    mimic2v26.chartevents ce,
    icustay_days icud
  WHERE ce.subject_id = icud.subject_id
  AND ce.charttime >= icud.icustay_day_intime
  AND ce.charttime <= icud.icustay_day_outtime
  AND ce.itemid = 198
  group by icud.subject_id, icud.icustay_id, icud.icustay_day
),
ss_daily_raw as (
  SELECT DISTINCT
    icud.subject_id,
    icud.icustay_id,
    icud.icustay_day,
    NVL(sdrl.hepatic_failure,0) hepatic_failure,
    NVL(sdrl.hematologic_failure,0) hematologic_failure,
    NVL(sdrc.cardiovascular_failure_abp,0) cardiovascular_failure_abp,
    NVL(sdrc.cardiovascular_failure_pres,0) cardiovascular_failure_pres,
    case
    when (NVL(sdrc.cardiovascular_failure_abp,0) > NVL(sdrc.cardiovascular_failure_pres,0)) then NVL(sdrc.cardiovascular_failure_abp,0)
    else NVL(sdrc.cardiovascular_failure_pres,0) end as cardiovascular_failure,
    NVL(sdrn.neurologic_failure,0) neurologic_failure,
    NVL(sdrr.respiratory_failure,0) respiratory_failure
  FROM
    icustay_days icud
  FULL OUTER JOIN ss_daily_raw_lab sdrl
  ON (icud.icustay_id = sdrl.icustay_id AND icud.icustay_day = sdrl.icustay_day)
  FULL OUTER JOIN ss_daily_raw_cardio sdrc
  ON (icud.icustay_id = sdrc.icustay_id AND icud.icustay_day = sdrc.icustay_day)
  FULL OUTER JOIN ss_daily_raw_neuro sdrn
  ON (icud.icustay_id = sdrn.icustay_id AND icud.icustay_day = sdrn.icustay_day)
  FULL OUTER JOIN ss_daily_raw_resp sdrr
  ON (icud.icustay_id = sdrr.icustay_id AND icud.icustay_day = sdrr.icustay_day)
),
non_renal_daily_sofa_score as (
select
  sofa.subject_id,
  sofa.icustay_id,
  sofa.icustay_day,
  sofa.hepatic_failure,
  sofa.hematologic_failure,
  sofa.neurologic_failure,
  --sofa.cardiovascular_failure_abp,
  --sofa.cardiovascular_failure_pres,
  sofa.cardiovascular_failure,
  sofa.respiratory_failure,
  sofa.respiratory_failure + sofa.hepatic_failure + sofa.hematologic_failure + sofa.neurologic_failure + sofa.cardiovascular_failure as addmission_non_renal_sofa
from ss_daily_raw sofa
join icustay_days icud
on (icud.icustay_id = sofa.icustay_id and icud.icustay_day = sofa.icustay_day)
)
SELECT * FROM non_renal_daily_sofa_score;

/*select 
aki.* ,
nrss.addmission_non_renal_sofa
from non_renal_sofa_score nrss
join 
djscott.aki
on (aki.icustay_id=nrss.icustay_id)*/

--CREATE INDEX IDX_SOFA_SCORES_SUBJECT_ID on DJSCOTT.SOFA_SCORES (subject_id);
--CREATE INDEX IDX_SOFA_SCORES_ICUSTAY_ID on DJSCOTT.SOFA_SCORES (subject_id,icustay_id);
--CREATE INDEX IDX_SOFA_SCORES_ICUSTAY_DAY on DJSCOTT.SOFA_SCORES (subject_id,icustay_id,icustay_day);

--GRANT SELECT ON DJSCOTT.SOFA_SCORES TO MIMIC2_RD;
