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
-- 46804 subjects


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


-- VENTILATED
select * from mimic2v30.d_items 
where itemid in (1209,141,14138,1651,1660,1672,1864,1865,2049,
           2065,2069,224417,224684,224685,224686,224688,224695,224696,224697,
           227565,227566,2400,2402,2420,2534,2988,3003,3050,3083,3605,3681,3689,38,
           39,40,444,535,543,544,545,5593,619,639,654,681,682,683,684,720,721,722,732);
select itemid,count(*) no from mimic2v30.chartevents
  where itemid in (1209,141,14138,1651,1660,1672,1864,1865,2049,
           2065,2069,224417,224684,224685,224686,224688,224695,224696,224697,
           227565,227566,2400,2402,2420,2534,2988,3003,3050,3083,3605,3681,3689,38,
           39,40,444,535,543,544,545,5593,619,639,654,681,682,683,684,720,721,722,732)
  group by itemid
  order by no desc;
/*
40	514690
722	493412
39	493101
720	425004
224697	391088
444	386460
224685	383104
38	379012
224695	378947
619	254701
682	252045
535	238583
683	233230
732	223955
224686	220999
684	198718
224688	194280
224684	185373
543	177372
545	99835
721	80536
227565	77727
227566	77683
224696	69967
3681	48529
224417	38603
3605	34359
3689	31674
141	18449
*/
select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (40,722,39,720,224697,444,224685,38,224695,
619,682,535,683,732,224686,684,224688,224684,543,
545,721,227565,227566,224696,681,224417,605,3689,141);
-- 24,618 subjects



-- RESPIRATION RATE
select * from mimic2v30.d_items 
where itemid in (618, 614, 615, 653,1884, 220210, 3603, 224689, 224690);
/*
614	Resp Rate (Spont)
615	Resp Rate (Total)
618	Respiratory Rate
653	Spont. Resp. Rate
1884	Spont Resp rate
3603	Resp Rate
220210	Respiratory Rate
224689	Respiratory Rate (spontaneous)
224690	Respiratory Rate (Total)
*/
select * from mimic2v30.d_items where lower(label) like '%resp%rate%';

select itemid,count(*) no from mimic2v30.chartevents
where itemid in (618, 614, 615, 653,1884, 220210, 3603, 224689, 224690)
group by itemid;
/*
614	239893
615	421300
618	3433853
653	143
1884	23
3603	1677429
220210	2555576
224689	378496
224690	327087
*/

select count(distinct subject_id) from mimic2v30.chartevents 
where itemid in (618, 614, 615, 653,1884, 220210, 3603, 224689, 224690);
-- subjects
