WITH user_activity AS (
    -- Extract unique user activity per account and month
    SELECT 
        account_id,
        user_id,
        TO_CHAR(record_date, 'YYYY-MM') AS record_month
    FROM sf_events
    GROUP BY account_id, user_id, record_month
), retained_users AS (
    -- Self-join to check if a user has activity in any future month
    SELECT 
        a.account_id,
        a.user_id,
        a.record_month,
        CASE 
            WHEN COUNT(b.user_id) > 0 THEN 1 ELSE 0 
        END AS is_retained
    FROM user_activity a
    LEFT JOIN user_activity b
        ON a.user_id = b.user_id 
        AND a.account_id = b.account_id
        AND b.record_month > a.record_month  -- Future activity check
    GROUP BY a.account_id, a.user_id, a.record_month
), retention_rates AS (
    -- Compute retention rate per account and month (filtering happens here)
    SELECT 
        account_id,
        record_month,
        SUM(is_retained) * 1.00 / COUNT(DISTINCT user_id) AS retention_rate
    FROM retained_users
    WHERE record_month IN ('2020-12', '2021-01')  -- Only compute retention for these months
    GROUP BY account_id, record_month
), jan_dec_ratio AS (
    -- Get retention rates for Dec 2020 and Jan 2021
    SELECT 
        account_id,
        MAX(CASE WHEN record_month = '2021-01' THEN retention_rate END) AS jan_retention,
        MAX(CASE WHEN record_month = '2020-12' THEN retention_rate END) AS dec_retention
    FROM retention_rates
    GROUP BY account_id
)
SELECT 
    account_id,
    COALESCE(jan_retention / NULLIF(dec_retention, 0), 0) AS Jan_Dec_Ratio
FROM jan_dec_ratio;
