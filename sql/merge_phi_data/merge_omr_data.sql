/*
  merge_omr_data.sql

  Created on   : May 2015 by Mornin Feng
  Last updated :
     $Author: Mornin Feng $
     $Date: 2015 May 25th  $
     $Rev: $
Merge PHI_OMR_DATA into mimic2v30. Must run on brp2 server
*/

create table BIDMC_012013.phi_omr_data_supplement as
select * from mornin.phi_omr_data_supplement;

/***************    data_deidentification  ********************/
drop table mornin.de_omr_data_supplement;
create materialized view mornin.de_omr_data_supplement as
with omr_data as(
select
MRN
,MRN_CM
,FISCAL_NUM
,to_date(ADM_DT, 'mm/dd/yy') as ADM_DT
,to_date(DISCH_DT, 'mm/dd/yyyy') as DISCH_DT
,to_date(DOB, 'mm/dd/yy') as DOB
--, HT_PER_OMR
, case when LENGTH(TRIM(TRANSLATE(HT_PER_OMR, ' +-.0123456789',' ')))>=1 then null
        else cast(HT_PER_OMR as number) end as HT_PER_OMR
,to_date(HT_PER_OMR_DT, 'mm/dd/yyyy') as HT_PER_OMR_DT

,cast(HEIGHT_INCHES_NURSING_ASSESS as number) as HEIGHT_INCHES_NURSING_ASSESS
,case when LENGTH(TRIM(TRANSLATE(WEIGHT_POUNDS_NURSING_ASSESS, ' +-.0123456789',' ')))>=1 then null
        else cast(WEIGHT_POUNDS_NURSING_ASSESS as number) end as WEIGHT_POUNDS_NURSING_ASSESS

,to_date(READMIT_DT, 'mm/dd/yyyy') as READMIT_DT
--,READMIT_ENC
,READMIT_PRINC_DIAG as READMIT_PRINC_DIAG_ICD9
,READMIT_PRINC_DIAGDESC
,READMITADT_REASON

,cast(MOST_RECENT_CREATININEVALUE as number(24,8)) as MOST_RECENT_CREATININEVALUE
,cast(cast(to_timestamp(MOST_RECENT_CREATININEDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as MOST_RECENT_CREATININEDT
,cast(PRE7DAYSCREATININEVALUE as number(24,8)) as PRE7DAYSCREATININEVALUE
,cast(cast(to_timestamp(PRE7DAYSCREATININEDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as PRE7DAYSCREATININEDT
,cast(POST7DAYSCREATININEVALUE as number(24,8)) as POST7DAYSCREATININEVALUE
,cast(cast(to_timestamp(POST7DAYSCREATININEDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as POST7DAYSCREATININEDT
,cast(PRE7DAYSWBCVALUE as number(10,6)) as PRE7DAYSWBCVALUE
,cast(cast(to_timestamp(PRE7DAYSWBCDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as PRE7DAYSWBCDT
,cast(PRE7DAYSHEMOGLOBINVALUE as number(10,6)) as PRE7DAYSHEMOGLOBINVALUE
,cast(cast(to_timestamp(PRE7DAYSHEMOGLOBINDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as PRE7DAYSHEMOGLOBINDT
,cast(PRE7DAYSPLATELETVALUE as number(10,6)) as PRE7DAYSPLATELETVALUE
,cast(cast(to_timestamp(PRE7DAYSPLATELETDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as PRE7DAYSPLATELETDT
,cast(PRE7DAYSALBUMINVALUE as number(10,6)) as PRE7DAYSALBUMINVALUE
,cast(cast(to_timestamp(PRE7DAYSALBUMINDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as PRE7DAYSALBUMINDT
,cast(PRE7DAYSSODIUMVALUE as number(10,6)) as PRE7DAYSSODIUMVALUE
,cast(cast(to_timestamp(PRE7DAYSSODIUMDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as PRE7DAYSSODIUMDT
,cast(POST7DAYSWBCVALUE as number(10,6)) as POST7DAYSWBCVALUE
,cast(cast(to_timestamp(POST7DAYSWBCDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as POST7DAYSWBCDT
,cast(POST7DAYSHEMOGLOBINVALUE as number(10,6)) as POST7DAYSHEMOGLOBINVALUE
,cast(cast(to_timestamp(POST7DAYSHEMOGLOBINDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as POST7DAYSHEMOGLOBINDT
,cast(POST7DAYSPLATELETVALUE as number(10,6)) as POST7DAYSPLATELETVALUE
,cast(cast(to_timestamp(POST7DAYSPLATELETDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as POST7DAYSPLATELETDT
,cast(POST7DAYSALBUMINVALUE as number(10,6)) as POST7DAYSALBUMINVALUE
,cast(cast(to_timestamp(POST7DAYSALBUMINDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as POST7DAYSALBUMINDT
,cast(POST7DAYSSODIUMVALUE as number(10,6)) as POST7DAYSSODIUMVALUE
,cast(cast(to_timestamp(POST7DAYSSODIUMDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as POST7DAYSSODIUMDT
,cast(MOST_RECENT_WBCVALUE as number(10,6)) as MOST_RECENT_WBCVALUE
,cast(cast(to_timestamp(MOST_RECENT_WBCDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as MOST_RECENT_WBCDT
,cast(MOST_RECENT_HEMOGLOBINVALUE as number(10,6)) as MOST_RECENT_HEMOGLOBINVALUE
,cast(cast(to_timestamp(MOST_RECENT_HEMOGLOBINDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as MOST_RECENT_HEMOGLOBINDT
,cast(MOST_RECENT_PLATELETVALUE as number(10,6)) as MOST_RECENT_PLATELETVALUE
,cast(cast(to_timestamp(MOST_RECENT_PLATELETDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as MOST_RECENT_PLATELETDT
,cast(MOST_RECENT_ALBUMINVALUE as number(10,6)) as MOST_RECENT_ALBUMINVALUE
,cast(cast(to_timestamp(MOST_RECENT_ALBUMINDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as MOST_RECENT_ALBUMINDT
,cast(MOST_RECENT_SODIUMVALUE as number(10,6)) as MOST_RECENT_SODIUMVALUE
,cast(cast(to_timestamp(MOST_RECENT_SODIUMDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as MOST_RECENT_SODIUMDT
from mornin.phi_omr_data_supplement
order by 1,2)

--select * from omr_data; --47563

, deidentified_data as
(select
adm.subject_id
, adm.hadm_id
--, mrg.days_shifted
--, omr.mrn
--, omr.fiscal_num
, case when omr.ht_per_omr is null then omr.HEIGHT_INCHES_NURSING_ASSESS else omr.ht_per_omr end as height_inches
, omr.WEIGHT_POUNDS_NURSING_ASSESS as WEIGHT_POUNDS
, case when omr.READMIT_DT is null then 0 else 1 end as readmit_flg
, omr.READMIT_DT + mrg.days_shifted as READMIT_DT
, omr.READMIT_PRINC_DIAG_ICD9
, omr.READMIT_PRINC_DIAGDESC
, omr.READMITADT_REASON
, omr.MOST_RECENT_CREATININEVALUE
, cast(omr.MOST_RECENT_CREATININEDT + mrg.days_shifted as timestamp(6)) as MOST_RECENT_CREATININEDT
, omr.PRE7DAYSCREATININEVALUE
, cast(omr.PRE7DAYSCREATININEDT + mrg.days_shifted as timestamp(6)) as PRE7DAYSCREATININEDT
, omr.POST7DAYSCREATININEVALUE
, cast(omr.POST7DAYSCREATININEDT + mrg.days_shifted as timestamp(6)) as POST7DAYSCREATININEDT
, omr.PRE7DAYSWBCVALUE
, cast(omr.PRE7DAYSWBCDT + mrg.days_shifted as timestamp(6)) as PRE7DAYSWBCDT
, omr.PRE7DAYSHEMOGLOBINVALUE
, cast(omr.PRE7DAYSHEMOGLOBINDT + mrg.days_shifted as timestamp(6)) as PRE7DAYSHEMOGLOBINDT
, omr.PRE7DAYSPLATELETVALUE
, cast(omr.PRE7DAYSPLATELETDT + mrg.days_shifted as timestamp(6)) as PRE7DAYSPLATELETDT
, omr.PRE7DAYSALBUMINVALUE
, cast(omr.PRE7DAYSALBUMINDT + mrg.days_shifted as timestamp(6)) as PRE7DAYSALBUMINDT
, omr.PRE7DAYSSODIUMVALUE
, cast(omr.PRE7DAYSSODIUMDT + mrg.days_shifted as timestamp(6)) as PRE7DAYSSODIUMDT
, omr.POST7DAYSWBCVALUE
, cast(omr.POST7DAYSWBCDT + mrg.days_shifted as timestamp(6)) as POST7DAYSWBCDT
, omr.POST7DAYSHEMOGLOBINVALUE
, cast(omr.POST7DAYSHEMOGLOBINDT + mrg.days_shifted as timestamp(6)) as POST7DAYSHEMOGLOBINDT
, omr.POST7DAYSPLATELETVALUE
, cast(omr.POST7DAYSPLATELETDT + mrg.days_shifted as timestamp(6)) as POST7DAYSPLATELETDT
, omr.POST7DAYSALBUMINVALUE
, cast(omr.POST7DAYSALBUMINDT + mrg.days_shifted as timestamp(6)) as POST7DAYSALBUMINDT
, omr.POST7DAYSSODIUMVALUE
, cast(omr.POST7DAYSSODIUMDT + mrg.days_shifted as timestamp(6)) as POST7DAYSSODIUMDT
, omr.MOST_RECENT_WBCVALUE
, cast(omr.MOST_RECENT_WBCDT + mrg.days_shifted as timestamp(6)) as MOST_RECENT_WBCDT
, omr.MOST_RECENT_HEMOGLOBINVALUE
, cast(omr.MOST_RECENT_HEMOGLOBINDT + mrg.days_shifted as timestamp(6)) as MOST_RECENT_HEMOGLOBINDT
, omr.MOST_RECENT_PLATELETVALUE
, cast(omr.MOST_RECENT_PLATELETDT + mrg.days_shifted as timestamp(6)) as MOST_RECENT_PLATELETDT
, omr.MOST_RECENT_ALBUMINVALUE
, cast(omr.MOST_RECENT_ALBUMINDT + mrg.days_shifted as timestamp(6)) as MOST_RECENT_ALBUMINDT
, omr.MOST_RECENT_SODIUMVALUE
, cast(omr.MOST_RECENT_SODIUMDT + mrg.days_shifted as timestamp(6)) as MOST_RECENT_SODIUMDT
from omr_data omr
join merge30.admissions adm on adm.fiscal_num=omr.fiscal_num
join gparam.MRN_SUBJECTID_DTSHIFT_MERGE30 mrg on mrg.subject_id=adm.subject_id
order by 1,2
)

select * from deidentified_data;

/***************   copy mornin.de_omr_data_supplement to merge30  ********************/
create table merge30.de_omr_data_supplement as
select * from mornin.de_omr_data_supplement;

/***************    merge height and weight into d_patient table  ********************/
create table mimic2v30b_utc.d_patients_new as
with new_table as
(select 
d.SUBJECT_ID
,d.SEX
,d.DOB
,d.DOD
, omr.height_inches as height_inches_from_omr
, omr.WEIGHT_POUNDS as WEIGHT_POUNDS_from_omr
,d.HOSPITAL_EXPIRE_FLG
,d.ZIPCODE
, rownum as D_PATIENTSDATAID
from mimic2v30b_utc.d_patients d
left join merge30.de_omr_data_supplement omr on d.subject_id=omr.subject_id
)

select * from new_table; --48018

/***************    merge re-admission info into admission table  ********************/
create table mimic2v30b_utc.ADMISSIONS_new as
with new_table as
(select distinct
adm.HADM_ID
,adm.SUBJECT_ID
,adm.ADMIT_DT
,adm.ADMIT_TIME
,adm.DISCH_DT
,adm.DISCH_TIME
,adm.ADM_DIAGNOSIS
,adm.FIRST_SERVICE
,adm.LAST_SERVICE
,omr.READMIT_FLG
,omr.READMIT_DT
,omr.READMIT_PRINC_DIAG_ICD9
,omr.READMIT_PRINC_DIAGDESC
,omr.READMITADT_REASON
,rownum as ADMISSIONSDATAID
from mimic2v30b_utc.ADMISSIONS adm
left join merge30.de_omr_data_supplement omr on omr.hadm_id=adm.hadm_id
order by adm.HADM_ID
)

select * from new_table;

/***************   create new omr lab table table  ********************/
create table mimic2v30b_utc.omrlabs as
select
subject_id
,hadm_id
,MOST_RECENT_CREATININEVALUE
,MOST_RECENT_CREATININEDT
,PRE7DAYSCREATININEVALUE
,PRE7DAYSCREATININEDT
,POST7DAYSCREATININEVALUE
,POST7DAYSCREATININEDT
,PRE7DAYSWBCVALUE
,PRE7DAYSWBCDT
,PRE7DAYSHEMOGLOBINVALUE
,PRE7DAYSHEMOGLOBINDT
,PRE7DAYSPLATELETVALUE
,PRE7DAYSPLATELETDT
,PRE7DAYSALBUMINVALUE
,PRE7DAYSALBUMINDT
,PRE7DAYSSODIUMVALUE
,PRE7DAYSSODIUMDT
,POST7DAYSWBCVALUE
,POST7DAYSWBCDT
,POST7DAYSHEMOGLOBINVALUE
,POST7DAYSHEMOGLOBINDT
,POST7DAYSPLATELETVALUE
,POST7DAYSPLATELETDT
,POST7DAYSALBUMINVALUE
,POST7DAYSALBUMINDT
,POST7DAYSSODIUMVALUE
,POST7DAYSSODIUMDT
,MOST_RECENT_WBCVALUE
,MOST_RECENT_WBCDT
,MOST_RECENT_HEMOGLOBINVALUE
,MOST_RECENT_HEMOGLOBINDT
,MOST_RECENT_PLATELETVALUE
,MOST_RECENT_PLATELETDT
,MOST_RECENT_ALBUMINVALUE
,MOST_RECENT_ALBUMINDT
,MOST_RECENT_SODIUMVALUE
,MOST_RECENT_SODIUMDT
,rownum as omrlabsdataid
from merge30.de_omr_data_supplement;
