with user_event_percentages as (
select user_id
    , sum(case when event_type in ('video call received', 'video call sent', 'voice call received', 'voice call sent') then 1 else 0 end)*1.00/count(*) as event_perc
from fact_events 
group by user_id
)
select fe.client_id
from fact_events as fe
join user_event_percentages as uep
on fe.user_id = uep.user_id
where uep.event_perc >= 0.5
group by fe.client_id
order by count(distinct uep.user_id) desc
offset 0 rows
fetch next 1 rows only


