with vote_allocation as (
select candidate
    , voter
    , 1.00/(count(*) over (partition by voter)) as vote_ratio
from voting_results
), vote_calculation as (
select candidate 
    , sum(vote_ratio) as candidate_votes
    , dense_rank() over (order by sum(vote_ratio) desc) as rnk
from vote_allocation
where candidate is not null
group by candidate
)
select candidate
from vote_calculation
where rnk = 1 
