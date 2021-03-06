create table mimic2v30b_utc.chartevents_new as
select
SUBJECT_ID
,HADM_ID
,ICUSTAY_ID
,ITEMID
,TIME
,ELEMID
,KEYINTIME
,CGID
,CUID
,VALUE1
,VALUE1NUM
,VALUE1UOM
, case when COMMENTS like ' ' then TO_NCLOB(null) else COMMENTS end as COMMENTS
,VALUE2
,VALUE2NUM
,VALUE2UOM
,RESULTSTATUS
,STOPPED
,WARNING
,ERROR
,rownum as CHARTEVENTSDATAID
from mimic2v30b_utc.chartevents;