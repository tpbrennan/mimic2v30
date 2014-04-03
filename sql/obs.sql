
with arterial_line as (
  select distinct fc.subject_id,
    fc.icustay_id,
    case 
      when lower(ce.label) like '%arterial blood%' then 'Y'
    else 'N'
    end as arterial_line
    from tbrennan.mimic3_adults fc
    join mimic2v30.chartevents ce 
      on fc.subject_id = ce.subject_id
      and fc.icustay_id = ce.subject_id
)
select * from arterial_line;