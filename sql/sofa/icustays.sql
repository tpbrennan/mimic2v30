CREATE TABLE ICUSTAYS AS
With icustays as (
  SELECT
    icue.subject_id,
    a.hadm_id,
    icue.icustay_id,
    icue.intime icustay_intime,
    icue.outtime icustay_outtime
  FROM mimic2v30.icustayevents icue,
       mimic2v30.d_patients p,
       mimic2v30.admissions a
  WHERE months_between(icue.intime, p.dob) / 12 >= 15
    AND p.subject_id = icue.subject_id
    AND a.subject_id = p.subject_id
    AND icue.intime >= a.admit_dt
    AND icue.outtime <= a.disch_dt + 1
    AND a.hadm_id is not null
    --and icue.subject_id between 1 and 50
)

SELECT * FROM ICUSTAYS;