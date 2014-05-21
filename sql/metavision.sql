select distinct test_name from mimic2v26.d_labitems where itemid in (50803,50022,50172,50025);

select parameterid, parametername from mv_adult_101212.parameters where lower(parametername) like '%gcs%';

select * from mv_adult_101212.signals where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112);

with tables as (
  select distinct table_name,
  case
    when column_name = 'PARAMETERID' then 1
  end as pmid,
  case
    when column_name = 'PATIENTID' then 1
  end as ptid
  from all_tab_columns 
  where owner = 'MV_ADULT_101212'
)
--select * from tables;

, pidtables as (
  select distinct table_name,
    sum(pmid) over (partition by table_name) pmid,
    sum(ptid) over (partition by table_name) ptid
  from tables
)
select * from pidtables where pmid = 1 and ptid = 1;


select 'PREADMISSIONMEDICATIONS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.PREADMISSIONMEDICATIONS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'SIGNALS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.SIGNALS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'QUERYTIMESPANS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.QUERYTIMESPANS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'SIGNALSLOG' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.SIGNALSLOG 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'MATERIALSIGNALSLOG' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.MATERIALSIGNALSLOG 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'MESSENGER' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.MESSENGER 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'NEWLABRESULTS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.NEWLABRESULTS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'QUERYSTATRESULTS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.QUERYSTATRESULTS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'EVENTSIGNALS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.EVENTSIGNALS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'IMAGESIGNALS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.IMAGESIGNALS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'MATERIALSIGNALS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.MATERIALSIGNALS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'DATETIMESIGNALS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.DATETIMESIGNALS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'PATIENTNORMALVALUES' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.PATIENTNORMALVALUES 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'PATIENTALLERGIES' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.PATIENTALLERGIES 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'QUERYCONDITIONALSPANS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.QUERYCONDITIONALSPANS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'DISCHARGELABPARAMETERS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.DISCHARGELABPARAMETERS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'FREETEXTSIGNALS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.FREETEXTSIGNALS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'RANGESIGNALS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.RANGESIGNALS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'LABPARAMETERS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.LABPARAMETERS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'MAPPEDSIGNALS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.MAPPEDSIGNALS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112)
union
select 'TEXTSIGNALS' table_name, count(distinct patientid) no_subjects 
from MV_ADULT_101212.TEXTSIGNALS 
where parameterid in (739,3900,3901,6755,6756,6757,6758,7011,7012,7013,7014,8112);

