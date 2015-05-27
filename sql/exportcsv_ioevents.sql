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
-- IOEVENTS ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/ioevents_mornin.csv"

-- ||','|| goes between each one and you need single quotes.

select 
'SUBJECT_ID'
||'$!*'||
'ICUSTAY_ID'
||'$!*'||
'ORDERID'
||'$!*'||
'ITEMID'
||'$!*'||
'LABEL'
||'$!*'||
'ELEMID'
||'$!*'||
'ALTID'
||'$!*'||
'STARTTIME'
||'$!*'||
'ENDTIME'
||'$!*'||
'KEYINSTARTTIME'
||'$!*'||
'CGID'
||'$!*'||
'CUID'
||'$!*'||
'VALUE'
||'$!*'||
'UOM'
||'$!*'||
'UNITSHUNG'
||'$!*'||
'UNITSHUNGUOM'
||'$!*'||
'NEWBOTTLE'
||'$!*'||
'STOPPED'
||'$!*'||
'ESTIMATE'
||'$!*'||
'IOEVENTSDATAID'
||'####'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
SUBJECT_ID
||'$!*'||
ICUSTAY_ID
||'$!*'||
ORDERID
||'$!*'||
ITEMID
||'$!*'||
LABEL
||'$!*'||
ELEMID
||'$!*'||
ALTID
||'$!*'||
STARTTIME
||'$!*'||
ENDTIME
||'$!*'||
KEYINSTARTTIME
||'$!*'||
CGID
||'$!*'||
CUID
||'$!*'||
VALUE
||'$!*'||
UOM
||'$!*'||
UNITSHUNG
||'$!*'||
UNITSHUNGUOM
||'$!*'||
NEWBOTTLE
||'$!*'||
STOPPED
||'$!*'||
ESTIMATE
||'$!*'||
IOEVENTSDATAID
||'####'
as x
from 
  ( select
SUBJECT_ID
,ICUSTAY_ID
,ORDERID
,ITEMID
,LABEL
,ELEMID
,ALTID
,to_char(STARTTIME, 'yyyy-mm-dd hh24:mi:ss') as STARTTIME
,to_char(ENDTIME, 'yyyy-mm-dd hh24:mi:ss') as ENDTIME
,to_char(KEYINSTARTTIME, 'yyyy-mm-dd hh24:mi:ss') as KEYINSTARTTIME
,CGID
,CUID
,VALUE
,UOM
,UNITSHUNG
,UNITSHUNGUOM
,NEWBOTTLE
,STOPPED
,ESTIMATE
,IOEVENTSDATAID
from mimic2v30b_utc.IOEVENTS));

spool off;

SET TERMOUT ON
