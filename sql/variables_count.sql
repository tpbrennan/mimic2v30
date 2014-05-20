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
226329	Blood Temperature CCO (C)	60803 ?
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
where itemid in (676, 677, 678, 679, 227054, 223762, 223761); -- 39076 subjects


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
where itemid in (807, 811, 1529, 225664, 220621, 226537, 3745, 3744, 1310, 1455, 2338); -- ** subjects


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
*/
select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (); -- subjects
