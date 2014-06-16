select count(*) from tbrennan.mimic3_adults;

-- HEART RATE
select * from mimic2v30.d_items where itemid in (220045, 211);
select * from mimic2v30.d_items where lower(label) like '%heart rate%' or lower(unitname) like '%bpm%';
select itemid,count(*) 
  from mimic2v30.chartevents c
  where itemid in (220045, 211)
  group by itemid;
/*
211	5231565
220045	2579620
*/
select count(distinct subject_id) from mimic2v30.chartevents c 
  where itemid in (220045, 211);
--


-- TEMPARATURE
select * from mimic2v30.d_items where itemid in (676, 677, 678, 679, 3652, 3655, 226329, 223761, 223762, 227054);
select * from mimic2v30.d_items where lower(label) like '%temp%';
select itemid,count(*) 
  from mimic2v30.chartevents c
  where itemid in (676, 677, 678, 679, 3652, 3655, 226329, 223761, 223762, 227054)
  group by itemid;
/*
676	381239
677	783760
678	785285
679	378707
3652	462116
3655	533228
223761	500128
223762	70207
226329	60803
227054	7
*/
select count(distinct subject_id) from mimic2v30.chartevents c 
  where itemid in 
(676, 677, 678, 679, 3652, 3655, 226329, 223761, 223762, 227054);
-- 44 837 subjects




--GLASGOW COMA SCORE

select * from mimic2v30.d_items where itemid in (198,223900,223901,220739,226755,
226756,226757,226758,228112,227011,227012,227013,227014);
select * from mimic2v30.d_items where lower(label) like '%gcs%';
/*
198	GCS Total
223900	GCS - Verbal Response
223901	GCS - Motor Response
220739	GCS - Eye Opening
226755	GcsApacheIIScore
226756	GCSEyeApacheIIValue
226757	GCSMotorApacheIIValue
226758	GCSVerbalApacheIIValue
228112	GCSVerbalApacheIIValue (intubated)
227011	GCSEye_ApacheIV
227012	GCSMotor_ApacheIV
227013	GcsScore_ApacheIV
227014	GCSVerbal_ApacheIV
*/
select itemid,count(*) 
  from mimic2v30.chartevents c
  where itemid in (198,223900,223901,220739,226755,
226756,226757,226758,228112,227011,227012,227013,227014)
  group by itemid;
/*
198	960006
226755	9
227013	7
*/
select count(distinct subject_id) from mimic2v30.chartevents c 
  where itemid in 
  (198,223900,223901,220739,226755,
226756,226757,226758,228112,227011,227012,227013,227014);
-- 23614 subjects



--HCT
select * from mimic2v30.d_items where itemid in (50383,51243,50029,50809);

