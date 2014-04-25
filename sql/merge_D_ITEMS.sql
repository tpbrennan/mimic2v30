/* This scripts is written to merge all d_...items tables in mimic2v26 and the parameters table in 
metavision (mv_adult_101212.parameters). The final table is called: D_ITEMS. 

Author: Lu Shen
Last updated: 10/29/13
*/
##############D_ITEM tables#####################################################################
select min(itemid), max(itemid) from mimic2v26.d_chartitems;  --1, 20009      
select min(itemid), max(itemid) from mimic2v26.d_ioitems;     --- -1, 6807   --->+40001
select min(itemid), max(itemid) from mimic2v26.d_meditems;    --- 1, 405     --->+30000
select min(itemid), max(itemid) from mimic2v26.d_labitems;    ---50001, 50735,  
select min(itemid), max(itemid) from mimic2v26.d_codeditems;  ---60001, 101885  
select distinct type from mimic2v26.d_codeditems;  --PROCEDURE, HFCA_DRG, MICROBIOLOGY
select min(itemid), max(itemid) from mimic2v26.d_codeditems where type='PROCEDURE'; --100001,101885
select min(itemid), max(itemid) from mimic2v26.d_codeditems where type='HFCA_DRG';  --60001, 61018
select min(itemid), max(itemid) from mimic2v26.d_codeditems where type='MICROBIOLOGY'; --70001, 90031
select distinct type from mimic2v26.d_codeditems; ---PROCEDURE, HFCA_DRG, MICROBIOLOGY
select min(itemid), max(itemid) from mimic2v26.d_demographicitems; ---200001,200088

desc mimic2v27.d_items
select * from mimic2v27.d_items;
select distinct type from mimic2v27.d_items;  --Demographic, MED, IO, PROCEDURE, HFCA_DRG, CHART, LAB, MICROBIOLOGY, ICD9
select min(itemid), max(itemid) from mimic2v27.d_items where type='CHART';  --1, 20009
select min(itemid), max(itemid) from mimic2v27.d_items where type='MED';    --30001, 30405
select min(itemid), max(itemid) from mimic2v27.d_items where type='IO';     --40000, 46808
select min(itemid), max(itemid) from mimic2v27.d_items where type='LAB';    --50001, 50735
select min(itemid), max(itemid) from mimic2v27.d_items where type='PROCEDURE'; --100002,101885
select min(itemid), max(itemid) from mimic2v27.d_items where type='HFCA_DRG';  --60001, 61018
select min(itemid), max(itemid) from mimic2v27.d_items where type='MICROBIOLOGY'; --70002,90031
select min(itemid), max(itemid) from mimic2v27.d_items where type='ICD9';         --110001,115675
select min(itemid), max(itemid) from mimic2v27.d_items where type='DEMOGRAPHIC';  --200001,200088

desc mimic2v27.d_items

 ################################mv_adult_101212.parameters table#########################################################
 select distinct p.parametertype, t.description, count(p.parameterid) 
 from mv_adult_101212.parameters p, mv_adult_101212.t_parameterstype t
 where p.parametertype=t.id
 group by p.parametertype, t.description
 order by p.parametertype;
 
 1	Numeric	647
2	Numeric with tag	40
3	Text	1309
4	Free text	463
5	Formula	292
6	Checkbox	307
7	Grouped	124
8	Solution	422
10	Ingredient	125
12	Process	125
15	Clinical event	1
16	Date time	142
17	Mapped	2
 
 #######################################################################################################
 --Step1: create the d_units table    
  drop table mv_units;
  create table mimic2v30.d_units as 
  select u.UNITID, u.UNITNAME, u.MULTIPLIER, u.ADDITION, u.ISBASEUNIT, g.ISRELATIONAL,g.ISTIME,g.ISVOLUME,g.GROUPNAME as CATEGORY
  from mv_adult_101212.units u, mv_adult_101212.unitgroups g
  where u.groupid=g.groupid;
  
  select count(*) from mimic2v30.d_units;  --183
  select * from mimic2v30.d_units;
  select count(*) from mv_adult_101212.units;  --183 
  
 --Step2: create an empty d_items table 
 
 drop table d_items;
 create table mimic2v30.d_items (
      ITEMID         NUMBER(7) NOT NULL,
      LABEL          VARCHAR2(100),
      ABBREVIATION   VARCHAR2(50),
      ORIGIN           VARCHAR2(12),
      CODE           VARCHAR2(10),
      CATEGORY       VARCHAR2(50),
      UNITID         NUMBER(5),
      UNITNAME       VARCHAR2(50),
      TYPE           VARCHAR2(20),
      DESCRIPTION    VARCHAR2(150),
      lownormalvalue float(126),
      highnormalvalue float(126),
      allergyaction  number(3),
      LOINC_CODE       varchar2(7),
      LOINC_DESCRIPTION varchar2(100)
      );


 --Step3: Insert mimic2v26 data into the new d_items table from mimic2v26.d_..items tables
  insert into mimic2v30.d_items (itemid, label, origin, category,description)
  select itemid, label, 'CHART' as origin, category, description
  from mimic2v26.d_chartitems;  ----4832 rows inserted
  
  insert into mimic2v30.d_items (itemid, label, origin, category)
  select itemid+40001, label, 'IO' as origin, category
  from mimic2v26.d_ioitems;   --6808 rows
 
  insert into mimic2v30.d_items (itemid, label, origin)
  select itemid+30000, label, 'MED' as origin
  from mimic2v26.d_meditems;  --405 rows inserted
  
  insert into mimic2v30.d_items (itemid, code, type, category, label, origin, description)
  select itemid, code, type, category,label, 'CODED' as origin, description
  from mimic2v26.d_codeditems;  --3339 rows inserted
  
  ###################Changes after labevents merging####################################################
  insert into d_items (itemid, label, type, category, origin, loinc_code, loinc_description)
  select itemid, test_name as label, fluid as type, category, 'LAB' as origin, loinc_code, loinc_description
  from mimic2v26.d_labitems;  --713 rows inserted
  
  ---Need to replace the old d_labitems table with the new d_labitems table
  desc merge30.d_labitems_new
  desc mimic2v30.d_items
  select * from merge30.d_labitems_new;
  
  select * from mimic2v30.d_items where origin='CODED';
  delete from mimic2v30.d_items where origin='LAB';
  
  alter table mimic2v30.d_items add (old_labitemid       number(7),
                                     old_test_name       varchar2(50),
                                     old_loinc_code      varchar2(7));
  alter table mimic2v30.d_items modify (type       varchar2(40));
                              
  insert into mimic2v30.d_items (itemid, label, type, category, origin, loinc_code, loinc_description, old_labitemid, old_test_name, old_loinc_code)
  select itemid, test_name as label, fluid as type, category, 'LAB' as origin, loinc_code, loinc_description,old_itemid as old_labitemid, old_test_name, old_loinc_code
  from merge30.d_labitems_new;   ----713 rows inserted
  
  
  ###############################################################################################
  insert into mimic2v30.d_items (itemid, label, category, origin)
  select itemid, label,  category, 'DEMOGRAPHIC' as origin
  from mimic2v26.d_demographicitems;   --88 rows inserted
  
  select count(*) from mimic2v30.d_items;  ---15472

  --insert into d_items (itemid, label, origin,code, category,description)
  --select itemid, label, type as origin, code, category, description
  --from mimic2v27.d_items;   --21858 rows inserted
   select * from d_items where origin='LAB'; ---16185   
----select count(*) from mimic2v27.d_items;  --21858
----select * from mimic2v27.d_items where type='ICD9';
 
--Step 4: insert data from metaVision into the new d_items table from mv_adult_101212.parameters, parameterscategories, units and t_parameterstype tables;
----------Note, all MV parameterids changed to 220000+ as the max(itemid) in mimic2v26 is at 210000 range.

select count(*) from mv_adult_101212.parameters;  -3999
select count(*) from mv_adult_101212.parameters where unitid is null;  --2348 rows have no unitid
select count(*) from mv_adult_101212.parameters where unitid is not null;  --1651 rows have unitid
  
insert into mimic2v30.d_items (itemid, label, abbreviation, origin, category,unitid, unitname, type, lownormalvalue,highnormalvalue,allergyaction)
select p.parameterid+220000 as itemid, p.parametername as label, 
         p.abbreviation, 'METAVISION' as origin, c.categoryname as category, 
         p.unitid, u.unitname, pt.description as type,
         p.lownormalvalue,
         p.highnormalvalue,
         p.allergyaction
  from mv_adult_101212.parameters p, 
       mv_adult_101212.parameterscategories c, 
       mv_adult_101212.units u, 
       mv_adult_101212.t_parameterstype pt
  where c.categoryid=p.categoryid 
  and p.parametertype=pt.id
  and p.unitid=u.unitid(+);   ---3,999 rows inserted
  
select count(*) from mimic2v30.d_items where origin='METAVISION' and unitid is null;  ---2348
select count(*) from mimic2v30.d_items where origin='METAVISION' and unitid is not null;  ---1651

select count(*) from mimic2v30.d_items;   ---19471
select * from mimic2v30.d_items where itemid>220000;

####################################################################################
 