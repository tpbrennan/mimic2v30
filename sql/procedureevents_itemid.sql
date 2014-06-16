-- INTUBATED
select * from mimic2v30.d_items where itemid in (100883,101750);
/*
100883 CHOLEDOCHOHEPAT INTUBAT  
101750 RESP TRACT INTUBAT NEC   
*/
select itemid,code,description from mimic2v30.d_items where lower(description) like '%intubat%'
  and type='PROCEDURE';
/*
100186	0944 	NASOLAC DUCT INTUBAT     
100230	2001 	MYRINGOTOMY W INTUBATION 
101750	9605 	RESP TRACT INTUBAT NEC   
100883	5143 	CHOLEDOCHOHEPAT INTUBAT  
*/
select count(distinct subject_id) from mimic2v30.procedureevents 
  where itemid in (100186,100230,101750,100883);
-- 351 subjects