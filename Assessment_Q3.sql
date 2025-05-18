SELECT pp.id AS plan_id, pp.owner_id,                     
    CASE WHEN pp.is_regular_savings = 1 THEN 'Savings'  
        WHEN pp.is_a_fund = 1 THEN 'Investment' ELSE 'Other' END AS type,
    MAX(DATE(ss.created_on)) AS last_transaction_date,          -- Date of last inflow transaction
    DATEDIFF(CURDATE(), MAX(ss.created_on)) AS inactivity_days  -- Days since last transaction
FROM plans_plan pp
LEFT JOIN savings_savingsaccount ss ON pp.id = ss.plan_id 
    AND ss.confirmed_amount > 0    -- Consider only successfull inflow transactions
-- Only consider plans marked as active savings or investment and archived means inactive; filter active plans
WHERE (pp.is_regular_savings = 1 OR pp.is_a_fund = 1) AND pp.is_archived = 0  
GROUP BY pp.id, pp.owner_id, type
HAVING (last_transaction_date IS NULL OR inactivity_days > 365) -- Filter to find plans with no transactions in the last 365 days
ORDER BY inactivity_days DESC;
