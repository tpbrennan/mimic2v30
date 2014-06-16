drop materialized view mimic3_admits;
create materialized view mimic3_admits as

with patients as (
  select ie.subject_id, ie.icustay_id, 
    case 
      when dc.label like '%CSRU' then 'CSRU' 
      when dc.label like '%T-SICU' then 'SICU' 
      else dc.label
    end as careunit,
    ie.intime icu_intime,
    ie.outtime icu_outtime,
    round(ie.los/1440,2) icu_los
    from mimic2v30.icustayevents ie
    join mimic2v30.d_careunits dc on ie.first_careunit = dc.cuid
)
--select * from patients;


, hosp_admts as (
  select p.subject_id, 
    ad.hadm_id,  
    p.icustay_id,
    p.careunit,
    ad.admit_dt hosp_admit,
    p.icu_intime,
    p.icu_outtime,
    p.icu_los,
    extract(day from ad.disch_dt - ad.admit_dt)+ round(extract(hour from ad.disch_dt - ad.admit_dt),2) as hosp_los,
    extract(day from ad.admit_dt - p.icu_intime) dt
    from patients p
    join mimic2v30.admissions ad 
      on ad.subject_id = p.subject_id
      and p.icu_intime > ad.admit_dt
)
--select * from hosp_admts where icustay_id=52006;


-- get hadm_id for icustay, as closest to ICU admission
, admts as (
  select distinct subject_id, icustay_id,
    FIRST_VALUE(hadm_id) over (partition by icustay_id order by dt DESC) hadm_id
    from hosp_admts
)
--select * from admts;

, final_admits as (
  select ic.subject_id, 
    ic.hadm_id, 
    ic.icustay_id, 
    ic.careunit,
    ic.icu_intime,
    ic.icu_outtime,
    ic.icu_los,
    ic.hosp_los
  from hosp_admts ic
  join admts ad 
    on ic.hadm_id = ad.hadm_id
    and ic.icustay_id = ad.icustay_id
    and ic.subject_id = ad.subject_id
)
--select * from final_admits;

, patient_info as (
    select pi.subject_id,
      ad.hadm_id,
      ad.icustay_id,
      pi.sex,
      case 
        when round((cast(ad.icu_intime as date) - pi.dob)/365,2) > 90 then 91.4
        else round((cast(ad.icu_intime as date) - pi.dob)/365,2)
      end as age_admit,
      ad.icu_intime,
      ad.icu_outtime,
      ad.icu_los,
      ad.hosp_los,
      ad.careunit,
      pi.dob,
      pi.dod,
      case 
        when (pi.dod > cast(ad.icu_intime as date) and pi.dod < cast(ad.icu_outtime as date)) 
        then 'Y' else 'N'
      end as icu_mort,  
      pi.hospital_expire_flg hosp_mort
      from final_admits ad
      join mimic2v30.d_patients pi 
        on pi.subject_id = ad.subject_id
)
--select * from patient_info;
      
, final_cohort as (
  select * from patient_info
    --where age_admit > 15
)
select * from final_cohort order by subject_id;

