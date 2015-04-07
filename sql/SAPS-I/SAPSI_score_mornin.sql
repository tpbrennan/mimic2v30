/*
  sapsi_score_mornin.sql

  Created on   : Mar 2015 by Mornin Feng
  Last updated :
     $Author: Mornin Feng $
     $Date: 2015 March 10 $
     $Rev: $

 Valid for MIMIC II database schema version 3.0.
 Must run on brp2 server

To get the worst score for each variable then sum them up for the total score

*/
drop table lcp_daily_sapsi;
create table lcp_daily_sapsi as
With minmax as
(select subject_id
, icustay_id
, icustay_day
, category
--, min(valuenum) as min_value
--, max(valuenum) as max_value
, GET_SAPS_FOR_PARAMETER(category, min(valuenum)) as min_value_score
, GET_SAPS_FOR_PARAMETER(category, max(valuenum)) as max_value_score
from mornin.v30_sapsi_raw_data
group by subject_id, icustay_id, icustay_day, category
order by 1,2,3
)

--select * from minmax;

, score as
(select subject_id
, icustay_id
, icustay_day
, category
, case when min_value_score>=max_value_score then min_value_score
      else max_value_score
    end as score
from minmax
)

--select * from score;

, score_pivot as(
select * from (
select subject_id, icustay_id, icustay_day, category, score
from score 
--where subject_id<100 
)
pivot
(max(score)
for category in ('AGE' as age_score
,'BUN' as  bun_score
,'CREATININE' as creatinine_score
,'GCS' as gcs_score
,'GLUCOSE' as glucose_score
,'HCT' as hct_score
,'HR' as hr_score
,'POTASSIUM' as potassium_score
,'SODIUM' as sodium_score
,'SPONTANEOUS_RESP' as rr_score
,'SYSABP' as sysabp_score
,'TEMPERATURE' as  temperature_score
,'URINE' as urine_score
,'VENTILATION' as ventilation_score
,'WBC' as wbc_score
, 'HCO3' as hco3_score
)
))

--select * from score_pivot;

, score_final as
(select subject_id
, icustay_id
, icustay_day
, age_score
, bun_score
--, creatinine_score
, gcs_score
, glucose_score
, hct_score
, hr_score
, potassium_score
, sodium_score
--, ventilation_score
--, rr_score
, case when ventilation_score>0 then ventilation_score else rr_score  end as rr_score
, sysabp_score
, temperature_score
, urine_score
, wbc_score
, hco3_score
, case when ventilation_score>0 
    then age_score+bun_score+gcs_score+glucose_score+hct_score+hr_score+potassium_score+sodium_score+ventilation_score+sysabp_score+temperature_score+urine_score+wbc_score+hco3_score
  else age_score+bun_score+gcs_score+glucose_score+hct_score+hr_score+potassium_score+sodium_score+rr_score+sysabp_score+temperature_score+urine_score+wbc_score+hco3_score
  end as sapsi_score
from score_pivot
)

select * from score_final;

