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
  ,
  elix_weights AS
  (
    SELECT
      subject_id,
      hadm_id,
      -- points for in-hospital mortality
      CONGESTIVE_HEART_FAILURE*(4) + CARDIAC_ARRHYTHMIAS*(4) + VALVULAR_DISEASE
                              *(-3) + PULMONARY_CIRCULATION*(0) +
      PERIPHERAL_VASCULAR     *(0) + HYPERTENSION*(-1) + PARALYSIS*(0) +
      OTHER_NEUROLOGICAL      *(7) + CHRONIC_PULMONARY*(0) +
      DIABETES_UNCOMPLICATED  *(-1) + DIABETES_COMPLICATED*(-4) +
      HYPOTHYROIDISM          *(0) + RENAL_FAILURE*(3) + LIVER_DISEASE*(4) +
      PEPTIC_ULCER            *(-9) + AIDS*(0) + LYMPHOMA*(7) +
      METASTATIC_CANCER       *(9) + SOLID_TUMOR*(0) + RHEUMATOID_ARTHRITIS*(0)
                              + COAGULOPATHY*(3) + OBESITY*(-5) + WEIGHT_LOSS*(
      4)                      + FLUID_ELECTROLYTE*(6) + BLOOD_LOSS_ANEMIA*(0) +
      DEFICIENCY_ANEMIAS      *(-4) + ALCOHOL_ABUSE*(0) + DRUG_ABUSE*(-6) +
      PSYCHOSES               *(-5) + DEPRESSION*(-8) AS hospital_mort_pt,
      -- points for 28 day mortality
      CONGESTIVE_HEART_FAILURE*(5) + CARDIAC_ARRHYTHMIAS*(4) + VALVULAR_DISEASE
                              *(-1) + PULMONARY_CIRCULATION*(0) +
      PERIPHERAL_VASCULAR     *(0) + HYPERTENSION*(-1) + PARALYSIS*(0) +
      OTHER_NEUROLOGICAL      *(6) + CHRONIC_PULMONARY*(0) +
      DIABETES_UNCOMPLICATED  *(0) + DIABETES_COMPLICATED*(-3) + HYPOTHYROIDISM
                              *(0) + RENAL_FAILURE*(4) + LIVER_DISEASE*(4) +
      PEPTIC_ULCER            *(0) + AIDS*(0) + LYMPHOMA*(5) +
      METASTATIC_CANCER       *(12) + SOLID_TUMOR*(1) + RHEUMATOID_ARTHRITIS*(0
      )                       + COAGULOPATHY*(3) + OBESITY*(-6) + WEIGHT_LOSS*(
      6)                      + FLUID_ELECTROLYTE*(6) + BLOOD_LOSS_ANEMIA*(0) +
      DEFICIENCY_ANEMIAS      *(-3) + ALCOHOL_ABUSE*(-2) + DRUG_ABUSE*(-6) +
      PSYCHOSES               *(-4) + DEPRESSION*(-6) AS
      twenty_eight_day_mort_pt,
      -- points for 1 year mortality
      CONGESTIVE_HEART_FAILURE*(5) + CARDIAC_ARRHYTHMIAS*(4) + VALVULAR_DISEASE
                              *(0) + PULMONARY_CIRCULATION*(0) +
      PERIPHERAL_VASCULAR     *(0) + HYPERTENSION*(-1) + PARALYSIS*(3) +
      OTHER_NEUROLOGICAL      *(4) + CHRONIC_PULMONARY*(2) +
      DIABETES_UNCOMPLICATED  *(0) + DIABETES_COMPLICATED*(0) + HYPOTHYROIDISM*
      (0)                     + RENAL_FAILURE*(5) + LIVER_DISEASE*(4) +
      PEPTIC_ULCER            *(0) + AIDS*(3) + LYMPHOMA*(6) +
      METASTATIC_CANCER       *(14) + SOLID_TUMOR*(3) + RHEUMATOID_ARTHRITIS*(0
      )                       + COAGULOPATHY*(3) + OBESITY*(-5) + WEIGHT_LOSS*(
      5)                      + FLUID_ELECTROLYTE*(4) + BLOOD_LOSS_ANEMIA*(0) +
      DEFICIENCY_ANEMIAS      *(-1) + ALCOHOL_ABUSE*(-3) + DRUG_ABUSE*(-3) +
      PSYCHOSES               *(-3) + DEPRESSION*(-2) AS one_yr_mort_pt,
      -- points for 2 year mortality
      CONGESTIVE_HEART_FAILURE*(10) + CARDIAC_ARRHYTHMIAS*(7) +
      VALVULAR_DISEASE        *(0) + PULMONARY_CIRCULATION*(0) +
      PERIPHERAL_VASCULAR     *(2) + HYPERTENSION*(-2) + PARALYSIS*(7) +
      OTHER_NEUROLOGICAL      *(9) + CHRONIC_PULMONARY*(6) +
      DIABETES_UNCOMPLICATED  *(1) + DIABETES_COMPLICATED*(0) + HYPOTHYROIDISM*
      (1)                     + RENAL_FAILURE*(13) + LIVER_DISEASE*(8) +
      PEPTIC_ULCER            *(0) + AIDS*(8) + LYMPHOMA*(12) +
      METASTATIC_CANCER       *(31) + SOLID_TUMOR*(7) + RHEUMATOID_ARTHRITIS*(0
      )                       + COAGULOPATHY*(5) + OBESITY*(-11) + WEIGHT_LOSS*
      (10)                    + FLUID_ELECTROLYTE*(9) + BLOOD_LOSS_ANEMIA*(0) +
      DEFICIENCY_ANEMIAS      *(0) + ALCOHOL_ABUSE*(-5) + DRUG_ABUSE*(-6) +
      PSYCHOSES               *(-3) + DEPRESSION*(-5) AS two_yr_mort_pt,
      -- points for 1 year survival
      CONGESTIVE_HEART_FAILURE*(4) + CARDIAC_ARRHYTHMIAS*(3) + VALVULAR_DISEASE
                              *(0) + PULMONARY_CIRCULATION*(0) +
      PERIPHERAL_VASCULAR     *(0) + HYPERTENSION*(-1) + PARALYSIS*(2) +
      OTHER_NEUROLOGICAL      *(4) + CHRONIC_PULMONARY*(2) +
      DIABETES_UNCOMPLICATED  *(0) + DIABETES_COMPLICATED*(0) + HYPOTHYROIDISM*
      (0)                     + RENAL_FAILURE*(4) + LIVER_DISEASE*(4) +
      PEPTIC_ULCER            *(0) + AIDS*(0) + LYMPHOMA*(5) +
      METASTATIC_CANCER       *(12) + SOLID_TUMOR*(3) + RHEUMATOID_ARTHRITIS*(0
      )                       + COAGULOPATHY*(2) + OBESITY*(-5) + WEIGHT_LOSS*(
      4)                      + FLUID_ELECTROLYTE*(5) + BLOOD_LOSS_ANEMIA*(0) +
      DEFICIENCY_ANEMIAS      *(-1) + ALCOHOL_ABUSE*(-3) + DRUG_ABUSE*(-4) +
      PSYCHOSES               *(-3) + DEPRESSION*(-3) AS one_year_survival_pt,
      -- points for 2 year survival
      CONGESTIVE_HEART_FAILURE*(7) + CARDIAC_ARRHYTHMIAS*(5) + VALVULAR_DISEASE
                              *(0) + PULMONARY_CIRCULATION*(0) +
      PERIPHERAL_VASCULAR     *(1) + HYPERTENSION*(-1) + PARALYSIS*(4) +
      OTHER_NEUROLOGICAL      *(6) + CHRONIC_PULMONARY*(4) +
      DIABETES_UNCOMPLICATED  *(0) + DIABETES_COMPLICATED*(0) + HYPOTHYROIDISM*
      (1)                     + RENAL_FAILURE*(7) + LIVER_DISEASE*(5) +
      PEPTIC_ULCER            *(0) + AIDS*(4) + LYMPHOMA*(8) +
      METASTATIC_CANCER       *(19) + SOLID_TUMOR*(4) + RHEUMATOID_ARTHRITIS*(0
      )                       + COAGULOPATHY*(3) + OBESITY*(-8) + WEIGHT_LOSS*(
      6)                      + FLUID_ELECTROLYTE*(6) + BLOOD_LOSS_ANEMIA*(0) +
      DEFICIENCY_ANEMIAS      *(-1) + ALCOHOL_ABUSE*(-4) + DRUG_ABUSE*(-5) +
      PSYCHOSES               *(-3) + DEPRESSION*(-4) AS two_year_survival_pt
    FROM
      raw_elix
    ORDER BY
      1,2
  )
SELECT
  *
FROM
  elix_weights;

GRANT SELECT ON MIMIC2DEVEL.ELIXHAUSER_POINTS TO MIMIC_PUBLIC_USERS;