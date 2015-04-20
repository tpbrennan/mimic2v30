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
--MICROBIOLOGYEVENTS ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/microbiologyevents_mornin.csv"

-- ||','|| goes between each one and you need single quotes.

select 
'SUBJECT_ID'
||','||
'HADM_ID'
||','||
'TIME'
||','||
'SPEC_TYPE_CD'
||','||
'SPEC_ITEMID'
||','||
'SPEC_TYPE_DESC'
||','||
'ORG_CD'
||','||
'ORG_ITEMID'
||','||
'ORG_NAME'
||','||
'ISOLATE_NUM'
||','||
'AB_CD'
||','||
'AB_ITEMID'
||','||
'AB_NAME'
||','||
'DILUTION_AMOUNT'
||','||
'DILUTION_COMPARISON'
||','||
'INTERPRETATION'
||','||
'MICROBIOLOGYEVENTSDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
SUBJECT_ID
||'","'||
HADM_ID
||'","'||
TIME
||'","'||
SPEC_TYPE_CD
||'","'||
SPEC_ITEMID
||'","'||
SPEC_TYPE_DESC
||'","'||
ORG_CD
||'","'||
ORG_ITEMID
||'","'||
ORG_NAME
||'","'||
ISOLATE_NUM
||'","'||
AB_CD
||'","'||
AB_ITEMID
||'","'||
AB_NAME
||'","'||
DILUTION_AMOUNT
||'","'||
DILUTION_COMPARISON
||'","'||
INTERPRETATION
||'","'||
MICROBIOLOGYEVENTSDATAID
||'"' as x
from 
  ( select
SUBJECT_ID
,HADM_ID
,to_char(TIME, 'dd-mon-yyyy') as TIME
,SPEC_TYPE_CD
,SPEC_ITEMID
,SPEC_TYPE_DESC
,ORG_CD
,ORG_ITEMID
,ORG_NAME
,ISOLATE_NUM
,AB_CD
,AB_ITEMID
,AB_NAME
,DILUTION_AMOUNT
,DILUTION_COMPARISON
,INTERPRETATION
,MICROBIOLOGYEVENTSDATAID
from mimic2v30b.MICROBIOLOGYEVENTS));

spool off;

SET TERMOUT ON
