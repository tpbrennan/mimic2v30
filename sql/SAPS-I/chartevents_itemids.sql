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
-- 46,769 subjects


--URINE
select * from mimic2v30.d_items 
where itemid in (40056,226559,43176,40070,40095,40066,40062,
40716,40474,40086,40058,40057,227489,40406,40289,40429,226631,40097,43172,
43374,40652,40652,45928,44205,43432,43523,42508,44168,42523,43590,42811,
44758,43538,42043,42677,43967,43463,43655,42120,42363,43381,43366,43366,
42860,42464,44133,42367,44685,44926,43520,43349,43356,42131,43380,43380,
45305,45305,41923,44753,40535,43812,43174,43577,43373,43375,43054,44254,
43634,45842,43334,43857,43348,43988,46181,44707,43639,46178,42069,43813);
select * from mimic2v30.d_items where lower(label) like '%urine%out%' or lower(label) like '%foley%';
/*
3216	NS FLUSH FOLEY
6196	IRRIG FOLEY 50ML NS
7672	Foley
40716	Urine Out Suprapubic
40751	foley irrigation
42043	ANGIO URINE OUT
42069	angio Urine output
40027	Urine Out Total
40057	Urine Out Lt Nephrostomy
40086	Urine Out Incontinent
40095	Urine Out Condom Cath
40097	Urine Out Ureteral Stent #1
41511	TOTAL OUT FOLEY BAG
40406	Urine Out Other
40429	Urine Out Straight Cath
42394	CC6 URINE OUTPUT
43166	Urine Output Total
43349	urine output/kg
43366	urine output/kg/hr
42112	ANGIO FOLEY URINE
42120	urine output-angio
41858	urine out in er
41987	PCU URINE OUTPUT
41315	NS foley Irragation
42363	CATH LAB URINE OUTPT
43670	ER URINE OUT
43812	urine out: cc/k/hr
43813	urine out:cc/k/hr
43932	Floor urine out
43967	real urine output
44326	ED URINE OUTPUT
42677	ANGIO URINE OUTPUT
42811	angio urine out
(43373	24hr urine output)
43381	urine outpt cc/kg/hr
44542	True Urine Output
44707	urine output
44912	urine output farr-10
44758	Foley Cath
44825	EW urine output
45305	Urine output cc/k/hr
45968	foley
46579	URINE OUTPUT-ER
44104	ER urine out
44133	Procedure urine out
44168	foley flush
44205	Foley Catheter
44238	E.R. urine out
46142	Foley flushed
46178	URINE OUT-ANGIO
42893	EW URINE OUT
43054	URINE OUT
44685	floor urine out
44835	er urine out
43639	urine output cc/k/hr
40056	Urine Out Foley
40058	Urine Out Rt Nephrostomy
40070	Urine Out Void
42367	angio urine output
45992	ew-urine output
43883	FoleyIrrigant
43988	urine out or
46615	urine output floor
46659	ED Urine output
46749	Cath Lab Urine Out
40652	Urine Out Ureteral Stent #2
45805	URINE OUTPUT-E.D.
42523	FOLEY FLUSH
42593	VICU URINE OUT
42667	E.R. URINE OUT
42695	ER URINE OUTPUT
42766	FARR 6 URINE OUT
42018	FARR 7 URINE OUTPUT
41236	foley irrigant
41255	URINE OUTPUT VICU
40474	Urine Out IleoConduit
44254	Urine out angio
46181	urine out-angio
46424	ed foley
45416	ED Urine OUT
226559	Foley
226566	Urine and GU Irrigant Out
226568	Total Urine Output
226406	TOTAL NET URINE OUTPUT
226641	Interval Urine Output
226683	TOTAL FOLEY
227082	INTERVAL NET URINE OUTPUT
227085	TOTAL URINE AND GU IRRIGANT OUT
227489	GU Irrigant/Urine Volume Out
227490	INTERVAL NET GU IRRIGANT/URINE OUTPUT
227491	TOTAL NET GU IRRIGANT/URINE OUTPUT
*/
select distinct itemid,label from mimic2v30.ioevents where lower(label) like '%urine%out%' or lower(label) like '%foley%';
/*
40058	Urine Out Rt Nephrostomy
40716	Urine Out Suprapubic
40429	Urine Out Straight Cath
42893	EW URINE OUT
43813	urine out:cc/k/hr
43883	FoleyIrrigant
43967	real urine output
44758	Foley Cath
44912	urine output farr-10
46424	ed foley
40406	Urine Out Other
41858	urine out in er
42523	FOLEY FLUSH
43054	URINE OUT
43349	urine output/kg
43366	urine output/kg/hr
43812	urine out: cc/k/hr
43932	Floor urine out
44104	ER urine out
44133	Procedure urine out
44238	E.R. urine out
44835	er urine out
46178	URINE OUT-ANGIO
42112	ANGIO FOLEY URINE
43373	24hr urine output
44254	Urine out angio
45805	URINE OUTPUT-E.D.
45992	ew-urine output
40056	Urine Out Foley
40086	Urine Out Incontinent
40097	Urine Out Ureteral Stent #1
40652	Urine Out Ureteral Stent #2
42367	angio urine output
42677	ANGIO URINE OUTPUT
43381	urine outpt cc/kg/hr
45416	ED Urine OUT
45968	foley
42695	ER URINE OUTPUT
40095	Urine Out Condom Cath
40057	Urine Out Lt Nephrostomy
40751	foley irrigation
41511	TOTAL OUT FOLEY BAG
42766	FARR 6 URINE OUT
44685	floor urine out
46181	urine out-angio
46749	Cath Lab Urine Out
226559	Foley
227489	GU Irrigant/Urine Volume Out
40070	Urine Out Void
42593	VICU URINE OUT
46659	ED Urine output
46579	URINE OUTPUT-ER
40474	Urine Out IleoConduit
42043	ANGIO URINE OUT
42667	E.R. URINE OUT
42811	angio urine out
44326	ED URINE OUTPUT
44825	EW urine output
44707	urine output
45305	Urine output cc/k/hr
42120	urine output-angio
42069	angio Urine output
42363	CATH LAB URINE OUTPT
43639	urine output cc/k/hr
43988	urine out or
44168	foley flush
44205	Foley Catheter
*/
select itemid,count(*) no from mimic2v30.ioevents
where itemid in (226559,227489,40056,40057,
40058,40070,40086,40095,40097,40406,40429,40474,40652,
40716,40751,41511,41858,42043,42069,42112,42120,42363,
42367,42523,42593,42667,42677,42695,42766,42811,42893,
43054,43349,43366,43373,43381,43639,43812,43813,43883,
43932,43967,43988,44104,44133,44168,44205,44238,44254,
44326,44685,44707,44758,44825,44835,44912,45305,45416,
45805,45968,45992,46178,46181,46424,46579,46659,46749)
group by itemid
order by no desc;
/* CHARTEVENTS
227489	3094
226559	1139129
*/
/* IOEVENTS
40056	1938312
226559	890514
40070	70733
40095	10240
40716	6985
40474	4827
40086	2934
40058	2797
40057	2729
227489	2111
40406	1829
40429	723
40097	418
40652	90
45968	38
44205	34
44168	21
42523	13
*/

select count(distinct subject_id) from mimic2v30.ioevents 
where itemid in (40056,226559,40070,40095,40716,40474,
40086,40058,40057,227489,40406,40429,40097,40652,45968,
44205,44168,42523);
-- CHARTEVENTS 15045  subjects
-- IOEVENTS 35319

