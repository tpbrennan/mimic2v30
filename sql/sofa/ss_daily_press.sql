--30043	Dopamine -- 221662      mcgkgmin mcg/min --divide rhs the other half weight divide this by 1K
--30042	Dobutamine -- 221653    mcgkgmin mcg/min --devide rhs by the patient weight 
--30044	Epinephrine -- 221289   mcgmin mcg/min -- devide both by weights
--30047	Levophed/Norepi -- 221906      mcgmin mcg/min --devide both by the weights

--30051 Vassopressin --222315   Umin units/hr
--30127 Neosynephrine/Phenylephrine -- 221749          mcg/min

--30119	Epinephrine-k --xxx      mcgkgmin
--30306	Dobutamine Drip --xxx    mcgkgmin
--30307	Dopamine Drip --xxx        
--30309	Epinephrine Drip --xxx
--30120	Levophed-k -- xxx   mcgkgmin
--30128 Neosynephrine-k -- xxx 

--DROP TABLE ss_daily_raw_press;
--CREATE TABLE ss_daily_raw_press AS

--SELECT COUNT(*) FROM MIMIC2V30.POE_MED_ORDER WHERE ITEMID IN 221653;

--SELECT DISTINCT DRUG_NAME_POE 
--FROM MIMIC2V30.POE_MED_ORDER 
--WHERE lower(DRUG_NAME_POE) LIKE '%epi%'
--AND SUBJECT_ID > 33000;
--SELECT DISTINCT ITEMID, LABEL FROM MIMIC2V30.MEDEVENTS WHERE lower(LABEL) LIKE '%levo%';
--SELECT DISTINCT ITEMID, LABEL FROM MIMIC2V30.MEDEVENTS WHERE lower(LABEL) LIKE '%epin%';

--SELECT distinct itemid FROM MIMIC2V30.CHARTEVENTS WHERE lower(LABEL) LIKE '%epin%';

--CREATE TABLE ss_daily_raw_press AS
WITH ss_daily_raw_press as (

  SELECT
    icud.subject_id,
    icud.icustay_id,
    icud.icustay_day,
    max(case
      when ((me.itemid in (30043,30307) and (me.value > 0 and me.value <= 5)) or (me.itemid in (30042,30306) and me.value > 0)) then 2
      when ((me.itemid in (221662) and (me.value/miw.weight > 0 and me.value/miw.weight <= 5)) or (me.itemid in (221653) and me.value > 0)) then 2 
      when ((me.itemid in (30043,30307) and (me.value > 5 and me.value <= 15)) or (me.itemid in (30044,30119,30309,30047,30120) and (me.value > 0 and (me.value/miw.weight) <= 0.1))) then 3
      when ((me.itemid in (221662) and (me.value/miw.weight > 5 and me.value/miw.weight <= 15)) or (me.itemid in (221906,221289) and (me.value > 0 and (me.value/miw.weight) <= 0.1))) then 3
      when ((me.itemid in (30043,30307) and me.value > 15) or (me.itemid in (30044,30119,30309,30047,30120) and (me.value/miw.weight) > 0.1)) then 4 
      when ((me.itemid in (221662) and me.value/miw.weight > 15) or (me.itemid in (221906,221289) and (me.value/miw.weight) > 0.1)) then 4     
      else 0
      end
    ) as cardiovascular_score_pres
  FROM
    mimic2v30.medevents me,
    max_icustay_weight miw,
    my_icustay_days icud 
  where miw.icustay_id = icud.icustay_id
  AND me.subject_id = icud.subject_id
  AND (   me.charttime >= icud.icustay_day_intime
      AND me.charttime <= icud.icustay_day_outtime
      OR
          me.starttime >= icud.icustay_day_intime
      AND me.starttime <= icud.icustay_day_outtime
      )
  AND me.itemid in (
                    30043,
                    30307,
                    30042,
                    30306,
                    30044,
                    30119,
                    30309,
                    30047,
                    30120,
                    221662,
                    221653,
                    221289,
                    221906)
  group by icud.subject_id, icud.icustay_id, icustay_day
)
--SELECT * FROM ss_daily_raw_press;







