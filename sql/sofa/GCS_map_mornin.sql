create table gcs_map_mornin as
with gcs as
(select 
mrn
, ENCOUNTERNUMBER
, to_timestamp(gcs.time, 'mm/dd/yy hh:mi am') as time
, parametername
, value
from mornin.phi_gcs_v30 gcs
where parametername is not null
)

--select gcs.mrn, m.subject_id, time+m.DAYS_SHIFTED as time_sifted from gcs 
--join gparam.MRN_SUBJECTID_DTSHIFT_MERGE30 m on m.mrn=gcs.mrn where subject_id=33000;

--select * from gcs where time is null;
, gcs_score as(
select * from 
(select mrn,ENCOUNTERNUMBER, time, parametername, value from gcs)
pivot
(max(value) as score for (parametername) in ('GCS - Motor Response' as motor, 'GCS - Eye Opening' as eye, 'GCS - Verbal Response' as verbal))
)

--select * from gcs_score;
, gcs_mapped as
(select
m.subject_id
, adm.hadm_id
, cast((gcs.time+m.DAYS_SHIFTED) as timestamp(6) with time zone) as shifted_time
, gcs.motor_score
, gcs.eye_score
, gcs.verbal_score
, (gcs.motor_score + gcs.eye_score + gcs.verbal_score) as gcs_total
from gcs_score gcs
join gparam.MRN_SUBJECTID_DTSHIFT_MERGE30 m on m.mrn=gcs.mrn
join merge30.admissions adm on adm.fiscal_num = gcs.ENCOUNTERNUMBER
)

select * from gcs_mapped;