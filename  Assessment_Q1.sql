
SELECT uc.id AS owner_id,
	CONCAT(first_name, ' ', last_name) AS name,  -- Combined full name
    
    -- Count of regular savings plans for the user
    COUNT(CASE WHEN is_regular_savings = 1 THEN 1 ELSE NULL END) AS savings_count,
    
    -- Count of investment (fund) plans for the user
    COUNT(CASE WHEN is_a_fund = 1 THEN 1 ELSE NULL END) AS investment_count,
    
    -- Total confirmed amount from savings accounts (converted from kobo to naira, rounded to 2 decimals)
    ROUND(SUM(confirmed_amount) / 100, 2) AS total_deposits
    
FROM users_customuser uc
JOIN plans_plan pp ON uc.id = pp.owner_id
-- Left join with savings_savingsaccount to get related savings account info (if any)
LEFT JOIN savings_savingsaccount ss ON uc.id = ss.owner_id AND pp.id = ss.plan_id
GROUP BY uc.id, first_name, last_name
-- Filter to only users having at least one savings and one investment plan
HAVING COUNT(CASE WHEN is_regular_savings = 1 THEN 1 ELSE NULL END) <> 0
   AND COUNT(CASE WHEN is_a_fund = 1 THEN 1 ELSE NULL END) <> 0
-- Sort results by total deposits in descending order
ORDER BY total_deposits DESC;