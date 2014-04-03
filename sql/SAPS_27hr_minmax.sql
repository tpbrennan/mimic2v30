/*
  saps_create_24hr_minmax.sql

  Created on   : September 2009 by Mauricio Villarroel
  Last updated :
     $Author: djscott@ECG.MIT.EDU $
     $Date: 2011-02-25 09:24:49 -0500 (Fri, 25 Feb 2011) $
     $Rev: 183 $

 Daniel J. Scott (djscott at mit dot edu)

 Valid for MIMIC II database schema version 2.6

 Creates the minimum and maximum values for each of the SAPS I
 parameters for each 24hr of each ICUStay for adult patients.

*/

CREATE TABLE merge26.SAPS_DAILY_PARAM as select * from merge25.saps_daily_param where rownum < 0;
alter table merge26.SAPS_DAILY_PARAM add (icustay_day NUMBER);
select * from merge26.SAPS_DAILY_PARAM;

--delete from merge26.SAPS_SCORE;
select count(*) from merge26.SAPS_DAILY_PARAM;--1827120
delete from merge26.SAPS_DAILY_PARAM;
--
INSERT INTO merge26.SAPS_DAILY_PARAM
     (SUBJECT_ID, ICUSTAY_ID, ICUSTAY_DAY, CALC_DT, CATEGORY,
      MIN_VAL, MIN_VAL_SCORE,
      MAX_VAL, MAX_VAL_SCORE, PARAM_SCORE)
-- Find the score for min/max value for each parameter
-- and choose the highest saps as the parameter representative
WITH ICUstays as (
  select dp.subject_id, icue.icustay_id, dob, intime,-- outtime,
         extract (day from intime - dob)/365 as age,
         begintime, endtime, seq as icustay_day
    from mimic2v26.icustayevents icue,
         mimic2v26.d_patients dp,
         mimic2v26.icustay_days icud
   where dp.subject_id = icue.subject_id
     and icue.icustay_id = icud.icustay_id
     and (months_between(intime, dp.dob) / 12) >= 15 -- Adults
     --and dp.subject_id in (13, 17, 21, 41, 61, 68, 91, 109, 377, 4412, 21369)
     --and dp.subject_id in (19235)
)
--select * from ICUstays;
, ChartedParams as (
  -- Group each c.itemid in meaninful category names
  -- also performin some metric conversion (temperature, etc...)
  select s.subject_id, s.icustay_id, s.icustay_day,
         s.endtime as calc_dt,
         case
            when c.itemid in (211) then
                'HR'
            when c.itemid in (676, 677, 678, 679) then
                'TEMPERATURE'
            when c.itemid in (51, 455) then -- 6, 51, 455, 6701
                                            -- suggested. 6 and 6701
                                            -- contain only 31 and
                                            -- 10000 events
                                            -- respectively compared
                                            -- to over 1 million for
                                            -- both 51 and 455.
                'SYS ABP'    -- Invasive/noninvasive BP
            when c.itemid in (781) then
                'BUN'
            when c.itemid in (198) then
                'GCS'
         end category,
         case
            when c.itemid in (678, 679) then
               round((5/9)*(c.value1num-32),2)
            else
               round(c.value1num,2)
         end valuenum
    from ICUStays s,
         mimic2v26.chartevents c
   where c.subject_id = s.subject_id
     and c.icustay_id = s.icustay_id
     and c.charttime between s.begintime and s.endtime
     and ((c.itemid in (211) and c.value1num between
                 (select acceptable_min from merge26.saps_variables where parameter = 'HR')
             and (select acceptable_max from merge26.saps_variables where parameter = 'HR'))
       or (c.itemid in (676, 677) and c.value1num between
                 (select acceptable_min from merge26.saps_variables where parameter = 'TEMPERATURE')
             and (select acceptable_max from merge26.saps_variables where parameter = 'TEMPERATURE'))
       or (c.itemid in (678, 679) and (5/9)*(c.value1num-32) between
                 (select acceptable_min from merge26.saps_variables where parameter = 'TEMPERATURE')
             and (select acceptable_max from merge26.saps_variables where parameter = 'TEMPERATURE'))
       or (c.itemid in (51,455) and c.value1num between
                 (select acceptable_min from merge26.saps_variables where parameter = 'SYS ABP')
             and (select acceptable_max from merge26.saps_variables where parameter = 'SYS ABP'))
       or (c.itemid in (781) and c.value1num between
                 (select acceptable_min from merge26.saps_variables where parameter = 'BUN')
             and (select acceptable_max from merge26.saps_variables where parameter = 'BUN'))
       or (c.itemid in (198))
         )
     -- This clause is a duplication of the above itemid restritcion- for if we
     -- choose to remove the bounds restrictions
     and c.itemid in (
         211,
         676, 677, 678, 679,
         51,455,
         781,
         198)
     and c.value1num is not null
)
--select * from ChartedParams;
--select category, icustay_day, count(*) from ChartedParams group by category, ICUSTAY_DAY;
, VentilatedRespParams as (
  select distinct s.subject_id, s.icustay_id, s.icustay_day,
         s.endtime as calc_dt,
         'VENTILATED_RESP' as category,
         -1 as valuenum -- force invalid number
    from ICUStays s,
         mimic2v26.chartevents c
   where c.subject_id = s.subject_id
     and c.icustay_id = s.icustay_id
     and c.charttime between s.begintime and s.endtime
     and c.itemid in (543, 544, 545, 619, 39, 535, 683, 720, 721, 722, 732)
)
--select * from VentilatedRespParams;
, SpontaneousRespParams as (
  -- Group each c.itemid in meaninful category names
  -- also performin some metric conversion (temperature, etc...)
  select s.subject_id, s.icustay_id, s.icustay_day,
         s.endtime as calc_dt,
         'SPONTANEOUS_RESP' as category,
         c.value1num as valuenum
    from ICUStays s,
         mimic2v26.chartevents c
   where c.subject_id = s.subject_id
     and c.icustay_id = s.icustay_id
     and c.charttime between s.begintime and s.endtime
     and (c.itemid in (219, 615, 618) and c.value1num between
                 (select acceptable_min from merge26.saps_variables where parameter = 'RESPIRATION_RATE')
             and (select acceptable_max from merge26.saps_variables where parameter = 'RESPIRATION_RATE'))
     and c.itemid in (
         219, 615, 618) -- 3603 was for NICU, 614 spontaneous useless
     and c.value1num is not null
     -- Calculated only when patient is not ventilated during the current ICU day.
     -- does not include rare cases where patient has poor spontaneous respiration rate which would give score of 4.
     and not exists (select 'X'
                       from VentilatedRespParams nv
                      where nv.icustay_id = s.icustay_id
                        and nv.calc_dt = s.endtime)
)
--select * from SpontaneousRespParams;
, LabParams as (
  -- Group each c.itemid in meaninful category names
  -- also performin some metric conversion (temperature, etc...)
  select s.subject_id, s.icustay_id, s.icustay_day,
         s.endtime as calc_dt,
         case
            when c.itemid in (50383) -- 347001, chartevents 813 only contains 217733 events
              then 'HCT'
            when c.itemid in (50316, 50468)
              then 'WBC'
            when c.itemid in (50006, 50112)
              then 'GLUCOSE'
            when c.itemid in (50022, 50025, 50172)
              then 'HCO3' -- 'TOTAL CO2'
            when c.itemid in (50009, 50149) then
                'POTASSIUM'
            when c.itemid in (50012, 50159) then
                'SODIUM'
            when c.itemid in (50177) then
                'BUN'
         end category,
         c.valuenum
    from ICUStays s,
         mimic2v26.labevents c
   where c.subject_id = s.subject_id
     and c.icustay_id = s.icustay_id
     and c.charttime between s.begintime and s.endtime
     and ((c.itemid in (50383) and c.valuenum between
                 (select acceptable_min from merge26.saps_variables where parameter = 'HCT')
             and (select acceptable_max from merge26.saps_variables where parameter = 'HCT'))
       or (c.itemid in (50316, 50468)  and c.valuenum*1000 between
                 (select acceptable_min from merge26.saps_variables where parameter = 'WBC')
             and (select acceptable_max from merge26.saps_variables where parameter = 'WBC'))
       or (c.itemid in (50006, 50112)  and c.valuenum between
                 (select acceptable_min from merge26.saps_variables where parameter = 'GLUCOSE')
             and (select acceptable_max from merge26.saps_variables where parameter = 'GLUCOSE'))
       or (c.itemid in (50022, 50025, 50172)  and c.valuenum between
                 (select acceptable_min from merge26.saps_variables where parameter = 'HCO3')
             and (select acceptable_max from merge26.saps_variables where parameter = 'HCO3'))
       or (c.itemid in (50009, 50149)  and c.valuenum between
                 (select acceptable_min from merge26.saps_variables where parameter = 'POTASSIUM')
             and (select acceptable_max from merge26.saps_variables where parameter = 'POTASSIUM'))
       or (c.itemid in (50012, 50159)  and c.valuenum between
                 (select acceptable_min from merge26.saps_variables where parameter = 'SODIUM')
             and (select acceptable_max from merge26.saps_variables where parameter = 'SODIUM'))
       or (c.itemid in (50177)  and c.valuenum between
                 (select acceptable_min from merge26.saps_variables where parameter = 'BUN')
             and (select acceptable_max from merge26.saps_variables where parameter = 'BUN'))
         )
     and c.itemid in (
         50383,        -- HCT
         50316, 50468, -- WBC
         50006, 50112, -- Glucose
         50022, 50025, 50172, -- HCO3
         50009, 50149, -- Potassium
         50012, 50159,  -- Sodium
         50177         -- BUN
         )
     and c.valuenum is not null
)
--select category, count(*) from LabParams group by category;
--select * from LabParams;
, AgeParams as (
  -- The age (in years) at the admission day
  select subject_id, icustay_id,  icustay_day, endtime as calc_dt,
         'AGE' as category, age as valuenum
    from ICUStays
)
--select * from AgeParams;
, UrineParams as (
  select s.subject_id, s.icustay_id, s.icustay_day,
         s.endtime as calc_dt,
         'URINE' as category,
         sum(c.volume)/1000 as valuenum
    from ICUStays s,
         mimic2v26.ioevents c
   where c.subject_id = s.subject_id
     and c.icustay_id = s.icustay_id
     and c.charttime between s.begintime and s.endtime
     and c.itemid IN ( 651, 715, 55, 56, 57, 61, 65, 69, 85, 94, 96, 288, 405, 428, 473, 2042, 2068, 2111, 2119, 2130, 1922, 2810, 2859, 3053, 3462, 3519, 3175, 2366, 2463, 2507, 2510, 2592, 2676, 3966, 3987, 4132, 4253, 5927 )
     and c.volume is not null
   GROUP BY s.subject_id, s.icustay_id, s.icustay_day, s.endtime
)
--select * from UrineParams;
--select min(valuenum), max(valuenum), avg(valuenum), stddev(valuenum) from UrineParams;
, CombinedParams as (
  select subject_id, icustay_id, icustay_day, calc_dt, category, valuenum
    from ChartedParams
  UNION
  select subject_id, icustay_id, icustay_day, calc_dt, category, valuenum
    from VentilatedRespParams
  UNION
  select subject_id, icustay_id, icustay_day, calc_dt, category, valuenum
    from SpontaneousRespParams
  UNION
  select subject_id, icustay_id, icustay_day, calc_dt, category, valuenum
    from AgeParams
  UNION
  select subject_id, icustay_id, icustay_day, calc_dt, category, valuenum
    from UrineParams
  UNION
  select subject_id, icustay_id, icustay_day, calc_dt, category, valuenum
    from LabParams
)
--select category, count(*) from CombinedParams group by category;
--select * from CombinedParams;
, MinMaxValues as (
  -- find the min and max values for each category and calc_dt
  select subject_id, icustay_id, icustay_day, calc_dt, category,
         min(valuenum) min_valuenum, max(valuenum) max_valuenum
   from CombinedParams
  GROUP BY subject_id, icustay_id, icustay_day, calc_dt, category
)
--select * from MinMaxValues;
, CalcSapsParams as (
  -- find the min and max values for each category and calc_dt
  select subject_id, icustay_id, icustay_day, calc_dt, category,
         min_valuenum,
         merge25.get_saps_for_parameter(category, min_valuenum)
            as min_valuenum_score,
         max_valuenum,
         merge25.get_saps_for_parameter(category, max_valuenum)
            as max_valuenum_score
   from MinMaxValues
)
--select * from CalcSapsParams;
--, SAPS_Parameters as (
select subject_id, icustay_id, icustay_day,
       calc_dt,
       category,
       min_valuenum, min_valuenum_score, max_valuenum, max_valuenum_score,
       case
          when min_valuenum_score >= max_valuenum_score then
              min_valuenum_score
          else
              max_valuenum_score
       end as param_score
  from CalcSapsParams
 order by subject_id, icustay_id, category, calc_dt
;--1,925,124 rows inserted

select * from merge26.SAPS_DAILY_PARAM;

-- Calculate the SAPS score for every patient record
CREATE TABLE merge26.saps_score as select * from merge25.saps_score where rownum < 0;
select count(*) from merge26.saps_score;--157261
delete from merge26.SAPS_SCORE;

INSERT INTO merge26.SAPS_SCORE
      (SUBJECT_ID, ICUSTAY_ID, calc_dt,
       SCORE, PARAM_COUNT)
select d.subject_id, d.icustay_id, d.calc_dt,
       SUM(param_score) SAPS_SCORE,
       count(*) param_count
  from merge26.SAPS_DAILY_PARAM D
 where d.param_score is not null
   and d.param_score >= 0
 group by d.subject_id, d.icustay_id, d.calc_dt;--161,802 rows inserted

select count(*) from merge26.SAPS_SCORE;

WITH saps26 AS (
select subject_id, count(*) as count_saps_26 from merge26.saps_score group by subject_id
), saps25 AS (
select subject_id, count(*) as count_saps_25 from merge25.saps_score group by subject_id
)
select * from saps26, saps25 where saps26.subject_id = saps25.subject_id and saps26.count_saps_26 != saps25.count_saps_25
;

select count(*) from mimic2v26.chartevents where itemid = 20001;--97,850 rows deleted
-- Insert the values into chartevents
delete from mimic2v26.chartevents where itemid = 20001;--97,850 rows deleted

grant select on merge26.SAPS_DAILY_PARAM to mimic_pro;
grant select on merge26.SAPS_SCORE to mimic_pro;

-- Add careunit for calculated values
select * from mimic2v26.d_careunits;
insert into mimic2v26.d_careunits (cuid, label) select * from mimic2v25.d_careunits where cuid = 20001;

insert into mimic2v26.chartevents(
            subject_id, itemid, charttime, elemid,
            realtime,  cgid, cuid, value1num)
     select subject_id, 20001, calc_dt, 1,
            calc_dt,  -1, 20001, score
       from merge26.SAPS_SCORE
      where param_count = 14;--107,835 rows inserted

select * from mimic2v25.chartevents where itemid = 20001 and subject_id = 6689;
select * from mimic2v26.chartevents where itemid = 20001 and subject_id = 6689;
select * from mimic2v26.chartevents where subject_id = 6689;--5340 rows
select * from mimic2v26.icustayevents where subject_id = 6689;

--Add ICU Stay IDs
update mimic2v26.chartevents ce1 set ce1.icustay_id = (
  select icu.icustay_id
    from mimic2v26.icustayevents icu
   where ce1.subject_id = icu.subject_id
     and ce1.charttime between icu.intime and icu.outtime
     and ce1.itemid = 20001
)
where ce1.itemid = 20001;--97850

select count(*) from mimic2v26.chartevents where itemid = 20001;
select * from mimic2v26.chartevents where itemid = 20001 and icustay_id is null;

WITH saps26 AS (
select subject_id, count(*) AS saps_score_26 from mimic2v26.chartevents where itemid = 20001 group by subject_id
), saps25 AS (
select subject_id, count(*) AS saps_score_25 from mimic2v25.chartevents where itemid = 20001 group by subject_id
)
select saps25.subject_id, saps_score_25, saps_score_26 from saps25, saps26 where saps26.subject_id = saps25.subject_id and saps_score_25 < saps_score_26;