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
select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (220045, 211); -- 46804 subjects


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
select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (676, 677, 678, 679, 3652, 3655, 226329, 223761, 223762); -- 44837 subjects


-- SYSABP
select distinct itemid, label,
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
select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (51, 455, 225309, 220179, 220050, 227243, 224167); -- 39227 subjects


-- HCT
select distinct itemid, label,
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
select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (813, 220545, 226540, 3761); -- 45067 subjects


-- WBC
select distinct itemid, label,
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
select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (220546, 1542, 1127, 861, 4200); --43965 subjects

-- GCS
select distinct itemid, label,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%gcs%' 
or 
lower(label) like '%glasgow%' 
order by num desc;
/*
198	GCS Total	960006
226755	GcsApacheIIScore	9
227013	GcsScore_ApacheIV	7
*/
select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (227013,198,226755); --23614 subjects


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
select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (807, 811, 1529, 225664, 220621, 226537, 3745, 3744, 1310, 1455, 2338); -- 41617 subjects


-- HCO3
select distinct itemid, label,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%bicarbonate%' 
or 
lower(label) like '%bicarb%' 
or 
lower(label) like '%hco3%' 
order by num desc;
/*
227443	HCO3 (serum)	134238
*/
select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (227443); -- 17141 subjects


-- POTASSIUM
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
select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (829, 1535, 3792, 3725, 4194, 227442, 227464); -- 41486 subjects

-- SODIUM
select distinct itemid, label,
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
select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (837, 1536, 3726, 3803, 220645, 226534); --  41382 subjects

-- BUN
select distinct itemid, label,
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
select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (781, 1162, 3737, 225624); -- 39379 subjects




-- CREATININE
select distinct itemid, label,
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
select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (791, 1525, 3750, 220615); -- 39374 subjects



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
select count(distinct subject_id) from mimic2v30.ioevents 
where itemid in ( 40056, 43176,40070,40095,40716,40474,40086,40058,40057,
40406	,40429	,40097	,43172	,43374, 40652	,45928	,43432	,
43523	,42508	,43590	,43538	,43967	,43463	); -- 26483 subjects


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

select distinct label from mimic2v30.chartevents
where itemid in (220210,618,653,3603,219,1635,8113,1884,615)