/**************************************************************************************************/
/***************    To generate service unit for both old and new patients     ********************/
/***************    Created by Mornin Apr 2014              ***************************************/
/**************************************************************************************************/
drop table v30_elix_raw_data;
create table v30_elix_raw_data as
WITH
  raw_elix AS
  (
    SELECT DISTINCT
      --adm.hadm_id
      --, adm.admit_dt
      --, dp.dod - adm.admit_dt
      co.*
      , case when dp.HOSPITAL_EXPIRE_FLG = 'Y' then 1
      else 0 end as hospital_mortality
      ,CASE
        WHEN dp.dod                    IS NULL
        OR extract(day from dp.dod-adm.admit_dt)+extract(hour from dp.dod-adm.admit_dt)/24>28
        THEN 0
        ELSE 1
      END AS twenty_eight_day_mortality
      ,CASE
        WHEN dp.dod                    IS NULL
        OR extract(day from dp.dod-adm.admit_dt)+extract(hour from dp.dod-adm.admit_dt)/24>365
        THEN 0
        ELSE 1
      END AS one_year_mortality
      ,CASE
        WHEN dp.dod                    IS NULL
        OR extract(day from dp.dod-adm.admit_dt)+extract(hour from dp.dod-adm.admit_dt)/24>365*2
        THEN 0
        ELSE 1
      END AS two_year_mortality
      ,CASE
        WHEN dp.dod                    IS NULL
        OR extract(day from dp.dod-adm.admit_dt)+extract(hour from dp.dod-adm.admit_dt)/24>365
        THEN 365
        when extract(day from dp.dod-adm.admit_dt) < 0
        then 0
        ELSE extract(day from dp.dod-adm.admit_dt)
        END AS one_yr_survival_days
      , case when dp.dod is null
      or extract(day from dp.dod-adm.admit_dt)+extract(hour from dp.dod-adm.admit_dt)/24>365
      then 1
      else 0
      end as one_yr_censor_flg
      
       ,CASE
        WHEN dp.dod                    IS NULL
        OR extract(day from dp.dod-adm.admit_dt)+extract(hour from dp.dod-adm.admit_dt)/24>365*2
        THEN 365*2
        when extract(day from dp.dod-adm.admit_dt) < 0
        then 0
        ELSE extract(day from dp.dod-adm.admit_dt)
        END AS two_yr_survival_days
      , case when dp.dod is null
      or extract(day from dp.dod-adm.admit_dt)+extract(hour from dp.dod-adm.admit_dt)/24>365*2
      then 1
      else 0
      end as two_yr_censor_flg

    FROM
      mimic2v30.admissions adm
     JOIN  mimic2v30.d_patients dp ON dp.subject_id=adm.subject_id
    join mimic2v30.comorbidity_scores co on adm.hadm_id=co.hadm_id
  )

select * from raw_elix order by 1,2;

create table v30_elixhuaser_scores as  
 with elix_weights AS
  (
    SELECT
      subject_id,
      hadm_id,
      -- points for in-hospital mortality
      CONGESTIVE_HEART_FAILURE*(4) + CARDIAC_ARRHYTHMIAS*(3) 
      + VALVULAR_DISEASE*(-1) + PULMONARY_CIRCULATION*(0) +
      PERIPHERAL_VASCULAR     *(1) + HYPERTENSION*(0) + PARALYSIS*(2) +
      OTHER_NEUROLOGICAL      *(4) + CHRONIC_PULMONARY*(1) +
      DIABETES_UNCOMPLICATED  *(0) + DIABETES_COMPLICATED*(-1) +
      HYPOTHYROIDISM          *(0) + RENAL_FAILURE*(5) + LIVER_DISEASE*(5) +
      PEPTIC_ULCER            *(0) + AIDS*(0) + LYMPHOMA*(6) +
      METASTATIC_CANCER       *(7) + SOLID_TUMOR*(1) + RHEUMATOID_ARTHRITIS*(0)
                              + COAGULOPATHY*(3) + OBESITY*(-5) + WEIGHT_LOSS*(3)
                              + FLUID_ELECTROLYTE*(6) + BLOOD_LOSS_ANEMIA*(0) +
      DEFICIENCY_ANEMIAS      *(-2) + ALCOHOL_ABUSE*(0) + DRUG_ABUSE*(-5) +
      PSYCHOSES               *(-4) + DEPRESSION*(-5) AS hospital_mort_pt,
      
      
      -- points for 28 day mortality
      CONGESTIVE_HEART_FAILURE*(5) + CARDIAC_ARRHYTHMIAS*(5) + VALVULAR_DISEASE
                              *(-2) + PULMONARY_CIRCULATION*(0) +
      PERIPHERAL_VASCULAR     *(0) + HYPERTENSION*(0) + PARALYSIS*(5) +
      OTHER_NEUROLOGICAL      *(8) + CHRONIC_PULMONARY*(2) +
      DIABETES_UNCOMPLICATED  *(1) + DIABETES_COMPLICATED*(-3) + HYPOTHYROIDISM
                              *(0) + RENAL_FAILURE*(4) + LIVER_DISEASE*(6) +
      PEPTIC_ULCER            *(0) + AIDS*(0) + LYMPHOMA*(5) +
      METASTATIC_CANCER       *(14) + SOLID_TUMOR*(2) + RHEUMATOID_ARTHRITIS*(0
      )                       + COAGULOPATHY*(3) + OBESITY*(-8) + WEIGHT_LOSS*(
      2)                      + FLUID_ELECTROLYTE*(9) + BLOOD_LOSS_ANEMIA*(0) +
      DEFICIENCY_ANEMIAS      *(-3) + ALCOHOL_ABUSE*(0) + DRUG_ABUSE*(-7) +
      PSYCHOSES               *(-6) + DEPRESSION*(-6) AS
      twenty_eight_day_mort_pt
      
      -- points for 1 year mortality
      ,CONGESTIVE_HEART_FAILURE*(14) + CARDIAC_ARRHYTHMIAS*(10) + VALVULAR_DISEASE
                              *(-3) + PULMONARY_CIRCULATION*(0) +
      PERIPHERAL_VASCULAR     *(3) + HYPERTENSION*(-1) + PARALYSIS*(9) +
      OTHER_NEUROLOGICAL      *(10) + CHRONIC_PULMONARY*(7) +
      DIABETES_UNCOMPLICATED  *(2) + DIABETES_COMPLICATED*(-2) + HYPOTHYROIDISM*
      (3)                     + RENAL_FAILURE*(14) + LIVER_DISEASE*(12) +
      PEPTIC_ULCER            *(0) + AIDS*(7) + LYMPHOMA*(14) +
      METASTATIC_CANCER       *(34) + SOLID_TUMOR*(9) + RHEUMATOID_ARTHRITIS*(0
      )                       + COAGULOPATHY*(8) + OBESITY*(-15) + WEIGHT_LOSS*(
      11)                      + FLUID_ELECTROLYTE*(13) + BLOOD_LOSS_ANEMIA*(0) +
      DEFICIENCY_ANEMIAS      *(-2) + ALCOHOL_ABUSE*(-5) + DRUG_ABUSE*(-9) +
      PSYCHOSES               *(-7) + DEPRESSION*(-5) AS one_yr_mort_pt,
      
      -- points for 2 year mortality
      CONGESTIVE_HEART_FAILURE*(15) + CARDIAC_ARRHYTHMIAS*(10) +
      VALVULAR_DISEASE        *(-3) + PULMONARY_CIRCULATION*(0) +
      PERIPHERAL_VASCULAR     *(4) + HYPERTENSION*(-1) + PARALYSIS*(9) +
      OTHER_NEUROLOGICAL      *(10) + CHRONIC_PULMONARY*(8) +
      DIABETES_UNCOMPLICATED  *(3) + DIABETES_COMPLICATED*(0) + HYPOTHYROIDISM*
      (4)                     + RENAL_FAILURE*(16) + LIVER_DISEASE*(12) +
      PEPTIC_ULCER            *(-4) + AIDS*(9) + LYMPHOMA*(16) +
      METASTATIC_CANCER       *(36) + SOLID_TUMOR*(11) + RHEUMATOID_ARTHRITIS*(0
      )                       + COAGULOPATHY*(8) + OBESITY*(-16) + WEIGHT_LOSS*
      (11)                    + FLUID_ELECTROLYTE*(12) + BLOOD_LOSS_ANEMIA*(0) +
      DEFICIENCY_ANEMIAS      *(0) + ALCOHOL_ABUSE*(-4) + DRUG_ABUSE*(-9) +
      PSYCHOSES               *(-4) + DEPRESSION*(-5) AS two_yr_mort_pt,
      
      -- points for 1 year survival
      CONGESTIVE_HEART_FAILURE*(14) + CARDIAC_ARRHYTHMIAS*(10) + VALVULAR_DISEASE
                              *(-3) + PULMONARY_CIRCULATION*(0) +
      PERIPHERAL_VASCULAR     *(3) + HYPERTENSION*(-1) + PARALYSIS*(9) +
      OTHER_NEUROLOGICAL      *(11) + CHRONIC_PULMONARY*(7) +
      DIABETES_UNCOMPLICATED  *(2) + DIABETES_COMPLICATED*(-2) + HYPOTHYROIDISM*
      (3)                     + RENAL_FAILURE*(13) + LIVER_DISEASE*(12) +
      PEPTIC_ULCER            *(0) + AIDS*(6) + LYMPHOMA*(13) +
      METASTATIC_CANCER       *(31) + SOLID_TUMOR*(9) + RHEUMATOID_ARTHRITIS*(0
      )                       + COAGULOPATHY*(7) + OBESITY*(-17) + WEIGHT_LOSS*(
      9)                      + FLUID_ELECTROLYTE*(15) + BLOOD_LOSS_ANEMIA*(0) +
      DEFICIENCY_ANEMIAS      *(-3) + ALCOHOL_ABUSE*(-5) + DRUG_ABUSE*(-11) +
      PSYCHOSES               *(-8) + DEPRESSION*(-6) AS one_year_survival_pt,
      
      -- points for 2 year survival
      CONGESTIVE_HEART_FAILURE*(14) + CARDIAC_ARRHYTHMIAS*(10) + VALVULAR_DISEASE
                              *(-3) + PULMONARY_CIRCULATION*(0) +
      PERIPHERAL_VASCULAR     *(3) + HYPERTENSION*(-1) + PARALYSIS*(9) +
      OTHER_NEUROLOGICAL      *(10) + CHRONIC_PULMONARY*(8) +
      DIABETES_UNCOMPLICATED  *(3) + DIABETES_COMPLICATED*(0) + HYPOTHYROIDISM*
      (3)                     + RENAL_FAILURE*(14) + LIVER_DISEASE*(12) +
      PEPTIC_ULCER            *(0) + AIDS*(8) + LYMPHOMA*(14) +
      METASTATIC_CANCER       *(31) + SOLID_TUMOR*(10) + RHEUMATOID_ARTHRITIS*(0
      )                       + COAGULOPATHY*(7) + OBESITY*(-18) + WEIGHT_LOSS*(9)
      + FLUID_ELECTROLYTE*(13) + BLOOD_LOSS_ANEMIA*(0) +
      DEFICIENCY_ANEMIAS      *(-1) + ALCOHOL_ABUSE*(-5) + DRUG_ABUSE*(-11) +
      PSYCHOSES               *(-5) + DEPRESSION*(-6) AS two_year_survival_pt
    FROM
      v30_elix_raw_data
    ORDER BY
      1,2
  )
SELECT
  *
FROM
  elix_weights;

GRANT SELECT ON MIMIC2DEVEL.ELIXHAUSER_POINTS TO MIMIC_PUBLIC_USERS;


select /*csv*/ * from v30_elixhuaser_scores where rownum<100;