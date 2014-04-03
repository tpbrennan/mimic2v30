create table angus_sepsis_cohort as 

SELECT    h.subject_ID,
          h.hadm_id   
  FROM tbrennan.martin_sepsis_cohort h, 
       mimic2v26.ICD9 code
  WHERE code.SUBJECT_ID = h.SUBJECT_ID     -- INFECTION + ORGAN FAILURE
    AND ( code.CODE like '785.5%' -- Cardiovascular Shock without trauma
        or code.CODE like '458%' -- Hypotension
        or code.CODE like '348.3%' -- Neurologic Encephalopathy 
        or code.CODE like '293%' -- Transient organic psychosis 
        or code.CODE like '348.1%' -- Anoxic brain damage 
        or code.CODE like '287.4%' -- Hematologic Secondary thrombocytopenia 
        or code.CODE like '287.5%' -- Thrombocytopenia, unspeciﬁed
        or code.CODE like '286.9%' -- Other/unspeciﬁed coagulation defect
        or code.CODE like '286.6%' -- Deﬁbrination syndrome
        or code.CODE like '570%' -- Hepatic Acute and subacute necrosis of liver
        or code.CODE like '573.4%' -- Hepatic infarction
        or code.CODE like '584%' -- Renal Acute renal failure 
        ) 
union     -- JOIN WITH MECH VENT+INFECTION patients
SELECT    ip.hadm_id, 
          ip.subject_ID
  FROM tbrennan.martin_sepsis_cohort ip,
       mimic2v26.procedureevents code
  WHERE   ip.subject_id = code.subject_id 
         and ip.hadm_id = code.hadm_id         
    AND   code.itemid in (  101729, -- NON Invasive Respiratory Mechanical ventilation
                            101781, -- Invasive Respiratory Mechanical ventilation
                            101782,  -- Invasive Respiratory Mechanical ventilation
                            101783); -- Invasive Respiratory Mechanical ventilation
        
);
