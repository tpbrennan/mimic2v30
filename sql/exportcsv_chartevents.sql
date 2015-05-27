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
SET COLSEP ','


/***************    CHARTEVENTS  ********************/

spool "/backup/dpdump/mimic2v30b_csv/chartevents_mornin.csv"
select 
'SUBJECT_ID'
||'$!*'||
'HADM_ID'
||'$!*'||
'ICUSTAY_ID'
||'$!*'||
'ITEMID'
||'$!*'||
'LABEL'
||'$!*'||
'TIME'
||'$!*'||
'ELEMID'
||'$!*'||
'KEYINTIME'
||'$!*'||
'CGID'
||'$!*'||
'CUID'
||'$!*'||
'VALUE1'
||'$!*'||
'VALUE1NUM'
||'$!*'||
'VALUE1UOM'
||'$!*'||
'VALUE2'
||'$!*'||
'VALUE2NUM'
||'$!*'||
'VALUE2UOM'
||'$!*'||
'RESULTSTATUS'
||'$!*'||
'STOPPED'
||'$!*'||
'WARNING'
||'$!*'||
'ERROR'
||'$!*'||
'CHARTEVENTSDATAID'
||'####'
from dual;

select x from (
select 
SUBJECT_ID
||'$!*'||
HADM_ID
||'$!*'||
ICUSTAY_ID
||'$!*'||
ITEMID
||'$!*'||
LABEL
||'$!*'||
TIME
||'$!*'||
ELEMID
||'$!*'||
KEYINTIME
||'$!*'||
CGID
||'$!*'||
CUID
||'$!*'||
VALUE1
||'$!*'||
VALUE1NUM
||'$!*'||
VALUE1UOM
||'$!*'||
VALUE2
||'$!*'||
VALUE2NUM
||'$!*'||
VALUE2UOM
||'$!*'||
RESULTSTATUS
||'$!*'||
STOPPED
||'$!*'||
WARNING
||'$!*'||
ERROR
||'$!*'||
CHARTEVENTSDATAID
||'####'
as x
from 
  ( select
  SUBJECT_ID
  ,HADM_ID
  ,ICUSTAY_ID
  ,ITEMID
  ,LABEL
  ,to_char(TIME, 'yyyy-mm-dd hh24:mi:ss') as TIME 
  ,ELEMID
  ,to_char(KEYINTIME, 'yyyy-mm-dd hh24:mi:ss') as KEYINTIME
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
  from mimic2v30b_utc.CHARTEVENTS));

spool off;

SET TERMOUT ON
