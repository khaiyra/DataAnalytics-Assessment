-- Q4: Customer Lifetime Value (CLV) Estimation
-- The query below estimates the CLV for each customer

SELECT
u.id AS customer_id,
CONCAT(u.first_name, ' ', u.last_name) AS name,
TIMESTAMPDIFF(MONTH, u.created_on, CURDATE()) AS tenure_months,   -- calculate how long the user has been active in months
COUNT(s.id) AS total_transactions,
ROUND(
(COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.created_on, CURDATE())) * 12 * (0.001 * AVG(s.confirmed_amount) / 100), 2
) AS estimated_clv
FROM
adashi_staging.users_customuser u
JOIN
adashi_staging.savings_savingsaccount s ON u.id = s.owner_id
WHERE
TIMESTAMPDIFF(MONTH, u.created_on, CURDATE()) > 0
GROUP BY
u.id, u.first_name, u.last_name, u.created_on
ORDER BY
estimated_clv DESC;