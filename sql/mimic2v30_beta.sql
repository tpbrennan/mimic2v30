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

alter table admissions
ADD CONSTRAINT admissions_pk PRIMARY KEY (hadm_id);

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