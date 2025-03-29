with users_ranked as (
select (uf.user_firstname || ' ' || uf.user_lastname) as full_name
    , count(distinct uf.video_id) as video_count
    , dense_rank() over (order by count(distinct uf.video_id) desc) as rnk
from user_flags uf
join flag_review fr
on uf.flag_id = fr.flag_id
where fr.reviewed_outcome = 'APPROVED'
group by (uf.user_firstname || ' ' || uf.user_lastname)
)
select full_name
from users_ranked 
where rnk = 1
