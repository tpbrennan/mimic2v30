

--HCT
select * from mimic2v30.d_items where itemid in (51243,50809);
/*
50809	HEMATOCRIT, CALCULATED
51243	HEMATOCRIT
*/
select * from mimic2v30.d_items where lower(label) like '%hematocrit%' and origin ='LAB' and type = 'BLOOD';
select count(distinct subject_id) from mimic2v30.labevents c 
  where itemid in (51243,50809);
-- 44669 subjects


-- WBC
select * from mimic2v30.d_items where itemid in (51327,51326);
/*
51326	WBC COUNT
51327	WHITE BLOOD CELLS
*/
select * from mimic2v30.d_items where (lower(label) like '%wbc%' or lower(label) like '%white blood cells%') 
  and origin ='LAB' and type = 'BLOOD';
select count(distinct subject_id) from mimic2v30.labevents c 
  where itemid in (51327,51326);
-- 44582 subjects


-- BLOOD GLUCOSE
select * from mimic2v30.d_items where itemid in (50936);
select * from mimic2v30.d_items where lower(label) like '%glucose%'
  and origin ='LAB' and type = 'BLOOD';
select count(distinct subject_id) from mimic2v30.labevents c 
  where itemid in (50936);
-- 38319 subjects

-- BICARDBONATE
select * from mimic2v30.d_items where itemid in 
(50886,50803,50802);
select * from mimic2v30.d_items where (lower(label) like '%bicarbonate%' or lower(label) like '%total co2%')
  and origin ='LAB' and type = 'BLOOD';
select count(distinct subject_id) from mimic2v30.labevents c 
  where itemid in (50886,50803,50802);
-- 40,922 subjects

-- POTASSIUM
select * from mimic2v30.d_items where itemid in 
(50976,50821);
select * from mimic2v30.d_items where lower(label) like '%potassium%'
  and origin ='LAB' and type = 'BLOOD';
/*
50976	POTASSIUM
50821	POTASSIUM, WHOLE BLOOD
*/
select itemid,count(*) from mimic2v30.labevents 
  where itemid in (50976,50821) group by itemid;
select count(distinct subject_id) from mimic2v30.labevents c 
  where itemid in (50976,50821);
-- 40,639 subjects


-- SODIUM
select * from mimic2v30.d_items where itemid in (50989);
select * from mimic2v30.d_items where lower(label) like '%sodium%'
  and origin ='LAB' and type = 'BLOOD';
/*
50989	SODIUM
50823	SODIUM, WHOLE BLOOD
*/
select itemid,count(*) from mimic2v30.labevents 
  where itemid in (50989,50823) group by itemid;
select count(distinct subject_id) from mimic2v30.labevents c 
  where itemid in (50989,50823);
-- 40,633 subjects


-- BUN
select * from mimic2v30.d_items where itemid in 
(51011);
select * from mimic2v30.d_items where lower(label) like '%urea%'
  and origin ='LAB' and type = 'BLOOD';
/*
51011	UREA NITROGEN
*/
select itemid,count(*) from mimic2v30.labevents 
  where itemid in (51011) group by itemid;
select count(distinct subject_id) from mimic2v30.labevents c 
  where itemid in (51011);
-- 38,658 subjects

-- CREATININE
select * from mimic2v30.d_items where itemid in 
(50916);
select * from mimic2v30.d_items where lower(label) like '%creatinine%'
  and origin ='LAB' and type = 'BLOOD';
/*
50916	CREATININE
*/
select itemid,count(*) from mimic2v30.labevents 
  where itemid in (50916) group by itemid;
select count(distinct subject_id) from mimic2v30.labevents c 
  where itemid in (50916);
-- 38,648 subjects

