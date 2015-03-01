-- WHAT WE NEED IS EVERY HEPARIN MEASUREMENT, 

SELECT COUNT(*)
FROM MIMIC2V26.LABEVENTS
WHERE ITEMID = 50440;


SELECT * FROM MIMIC2V26.D_LABITEMS WHERE LOWER(LOINC_DESCRIPTION) LIKE '%sofa%';

--LAB INFORMATION
50177	UREA N	BLOOD	CHEMISTRY	3094-0	Urea nitrogen [Mass/volume] in Serum or Plasma
50018	PH	BLOOD	BLOOD GAS	11558-4	pH of Blood
50060	ALBUMIN	BLOOD	CHEMISTRY	1751-7	Albumin [Mass/volume] in Serum or Plasma
50468	WBC	BLOOD	HEMATOLOGY
50172	TOTAL CO2	BLOOD
50383	HCT	BLOOD
50386	HGB	BLOOD	HEMATOLOGY	718-7	Hemoglobin [Mass/volume] in Blood
50440 APTT


--CHART INFORMATION
Heart Rate	heart rate	211
SpO2	spo2	646
Respiratory Rate	respiratory rate	618
Heart Rhythm	heart rhythm	212
Service Type	service type	1125
Arterial BP	arterial bp	51
SaO2	sao2	834
GCS Total	gcs total	198
Temperature F	temperature f	678












