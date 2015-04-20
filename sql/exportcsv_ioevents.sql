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
||','||
'ICUSTAY_ID'
||','||
'ORDERID'
||','||
'ITEMID'
||','||
'LABEL'
||','||
'CHARTTIME'
||','||
'ELEMID'
||','||
'ALTID'
||','||
'REALTIME'
||','||
'STARTTIME'
||','||
'ENDTIME'
||','||
'CGID'
||','||
'CUID'
||','||
'VALUE'
||','||
'UOM'
||','||
'UNITSHUNG'
||','||
'UNITSHUNGUOM'
||','||
'NEWBOTTLE'
||','||
'STOPPED'
||','||
'ESTIMATE'
||','||
'IOEVENTSDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
SUBJECT_ID
||'","'||
ICUSTAY_ID
||'","'||
ORDERID
||'","'||
ITEMID
||'","'||
LABEL
||'","'||
CHARTTIME
||'","'||
ELEMID
||'","'||
ALTID
||'","'||
REALTIME
||'","'||
STARTTIME
||'","'||
ENDTIME
||'","'||
CGID
||'","'||
CUID
||'","'||
VALUE
||'","'||
UOM
||'","'||
UNITSHUNG
||'","'||
UNITSHUNGUOM
||'","'||
NEWBOTTLE
||'","'||
STOPPED
||'","'||
ESTIMATE
||'","'||
IOEVENTSDATAID
||'"' as x
from 
  ( select
SUBJECT_ID
,ICUSTAY_ID
,ORDERID
,ITEMID
,LABEL
,to_char(CHARTTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as CHARTTIME 
,ELEMID
,ALTID
,to_char(REALTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as REALTIME 
,to_char(STARTTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as STARTTIME 
,to_char(ENDTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as ENDTIME 
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
from mimic2v30b.IOEVENTS));

spool off;

SET TERMOUT ON
