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
676	Temperature C	381239
223762	Temperature Celsius	70207
227054	TemperatureF_ApacheIV
223761	Temperature Fahrenheit	500128
3652	Temp Axillary [F]	462116
678	Temperature F	785285
679	Temperature F (calc)	378707
*/
select count(distinct subject_id), count(distinct icustay_id), max(icustay_id) from mimic2v30.chartevents 
where itemid in (676, 677, 678, 679, 3652, 3655, 226329, 223761, 223762, 227054); 
-- TEMPERATURE: 44837 subjects,	55422	icustays, 71458 max icustay_id






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
lower(label) like '%ibp%'
or 
lower(label) like '%abp%'
or 
lower(label) like '%art%bp%'
or 
lower(label) like '%manual%bp%'
or 
label like '%BP%'
order by num desc;
/*
51	Arterial BP	2117328
455	NBP	1610101
220179	Non Invasive Blood Pressure systolic	1241873
220050	Arterial Blood Pressure systolic	1041561
225309	ART BP Systolic	83205
224167	Manual Blood Pressure Systolic Left	721
227243	Manual Blood Pressure Systolic Right	526
6701	Arterial BP #2	mmHg	19279
3313	BP Cuff [S/D]	cc/min	148170
*/
select count(distinct subject_id),count(distinct icustay_id), max(icustay_id) from mimic2v30.chartevents 
where itemid in (51, 442, 455, 225309, 220179, 220050, 227243, 224167, 6701, 3313); 
-- SYSABP: 46533 subjects,	55995	icustays, 71458 max icustay_id


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
where itemid in (227013,198,226755); 
--23614 subjects, 30490 icustays, max icustay_id 69434






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
select distinct itemid, test_name, category, fluid,
  count(*) over (partition by itemid) num from mimic2v30.labevents 
where 
lower(fluid) = 'blood'
and
(lower(test_name) like '%hematocrit%' 
or 
lower(test_name) like '%hct%')
order by num desc;
/*
50383	HCT	HEMATOLOGY	BLOOD	596638
51243	Hematocrit	Hematology	Blood	274546
50029	calcHCT	BLOOD GAS	BLOOD	62387
50809	Hematocrit, Calculated	Blood Gas	Blood	26730
*/
with subjects as (
  --select subject_id, icustay_id from mimic2v30.chartevents where itemid in (813, 220545, 226540, 3761)
  --union 
  select subject_id, hadm_id from mimic2v30.labevents 
  where itemid in (50383,51243,50029,50809) 
)
select count(distinct subject_id), count(distinct hadm_id), max(hadm_id) from subjects;
-- HCT: 46712	subjects, 56403	icustays, 71458 max icustay
-- HCT (labs): 46445	subjects, 56441	hadms, 58847 max hadm_id







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
select distinct itemid, test_name, fluid,
  count(*) over (partition by itemid) num from mimic2v30.labevents 
where 
lower(fluid) = 'blood'
and 
(lower(test_name) like '%wbc%' 
or 
lower(test_name) like '%white%blood%cell%')
order by num desc;
/*
50468	WBC	BLOOD	506659
51327	White Blood Cells	Blood	235686
50316	 WBC	BLOOD	2013
51326	WBC Count	Blood	218
*/
with subjects as (
  --select subject_id, icustay_id from mimic2v30.chartevents where itemid in (220546, 1542, 1127, 861, 4200)
  --union 
  select subject_id, hadm_id from mimic2v30.labevents 
  where itemid in (50468,51327,50316,51326) 
)
select count(distinct subject_id), count(distinct hadm_id), max(hadm_id) from subjects;
-- WBC: 46635	subjects, 55827	icustays, 71458 max icustay
-- WBC (labs): 46369	subjects, 56321	hadms, 58847 max hadm_id







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

select distinct itemid, test_name, fluid,
  count(*) over (partition by itemid) num 
  from mimic2v30.labevents 
where 
lower(test_name) like '%glucose%'
and
lower(fluid) like '%blood%'
order by num desc;
/*
50112	GLUCOSE	490332
50936	Glucose	307488
50006	GLUCOSE	138255
*/
with subjects as (
  --select subject_id, icustay_id from mimic2v30.chartevents where itemid in (807, 811, 1529, 225664, 220621, 226537, 3745, 3744, 1310, 1455, 2338)
  --union 
  select subject_id, hadm_id from mimic2v30.labevents 
  where itemid in (50112, 50936, 50006)
)
select count(distinct subject_id), count(distinct hadm_id), max(hadm_id) from subjects;
-- GLUCOSE: 43114	subjects, 52677	icustays, 71458 max icustay
-- GLUCOSE (labs): 40064 subjects,	49994	hadm_id, 58847 hadms






-- HCO3
select distinct itemid, label, 
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
(lower(label) like '%bicarbonate%' 
or 
lower(label) like '%hco3%' 
or 
lower(label) like '%tco2%' 
or 
lower(label) like '%total co2%') 
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
select distinct itemid, test_name, category, fluid,
  count(*) over (partition by itemid) num from mimic2v30.labevents 
where 
lower(fluid) like '%blood%'
and
(lower(test_name) like '%bicarbonate%' 
or 
lower(test_name) like '%bicarb%' 
or 
lower(test_name) like '%hco3%' 
or
lower(test_name) like '%tco2%' 
or
lower(test_name) like '%total%co2%')
order by num desc;
/*
50172	TOTAL CO2	CHEMISTRY	BLOOD	516264
50025	TOTAL CO2	BLOOD GAS	BLOOD	344364
50886	Bicarbonate	Chemistry	Blood	253894
50803	Calculated Total CO2	Blood Gas	Blood	144006
50022	TCO2	BLOOD GAS	BLOOD	5658
50802	Calculated Bicarbonate, Whole Blood	Blood Gas	Blood	3538
*/
with subjects as (
  --select subject_id, icustay_id from mimic2v30.chartevents where itemid in (3808, 3809, 3810, 4199, 223679, 225698, 227443)
  --union 
  select subject_id, hadm_id from mimic2v30.labevents 
  where itemid in (50172,50025,50886,50803,50022,50802) 
)
select count(distinct subject_id), count(distinct hadm_id), max(hadm_id) from subjects;
-- HCO3: 42946 subjects, 52727 icustays, 71458 max(icustay_id)
-- HCO3 (labs only): 42664 subjects,	52686	hadms, 58847 max hadm_id






-- POTASSIUM

select distinct itemid, label, valueuom, category,
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
select distinct itemid, test_name, category, fluid,
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
50149	POTASSIUM	CHEMISTRY	BLOOD	561230
50976	Potassium	Chemistry	Blood	273239
*/
with subjects as (
  --select subject_id, icustay_id from mimic2v30.chartevents where itemid in (829, 1535, 3792, 3725, 4194, 227442, 227464)
  --union 
  select subject_id, hadm_id from mimic2v30.labevents 
  where itemid in (50149,50976)
)
select count(distinct subject_id), count(distinct hadm_id), max(hadm_id) from subjects;
-- POTASSIUM: 42599	subjects, 52944	icustays, 71458 max icustay
-- POTASSIUM (labs only): 42249	52262	58847





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
select distinct itemid, test_name, category, fluid, 
  count(*) over (partition by itemid) num from mimic2v30.labevents 
where 
lower(fluid) = 'blood'
and 
(lower(test_name) like '%sodium%' 
or 
lower(test_name) like '%blood%na%' 
or 
lower(test_name) like '%serum%na%' 
or 
lower(test_name) like '%na%serum%' 
or 
lower(test_name) like '%na%blood%') 
order by num desc;
/*
50159	SODIUM	mEq/L	528292
50989	Sodium	mEq/L	268674
*/
with subjects as (
  --select subject_id, icustay_id from mimic2v30.chartevents where itemid in (837, 1536, 3726, 3803, 220645, 226534)
  --union 
  select subject_id, hadm_id from mimic2v30.labevents 
  where itemid in (50159, 50989)
)
select count(distinct subject_id), count(distinct hadm_id), max(hadm_id) from subjects;
-- SODIUM (both): 42572 subjects,	52776	icustays, 71458 max icustay
-- SODIUM (labs only): 42238 subjects, 52231 hadm_id, 58847 max hadm_id






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
select distinct itemid, test_name, category, fluid,
  count(*) over (partition by itemid) num 
  --from mimic2v30.d_items where origin = 'LAB' and
  from mimic2v30.labevents where 
(lower(test_name) like '%bun%' 
or 
lower(test_name) like '%blood%urea%nitrogren%' 
or 
lower(test_name) like '%nitrogren%' 
or 
lower(test_name) like '%urea n%')
order by num desc;
/*
labevents
50177	UREA N	mg/dL	522157 = 51011	Urea Nitrogen	mg/dL	258314
*/
with subjects as (
  --select subject_id, icustay_id from mimic2v30.chartevents where itemid in (781, 1162, 3737, 225624)
  --union
  select subject_id, icustay_id from mimic2v30.labevents 
  where itemid in (50177,51011)
)
select count(distinct subject_id), count(distinct icustay_id), max(icustay_id) from subjects;
-- BUN (both) 40678 subjects,	50771 icustays,	71458 max icustay
-- BUN (charts only) 39379	subjects,  50545 icustays	71458
-- BUN (labs only) 40416	subjects, 30380	icustays, 47532 max icustay






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
select distinct itemid, test_name, category, fluid,
  count(*) over (partition by itemid) num from mimic2v30.labevents 
where 
lower(fluid) like '%blood%'
and 
(lower(test_name) like '%creatinine%' 
or 
lower(test_name) like '%creat%')
order by num desc;
/*
50090	CREAT	CHEMISTRY	BLOOD	526309
50916	Creatinine	Chemistry	Blood	259257
*/
with subjects as (
  --select subject_id, icustay_id from mimic2v30.chartevents where itemid in (791, 1525, 3750, 220615)
  --union 
  select subject_id, hadm_id from mimic2v30.labevents 
  where itemid in (50090, 50916)
)
select count(distinct subject_id), count(distinct hadm_id), max(hadm_id) from subjects;
-- CREATININE: 40669 subjects,	50786	icustays, 71458 max icustay
-- CREATININE (labs): 40405	subjects, 50332	hadms, 58847 max hadm_id





-- URINE 
select distinct itemid, label, uom,
  count(*) over (partition by itemid) num from mimic2v30.ioevents 
  where itemid in (651, 715, 55, 56, 57, 61, 65, 69, 85, 94, 96, 288, 405,
                      428, 473, 2042, 2068, 2111, 2119, 2130, 1922, 2810, 2859,
                      3053, 3462, 3519, 3175, 2366, 2463, 2507, 2510, 2592,
                      2676, 3966, 3987, 4132, 4253, 5927, 40056, 43176,40070,
                      40095,40716,40474,40086,40058,40057, 40406	,40429	,
                      40097	,43172	,43374, 40652	,45928	,43432	,
                      43523	,42508	,43590	,43538	,43967	,43463)
  order by num desc;	
/*
40056	Urine Out Foley	ml	1938312
43176	Urine .	ml	109042
40070	Urine Out Void	ml	70733
40095	Urine Out Condom Cath	ml	10240
40716	Urine Out Suprapubic	ml	6985
40474	Urine Out IleoConduit	ml	4827
40086	Urine Out Incontinent	ml	2934
40058	Urine Out Rt Nephrostomy	ml	2797
40057	Urine Out Lt Nephrostomy	ml	2729
40406	Urine Out Other	ml	1829
40429	Urine Out Straight Cath	ml	723
40097	Urine Out Ureteral Stent #1	ml	418
43172	URINE CC/KG/HR	ml	314
43374	urine cc/kg/hr	ml	122
40652	Urine Out Ureteral Stent #2	ml	90
45928	True Urine	ml	45
43432	Urine cc/k/hr	ml	43
43523	Urine cc/kg/hr	ml	30
42508	TRUE URINE	ml	27
43590	urine cc/k/hr	ml	10
43538	urine o/p	ml	7
43967	real urine output	ml	6
43463	urine	ml	6
*/
select distinct itemid, label, uom,
  count(*) over (partition by itemid) num from mimic2v30.ioevents 
where 
lower(label) like '%urine%' 
or 
lower(label) like '%urine out%'
or 
lower(label) like '%foley%'
order by num desc;
/*
40056	Urine Out Foley	ml	1938312
226559	Foley	mL	890514
43176	Urine .	ml	109042
40070	Urine Out Void	ml	70733
40095	Urine Out Condom Cath	ml	10240
40066	OR Out PACU Urine	ml	7749
40062	OR Out OR Urine	ml	7376
40716	Urine Out Suprapubic	ml	6985
40474	Urine Out IleoConduit	ml	4827
40086	Urine Out Incontinent	ml	2934
40058	Urine Out Rt Nephrostomy	ml	2797
40057	Urine Out Lt Nephrostomy	ml	2729
227489	GU Irrigant/Urine Volume Out	mL	2111
40406	Urine Out Other	ml	1829
40289	PACU Out PACU Urine	ml	1148
40429	Urine Out Straight Cath	ml	723
226631	PACU Urine	mL	419
40097	Urine Out Ureteral Stent #1	ml	418
43172	URINE CC/KG/HR	ml	314
43374	urine cc/kg/hr	ml	122
40652	Urine Out Ureteral Stent #2	ml	90
40652	Urine Out Ureteral Stent #2		90
45928	True Urine	ml	45
44205	Foley Catheter	ml	34
43432	Urine cc/k/hr	ml	43
43523	Urine cc/kg/hr	ml	30
42508	TRUE URINE	ml	27
44168	foley flush	ml	21
42523	FOLEY FLUSH	ml	13
43590	urine cc/k/hr	ml	10
42811	angio urine out	ml	7
44758	Foley Cath	ml	7
43538	urine o/p	ml	7
42043	ANGIO URINE OUT	ml	6
42677	ANGIO URINE OUTPUT	ml	6
43967	real urine output	ml	6
43463	urine	ml	6
43655	urine o/p cc/kg/hr	ml	6
42120	urine output-angio	ml	6
42363	CATH LAB URINE OUTPT	ml	5
43381	urine outpt cc/kg/hr	ml	5
43366	urine output/kg/hr	ml	5
43366	urine output/kg/hr		5
42860	ANGIO URINE	ml	4
42464	cath lab urine	ml	4
44133	Procedure urine out	ml	4
42367	angio urine output	ml	4
44685	floor urine out	ml	4
44926	true urine	ml	4
43520	urine amnt	ml	4
43349	urine output/kg	ml	4
43356	urine/k/hr	ml	4
42131	ANGIO URINE O/P	ml	3
43380	URINECC/KG/HR	ml	3
43380	URINECC/KG/HR		3
45305	Urine output cc/k/hr	ml	3
45305	Urine output cc/k/hr		3
41923	angio urine	ml	3
44753	inc urine	ml	3
40535	urine flush	ml	3
43812	urine out: cc/k/hr	ml	3
43174	urinecc/kg/hr	ml	3
43577	24hr Urine cc/kg/hr	ml	2
43373	24hr urine output	ml	2
43375	URINE CC?KG?HR	ml	2
43054	URINE OUT	ml	2
44254	Urine out angio	ml	2
43634	Urine,cc/kg/day	ml	2
45842	bladder irrig/urine	ml	2
43334	urine cc's/k/hr	ml	2
43857	urine cc/k/ghr	ml	2
43348	urine cc/kg	ml	2
43988	urine out or	ml	2
46181	urine out-angio	ml	2
44707	urine output	ml	2
43639	urine output cc/k/hr	ml	2
46178	URINE OUT-ANGIO	ml	1
42069	angio Urine output	ml	1
43813	urine out:cc/k/hr	ml	1
*/
--select count(distinct subject_id) from mimic2v30.ioevents 
select count(distinct subject_id), count(distinct icustay_id), max(icustay_id) from mimic2v30.ioevents
where itemid in (40056,226559,43176,40070,40095,40066,40062,
40716,40474,40086,40058,40057,227489,40406,40289,40429,226631,40097,43172,
43374,40652,40652,45928,44205,43432,43523,42508,44168,42523,43590,42811,
44758,43538,42043,42677,43967,43463,43655,42120,42363,43381,43366,43366,
42860,42464,44133,42367,44685,44926,43520,43349,43356,42131,43380,43380,
45305,45305,41923,44753,40535,43812,43174,43577,43373,43375,43054,44254,
43634,45842,43334,43857,43348,43988,46181,44707,43639,46178,42069,43813);
-- MIMIC2V30 URINE: 26843	subjects, 32488	icustays, 47532 max icustay_id
-- MIMIC2V30 URINE: 38878	subjects, 49033	icustays, 71458 max icustay_id






-- VENTILATED
select distinct itemid, label, value1uom,
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
select distinct itemid, label, 
  count(*) over (partition by itemid) num
from mimic2v30.procedureevents 
where 
lower(label) like '%intub%'
or 
lower(label) like '%ventilat%'
order by num desc;
/*
225792	Invasive Ventilation	8607
224385	Intubation	3494
101750	RESP TRACT INTUBAT NEC   	459
100883	CHOLEDOCHOHEPAT INTUBAT  	7
100230	MYRINGOTOMY W INTUBATION 	2
100186	NASOLAC DUCT INTUBAT     	1 
*/

with subjects as (
  select subject_id, hadm_id from mimic2v30.chartevents 
    where itemid in (40,722,39,720,224697,444,224685,38,224695,682,535,683,732,224686,
                      684,224684,543,721,227565,227566,224696,3681,224417,3689,141)
  union 
  select subject_id, hadm_id from mimic2v30.procedureevents where itemid in (225792,100230,100186,100883,224385,101750)
)
select count(distinct subject_id), count(distinct hadm_id), max(hadm_id) from subjects;
-- VENTILATED: 24038 subjects,	10208 icustays,	58847 max hadm_id




  


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
select count(distinct subject_id), count(distinct icustay_id), max(icustay_id) from mimic2v30.chartevents
where itemid in (219, 618, 614, 619, 615, 220210, 3603, 224689, 224690, 224688); 
-- RESP: 46769 subjects,	56737	icustays, 71458 max icustay_id



