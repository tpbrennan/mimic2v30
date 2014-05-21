-- HEART RATE
select distinct itemid, label,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%heart%' 
or 
lower(label) like '%heartrate%'
or 
lower(label) like '%heart%rate%'
order by num desc; 
/*
220045	Heart Rate	2579620
211	Heart Rate	5231565
*/
select count(distinct subject_id), count(distinct icustay_id), max(icustay_id) from mimic2v30.chartevents 
where itemid in (220045, 211); 
-- HR: 46804	subjects, 56781	icustays, 71458 max icustay_id






-- TEMPARATURE
select distinct itemid, label,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%temperature%' 
or 
lower(label) like '%body%temp%'
or 
lower(label) like '%celsius%'
or 
lower(label) like '%farenheit%'
order by num desc;
/*
226329	Blood Temperature CCO (C)	60803 
677	Temperature C (calc)	783760
3655	Temp Skin [C]	533228
3652	Temp Axillary [F]	462116
676	Temperature C	381239
223762	Temperature Celsius	70207
223761	Temperature Fahrenheit	500128
678	Temperature F	785285
679	Temperature F (calc)	378707
*/
select count(distinct subject_id), count(distinct icustay_id), max(icustay_id) from mimic2v30.chartevents 
where itemid in (676, 677, 678, 679, 3652, 3655, 226329, 223761, 223762); 
-- TEMPERATURE: 44837 subjects






-- SYSABP
select distinct itemid, label, value1uom,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%systolic%' 
or 
lower(label) like '%blood%pressure%'
or 
lower(label) like '%nbp%'
or 
lower(label) like '%abp%'
or 
lower(label) like '%arterial%bp%'
order by num desc;
/*
51	Arterial BP	2117328
455	NBP	1610101
220179	Non Invasive Blood Pressure systolic	1241873
220050	Arterial Blood Pressure systolic	1041561
225309	ART BP Systolic	83205
224167	Manual Blood Pressure Systolic Left	721
227243	Manual Blood Pressure Systolic Right	526
*/
select count(distinct subject_id),count(distinct icustay_id), max(icustay_id) from mimic2v30.chartevents 
where itemid in (51, 455, 225309, 220179, 220050, 227243, 224167); 
-- 39227 subjects






-- HCT
select distinct itemid, label, value1uom,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%hematocrit%' 
or 
lower(label) like '%hct%' 
order by num desc;
/*
813	Hematocrit	278186
220545	Hematocrit (serum)	145378
226540	Hematocrit (whole blood - calc)	15232
3761	Hematocrit (35-51)	12517
*/
select distinct itemid, test_name, valueuom,
  count(*) over (partition by itemid) num from mimic2v30.labevents 
where 
lower(test_name) like '%hematocrit%' 
or 
lower(test_name) like '%hct%' 
order by num desc;
/*
50383	HCT	%	596638
51243	Hematocrit	%	274546
50029	calcHCT	%	62387
50809	Hematocrit, Calculated	%	26730
50604	HCT	%	185
50582	HCT	%	171
50302	HCT	%	106
50535	HCT	%	44
50514	HCT	%	31
50643	HCT	%	4
51512	Hematocrit	%	2
*/
with subjects as (
  select subject_id, icustay_id from mimic2v30.chartevents where itemid in (813, 220545, 226540, 3761)
  union 
  select subject_id, icustay_id from mimic2v30.labevents where itemid in (50383,51243,50029,50809,50604,50582,50302,50535,50514,50643,51512) 
)
select count(distinct subject_id), count(distinct icustay_id), max(icustay_id) from subjects;
-- HCT: 46712	subjects, 56403	icustays, 71458 max icustay







-- WBC
select distinct itemid, label, value1uom,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%wbc%' 
or 
lower(label) like '%white%blood%cell%' 
order by num desc;
/*
4200	WBC 4.0-11.0	8919
220546	WBC	117126
1542	WBC	140123
1127	WBC   (4-11,000)	171685
861	WBC (4-11,000)	180449
*/
select distinct itemid, test_name, valueuom,
  count(*) over (partition by itemid) num from mimic2v30.labevents 
where 
lower(test_name) like '%wbc%' 
or 
lower(test_name) like '%white%blood%cell%' 
order by num desc;
/*
50468	WBC	K/uL	506659
51327	White Blood Cells	K/uL	235686
50674	WBC	#/hpf	58716
51550	WBC	#/hpf	26153
50527	WBC	#/uL	4101
50314	WBC	#/CU MM	2016
50314	WBC	#/uL	2016
50316	 WBC	K/uL	2013
50617	WBC	#/uL	1745
50599	WBC	#/uL	1098
50548	WBC	#/uL	467
51326	WBC Count	K/uL	218
*/
with subjects as (
  select subject_id, icustay_id from mimic2v30.chartevents where itemid in (220546, 1542, 1127, 861, 4200)
  union 
  select subject_id, icustay_id from mimic2v30.labevents where itemid in (50468,51327,50674,51550,50527,50314,50314,50316,50617,50599,50548,51326) 
)
select count(distinct subject_id), count(distinct icustay_id), max(icustay_id) from subjects;
-- WBC: 46635	subjects, 55827	icustays, 71458 max icustay





-- GCS
select distinct itemid, label,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%gcs%' 
or 
lower(label) like '%glasgow%' 
or 
lower(label) like '%coma%' 
order by num desc;
/*
198	GCS Total	960006
226755	GcsApacheIIScore	9
227013	GcsScore_ApacheIV	7
*/
--select count(distinct subject_id) from mimic2v30.chartevents 
select max(icustay_id) from mimic2v30.chartevents
where itemid in (227013,198,226755); --23614 subjects, max icustay_id 69434






-- GLUCOSE
select distinct itemid, label,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%glucose%' 
or 
lower(label) like '%bs%' 
order by num desc;
/*
807	Fingerstick Glucose	439685
811	Glucose (70-105)	385098
1529	Glucose	289096
225664	Glucose finger stick	237336
220621	Glucose (serum)	137008
226537	Glucose (whole blood)	61647
3745	BloodGlucose	2656
3744	Blood Glucose	533
1310	FINGERSTICK GLUCOSE.	5
1455	fingerstick glucose	5
2338	finger stick glucose	2
*/

select distinct itemid, test_name,
  count(*) over (partition by itemid) num from mimic2v30.labevents 
where 
lower(test_name) like '%glucose%' 
or 
lower(test_name) like '%bs%' 
order by num desc;
/*
50112	GLUCOSE	490332
50936	Glucose	307488
50006	GLUCOSE	138255
50641	GLUCOSE	79620
51510	Glucose	34317
50201	GLUCOSE	2896
50240	GLUCOSE	1467
50043	GLUCOSE	714
50217	GLUCOSE	301
50208	GLUCOSE	47
50266	GLUCOSE	43
*/
with subjects as (
  select subject_id, icustay_id from mimic2v30.chartevents where itemid in (807, 811, 1529, 225664, 220621, 226537, 3745, 3744, 1310, 1455, 2338)
  union 
  select subject_id, icustay_id from mimic2v30.labevents where itemid in (50112,50936,50006,50641,51510,50201,50240,50043,50217,50208,50266) 
)
select count(distinct subject_id), count(distinct icustay_id), max(icustay_id) from subjects;
-- GLUCOSE: 43114	subjects, 52677	icustays, 71458 max icustay






-- HCO3
select distinct itemid, test_name,
  count(*) over (partition by itemid) num from mimic2v30.labevents 
where 
lower(test_name) like '%bicarbonate%' 
or 
lower(test_name) like '%bicarb%' 
or 
lower(test_name) like '%hco3%' 
or
lower(test_name) like '%tco2%' 
or
lower(test_name) like '%total%co2%' 
order by num desc;
/*
50172	TOTAL CO2	516264
50025	TOTAL CO2	344364
50886	Bicarbonate	253894
50803	Calculated Total CO2	144006
50022	TCO2	5658
50802	Calculated Bicarbonate, Whole Blood	3538
50279	TOTAL CO2	921
50230	TOTAL CO2	50
*/
select distinct itemid, label,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%bicarbonate%' 
or 
lower(label) like '%hco3%' 
or 
lower(label) like '%tco2%' 
or 
lower(label) like '%total co2%' 
order by num desc;
/*
227443	HCO3 (serum)	134238
225698	TCO2 (calc) Arterial	117912
3810	Total CO2	21723
3808	TCO2        (21-30)	9234
3809	TCO2 (other)	8436
4199	TCO2 (cap)	8098
223679	TCO2 (calc) Venous	3912
*/
with subjects as (
  select subject_id, icustay_id from mimic2v30.chartevents where itemid in (3808, 3809, 3810, 4199, 223679, 225698, 227443)
  union 
  select subject_id, icustay_id from mimic2v30.labevents where itemid in (50172,50025,50886,50803,50022,50802,50279,50230) 
)
select count(distinct subject_id), count(distinct icustay_id), max(icustay_id) from subjects;
-- HCO3: 42946 subjects, 52727 icustays, 71458 max(icustay_id)






-- POTASSIUM
select distinct itemid, test_name,
  count(*) over (partition by itemid) num from mimic2v30.labevents 
where 
lower(test_name) like '%potassium%' 
or 
lower(test_name) like '%blood%k%' 
or 
lower(test_name) like '%serum%k%' 
or 
lower(test_name) like '%k%serum%' 
or 
lower(test_name) like '%k%blood%' 
order by num desc;
/*
50149	POTASSIUM	561230
50976	Potassium	273239
50821	Potassium, Whole Blood	55521
50275	POTASSIUM	4132
50251	POTASSIUM	81
50225	POTASSIUM	60
50048	POTASSIUM	30
50243	POTASSIUM	11
*/
select distinct itemid, label,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%potassium%' 
or 
lower(label) like '%blood%k%' 
or 
lower(label) like '%serum%k%' 
or 
lower(label) like '%k%serum%' 
or 
lower(label) like '%k%blood%' 
order by num desc;
/*
829	Potassium (3.5-5.3)	330049
1535	Potassium	249964
227442	Potassium (serum)	146115
227464	Potassium (whole blood)	40681
3792	Potassium  (3.5-5.3)	15818
3725	ABG POTASSIUM	114
4194	ABG Potassium	109
*/
with subjects as (
  select subject_id, icustay_id from mimic2v30.chartevents where itemid in (829, 1535, 3792, 3725, 4194, 227442, 227464)
  union 
  select subject_id, icustay_id from mimic2v30.labevents where itemid in (50149, 50976, 50821, 50275, 50251, 50225, 50048, 50243)
)
select count(distinct subject_id), count(distinct icustay_id), max(icustay_id) from subjects;
-- POTASSIUM: 42599	subjects, 52944	icustays, 71458 max icustay



-- SODIUM
select distinct itemid, label, value1uom,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%sodium%' 
or 
lower(label) like '%blood%na%' 
or 
lower(label) like '%serum%na%' 
or 
lower(label) like '%na%serum%' 
or 
lower(label) like '%na%blood%' 
order by num desc;
/*
837	Sodium (135-148)	224725
1536	Sodium	174475
220645	Sodium (serum)	143787
3803	Sodium  (135-148)	15768
226534	Sodium (whole blood)	14170
3726	ABG SODIUM	52
4195	ABG Sodium	47
*/
select distinct itemid, test_name, valueuom,
  count(*) over (partition by itemid) num from mimic2v30.labevents 
where 
lower(test_name) like '%sodium%' 
or 
lower(test_name) like '%blood%na%' 
or 
lower(test_name) like '%serum%na%' 
or 
lower(test_name) like '%na%serum%' 
or 
lower(test_name) like '%na%blood%' 
order by num desc;
/*
50159	SODIUM	528292
50989	Sodium	268674
50823	Sodium, Whole Blood	24684
50277	SODIUM	16454
50252	SODIUM	82
50226	SODIUM	66
50049	SODIUM	37
50244	SODIUM	11
*/
with subjects as (
  select subject_id, icustay_id from mimic2v30.chartevents where itemid in (837, 1536, 3726, 3803, 220645, 226534)
  union 
  select subject_id, icustay_id from mimic2v30.labevents where itemid in (50159, 50989, 50823, 50277, 50252, 50226, 50049, 50244)
)
select count(distinct subject_id), count(distinct icustay_id), max(icustay_id) from subjects;
-- SODIUM: 42572 subjects,	52776	icustays, 71458 max icustay






-- BUN
select distinct itemid, label, value1uom,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%bun%' 
or 
lower(label) like '%blood%urea%nitrogren%' 
order by num desc;
/*
781 BUN (6-20) 197870
1162 BUN 154173
225624 BUN 134066
3737 BUN (6-20) 2139
*/
select distinct itemid, test_name, valueuom,
  count(*) over (partition by itemid) num from mimic2v30.labevents 
where 
lower(test_name) like '%bun%' 
or 
lower(test_name) like '%blood%urea%nitrogren%' 
or 
lower(test_name) like '%nitrogren%' 
order by num desc;
/*
NONE
*/
with subjects as (
  select subject_id, icustay_id from mimic2v30.chartevents where itemid in (781, 1162, 3737, 225624)
)
select count(distinct subject_id), count(distinct icustay_id), max(icustay_id) from subjects;
 -- 39379	subjects, 50545 icustays, 71458 max icustays






-- CREATININE
select distinct itemid, label, value1uom,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%creatinine%' 
or 
lower(label) like '%creat%' 
order by num desc;
/*
791	Creatinine (0-1.3)	198844
1525	Creatinine	154939
220615	Creatinine	134556
3750	Creatinine   (0-0.7)	2103
*/
select distinct itemid, test_name, valueuom,
  count(*) over (partition by itemid) num from mimic2v30.labevents 
where 
lower(test_name) like '%creatinine%' 
or 
lower(test_name) like '%creat%' 
order by num desc;
/*
51093	Creatinine, Serum	mg/dL	23
50239	CREAT	mg/dL	179
50042	CREAT	mg/dL	304
50216	CREAT	mg/dL	282
50264	CREAT	mg/dL	22225
50916	Creatinine	mg/dL	259257
50090	CREAT	mg/dL	526309
*/
with subjects as (
  select subject_id, icustay_id from mimic2v30.chartevents where itemid in (791, 1525, 3750, 220615)
  union 
  select subject_id, icustay_id from mimic2v30.labevents where itemid in (50090,50916,50264,50042,50216,50239,51093)
)
select count(distinct subject_id), count(distinct icustay_id), max(icustay_id) from subjects;
-- CREATININE: 40669 subjects,	50786	icustays, 71458 max icustay





-- URINE 
select distinct itemid, label,
  count(*) over (partition by itemid) num from mimic2v30.ioevents 
where 
lower(label) like '%urine%' 
or 
lower(label) like '%urine%out%'
order by num desc;
/*
40056	Urine Out Foley	1938312
43176	Urine .	109042
40070	Urine Out Void	70733
40095	Urine Out Condom Cath	10240
40716	Urine Out Suprapubic	6985
40474	Urine Out IleoConduit	4827
40086	Urine Out Incontinent	2934
40058	Urine Out Rt Nephrostomy	2797
40057	Urine Out Lt Nephrostomy	2729
40406	Urine Out Other	1829
40429	Urine Out Straight Cath	723
40097	Urine Out Ureteral Stent #1	418
43172	URINE CC/KG/HR	314
43374	urine cc/kg/hr	122
40652	Urine Out Ureteral Stent #2	90
45928	True Urine	45
43432	Urine cc/k/hr	43
43523	Urine cc/kg/hr	30
42508	TRUE URINE	27
43590	urine cc/k/hr	10
43538	urine o/p	7
43967	real urine output	6
43463	urine	6
*/
--select count(distinct subject_id) from mimic2v30.ioevents 
select max(icustay_id) from mimic2v30.ioevents
where itemid in ( 40056, 43176,40070,40095,40716,40474,40086,40058,40057,
40406	,40429	,40097	,43172	,43374, 40652	,45928	,43432	,
43523	,42508	,43590	,43538	,43967	,43463	); -- 26483 subjects, 47532 max icustay_id






-- VENTILATED
select distinct itemid, label,
  count(*) over (partition by itemid) num
  from mimic2v30.chartevents
  where 
  lower(label) like '%ventilator%'
  or
  lower(label) like '%waveform%vent%'
  or
  lower(label) like '%airway%'
  or
  lower(label) like '%cuff%pressure%'
  or
  lower(label) like '%peak%insp%pressure%'
  or
  lower(label) like '%plateau%pressure%'
  or
  lower(label) like '%tidal%volume%'
  order by num desc;
/*
40	Airway Type	514690
722	Ventilator Type	493412
39	Airway Size	493101
720	Ventilator Mode	425004
224697	Mean Airway Pressure	391088
444	Mean Airway Pressure	386460
224685	Tidal Volume (observed)	383104
38	Airway	379012
224695	Peak Insp. Pressure	378947
682	Tidal Volume (Obser)	252045
535	Peak Insp. Pressure	238583
683	Tidal Volume (Set)	233230
732	Waveform-Vent	223955
224686	Tidal Volume (spontaneous)	220999
684	Tidal Volume (Spont)	198718
224684	Tidal Volume (set)	185373
543	Plateau Pressure	177372
721	Ventilator No.	80536
227565	Ventilator Tank #1	77727
227566	Ventilator Tank #2	77683
224696	Plateau Pressure	69967
3681	Ventilator Number	48529
224417	Cuff Pressure	38603
3689	Vt [Ventilator]	31674
141	Cuff Pressure-Airway	18449
*/
--select count(distinct subject_id) from mimic2v30.chartevents
select max(icustay_id) from mimic2v30.chartevents
where itemid in (40,722,39,720,224697,444,224685,38,
224695,682,535,683,732,224686,
684,224684,543,721,227565,227566,224696,3681,224417,3689,141); -- 23960 subjects, max icustay_id 71458





-- RESP
select distinct itemid, label,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%repiratory%' 
or 
lower(label) like '%resp%rate%'
or 
lower(label) like '%resp%rate%'
order by num desc;
/*
618	Respiratory Rate	3433853
220210	Respiratory Rate	2555576
3603	Resp Rate	1677429
615	Resp Rate (Total)	421300
219	High Resp. Rate	385422
224689	Respiratory Rate (spontaneous)	378496
224690	Respiratory Rate (Total)	327087
619	Respiratory Rate Set	254701
614	Resp Rate (Spont)	239893
224688	Respiratory Rate (Set)	194280
*/
select count(distinct subject_id) from mimic2v30.chartevents
where itemid in (219, 618, 614, 619, 615, 220210, 3603, 224689, 224690, 224688); -- 46769 subjects


On a related note, I've been looking through MIMIC2V30 for the SAPS variables. I've been able to track down most SAPS data using both CHARTEVENTS tables, except the following
GCS data from CHARTEVENTS for 23614 subjects, max icustay_id 69434
HCO3 data from CHARTEVENTS for 17141 subjects, max icustay_id 71,458
VENTILATED data from CHARTEVENTS for 23960 subjects, max icustay_id 71458
Urine Out data from IOEVENTS for 26483 subjects, max icustay_id 47532 