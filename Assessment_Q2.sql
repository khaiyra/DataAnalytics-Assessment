-- Q2: Transaction Frequency Analysis
-- The query below calculates the average number of deposit transactions per month per customer

WITH customer_txn_summary AS (    -- pre process customer level summaries 
-- calculat ethe duration of customer activity
SELECT
s.owner_id,
COUNT(*) AS total_transactions,
TIMESTAMPDIFF(MONTH, MIN(s.created_on), MAX(s.created_on)) + 1 AS active_months,
ROUND(COUNT(*) / (TIMESTAMPDIFF(MONTH, MIN(s.created_on), MAX(s.created_on)) + 1), 2) AS avg_txn_per_month  -- months between first and last transcation
FROM adashi_staging.savings_savingsaccount s
GROUP BY s.owner_id
),
-- assign each customer to a frequency category based on calculated average
categorized_customers AS (
SELECT
owner_id,
avg_txn_per_month,
CASE
WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
ELSE 'Low Frequency'
END AS frequency_category
FROM customer_txn_summary
)
-- calculate how many customers and the average of their monhly transactions
SELECT
frequency_category,
COUNT(*) AS customer_count,
ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM
categorized_customers
GROUP BY
frequency_category
ORDER BY
FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');