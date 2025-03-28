select video_id
    , count(distinct coalesce(user_firstname,'') || ' ' || coalesce(user_lastname,'')) as unique_user_flags
from user_flags
where flag_id is not null
group by video_id
