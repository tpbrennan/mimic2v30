/**************************************************************************************************/
/***************    To separate date and time from admission table  ********************/
/***************    Created by Mornin Apr 2014              ***************************************/
/**************************************************************************************************/

create table v30_admissions_beta as
with admission as
(select 
hadm_id
, subject_id
, trunc(admit_dt) as admit_dt 
, case when hadm_id>=37000 then admit_dt else null end as admit_time
, trunc(disch_dt) as disch_dt
, case when hadm_id>=37000 then disch_dt else null end as disch_time
, ADM_DIAGNOSIS
, FIRST_SERVICE
, LAST_SERVICE
from mimic2v30.admissions
)

select * from admission;

create table admissions as
select * from mornin.v30_admissions_beta;