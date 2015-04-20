/***** A hardcore but working version *******/

SET TERMOUT OFF
SET FEEDBACK OFF
SET NEWPAGE none
SET SPACE 0
SET PAGESIZE 0
SET TRIMSPOOL ON
SET ECHO OFF
SET HEADING OFF
SET RECSEP OFF
--SET RECSEPCHAR '!#$'
Set pages 50000
set long 99999999
set longchunksize 99999999
set LINESIZE 32767
--SET COLSEP ','

--------------------------------------------------------------------------------
--MICROBIOLOGYEVENTS ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/microbiologyevents_mornin.csv"

-- ||','|| goes between each one and you need single quotes.

select 
'SUBJECT_ID'
||','||
'HADM_ID'
||','||
'TIME'
||','||
'SPEC_TYPE_CD'
||','||
'SPEC_ITEMID'
||','||
'SPEC_TYPE_DESC'
||','||
'ORG_CD'
||','||
'ORG_ITEMID'
||','||
'ORG_NAME'
||','||
'ISOLATE_NUM'
||','||
'AB_CD'
||','||
'AB_ITEMID'
||','||
'AB_NAME'
||','||
'DILUTION_AMOUNT'
||','||
'DILUTION_COMPARISON'
||','||
'INTERPRETATION'
||','||
'MICROBIOLOGYEVENTSDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
SUBJECT_ID
||'","'||
HADM_ID
||'","'||
TIME
||'","'||
SPEC_TYPE_CD
||'","'||
SPEC_ITEMID
||'","'||
SPEC_TYPE_DESC
||'","'||
ORG_CD
||'","'||
ORG_ITEMID
||'","'||
ORG_NAME
||'","'||
ISOLATE_NUM
||'","'||
AB_CD
||'","'||
AB_ITEMID
||'","'||
AB_NAME
||'","'||
DILUTION_AMOUNT
||'","'||
DILUTION_COMPARISON
||'","'||
INTERPRETATION
||'","'||
MICROBIOLOGYEVENTSDATAID
||'"' as x
from 
  ( select
SUBJECT_ID
,HADM_ID
,to_char(TIME, 'dd-mon-yyyy') as TIME
,SPEC_TYPE_CD
,SPEC_ITEMID
,SPEC_TYPE_DESC
,ORG_CD
,ORG_ITEMID
,ORG_NAME
,ISOLATE_NUM
,AB_CD
,AB_ITEMID
,AB_NAME
,DILUTION_AMOUNT
,DILUTION_COMPARISON
,INTERPRETATION
,MICROBIOLOGYEVENTSDATAID
from mimic2v30b.MICROBIOLOGYEVENTS));

spool off;




--------------------------------------------------------------------------------
-- MEDEVENTS ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/medevents_mornin.csv"

-- ||','|| goes between each one and you need single quotes.

select 
'SUBJECT_ID'
||','||
'ICUSTAY_ID'
||','||
'ORDERID'
||','||
'ITEMID'
||','||
'LABEL'
||','||
'SOLITEMID'
||','||
'SOLITEMLABEL'
||','||
'CHARTTIME'
||','||
'ELEMID'
||','||
'REALTIME'
||','||
'STARTTIME'
||','||
'ENDTIME'
||','||
'VALUE'
||','||
'UOM'
||','||
'SOLITEMVALUE'
||','||
'SOLITEMUOM'
||','||
'CGID'
||','||
'CUID'
||','||
'STOPPED'
||','||
'MEDEVENTSDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
SUBJECT_ID
||'","'||
ICUSTAY_ID
||'","'||
ORDERID
||'","'||
ITEMID
||'","'||
LABEL
||'","'||
SOLITEMID
||'","'||
SOLITEMLABEL
||'","'||
CHARTTIME
||'","'||
ELEMID
||'","'||
REALTIME
||'","'||
STARTTIME
||'","'||
ENDTIME
||'","'||
VALUE
||'","'||
UOM
||'","'||
SOLITEMVALUE
||'","'||
SOLITEMUOM
||'","'||
CGID
||'","'||
CUID
||'","'||
STOPPED
||'","'||
MEDEVENTSDATAID
||'"' as x
from 
  ( select
SUBJECT_ID
,ICUSTAY_ID
,ORDERID
,ITEMID
,LABEL
,SOLITEMID
,SOLITEMLABEL
,to_char(CHARTTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as CHARTTIME 
,ELEMID
,to_char(REALTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as REALTIME 
,to_char(STARTTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as STARTTIME 
,to_char(ENDTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as ENDTIME 
,VALUE
,UOM
,SOLITEMVALUE
,SOLITEMUOM
,CGID
,CUID
,STOPPED
,MEDEVENTSDATAID
from mimic2v30b.MEDEVENTS));

spool off;



--------------------------------------------------------------------------------
-- LCP_VENTILIATION ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/lcp_ventilation_mornin.csv"

-- ||','|| goes between each one and you need single quotes.

select 
'SUBJECT_ID'
||','||
'HADM_ID'
||','||
'ICUSTAY_ID'
||','||
'SEQ'
||','||
'STARTTIME'
||','||
'ENDTIME'
||','||
'LCP_VENTILATIONDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
SUBJECT_ID
||'","'||
HADM_ID
||'","'||
ICUSTAY_ID
||'","'||
SEQ
||'","'||
STARTTIME
||'","'||
ENDTIME
||'","'||
LCP_VENTILATIONDATAID
||'"' as x
from 
  ( select
SUBJECT_ID
,HADM_ID
,ICUSTAY_ID
,SEQ
,to_char(STARTTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as STARTTIME 
,to_char(ENDTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as ENDTIME 
,LCP_VENTILATIONDATAID
from mimic2v30b.LCP_VENTILATION));

spool off;



--------------------------------------------------------------------------------
-- LCP_ELICHAUSER_SCORES ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/lcp_elixhauser_scores_mornin.csv"

-- ||','|| goes between each one and you need single quotes.

select 
'SUBJECT_ID'
||','||
'HADM_ID'
||','||
'HOSPITAL_MORT_PT'
||','||
'TWENTY_EIGHT_DAY_MORT_PT'
||','||
'ONE_YR_MORT_PT'
||','||
'TWO_YR_MORT_PT'
||','||
'ONE_YEAR_SURVIVAL_PT'
||','||
'TWO_YEAR_SURVIVAL_PT'
||','||
'LCP_ELIXHAUSER_SCORESDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
SUBJECT_ID
||'","'||
HADM_ID
||'","'||
HOSPITAL_MORT_PT
||'","'||
TWENTY_EIGHT_DAY_MORT_PT
||'","'||
ONE_YR_MORT_PT
||'","'||
TWO_YR_MORT_PT
||'","'||
ONE_YEAR_SURVIVAL_PT
||'","'||
TWO_YEAR_SURVIVAL_PT
||'","'||
LCP_ELIXHAUSER_SCORESDATAID
||'"' as x
from 
  ( select
SUBJECT_ID
,HADM_ID
,HOSPITAL_MORT_PT
,TWENTY_EIGHT_DAY_MORT_PT
,ONE_YR_MORT_PT
,TWO_YR_MORT_PT
,ONE_YEAR_SURVIVAL_PT
,TWO_YEAR_SURVIVAL_PT
,LCP_ELIXHAUSER_SCORESDATAID
from mimic2v30b.LCP_ELIXHAUSER_SCORES));

spool off;



--------------------------------------------------------------------------------
-- LCP_DAILY_SOFA ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/lcp_daily_sofa_mornin.csv"

-- ||','|| goes between each one and you need single quotes.

select 
'SUBJECT_ID'
||','||
'ICUSTAY_ID'
||','||
'ICUSTAY_DAY'
||','||
'RESPIRATORY_FAILURE'
||','||
'NEUROLOGICAL_SCORE'
||','||
'CARDIOVASCULAR_SCORE_FINAL'
||','||
'HEPATIC_SCORE'
||','||
'HEMATOLOGIC_SCORE'
||','||
'RENAL_SCORE'
||','||
'SOFA_TOTAL'
||','||
'LCP_DAILY_SOFADATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
SUBJECT_ID
||'","'|| 
ICUSTAY_ID
||'","'|| 
ICUSTAY_DAY
||'","'|| 
RESPIRATORY_FAILURE
||'","'|| 
NEUROLOGICAL_SCORE
||'","'|| 
CARDIOVASCULAR_SCORE_FINAL
||'","'|| 
HEPATIC_SCORE
||'","'|| 
HEMATOLOGIC_SCORE
||'","'|| 
RENAL_SCORE
||'","'|| 
SOFA_TOTAL
||'","'|| 
LCP_DAILY_SOFADATAID
||'"' as x
from 
  ( select
SUBJECT_ID
,ICUSTAY_ID
,ICUSTAY_DAY
,RESPIRATORY_FAILURE
,NEUROLOGICAL_SCORE
,CARDIOVASCULAR_SCORE_FINAL
,HEPATIC_SCORE
,HEMATOLOGIC_SCORE
,RENAL_SCORE
,SOFA_TOTAL
,LCP_DAILY_SOFADATAID
from mimic2v30b.LCP_DAILY_SOFA));

spool off;



--------------------------------------------------------------------------------
-- LCP_DAILY_SAPSI ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/lcp_daily_sapsi_mornin.csv"

-- ||','|| goes between each one and you need single quotes.

select 
'SUBJECT_ID'
||','|| 
'ICUSTAY_ID'
||','|| 
'ICUSTAY_DAY'
||','|| 
'AGE_SCORE'
||','|| 
'BUN_SCORE'
||','|| 
'GCS_SCORE'
||','|| 
'GLUCOSE_SCORE'
||','|| 
'HCT_SCORE'
||','|| 
'HR_SCORE'
||','|| 
'POTASSIUM_SCORE'
||','|| 
'SODIUM_SCORE'
||','|| 
'RR_SCORE'
||','|| 
'SYSABP_SCORE'
||','|| 
'TEMPERATURE_SCORE'
||','|| 
'URINE_SCORE'
||','|| 
'WBC_SCORE'
||','|| 
'HCO3_SCORE'
||','|| 
'SAPSI_SCORE'
||','|| 
'LCP_DAILY_SAPSIDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
SUBJECT_ID
||'","'||
ICUSTAY_ID
||'","'||
ICUSTAY_DAY
||'","'||
AGE_SCORE
||'","'||
BUN_SCORE
||'","'||
GCS_SCORE
||'","'||
GLUCOSE_SCORE
||'","'||
HCT_SCORE
||'","'||
HR_SCORE
||'","'||
POTASSIUM_SCORE
||'","'||
SODIUM_SCORE
||'","'||
RR_SCORE
||'","'||
SYSABP_SCORE
||'","'||
TEMPERATURE_SCORE
||'","'||
URINE_SCORE
||'","'||
WBC_SCORE
||'","'||
HCO3_SCORE
||'","'||
SAPSI_SCORE
||'","'||
LCP_DAILY_SAPSIDATAID
||'"' as x
from 
  ( select
SUBJECT_ID
,ICUSTAY_ID
,ICUSTAY_DAY
,AGE_SCORE
,BUN_SCORE
,GCS_SCORE
,GLUCOSE_SCORE
,HCT_SCORE
,HR_SCORE
,POTASSIUM_SCORE
,SODIUM_SCORE
,RR_SCORE
,SYSABP_SCORE
,TEMPERATURE_SCORE
,URINE_SCORE
,WBC_SCORE
,HCO3_SCORE
,SAPSI_SCORE
,LCP_DAILY_SAPSIDATAID
from mimic2v30b.LCP_DAILY_SAPSI));

spool off;




--------------------------------------------------------------------------------
-- LCP_COMORBIDITY_SCORES ---------------------------------------------------------------
--------------------------------------------------------------------------------

spool "/backup/dpdump/mimic2v30b_csv/lcp_comorbidity_scores_mornin.csv"

-- ||','|| goes between each one and you need single quotes.

select 
'SUBJECT_ID'
||','||
'HADM_ID'
||','||
'CATEGORY'
||','||
'CONGESTIVE_HEART_FAILURE'
||','||
'CARDIAC_ARRHYTHMIAS'
||','||
'VALVULAR_DISEASE'
||','||
'PULMONARY_CIRCULATION'
||','||
'PERIPHERAL_VASCULAR'
||','||
'HYPERTENSION'
||','||
'PARALYSIS'
||','||
'OTHER_NEUROLOGICAL'
||','||
'CHRONIC_PULMONARY'
||','||
'DIABETES_UNCOMPLICATED'
||','||
'DIABETES_COMPLICATED'
||','||
'HYPOTHYROIDISM'
||','||
'RENAL_FAILURE'
||','||
'LIVER_DISEASE'
||','||
'PEPTIC_ULCER'
||','||
'AIDS'
||','||
'LYMPHOMA'
||','||
'METASTATIC_CANCER'
||','||
'SOLID_TUMOR'
||','||
'RHEUMATOID_ARTHRITIS'
||','||
'COAGULOPATHY'
||','||
'OBESITY'
||','||
'WEIGHT_LOSS'
||','||
'FLUID_ELECTROLYTE'
||','||
'BLOOD_LOSS_ANEMIA'
||','||
'DEFICIENCY_ANEMIAS'
||','||
'ALCOHOL_ABUSE'
||','||
'DRUG_ABUSE'
||','||
'PSYCHOSES'
||','||
'DEPRESSION'
||','||
'LCP_COMORBIDITY_SCORESDATAID'
from dual;

-- ||'","'|| goes in between each one
select x from (
select 
'"'||
SUBJECT_ID
||'","'||
HADM_ID
||'","'||
CATEGORY
||'","'||
CONGESTIVE_HEART_FAILURE
||'","'||
CARDIAC_ARRHYTHMIAS
||'","'||
VALVULAR_DISEASE
||'","'||
PULMONARY_CIRCULATION
||'","'||
PERIPHERAL_VASCULAR
||'","'||
HYPERTENSION
||'","'||
PARALYSIS
||'","'||
OTHER_NEUROLOGICAL
||'","'||
CHRONIC_PULMONARY
||'","'||
DIABETES_UNCOMPLICATED
||'","'||
DIABETES_COMPLICATED
||'","'||
HYPOTHYROIDISM
||'","'||
RENAL_FAILURE
||'","'||
LIVER_DISEASE
||'","'||
PEPTIC_ULCER
||'","'||
AIDS
||'","'||
LYMPHOMA
||'","'||
METASTATIC_CANCER
||'","'||
SOLID_TUMOR
||'","'||
RHEUMATOID_ARTHRITIS
||'","'||
COAGULOPATHY
||'","'||
OBESITY
||'","'||
WEIGHT_LOSS
||'","'||
FLUID_ELECTROLYTE
||'","'||
BLOOD_LOSS_ANEMIA
||'","'||
DEFICIENCY_ANEMIAS
||'","'||
ALCOHOL_ABUSE
||'","'||
DRUG_ABUSE
||'","'||
PSYCHOSES
||'","'||
DEPRESSION
||'","'||
LCP_COMORBIDITY_SCORESDATAID
||'"' as x
from 
  ( select
SUBJECT_ID
,HADM_ID
,CATEGORY
,CONGESTIVE_HEART_FAILURE
,CARDIAC_ARRHYTHMIAS
,VALVULAR_DISEASE
,PULMONARY_CIRCULATION
,PERIPHERAL_VASCULAR
,HYPERTENSION
,PARALYSIS
,OTHER_NEUROLOGICAL
,CHRONIC_PULMONARY
,DIABETES_UNCOMPLICATED
,DIABETES_COMPLICATED
,HYPOTHYROIDISM
,RENAL_FAILURE
,LIVER_DISEASE
,PEPTIC_ULCER
,AIDS
,LYMPHOMA
,METASTATIC_CANCER
,SOLID_TUMOR
,RHEUMATOID_ARTHRITIS
,COAGULOPATHY
,OBESITY
,WEIGHT_LOSS
,FLUID_ELECTROLYTE
,BLOOD_LOSS_ANEMIA
,DEFICIENCY_ANEMIAS
,ALCOHOL_ABUSE
,DRUG_ABUSE
,PSYCHOSES
,DEPRESSION
,LCP_COMORBIDITY_SCORESDATAID
from mimic2v30b.LCP_COMORBIDITY_SCORES));

spool off;

SET TERMOUT ON
