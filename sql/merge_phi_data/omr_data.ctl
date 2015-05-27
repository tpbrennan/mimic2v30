OPTIONS (skip=2, errors=0)
LOAD DATA
INFILE '/backup/dpdump/mimic2v30/bidmc_phi_john/omr_data_supplment.csv' "str '\n'"
TRUNCATE
INTO TABLE "MORNIN"."OMR_DATA_SUPPLEMENT"
FIELDS TERMINATED BY','
OPTIONALLY ENCLOSED BY '"' AND '"'
TRAILING NULLCOLS ( 
MRN
,FISCAL_NUM
,ADM_DT
,DOB
,mrn_cm
,disch_dt
,Ht_per_OMR
,Ht_per_OMR_Dt
,height_inches_Nursing_Assess
,weight_pounds_Nursing_Assess
,readmit_dt
,readmit_enc
,readmit_princ_diag
,readmit_princ_diagDesc
,readmitADT_reason
,most_recent_creatinineValue
,most_recent_CreatinineDt
,Pre7DaysCreatinineValue
,Pre7DaysCreatinineDt
,Post7DaysCreatinineValue
,Post7DaysCreatinineDt
,Pre7DaysWBCValue
,Pre7DaysWBCDt
,Pre7DaysHemoglobinValue
,Pre7DaysHemoglobinDt
,Pre7DaysPlateletValue
,Pre7DaysPlateletDt
,Pre7DaysAlbuminValue
,Pre7DaysAlbuminDt
,Pre7DaysSodiumValue
,Pre7DaysSodiumDt
,Post7DaysWBCValue
,Post7DaysWBCdt
,Post7DaysHemoglobinValue
,Post7DaysHemoglobinDt
,Post7DaysPlateletValue
,Post7DaysPlateletDt
,Post7DaysAlbuminValue
,Post7DaysAlbuminDt
,Post7DaysSodiumValue
,Post7DaysSodiumDt
,most_recent_WBCValue
,most_recent_WBCDt
,most_recent_HemoglobinValue
,most_recent_HemoglobinDt
,most_recent_PlateletValue
,most_recent_PlateletDt
,most_recent_AlbuminValue
,most_recent_AlbuminDt
,most_recent_SodiumValue
,most_recent_SodiumDt
)
