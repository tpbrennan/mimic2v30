/*
  merge_omr_data.sql

  Created on   : May 2015 by Mornin Feng
  Last updated :
     $Author: Mornin Feng $
     $Date: 2015 May 25th  $
     $Rev: $
Merge PHI_OMR_DATA into mimic2v30. Must run on brp2 server
*/

select
MRN
,MRN_CM
,FISCAL_NUM
,to_date(ADM_DT, 'mm/dd/yy') as ADM_DT
,to_date(DISCH_DT, 'mm/dd/yyyy') as DISCH_DT
,to_date(DOB, 'mm/dd/yy') as DOB
--, HT_PER_OMR
, case when LENGTH(TRIM(TRANSLATE(HT_PER_OMR, ' +-.0123456789',' ')))>=1 then null
        else cast(HT_PER_OMR as number(5,3)) end as HT_PER_OMR
,to_date(HT_PER_OMR_DT, 'mm/dd/yyyy') as HT_PER_OMR_DT

,cast(HEIGHT_INCHES_NURSING_ASSESS as number(5,3)) as HEIGHT_INCHES_NURSING_ASSESS
,cast(WEIGHT_POUNDS_NURSING_ASSESS as number(13,3)) as WEIGHT_POUNDS_NURSING_ASSESS

,to_date(READMIT_DT, 'mm/dd/yyyy') as READMIT_DT
--,READMIT_ENC
,READMIT_PRINC_DIAG as READMIT_PRINC_DIAG_ICD9
,READMIT_PRINC_DIAGDESC
,READMITADT_REASON

,cast(MOST_RECENT_CREATININEVALUE as number(10,6)) as MOST_RECENT_CREATININEVALUE
, cast(cast(to_timestamp(MOST_RECENT_CREATININEDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as MOST_RECENT_CREATININEDT
,cast(PRE7DAYSCREATININEVALUE as number(10,6)) as PRE7DAYSCREATININEVALUE
,cast(cast(to_timestamp(PRE7DAYSCREATININEDT, 'mm/dd/yy hh:mi am') as timestamp with time zone) at time zone 'UTC' as timestamp) as PRE7DAYSCREATININEDT
,cast(POST7DAYSCREATININEVALUE as number(10,6)) as POST7DAYSCREATININEVALUE
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
from mornin.phi_omr_data_supplement;