/*
  mimic2v30_beta.sql

  Created on   : Mar 2015 by Mornin Feng
  Last updated :
     $Author: Mornin Feng $
     $Date: 2014 March 1st  $
     $Rev: $

Must run from mimic2v30b
Recreating mimic2v30 with new updates

*/
/***************    addiditves  ********************/

create table additives as
select a.* 
, case when charttime is null then 'metavision' else 'v26' end as source_flg
from mimic2v30.additives a;
--order by 1 desc;

COMMENT ON COLUMN additives.subject_id IS 'Unique patient identifier';



/***************    admissions  ********************/

create table admissions as
select * from mornin.v30_admissions_beta;


/***************    censusevents  ********************/

create table censusevents as
select * from mimic2v30.censusevents;



/***************    chartevents  ********************/
create table chartevents as
select * from mimic2v30.chartevents
union all
select * from mornin.v30_gcs_merge
union all
select * from mornin.v30_code_status;

/***************    cptevents  ********************/
create table cptevents as
select * from mimic2v30.cptevents;

/***************    D_CAREGIVERS  ********************/
create table D_CAREGIVERS as
select * from mimic2v30.D_CAREGIVERS;


/***************    D_CAREUNITS  ********************/
create table D_CAREUNITS as
select * from mimic2v30.D_CAREUNITS;


/***************    d_items  ********************/

create table d_items as
select * from mimic2v30.d_items;

insert into d_items
(
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
)
values
(
229000
, 'GCS - GCS Total'
, null
, 'MORNIN'
, null
, 'Neurological'
, null
, null
, 'Numeric'
, null
, null
, null
, null
, null
, null
, null
, null
, null
);

commit;

/***************    D_PATIENTS  ********************/
create table D_PATIENTS as
select * from mimic2v30.D_PATIENTS;

/***************    D_UNITS  ********************/
create table D_UNITS as
select * from mimic2v30.D_UNITS;

/***************    DEMOGRAPHIC_DETAIL  ********************/
create table DEMOGRAPHIC_DETAIL as
select * from mimic2v30.DEMOGRAPHIC_DETAIL;

/***************    DRGEVENTS  ********************/
create table DRGEVENTS as
select * from mimic2v30.DRGEVENTS;

/***************    ICD9  ********************/
create table ICD9 as
select * from mimic2v30.ICD9;

/***************    ICUSTAY_DAYS  ********************/
create table ICUSTAY_DAYS as
select * from mimic2v30.ICUSTAY_DAYS;

/***************    ICUSTAYEVENTS  ********************/
create table ICUSTAYEVENTS as
select * from mimic2v30.ICUSTAYEVENTS;

/***************    IOEVENTS  ********************/
create table IOEVENTS as
select * from mimic2v30.IOEVENTS;


--MEDEVENTS
--MICROBIOLOGYEVENTS
--NOTEEVENTS
--ORDERENTRY
--POE_MED_ORDER
--PROCEDUREEVENTS
--TOTALBALEVENTS


/***************    labevents  ********************/
create table labevents as
with new_lab as
(select 
--rownum as row_id
SUBJECT_ID
,HADM_ID
,ITEMID
,CHARTTIME
,TEST_NAME
,value
,case when regexp_like(value, '[[:digit:]]') and
(
  regexp_like(value, '^[-+]{0,1}([[:digit:]]){0,3}(\,([[:digit:]]){0,3})*(\.[[:digit:]]+){0,1}$')
  or 
  regexp_like(value, '^[-+]{0,1}[[:digit:]]*(\.[[:digit:]]+){0,1}$')
)
  then to_number(value) 
  --then 1
  else null end as valuenum
,VALUEUOM
,FLAG
,FLUID
,CATEGORY
,LOINC_CODE

from mimic2v30.labevents)

select * from new_lab;


/***************    MEDEVENTS  ********************/
create table MEDEVENTS as
select * from mimic2v30.MEDEVENTS;

/***************    MICROBIOLOGYEVENTS  ********************/
create table MICROBIOLOGYEVENTS as
select * from mimic2v30.MICROBIOLOGYEVENTS;

/***************    NOTEEVENTS  ********************/
create table NOTEEVENTS as
select * from mimic2v30.NOTEEVENTS;

/***************    ORDERENTRY  ********************/
create table ORDERENTRY as
select * from mimic2v30.ORDERENTRY;

/***************    POE_MED_ORDER  ********************/
create table POE_MED_ORDER as
select * from mimic2v30.POE_MED_ORDER;

/***************    PROCEDUREEVENTS  ********************/
create table PROCEDUREEVENTS as
select * from mimic2v30.PROCEDUREEVENTS;

/***************    TOTALBALEVENTS  ********************/
create table TOTALBALEVENTS as
select * from mimic2v30.TOTALBALEVENTS;



--select * from new_lab where itemid in (225677);
--group by valueuom;
/***************    ventilation  ********************/
select 
cast(subject_id as number(8,0)) as subject_id
, cast(icustay_id as number(8,0)) as icustay_id
, cast(seq as number(1,0)) as seq
, to_date(begin_time, 'DD-MON-YY hh:mi:ss am', 'nls_date_language = ENGLISH')
--, to_timestamp_tz(begin_time, 'DD-MON-YYYY hh:mi:ss am tzr', 'nls_date_language = ENGLISH') as start_time
from MORNIN.v26_ventilation;

/***************    lcp_COMORBIDITY_SCORES  ********************/
create table lcp_COMORBIDITY_SCORES as
select * from mimic2v30.COMORBIDITY_SCORES;

create table lcp_ELIXHAUSER_SCORES as
select * from mornin.V30_ELIXHAUSER_SCORES;


/***************    lcp_daily_sofa  ********************/
create table cal_daily_sofa as
select * from MOHAMMAD.daily_sofa_score;

alter table cal_daily_sofa rename to lcp_daily_sofa;

commit;