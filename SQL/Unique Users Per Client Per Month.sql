select client_id
    , extract(month from time_id) as month
    , count(distinct user_id) as number_of_unique_users
from fact_events
group by client_id, extract(month from time_id)
