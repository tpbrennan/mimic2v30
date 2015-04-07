-- HCT
select distinct itemid, test_name from mimic2v30.labevents 
  where lower(test_name) like '%hct%'
  order by itemid;

select distinct itemid, label from mimic2v30.chartevents 
  where lower(label) like '%hct%'
  order by itemid;

select distinct l.itemid, dl.test_name 
  from mimic2v26.labevents l
  join mimic2v26.d_labitems dl
    on dl.itemid = l.itemid
  where lower(dl.test_name) like '%hct%'
  order by itemid;

--WBC
select distinct itemid, test_name from mimic2v30.labevents 
  where lower(test_name) like '%wbc%'
  order by itemid;

select distinct itemid, label from mimic2v30.chartevents 
  where lower(label) like '%wbc%'
  order by itemid;

select distinct l.itemid, dl.test_name 
  from mimic2v26.labevents l
  join mimic2v26.d_labitems dl
    on dl.itemid = l.itemid
  where lower(dl.test_name) like '%wbc%'
  order by itemid;

select count(distinct subject_id) from mimic2v30.chartevents
  where lower(label) like '%glucose%'
   and icustay_id > 48000;

select count (distinct icustay_id) from tbrennan.gcs;
select count (distinct subject_id) from tbrennan.gcs;
select * from tbrennan.old_gcs;