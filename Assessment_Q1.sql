-- Q1: High-Value Customers with Multiple Products
-- The query below finds customers with at least one funded savings plan and one funded investment plan       
                                              
SELECT
	u.id AS owner_id,
	CONCAT(u.first_name, ' ', u.last_name) AS name,
	savings.savings_count,
	investments.investment_count,
	ROUND(COALESCE(savings.total_deposits, 0) / 100, 2) AS total_deposits -- treat nulls as zero and convert kobo to naira to 2 decimal places
FROM
	adashi_staging.users_customuser u

-- join savings and plan tables using plan_id to get regular savings
JOIN (
	SELECT
		s.owner_id,
		COUNT(*) AS savings_count,
		SUM(s.confirmed_amount) AS total_deposits
	FROM adashi_staging.savings_savingsaccount s
	JOIN plans_plan p ON s.plan_id = p.id
	WHERE s.confirmed_amount > 0 AND p.is_regular_savings = 1
	GROUP BY s.owner_id
) AS savings ON u.id = savings.owner_id

-- query for inestment plans
JOIN (
	SELECT
		p.owner_id,
		COUNT(*) AS investment_count
	FROM adashi_staging.plans_plan p
	WHERE p.amount > 0 AND p.is_a_fund = 1 -- filter for investment plan and if funded
	GROUP BY p.owner_id
) AS investments ON u.id = investments.owner_id
ORDER BY total_deposits DESC;