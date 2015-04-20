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
-- CPTEVENTS ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/cptevents.csv"

-- ||','|| goes between each one and you need single quotes.

select 
'SUBJECT_ID'
||','||
'HADM_ID'
||','||
'CPT_CD'
||','||
'CPTEVENTSDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
SUBJECT_ID
||'","'||
HADM_ID
||'","'||
CPT_CD
||'","'||
CPTEVENTSDATAID
||'"' as x
from 
  ( select
    SUBJECT_ID
    ,HADM_ID
    ,CPT_CD
    ,CPTEVENTSDATAID
from mimic2v30b.CPTEVENTS));

spool off;

--------------------------------------------------------------------------------
-- D_CAREGIVERS ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/d_caregivers.csv"

-- ||','|| goes between each one and you need single quotes.

select
'CGID'
||','|| 
'CG_UNIQUEID'
||','|| 
'LABEL'
||','|| 
'DESCRIPTION'
||','|| 
'CGID_STATUS'
||','|| 
'D_CAREGIVERSDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
CGID
||'","'||
CG_UNIQUEID
||'","'||
LABEL
||'","'||
DESCRIPTION
||'","'||
CGID_STATUS
||'","'||
D_CAREGIVERSDATAID
||'"' as x
from 
    ( select
    CGID
    ,CG_UNIQUEID
    ,LABEL
    ,DESCRIPTION
    ,CGID_STATUS
    ,D_CAREGIVERSDATAID
from mimic2v30b.D_CAREGIVERS));

spool off;


--------------------------------------------------------------------------------
-- D_CAREUNITS ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/d_careunits.csv"

-- ||','|| goes between each one and you need single quotes.

select
'CUID'
||','||
'LABEL'
||','||
'D_CAREUNITSDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
CUID
||'","'||
LABEL
||'","'||
D_CAREUNITSDATAID
||'"' as x
from 
    ( select
      CUID
      ,LABEL
      ,D_CAREUNITSDATAID
from mimic2v30b.D_CAREUNITS));

spool off;

--------------------------------------------------------------------------------
-- D_ITEMS ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/d_items.csv"

-- ||','|| goes between each one and you need single quotes.

select
'ITEMID'
||','||
'LABEL'
||','||
'ABBREVIATION'
||','||
'ORIGIN'
||','||
'CODE'
||','||
'CATEGORY'
||','||
'UNITID'
||','||
'UNITNAME'
||','||
'TYPE'
||','||
'DESCRIPTION'
||','||
'LOWNORMALVALUE'
||','||
'HIGHNORMALVALUE'
||','||
'ALLERGYACTION'
||','||
'LOINC_CODE'
||','||
'LOINC_DESCRIPTION'
||','||
'OLD_LABITEMID'
||','||
'OLD_TEST_NAME'
||','||
'OLD_LOINC_CODE'
||','||
'D_ITEMSDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
ITEMID
||'","'||
LABEL
||'","'||
ABBREVIATION
||'","'||
ORIGIN
||'","'||
CODE
||'","'||
CATEGORY
||'","'||
UNITID
||'","'||
UNITNAME
||'","'||
TYPE
||'","'||
DESCRIPTION
||'","'||
LOWNORMALVALUE
||'","'||
HIGHNORMALVALUE
||'","'||
ALLERGYACTION
||'","'||
LOINC_CODE
||'","'||
LOINC_DESCRIPTION
||'","'||
OLD_LABITEMID
||'","'||
OLD_TEST_NAME
||'","'||
OLD_LOINC_CODE
||'","'||
D_ITEMSDATAID
||'"' as x
from 
    ( select
      ITEMID
      ,LABEL
      ,ABBREVIATION
      ,ORIGIN
      ,CODE
      ,CATEGORY
      ,UNITID
      ,UNITNAME
      ,TYPE
      ,DESCRIPTION
      ,LOWNORMALVALUE
      ,HIGHNORMALVALUE
      ,ALLERGYACTION
      ,LOINC_CODE
      ,LOINC_DESCRIPTION
      ,OLD_LABITEMID
      ,OLD_TEST_NAME
      ,OLD_LOINC_CODE
      ,D_ITEMSDATAID
from mimic2v30b.D_ITEMS));

spool off;

--------------------------------------------------------------------------------
-- D_PATIENTS ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/d_patients.csv"

-- ||','|| goes between each one and you need single quotes.

select
'SUBJECT_ID'
||','||
'SEX'
||','||
'DOB'
||','||
'DOD'
||','|| 
'HOSPITAL_EXPIRE_FLG'
||','|| 
'ZIPCODE'
||','||
'D_PATIENTSDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
SUBJECT_ID
||'","'||
SEX
||'","'||
DOB
||'","'||
DOD
||'","'||
HOSPITAL_EXPIRE_FLG
||'","'||
ZIPCODE
||'","'||
D_PATIENTSDATAID
||'"' as x
from 
    ( select
      SUBJECT_ID
      ,SEX
      ,to_char(DOB, 'dd-mon-yyyy') as DOB
      ,to_char(DOD, 'dd-mon-yyyy') as DOD
      ,HOSPITAL_EXPIRE_FLG
      ,ZIPCODE
      ,D_PATIENTSDATAID
from mimic2v30b.D_PATIENTS));

spool off;

--------------------------------------------------------------------------------
-- D_UNITS ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/d_units.csv"

-- ||','|| goes between each one and you need single quotes.

select
'UNITID'
||','||
'UNITNAME'
||','||
'MULTIPLIER'
||','||
'ADDITION'
||','||
'ISBASEUNIT'
||','||
'ISRELATIONAL'
||','||
'ISTIME'
||','||
'ISVOLUME'
||','||
'CATEGORY'
||','||
'D_UNITSDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
UNITID
||'","'||
UNITNAME
||'","'||
MULTIPLIER
||'","'||
ADDITION
||'","'||
ISBASEUNIT
||'","'||
ISRELATIONAL
||'","'||
ISTIME
||'","'||
ISVOLUME
||'","'||
CATEGORY
||'","'||
D_UNITSDATAID
||'"' as x
from 
    ( select
      UNITID
      ,UNITNAME
      ,MULTIPLIER
      ,ADDITION
      ,ISBASEUNIT
      ,ISRELATIONAL
      ,ISTIME
      ,ISVOLUME
      ,CATEGORY
      ,D_UNITSDATAID
from mimic2v30b.D_UNITS));

spool off;


--------------------------------------------------------------------------------
-- DEMOGRAPHIC_DETAIL ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/demographic_detail.csv"

-- ||','|| goes between each one and you need single quotes.

select
'SUBJECT_ID'
||','||
'HADM_ID'
||','||
'MARITAL_STATUS_ITEMID'
||','||
'MARITAL_STATUS_DESCR'
||','||
'ETHNICITY_ITEMID'
||','||
'ETHNICITY_DESCR'
||','||
'OVERALL_PAYOR_GROUP_ITEMID'
||','||
'OVERALL_PAYOR_GROUP_DESCR'
||','||
'RELIGION_ITEMID'
||','||
'RELIGION_DESCR'
||','||
'ADMISSION_TYPE_ITEMID'
||','||
'ADMISSION_TYPE_DESCR'
||','||
'ADMISSION_SOURCE_ITEMID'
||','||
'ADMISSION_SOURCE_DESCR'
||','||
'DEMOGRAPHIC_DETAILDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
SUBJECT_ID
||'","'||
HADM_ID
||'","'||
MARITAL_STATUS_ITEMID
||'","'||
MARITAL_STATUS_DESCR
||'","'||
ETHNICITY_ITEMID
||'","'||
ETHNICITY_DESCR
||'","'||
OVERALL_PAYOR_GROUP_ITEMID
||'","'||
OVERALL_PAYOR_GROUP_DESCR
||'","'||
RELIGION_ITEMID
||'","'||
RELIGION_DESCR
||'","'||
ADMISSION_TYPE_ITEMID
||'","'||
ADMISSION_TYPE_DESCR
||'","'||
ADMISSION_SOURCE_ITEMID
||'","'||
ADMISSION_SOURCE_DESCR
||'","'||
DEMOGRAPHIC_DETAILDATAID
||'"' as x
from 
    ( select
      SUBJECT_ID
      ,HADM_ID
      ,MARITAL_STATUS_ITEMID
      ,MARITAL_STATUS_DESCR
      ,ETHNICITY_ITEMID
      ,ETHNICITY_DESCR
      ,OVERALL_PAYOR_GROUP_ITEMID
      ,OVERALL_PAYOR_GROUP_DESCR
      ,RELIGION_ITEMID
      ,RELIGION_DESCR
      ,ADMISSION_TYPE_ITEMID
      ,ADMISSION_TYPE_DESCR
      ,ADMISSION_SOURCE_ITEMID
      ,ADMISSION_SOURCE_DESCR
      ,DEMOGRAPHIC_DETAILDATAID
from mimic2v30b.DEMOGRAPHIC_DETAIL));

spool off;

SET TERMOUT ON
