-- Q3: Account Inactivity Alert
-- The query below finds all active accounts with no transactions in the last 365 days

WITH savings_inactivity AS (   -- CTE to calculate inactivity for savings accounts
SELECT
s.id AS plan_id,
s.owner_id,
'Savings' AS type,
MAX(s.created_on) AS last_transaction_date,  -- most recent deposit date 
DATEDIFF(CURDATE(), MAX(s.created_on)) AS inactivity_days   -- calculates how many days have passed since last transaction
FROM adashi_staging.savings_savingsaccount s
GROUP BY s.id, s.owner_id
),

investment_inactivity AS (
SELECT
p.id AS plan_id,
p.owner_id,
'Investment' AS type,
MAX(p.created_on) AS last_transaction_date,
DATEDIFF(CURDATE(), MAX(p.created_on)) AS inactivity_days
FROM adashi_staging.plans_plan p
WHERE p.plan_type_id IN (2, 3, 4)
GROUP BY p.id, p.owner_id
)

SELECT *
FROM (
SELECT * FROM savings_inactivity
UNION ALL
SELECT * FROM investment_inactivity
) AS all_accounts
WHERE inactivity_days > 365
ORDER BY inactivity_days DESC;