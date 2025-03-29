with product_ranked as (
select product_id
    , sum(cost_in_dollars*units_sold) as total_revenue
    , row_number() over (order by sum(cost_in_dollars*units_sold) desc) as rnk 
from online_orders
where extract(month from date_sold) between 1 and 6
    and extract(year from date_sold) = 2022
group by product_id)
select product_id
    , total_revenue
from product_ranked
where rnk <6
