create materialized view mimic2v30_hadm as

  
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
    --p.careunit,
    to_timestamp_tz(to_char(ad.admit_dt,'DD-MON-YY HH24.MI.SS'),'DD-MON-YY HH24.MI.SS') hosp_intime,
    ad.admit_dt,
    p.icu_intime,
    --p.icu_outtime,
    --p.icu_los,
    --round(ad.disch_dt - ad.admit_dt,2) as hosp_los,
    round(extract(day from p.icu_intime - ad.admit_dt)+
      extract(hour from p.icu_intime - ad.admit_dt)/24,2) dt
    --round(extract(day from p.icu_intime - to_timestamp_tz(to_char(ad.admit_dt,'DD-MON-YY HH24.MI.SS'),'DD-MON-YY HH24.MI.SS')),2) dt
      --+ extract(hour from p.icu_intime - to_timestamp_tz(to_char(ad.admit_dt,'DD-MON-YY HH24.MI.SS'),'DD-MON-YY HH24.MI.SS'))/24,2) dt
    --round(extract(day from p.icu_intime -  cast(to_char(ad.admit_dt-0.5,'DD-MON-YY HH24.MI.SS.SSSSSS') as datetime))+
    --  extract(minute from p.icu_intime - cast(ad.admit_dt as datetime))/60,2) as dt
    from patients p
    join mimic2v30.admissions ad 
      on ad.subject_id = p.subject_id
      and p.icu_intime < ad.disch_dt 
)
--select * from hosp_admts ;
select distinct icustay_id, 
  first_value(hadm_id) over (partition by subject_id, icustay_id order by abs(dt)) hadm_id,
  first_value(icu_intime) over (partition by subject_id, icustay_id order by abs(dt)) icu_intime,
  first_value(admit_dt) over (partition by subject_id, icustay_id order by abs(dt)) admit_dt,
  first_value(abs(dt)) over (partition by subject_id, icustay_id order by abs(dt)) dt
  from hosp_admts
  order by dt desc;
  
