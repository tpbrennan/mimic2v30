/*
  merge_code_status_to_chart.sql

  Created on   : March 2015 by Mornin Feng
  Last updated :
     $Author: Mornin Feng $
     $Date: 2015 March 1st $
     $Rev: $

 Valid for MIMIC II database schema version 3.0.
 Must run on brp2 server
 Run using user: mornin

convert V30_RESUSCITATION_CODE_RAW table into chartevents table format for merging later

*/
--drop table v30_code_status;
--create table v30_code_status as
with code_status as
(select 
cast(icu.subject_id as number(7,0)) as subject_id
, cast(null as number(7,0)) as hadm_id
, icu.icustay_id
, 223758 as itemid
, cast('Code Status' as VARCHAR2(100 BYTE)) as LABEL
, cast(to_timestamp(code.time, 'yyyy-mm-dd hh24:mi:ss')+ds.DAYS_SHIFTED as timestamp(6) with time zone) as time
--, code.time as time_text
, cast(null as number(7,0)) as ELEMID
, cast(to_timestamp(code.VALIDATIONTIME,'yyyy-mm-dd hh24:mi:ss')+ds.DAYS_SHIFTED as timestamp(6) with time zone) as VALIDATIONTIME
--, code.VALIDATIONTIME as time_text
, cast(null as NUMBER(7,0)) as CGID
, cast(null as NUMBER(7,0)) as CUID
, case when code.textid='1' then 'Full Code'
       when code.textid='2' then 'Do Not Resuscita'
       when code.textid='3' then 'DNR/DNI'
       when code.textid='4' then 'Do Not Intubate'
       when code.textid='5' then 'Comfort Measures'
      end as VALUE1
, cast(null as number) VALUE1NUM
, cast(null as VARCHAR2(120 BYTE)) as VALUE1UOM
, TO_NCLOB(null) as COMMENTS
, cast(null as VARCHAR2(110 BYTE)) as VALUE2
, cast(null as number) as VALUE2NUM
, cast(null as VARCHAR2(20 BYTE)) as VALUE2UOM
, cast(null as VARCHAR2(20 BYTE)) as RESULTSTATUS
, cast(null as VARCHAR2(20 BYTE)) as STOPPED
, cast(code.warning as NUMBER(1,0)) as WARNING
, cast(code.error as NUMBER(1,0)) as ERROR
from V30_RESUSCITATION_CODE_RAW code
join merge30.icustayevents icu on icu.patientid=code.patientid
--join gparam.MRN_SUBJECTID_DTSHIFT_MERGE30 ds on icu.subject_id=ds.subject_id
)

--select count(distinct icustay_id) from code_status;
select * from code_status;

--select * from code_status where rownum<10
--union all
--select * 
--from mimic2v30.chartevents where rownum<10;
