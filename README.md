# DataAnalytics-Assessment

### Assessment_Q1 - Active User Summary
Identify users who have engaged with both savings and investment plans, and show how much they've deposited.

My Approach:
- I joined the users_customuser, plans_plan, and savings_savingsaccount tables, making sure each deposit ties back correctly to both the user and their plan.
- I filtered for users with both a savings and an investment plan by checking columns (is_regular_savings and is_a_fund) respectively.
- The query also aggregates total confirmed deposits converted from kobo to naira by dividibg total value by 100.
- Presents names cleanly using CONCAT TO JOIN FIRST_NAME AND LAST_NAME.
- The result is sorted in descending order of total deposits

Challenge & Fix:
I noticed early issues with inflated counts due to overlapping joins. 
To fix this, I carefully use the joins using both owner_id and plan_id, ensuring accurate aggregation per user and eliminating noise from unrelated rows.

### Assessment_Q2 - Customer Transaction Frequency Category
Categorize users based on how often they transact each month and tally how many fall into each group.

My Approach:
* I grouped transactions by user and month, filtering out zero-value ones. 
* Then I calculated the average number of monthly transactions per user.
* Based on this, users were labeled as High, Medium, or Low Frequency.
* Get the count of customers in each category.
* The average number of monthly transaction for each customer.
* The result is sorted by descending order by average monthly transaction by per customer
Notes:
* Only months with transactions are counted for the average.
* Only customers with confirmed transactions are included.



### Assessment_Q3 -  Inactivity Alert
Help the ops team flag accounts that haven’t had any deposits in over a year.

My Approach:
* I check all plans marked as active savings or investments with their id.
* Linked it to the savings table using the plan_id 
* Finds the date of the most recent inflow transaction  for each plan_id / owner_id using MAX(created_on) and then compared it with today’s date using DATEDIFF.
* Calculates how many days have passed since that last transaction.
* Returns only those accounts with no transactions in the past year or no transactions at all.
* For each inactive account, you get:
* plan_id: The unique plan identifier, owner_id: The user who owns the plan
* type: Whether it’s a Savings or Investment plan, last_transaction_date: Date of the last inflow transaction (if any)
* inactivity_days: Number of days since the last transaction


### Assessment_Q4 -  Customer Lifetime Value (CLV)
Estimate the lifetime value of each customer using a simplified profit model.

My Approach:
* Used users_customuser to get customer details like signup date (created_on) and name (CONCAT first_name & last_name).
* Used savings_savingsaccount to get confirmed transaction values.
* To get valid transactions, I excluded records with confirmed_amount = 0 to ensure we only account for actual inflows.
* Calculated the time difference between signup_date and the current date . Then, I converted it to months to standardize the tenure metric for CLV.
* I handled cases where tenure is less than a month by using GREATEST(tenure, 1) and also prevented zero division.
* I counted total valid transactions per user to get the average transaction value (AVG(confirmed_amount)), converting from kobo to naira (/100.0).
* I worked with the formula: CLV = (total_transactions / tenure_months) * 12 * (avg_transaction * 0.001) to estimates annual transaction rate multiplied by profit per transaction.
* Returned: customer_id, name, tenure_months, total_transactions and estimated_clv rounded CLV to 2 decimal places for clarity.
* Sorted by estimated_clv in descending order to highlight top-value customers.

Challenge & Fix:
* I had to prevent division by zero for new users, so I defaulted tenure to at least 1 month using GREATEST(1, tenure). 
* I also converted kobo values to Naira for better readability in business reports.
