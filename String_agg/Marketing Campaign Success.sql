with first_purchase_details as (
select user_id
    , product_id
    , created_at
    , min(created_at) over (partition by user_id) as first_purchase_date
from marketing_campaign),
repeat_purchase_details as (
select user_id
    , string_agg(product_id::TEXT, ',' order by product_id) as products
from (select distinct user_id
    , product_id
    from first_purchase_details
    where created_at > first_purchase_date)
group by user_id),
first_day_purchases as (
select user_id
    , string_agg(product_id::TEXT, ',' order by product_id) as all_products
from (select distinct user_id
    , product_id
    from first_purchase_details
    where created_at = first_purchase_date)
group by user_id)
select count(distinct rpd.user_id) as user_count
from repeat_purchase_details rpd
join first_day_purchases fdp
on rpd.user_id = fdp.user_id
where fdp.all_products <> rpd.products
