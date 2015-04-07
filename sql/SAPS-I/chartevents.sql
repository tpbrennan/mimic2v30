
with charted as (
  select distinct fc.subject_id,
    fc.icustay_id,
    case 
      when lower(ce.label) like '%arterial blood%' then 'Y'
    else 'N'
    end as arterial_line,
    case 
      when lower(ce.label) like '%arterial blood%' then 'Y'
    else 'N'
    end as swanpap
    from tbrennan.mimic3_adults fc
    join mimic2v30.chartevents ce 
      on fc.subject_id = ce.subject_id
      and fc.icustay_id = ce.icustay_id
)
--select * from arterial_line;

, procedures as (
  select distinct fc.subject_id, 
    fc.icustay_id,
    case 
      when lower(pe.label) like 'invasive ventilation' then 'Y'
    else 'N'
    end as ventilated
    from tbrennan.mimic3_adults fc
    join mimic2v30.procedureevents pe 
      on fc.subject_id = pe.subject_id
      and fc.hadm_id = pe.hadm_id
)
--select * from procedures;

, vasopressors as (
  select distinct fc.subject_id, fc.icustay_id,
    case 
      when lower(me.label) like '%dobutamine%' then 'Y' 
      when lower(me.label) like '%dopamine%' then 'Y'
      when lower(me.label) like '%epinephrine%' then 'Y'
      when lower(me.label) like '%levophed%' then 'Y'
      when lower(me.label) like '%milrinone%' then 'Y'
      when lower(me.label) like '%neosynephrine%' then 'Y'
    else 'N'
    end as vasopressors
  from tbrennan.mimic3_adults fc
  join mimic2v30.medevents me
    on fc.subject_id = me.subject_id 
    and fc.icustay_id = me.icustay_id
)
select * from vasopressors;

