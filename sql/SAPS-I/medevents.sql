with vasopressors as (
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
