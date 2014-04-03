create table RRT_COHORT as 

  select distinct icustay_id,
      case 
        when (   lower(n.text) LIKE '% dialysis %'
              or lower(n.text) LIKE '% hemodialysis %'
              or lower(n.text) LIKE '% ihd %'
              or lower(n.text) LIKE '% crrt %'
              or lower(n.text) LIKE '% cvvh %'
              or lower(n.text) LIKE '% cvvhd %'
              or lower(n.text) LIKE '% esrd %' ) then 1
          else 0
      end as rrt
    from mimic2v26.noteevents n;
      