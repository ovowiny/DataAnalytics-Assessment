SELECT
    frequency_category,                           -- "High", "Medium", or "Low" frequency group
    COUNT(distinct user_id) AS customer_count,             -- Number of users in each category
    ROUND(AVG(monthly_txn_count), 2) AS avg_transactions_per_month  -- Avg monthly transactions per user
FROM (
    SELECT uc.id AS user_id,  -- Unique identifier for each user
        -- Calculate average transactions per active month (only for non-zero transactions)
        COUNT(ss.id) * 1.0 / COUNT(DISTINCT DATE_FORMAT(ss.created_on, '%Y-%m')) AS monthly_txn_count,

        -- Categorize users by their monthly transaction activity
        CASE WHEN COUNT(ss.id) / COUNT(DISTINCT DATE_FORMAT(ss.created_on, '%Y-%m')) >= 10 THEN 'High Frequency'
            WHEN COUNT(ss.id) / COUNT(DISTINCT DATE_FORMAT(ss.created_on, '%Y-%m')) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency' END AS frequency_category

    FROM users_customuser uc
    JOIN savings_savingsaccount ss ON uc.id = ss.owner_id
    WHERE ss.confirmed_amount > 0      -- Consider only confirmed transactions with a non-zero amount
    GROUP BY uc.id
) AS user_txn_summary

GROUP BY frequency_category  		-- Group by frequency to get number of users and their average activity
ORDER BY avg_transactions_per_month DESC; -- Order results from highest to lowest average monthly transaction rate
