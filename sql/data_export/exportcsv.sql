/***** A hardcore but working version *******/

SET TERMOUT OFF
SET FEEDBACK OFF
SET NEWPAGE none
SET SPACE 0
SET PAGESIZE 0
SET TRIMSPOOL ON
SET ECHO OFF
SET HEADING OFF
SET RECSEP OFF
--SET RECSEPCHAR '!#$'
Set pages 50000
set long 99999999
set longchunksize 99999999
set LINESIZE 32767
--SET COLSEP ','

/***************    addiditves  ********************/

--spool "/backup/dpdump/mimic2v30b_csv/additives.csv"
--select 'SUBJECT_ID'||','||'ICUSTAY_ID'||','||'ORDERID'||','||'ITEMID'||','||'LABEL'||','||'IOITEMID'||','||'IOITEMLABEL'||','||'CHARTTIME'||','||'STARTTIME'||','||'ENDTIME'||','||'ELEMID'||','||'CGID'||','||'CUID'||','||'VALUE'||','||'UOM'||','||'IOITEMVALUE'||','||'IOITEMUOM'||','||'SOURCE_FLG' || ',' || 'ADDITIVESDATAID' from dual;
--
--select x from (
--select SUBJECT_ID||','||ICUSTAY_ID||','||ORDERID||','||ITEMID||',"'||LABEL||'",'||IOITEMID||',"'||IOITEMLABEL||'",'||CHARTTIME||','||STARTTIME||','||ENDTIME||','||ELEMID||','||CGID||','||CUID||','||VALUE||',"'||UOM||'",'||IOITEMVALUE||',"'||IOITEMUOM||'",'||SOURCE_FLG || ',' || ADDITIVESDATAID as x
--from 
--  ( select
--  SUBJECT_ID
--  ,ICUSTAY_ID
--  ,ORDERID
--  ,ITEMID
--  ,LABEL
--  ,IOITEMID
--  ,IOITEMLABEL
--  ,to_char(charttime, 'dd-mon-yyyy hh24:mi:ss tzr') as charttime 
--  ,to_char(starttime, 'dd-mon-yyyy hh24:mi:ss tzr') as starttime
--  ,to_char(ENDTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as ENDTIME
--  ,ELEMID
--  ,CGID
--  ,CUID
--  ,VALUE
--  ,UOM
--  ,IOITEMVALUE
--  ,IOITEMUOM
--  ,SOURCE_FLG
--  , ADDITIVESDATAID
--  from mimic2v30b.additives));
--spool off;

--/***************    admissions  ********************/
--
--spool "/backup/dpdump/mimic2v30b_csv/admissions.csv"
--select 'HADM_ID'||','||'SUBJECT_ID'||','||'ADMIT_DT'||','||'ADMIT_TIME'||','||'DISCH_DT'||','||'DISCH_TIME'||','||'ADM_DIAGNOSIS'||','||'FIRST_SERVICE'||','||'LAST_SERVICE'||','||'ADMISSIONSDATAID' from dual;
--
--select x from (
--select HADM_ID||','||SUBJECT_ID||','||ADMIT_DT||','||ADMIT_TIME||','||DISCH_DT||','||DISCH_TIME||',"'||ADM_DIAGNOSIS||'","'||FIRST_SERVICE||'","'||LAST_SERVICE||'",'||ADMISSIONSDATAID as x
--from 
--  ( select
--  HADM_ID
--  ,SUBJECT_ID
--  ,to_char(ADMIT_DT, 'dd-mon-yyyy') as ADMIT_DT
--  ,to_char(ADMIT_TIME, 'dd-mon-yyyy hh24:mi:ss tzr') as ADMIT_TIME
--  ,to_char(DISCH_DT, 'dd-mon-yyyy') as DISCH_DT
--  ,to_char(DISCH_TIME, 'dd-mon-yyyy hh24:mi:ss tzr') as DISCH_TIME 
--  ,ADM_DIAGNOSIS
--  ,FIRST_SERVICE
--  ,LAST_SERVICE
--  ,ADMISSIONSDATAID
--  from mimic2v30b.admissions));
--spool off;

--/***************    CENSUSEVENTS  ********************/
--
--spool "/backup/dpdump/mimic2v30b_csv/CENSUSEVENTS.csv"
--
--select 'CENSUS_ID'||','||'SUBJECT_ID'||','||'ICUSTAY_ID'||','||'INTIME'||','||'OUTTIME'||','||'CUID'||','||'LOS'||','||'DESTCAREUNIT'||','||'DISCHSTATUS'||','||'CENSUSEVENTSDATAID' from dual;
--
--select x from (
--select CENSUS_ID||','||SUBJECT_ID||','||ICUSTAY_ID||','||INTIME||','||OUTTIME||','||CUID||','||LOS||','||DESTCAREUNIT||',"'||DISCHSTATUS||'",'||CENSUSEVENTSDATAID as x
--from 
--  ( select
--  CENSUS_ID
--  ,SUBJECT_ID
--  ,ICUSTAY_ID
--  ,to_char(INTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as INTIME  
--  ,to_char(OUTTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as OUTTIME 
--  ,CUID
--  ,LOS
--  ,DESTCAREUNIT
--  ,DISCHSTATUS
--  ,CENSUSEVENTSDATAID
--  from mimic2v30b.CENSUSEVENTS));
--
--
--spool off;

/***************    CHARTEVENTS  ********************/

spool "/backup/dpdump/mimic2v30b_csv/chartevents.csv"
select 'SUBJECT_ID'||','||'HADM_ID'||','||'ICUSTAY_ID'||','||'ITEMID'||','||'LABEL'||','||'TIME'||','||'ELEMID'||','||'VALIDATIONTIME'||','||'CGID'
||','||'CUID'||','||'VALUE1'||','||'VALUE1NUM'||','||'VALUE1UOM'||','||'COMMENTS'||','||'VALUE2'||','||'VALUE2NUM'||','||'VALUE2UOM'||','||'RESULTSTATUS' 
||','||'STOPPED'||','||'WARNING'||','||'ERROR'||','||'CHARTEVENTSDATAID' from dual;

select x from (
select SUBJECT_ID||','||HADM_ID||','||ICUSTAY_ID||','||ITEMID||',"'||LABEL||'",'||TIME||','||ELEMID||','||VALIDATIONTIME||','||CGID
||','||CUID||',"'||VALUE1||'",'||VALUE1NUM||',"'||VALUE1UOM||'","'||COMMENTS||'","'||VALUE2||'",'||VALUE2NUM||',"'||VALUE2UOM||'","'||RESULTSTATUS 
||'","' || STOPPED || '",' || WARNING || ',' || ERROR || ',' || CHARTEVENTSDATAID  as x
from 
  ( select
  SUBJECT_ID
  ,HADM_ID
  ,ICUSTAY_ID
  ,ITEMID
  ,LABEL
  ,to_char(TIME, 'dd-mon-yyyy hh24:mi:ss tzr') as TIME  
  ,ELEMID
  ,to_char(VALIDATIONTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as VALIDATIONTIME 
  ,CGID
  ,CUID
  ,VALUE1
  ,VALUE1NUM
  ,VALUE1UOM
  ,COMMENTS
  ,VALUE2
  ,VALUE2NUM
  ,VALUE2UOM
  ,RESULTSTATUS
  ,STOPPED
  ,WARNING
  ,ERROR
  ,CHARTEVENTSDATAID
  from mimic2v30b.CHARTEVENTS));

spool off;

SET TERMOUT ON
