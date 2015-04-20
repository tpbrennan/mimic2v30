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

spool "/backup/dpdump/mimic2v30b_csv/labevents_mornin.csv"

-- ||','|| goes between each one and you need single quotes.

select 
'SUBJECT_ID'
||','||
'HADM_ID'
||','||
'ITEMID'
||','||
'CHARTTIME'
||','||
'TEST_NAME'
||','||
'VALUE'
||','||
'VALUENUM'
||','||
'VALUEUOM'
||','||
'FLAG'
||','||
'FLUID'
||','||
'CATEGORY'
||','||
'LOINC_CODE'
||','||
'LABEVENTSDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
SUBJECT_ID
||'","'||
HADM_ID
||'","'||
ITEMID
||'","'||
CHARTTIME
||'","'||
TEST_NAME
||'","'||
VALUE
||'","'||
VALUENUM
||'","'||
VALUEUOM
||'","'||
FLAG
||'","'||
FLUID
||'","'||
CATEGORY
||'","'||
LOINC_CODE
||'","'||
LABEVENTSDATAID
||'"' as x
from 
  ( select
SUBJECT_ID
,HADM_ID
,ITEMID
,to_char(CHARTTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as CHARTTIME 
,TEST_NAME
,VALUE
,VALUENUM
,VALUEUOM
,FLAG
,FLUID
,CATEGORY
,LOINC_CODE
,LABEVENTSDATAID
from mimic2v30b.LABEVENTS));

spool off;

SET TERMOUT ON
