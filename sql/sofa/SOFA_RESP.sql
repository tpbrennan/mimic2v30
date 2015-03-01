CREATE TABLE MOHAMMAD.ss_daily_raw_resp AS

WITH ss_daily_raw_resp as (
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
from MOHAMMAD.p_f_daily_ratio
GROUP BY subject_id, icustay_id, icustay_day, p_f_ratio
ORDER BY subject_id, icustay_id, icustay_day
)

SELECT * FROM ss_daily_raw_resp;


/*WITH p_f_daily_ratio as(
select 
  subject_id,
  icustay_id,
  icustay_day,
  min (pf_ratio) as p_f_ratio
from 
  MOHAMMAD.PFRATIO
GROUP BY subject_id, icustay_id, icustay_day
ORDER BY subject_id, icustay_id, icustay_day
)

SELECT * FROM p_f_daily_ratio; */

/* WITH PFRatio as (
   select distinct 
         p.icustay_id, 
         p.subject_id, 
         icusd.icustay_day,
         to_char(icusd.icustay_day_intime, 'YYYY-MM-DD HH24:MI') as icu_intime,
         to_char(icusd.icustay_day_outtime, 'YYYY-MM-DD HH24:MI') as icu_outtime,
         to_char(p.charttime , 'YYYY-MM-DD HH24:MI') as pc_charttime,
         to_char(f.charttime , 'YYYY-MM-DD HH24:MI') as fc_charttime,
         p.charttime as p_charttime, 
         p.value as p_value,
         first_value(f.charttime) over (partition by p.icustay_id, p.charttime order by f.charttime desc) as f_charttime,
         first_value(f.value) over (partition by p.icustay_id, p.charttime order by f.charttime desc) as f_value,
         p.value / first_value(f.value) over (partition by p.icustay_id, p.charttime order by f.charttime desc) as pf_ratio
    from MOHAMMAD.my_icustay_days icusd
    JOIN MOHAMMAD.Pao2 p ON p.icustay_id = icusd.icustay_id 
    JOIN MOHAMMAD.Fio2 f ON f.icustay_id = icusd.icustay_id
   WHERE f.charttime <= p.charttime
     and p.charttime >= icusd.icustay_day_intime
     and p.charttime <= icusd.icustay_day_outtime
     and f.value > 0
   order by p.icustay_id, p.charttime
) 
SELECT * FROM PFRatio; */


--SELECT * FROM MOHAMMAD.my_icustay_d
/*my_icustay_days AS(
SELECT DISTINCT 
       icd.subject_id,
       icd.icustay_id,
       icd.begintime icustay_day_intime,
       icd.endtime icustay_day_outtime,
       icd.seq icustay_day
FROM MIMIC2V30.ICUSTAY_DAYS icd
--WHERE icd.icustay_id = 48132
)
select * from my_icustay_days;*/


/*,Pao2 as (
  select 
    ce.subject_id,
    ce.icustay_id,
    ce.TIME AS CHARTTIME,
    ce.value1num AS VALUE
  from my_icustay_days icd
  where ce.itemid IN('779','220224') 
    and ce.value1num IS NOT NULL
)*/
--SELECT * FROM Pao2;

/*,Fio2 as (
  select 
    ce.subject_id,
    ce.icustay_id,
    ce.TIME AS CHARTTIME,
    ce.value1num AS VALUE
  from my_icustay_days icd
  where ce.itemid IN('3420','223835')
    and ce.value1num IS NOT NULL
)*/

--DONE!
--SELECT * FROM Fio2;


/* ************************************************************************** */