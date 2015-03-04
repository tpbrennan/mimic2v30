/*
  merge_gcs_to_chart.sql

  Created on   : March 2015 by Mornin Feng
  Last updated :
     $Author: Mornin Feng $
     $Date: 2015 March 1st $
     $Rev: $

 Valid for MIMIC II database schema version 3.0.
 Must run on brp2 server
 Run using user: mornin

convert GCS_MAP_Mornin table into chartevents table format for merging later

*/


--create table v30_gcs_merge as
with gcs as
(select cast(subject_id as number(8,0)) as subject_id
, hadm_id
, shifted_time as time
, cast(motor_score as number(1,0)) as motor_score
, cast(eye_score as number(1,0)) as eye_score
, cast(verbal_score as number(1,0)) as verbal_score
, gcs_total
from mornin.gcs_map_mornin
)

, gcs_unpivot as
(
select *
from gcs
unpivot(
value1num
for label in (motor_score as 'GCS - Motor Response', eye_score as 'GCS - Eye Opening', verbal_score as 'GCS - Verbal Response', gcs_total as 'GCS - GCS Total')
)
)

--select * from gcs_unpivot;

--select * from gcs;
, gcs_chart as
(select subject_id
, hadm_id
, cast(null as number(7,0)) as icustay_id
, case when label =  'GCS - Motor Response' then 223901
      when label =  'GCS - Eye Opening' then 220739
      when label =  'GCS - Verbal Response' then 223900
      when label =  'GCS - GCS Total' then 229000
      else null
      end ITEMID
, LABEL
, time
, cast(null as number(7,0)) as ELEMID
, cast(null as TIMESTAMP(6) WITH TIME ZONE) as VALIDATIONTIME
, cast(null as NUMBER(7,0)) as CGID
, cast(null as NUMBER(7,0)) as CUID
, cast(null as VARCHAR2(110 BYTE)) as VALUE1
, VALUE1NUM
, cast(null as VARCHAR2(120 BYTE)) as VALUE1UOM
, TO_NCLOB(null) as COMMENTS
, cast(null as VARCHAR2(110 BYTE)) as VALUE2
, cast(null as number) as VALUE2NUM
, cast(null as VARCHAR2(20 BYTE)) as VALUE2UOM
, cast(null as VARCHAR2(20 BYTE)) as RESULTSTATUS
, cast(null as VARCHAR2(20 BYTE)) as STOPPED
, cast(null as NUMBER(1,0)) as WARNING
, cast(null as NUMBER(1,0)) as ERROR
from gcs_unpivot
)

select * from gcs_chart;



--select *
--from V30_GCS_MERGE where rownum<10
--union all
--select * 
--from mimic2v30.chartevents where rownum<10;