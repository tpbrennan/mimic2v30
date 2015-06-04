/*
  v30_ventilation.sql

  Created on   : march 2015 by Mornin Feng
  Last updated :
     $Author: Mornin Feng $
     $Date: 2015 march  $
     $Rev: $

 Valid for MIMIC II database schema version 3.0.
 Must run on brp2 server

Ventilation info for v30 patients

*/

/*********** first export ventilation table from tesla ****************/
drop table mornin.v26_ventilation;
create table mornin.v26_ventilation as
WITH ventilation_filter AS
  ( SELECT DISTINCT subject_id,
    icustay_id,
    charttime
  FROM mimic2v26.chartevents
  WHERE (
    -- ITEMIDs which indicate ventilation
    itemid        = '720'
  OR itemid       = '722' )
  AND icustay_id IS NOT NULL
  ORDER BY icustay_id,
    charttime
  )
  --Return results that is 'Y' or 'N' for new day
  ,
  ventilation_begin AS
  (SELECT vf.subject_id,
    vf.icustay_id,
    charttime,
    CASE
      WHEN EXTRACT(DAY FROM charttime - LAG(charttime) OVER (partition BY icustay_id ORDER BY charttime)) > 0
      THEN 'Y' --if more then a day has passed, flag as 'Y'
      WHEN LAG(charttime, 1) OVER (partition BY icustay_id ORDER BY charttime ) IS NULL
      THEN 'Y' --if lag is null, then > 24hrs has passed
      ELSE 'N'
    END AS new_day
  FROM ventilation_filter vf
  )
  --select * from ventilation_begin; --504205 rows
  --Return results that is 'Y' or 'N' for end_day
  ,
  ventilation_end AS
  (SELECT vf.subject_id,
    vf.icustay_id,
    charttime,
    CASE
      WHEN LEAD(new_day, 1) OVER (partition BY icustay_id ORDER BY charttime) = 'Y'
      THEN 'Y' --if lead is 'Y', then the current row is end
      WHEN LEAD(new_day, 1) OVER (partition BY icustay_id ORDER BY charttime) IS NULL
      THEN 'Y' --if lead is null, then partition is over
      ELSE 'N' --else not an end day
    END AS end_day
  FROM ventilation_begin vf
  )
  --select * from ventilation_end; --504205 rows
  --Return results that is 'Y' for new_day
  ,
  ventilation_assemble_begin AS
  ( SELECT * FROM ventilation_begin WHERE new_day = 'Y'
  )
  --select * from ventilation_begin_remove_no; -- 17994 rows
  --Return results that is 'Y' for end_day
  ,
  ventilation_assemble_end AS
  ( SELECT * FROM ventilation_end WHERE end_day = 'Y'
  )
  --select * from ventilation_end_remove_no; -- 17994 rows
  --Return results has a match of begin day with end day.  end_day is found by
  -- min(end_day - begin_day) that has to be >= 0.
  ,
  ventilation_find_end_date AS
  (SELECT vab.subject_id,
    vab.icustay_id,
    vab.charttime BEGIN,
    MIN(vae.charttime - vab.charttime)
END
FROM ventilation_assemble_begin vab
JOIN ventilation_assemble_end vae
ON vab.icustay_id                                      = vae.icustay_id
WHERE EXTRACT(DAY FROM vae.charttime - vab.charttime) >= 0
GROUP BY vab.subject_id,
  vab.icustay_id,
  vab.charttime
  )
  --select * from ventilation_find_end_date; -- 17994 rows
  --Return results that has subject_id, icustay_id, seq, begin time, and end
  -- time
  ,
  assemble AS
  (SELECT subject_id,
    icustay_id,
    row_number() over (partition BY icustay_id order by BEGIN) AS seq, --
    -- create seq
    BEGIN begin_time,
    BEGIN +
END end_time
FROM ventilation_find_end_date
  )
SELECT * FROM assemble;



--create table lcp_ventilation as
with v30_vent1 as
(
select subject_id
, hadm_id
, cast(null as number(7,0)) as icustay_id
, 0 as seq
, starttime
, endtime
from MIMIC2V30.procedureevents where ordercategoryname='Ventilation' 
--and endtime>=starttime+1/24
order by subject_id, hadm_id, starttime
)

--select * from v30_vent1 where endtime<starttime+1/24;

, v30_vent as
(select subject_id
, hadm_id
, icustay_id
, row_number() over (partition by hadm_id order by starttime asc) as seq
, starttime
, endtime
from v30_vent1
)

--select * from v30_vent;

, v26_vent as
(
select subject_id
, cast(null as number(7,0)) as hadm_id
, icustay_id
, seq
, begin_time as startime
, end_time as endtime
from mornin.v26_ventilation
)

--select * from v26_vent;
, vent_final as
(
select * from v30_vent
union
select * from v26_vent
)

select * from vent_final;



















/************************ potential useless **********************/
with intubation as
(select subject_id
, hadm_id
, starttime as intub_time
from MIMIC2V30.procedureevents where ordercategoryname='Intubation/Extubation' and label = 'Intubation'
)

--select * from intubation;
, extubation as
(select subject_id
, hadm_id
, starttime as extub_time
from MIMIC2V30.procedureevents where ordercategoryname='Intubation/Extubation' and label = 'Extubation'
)

--select * from extubation;
, intub_extub as
(select distinct 
i.subject_id
, i.hadm_id
, i.intub_time
, first_value(ex.extub_time) over (partition by i.subject_id, i.hadm_id, i.intub_time order by ex.extub_time asc) as extub_time
from intubation i
join extubation ex on i.hadm_id=ex.hadm_id and i.intub_time<=ex.extub_time
order by 1,2
)

select * from intub_extub;