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
--220045	Heart Rate	2579620
--211	Heart Rate	5231565

-- TEMPARATURE
select distinct itemid, label,
  count(*) over (partition by itemid) num 
  from mimic2v30.chartevents 
  where itemid in (676, 677, 678, 679, 227054, 223762, 223761)
  order by num desc;
  
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


-- SYSABP
select distinct itemid, label,
  count(*) over (partition by itemid) num 
  from mimic2v30.chartevents 
  where itemid in (51, 455, 225309)
  order by num desc;
  
select distinct itemid, label,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%systolic%' 
or 
lower(label) like '%blood%pressure%'
or 
lower(label) like '%bp%'
order by num;

-- WBC
select distinct itemid, label,
  count(*) over (partition by itemid) num from mimic2v30.chartevents 
where 
lower(label) like '%wbc%' 
or 
lower(label) like '%white%blood%cell%' 
order by num desc;
--4200	WBC 4.0-11.0	8919
--220546	WBC	117126
--1542	WBC	140123
--1127	WBC   (4-11,000)	171685
--861	WBC (4-11,000)	180449



