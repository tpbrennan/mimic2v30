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
-- DRGEVENTS ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/drgevents.csv"

-- ||','|| goes between each one and you need single quotes.

select 
'SUBJECT_ID'
||','||
'HADM_ID'
||','||
'ITEMID'
||','||
'TYPE'
||','||
'CODE'
||','||
'DESCRIPTION'
||','||
'COST_WEIGHT'
||','||
'DRGEVENTSDATAID'
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
TYPE
||'","'||
CODE
||'","'||
DESCRIPTION
||'","'||
COST_WEIGHT
||'","'||
DRGEVENTSDATAID
||'"' as x
from 
  ( select
    SUBJECT_ID
    ,HADM_ID
    ,ITEMID
    ,TYPE
    ,CODE
    ,DESCRIPTION
    ,COST_WEIGHT
    ,DRGEVENTSDATAID
    from mimic2v30b.DRGEVENTS));

spool off;

--------------------------------------------------------------------------------
-- ICD9 ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/icd9.csv"

-- ||','|| goes between each one and you need single quotes.

select 
'SUBJECT_ID'
||','||
'HADM_ID'
||','||
'SEQUENCE'
||','||
'CODE'
||','||
'DESCRIPTION'
||','||
'ICD9DATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
SUBJECT_ID
||'","'||
HADM_ID
||'","'||
SEQUENCE
||'","'||
CODE
||'","'||
DESCRIPTION
||'","'||
ICD9DATAID
||'"' as x
from 
  ( select
    SUBJECT_ID
    ,HADM_ID
    ,SEQUENCE
    ,CODE
    ,DESCRIPTION
    ,ICD9DATAID
    from mimic2v30b.ICD9));

spool off;

--------------------------------------------------------------------------------
-- ICUSTAY_DAYS ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/icustay_days.csv"

-- ||','|| goes between each one and you need single quotes.

select
'ICUSTAY_ID'
||','||
'SUBJECT_ID'
||','||
'SEQ'
||','||
'BEGINTIME'
||','||
'ENDTIME'
||','||
'FIRST_DAY_FLG'
||','||
'LAST_DAY_FLG'
||','||
'ICUSTAY_DAYSDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
ICUSTAY_ID
||'","'||
SUBJECT_ID
||'","'||
SEQ
||'","'||
BEGINTIME
||'","'||
ENDTIME
||'","'||
FIRST_DAY_FLG
||'","'||
LAST_DAY_FLG
||'","'||
ICUSTAY_DAYSDATAID
||'"' as x
from 
  ( select
    ICUSTAY_ID
    ,SUBJECT_ID
    ,SEQ
    ,to_char(BEGINTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as BEGINTIME
    ,to_char(ENDTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as ENDTIME
    ,FIRST_DAY_FLG
    ,LAST_DAY_FLG
    ,ICUSTAY_DAYSDATAID
    from mimic2v30b.ICUSTAY_DAYS));

spool off;

--------------------------------------------------------------------------------
-- ICUSTAYEVENTS ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/icustayevents.csv"

-- ||','|| goes between each one and you need single quotes.

select
'ICUSTAY_ID'
||','||
'SUBJECT_ID'
||','||
'INTIME'
||','||
'OUTTIME'
||','||
'LOS'
||','||
'FIRST_CAREUNIT'
||','||
'LAST_CAREUNIT'
||','||
'ICUSTAYEVENTSDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
ICUSTAY_ID
||'","'||
SUBJECT_ID
||'","'||
INTIME
||'","'||
OUTTIME
||'","'||
LOS
||'","'||
FIRST_CAREUNIT
||'","'||
LAST_CAREUNIT
||'","'||
ICUSTAYEVENTSDATAID
||'"' as x
from 
  ( select
    ICUSTAY_ID
    ,SUBJECT_ID
    ,to_char(INTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as INTIME 
    ,to_char(OUTTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as OUTTIME 
    ,LOS
    ,FIRST_CAREUNIT
    ,LAST_CAREUNIT
    ,ICUSTAYEVENTSDATAID
    from mimic2v30b.ICUSTAYEVENTS));

spool off;

SET TERMOUT ON
