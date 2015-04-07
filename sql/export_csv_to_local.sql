--spool "/home/mornin/mimic2v30b/additives.csv"
--
----select /*csv*/ subject_id, icustay_id, to_char(charttime, 'dd-mon-yyyy hh24:mi:ss tzr') as charttime from additives where rownum<10;
--
--select /*csv*/
--SUBJECT_ID
--,ICUSTAY_ID
--,ORDERID
--,ITEMID
--,LABEL
--,IOITEMID
--,IOITEMLABEL
--,to_char(charttime, 'dd-mon-yyyy hh24:mi:ss tzr') as charttime 
--,to_char(starttime, 'dd-mon-yyyy hh24:mi:ss tzr') as starttime
--,to_char(ENDTIME, 'dd-mon-yyyy hh24:mi:ss tzr') as ENDTIME
--,ELEMID
--,CGID
--,CUID
--,VALUE
--,UOM
--,IOITEMVALUE
--,IOITEMUOM
--,SOURCE_FLG
--from additives;
--
--spool off;


spool "/home/mornin/mimic2v30b/admissions.csv"

select /*csv*/
HADM_ID
,SUBJECT_ID
, to_char(ADMIT_DT, 'dd-mon-yyyy') as ADMIT_DT 
,to_char(ADMIT_TIME, 'dd-mon-yyyy hh24:mi:ss tzr') as ADMIT_TIME 
, to_char(DISCH_DT, 'dd-mon-yyyy') as DISCH_DT 
,to_char(DISCH_TIME, 'dd-mon-yyyy hh24:mi:ss tzr') as DISCH_TIME 
,ADM_DIAGNOSIS
,FIRST_SERVICE
,LAST_SERVICE
from admissions;

spool off;
