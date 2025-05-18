SELECT uc.id AS customer_id,
    CONCAT(uc.first_name, ' ', uc.last_name) AS name,
    GREATEST(TIMESTAMPDIFF(MONTH, uc.created_on, CURDATE()), 1) AS tenure_months,  -- Account age in months
    COUNT(ss.id) AS total_transactions,        
    ROUND((
        (COUNT(ss.id) / NULLIF(TIMESTAMPDIFF(MONTH, uc.created_on, CURDATE()), 0))  -- Transactions per month
        * 12                                                           -- Annualized transactions
        * AVG(ss.confirmed_amount) * 0.001)/ 100,                            -- Profit per transaction (0.1%) and convert to naira 
        2
    ) AS estimated_clv                                            

FROM users_customuser uc
-- Join savings accounts with confirmed transactions only (assuming confirmed_amount > 0)
LEFT JOIN savings_savingsaccount ss ON uc.id = ss.owner_id AND ss.confirmed_amount > 0
GROUP BY uc.id, uc.first_name, uc.last_name, uc.created_on
ORDER BY estimated_clv DESC;
