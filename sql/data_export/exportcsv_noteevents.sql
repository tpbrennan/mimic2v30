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

--------------------------------------------------------------------------------
-- LABEVENTS ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/home/mornin/noteevents_mornin.dsv"

-- ||','|| goes between each one and you need single quotes.

select 
'REC_ID'
||'$!*'||
'SUBJECT_ID'
||'$!*'||
'HADM_ID'
||'$!*'||
'ICUSTAY_ID'
||'$!*'||
'ELEMID'
||'$!*'||
'TIME'
||'$!*'||
'KEYINTIME'
||'$!*'||
'CGID'
||'$!*'||
'CORRECTION'
||'$!*'||
'CUID'
||'$!*'||
'CATEGORY'
||'$!*'||
'TITLE'
||'$!*'||
'TEXT'
||'$!*'||
'EXAM_NAME'
||'$!*'||
'PATIENT_INFO'
||'$!*'||
'NOTEEVENTSDATAID'
||'####'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
REC_ID
||'$!*'||
SUBJECT_ID
||'$!*'||
HADM_ID
||'$!*'||
ICUSTAY_ID
||'$!*'||
ELEMID
||'$!*'||
TIME
||'$!*'||
KEYINTIME
||'$!*'||
CGID
||'$!*'||
CORRECTION
||'$!*'||
CUID
||'$!*'||
CATEGORY
||'$!*'||
TITLE
||'$!*'||
TEXT
||'$!*'||
EXAM_NAME
||'$!*'||
PATIENT_INFO
||'$!*'||
NOTEEVENTSDATAID
||'####'
as x
from 
  ( select
REC_ID
,SUBJECT_ID
,HADM_ID
,ICUSTAY_ID
,ELEMID
,to_char(TIME, 'yyyy-mm-dd hh24:mi:ss') as TIME
,to_char(KEYINTIME, 'yyyy-mm-dd hh24:mi:ss') as KEYINTIME
,CGID
,CORRECTION
,CUID
,CATEGORY
,TITLE
,TEXT
,EXAM_NAME
,PATIENT_INFO
,NOTEEVENTSDATAID
from mimic2v30b_utc.NOTEEVENTS));

spool off;

SET TERMOUT ON
