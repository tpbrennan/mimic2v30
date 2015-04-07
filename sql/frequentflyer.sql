create table freq_flyer_march15 as
WITH temp AS
(SELECT DISTINCT
adm1.subject_id
, adm1.hadm_id as first_adm
, adm1.admit_dt as first_dt
, adm2.hadm_id as subsequent_adm
, adm2.admit_dt as second_dt
FROM MIMIC2V30.admissions adm1
JOIN mimic2v30.admissions adm2 
  ON adm1.subject_id = adm2.subject_id 
  AND adm2.admit_dt BETWEEN adm1.admit_dt AND adm1.admit_dt+365 
  AND adm1.hadm_id != adm2.hadm_id
ORDER BY 1,2
)

--select * from temp;

, temp1 AS
(SELECT subject_id
, first_adm as first_hadm_id
, first_dt as first_hadm_dt
, COUNT(*) AS adm_count
FROM temp
GROUP BY subject_id, first_adm, first_dt
)

--select * from temp1;

, over3adm_id AS
(SELECT DISTINCT 
 subject_id
--, first_hadm_id
-- first_hadm_dt
, first_value(first_hadm_id) over (partition by subject_id order by first_hadm_dt asc) as first_hadm_id
, first_value(first_hadm_dt) over (partition by subject_id order by first_hadm_dt asc) as first_hadm_dt
FROM temp1 
WHERE adm_count>=2
)

--select * from over3adm_id;
--select count(distinct subject_id) from over3adm_id;

, demo_info as
(select o.subject_id
, o.first_hadm_id
, d.sex as gender
, round(extract(day from (o.first_hadm_dt-d.dob))/365, 2) as adm_age
, d.zipcode
, adm.adm_diagnosis
, adm.first_service
, com.CONGESTIVE_HEART_FAILURE
, com.CARDIAC_ARRHYTHMIAS
, com.VALVULAR_DISEASE
, com.PULMONARY_CIRCULATION
, com.PERIPHERAL_VASCULAR
, com.HYPERTENSION
, com.PARALYSIS
, com.OTHER_NEUROLOGICAL
, com.CHRONIC_PULMONARY
, com.DIABETES_UNCOMPLICATED
, com.DIABETES_COMPLICATED
, com.HYPOTHYROIDISM
, com.RENAL_FAILURE
, com.LIVER_DISEASE
, com.PEPTIC_ULCER
, com.AIDS
, com.LYMPHOMA
, com.METASTATIC_CANCER
, com.SOLID_TUMOR
, com.RHEUMATOID_ARTHRITIS
, com.COAGULOPATHY
, com.OBESITY
, com.WEIGHT_LOSS
, com.FLUID_ELECTROLYTE
, com.BLOOD_LOSS_ANEMIA
, com.DEFICIENCY_ANEMIAS
, com.ALCOHOL_ABUSE
, com.DRUG_ABUSE
, com.PSYCHOSES
, com.DEPRESSION
from over3adm_id o
left join mimic2v30.d_patients d on o.subject_id=d.subject_id
left join mimic2v30.admissions adm on o.first_hadm_id = adm.hadm_id
left join mimic2v30.comorbidity_scores com on com.hadm_id=o.first_hadm_id
)

select * from demo_info;