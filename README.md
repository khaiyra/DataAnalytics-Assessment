# DataAnalytics-Assessment

This repository contains my solutions to the SQL assessment. It showcases my ability to write clean, optimized SQL, analyze transaction behavior, and extract actionable business insights. Beyond querying, I focus on storytelling with data and understanding how insights drive business goals. Each question is addressed in its own SQL file, and this README explains my approach to solving each one.

---
### My SQL Writing Approach

I follow these conventions for clear and maintainable queries:

- **Descriptive aliases** (e.g. `total_deposits` not `td`)
- **Common Table Expressions (CTEs) over nested subqueries** for readability
- **Line breaks for complex SELECTs and WHEREs**
- **Consistent formatting**: UPPERCASE for SQL keywords, lowercase for column names
- Comments for logic sections and assumptions

They help with readability and quick understanding.

---
### Per Question Explanations

| Assessment Question | Goal  | Approach | Challenges |
| ------------- | ------------- | ------------- | ------------- |
| Q1: High-Value Customers with Multiple Products | To help the business identify customers who have both funded savings and funded investment plan, and rank them by total deposits. | <ul><li>Joined `savings_savingsaccount` with `plans_plan` using `plan_id` to access plan details.</li><li>Filtered for savings accounts where `is_regular_savings = 1` and `confirmed_amount > 0`.</li><li>Filtered investment plans where `is_a_fund = 1` and `amount > 0`.</li><li>Aggregated counts of savings and investment products per customer.</li><li>Summed all confirmed deposit amounts per customer and converted them from **kobo to naira**.</li><li>Retained only customers who had both savings and investment plans (via inner joins).</li><li>Ordered final output by total deposit value in descending order.</li></ul>  |  <ul><li>Initial assumption that `plans_plan` contained `confirmed_amount` was incorrect.</li><li>Later assumed `is_regular_savings` existed in `savings_savingsaccount`, but it was actually in `plans_plan`.</li><li>Solved by joining `savings_savingsaccount` with `plans_plan` on `plan_id` to filter savings using `is_regular_savings`.</li><li>Required verifying actual column relationships in the schema to map business rules correctly.</li></ul>  |
| Q2: Transaction Frequency Analysis   |  To assist the finance team understand how often customers transact by classifying customers based on average deposit transaction frequency per month. | <ul><li>Grouped deposits by customer to count transactions</li><li>Calculated number of active months based on earliest and latest `created_on` dates.</li><li>Derived average transactions per month</li><li></li>Categorized each user into frequency groups.</li><li>Aggregated category-level results</li></ul> | <ul><li>Initially used `created_at`, which caused an error. Corrected by checking schema and using `created_on`.</li><li>Ensured division-by-zero was avoided by adding `+1` to the month difference.</li></ul> |
| Q3: Account Inactivity Alert   |  To identify savings or investment accounts with no inflow in the past 365 days which seamlessly assistes the ops team on accounts to flag. | <ul><li>For savings: grouped by account ID and found the most recent deposit date</li><li>For investments: grouped plans by ID and used `created_on` as last activity.</li><li>Calculated inactivity in days using `DATEDIFF(CURDATE(), last_transaction_date)`</li><li>Filtered for accounts with inactivity > 365 days.</li><li>Combined both account types using `UNION ALL`</li></ul> | <ul><li>Initially used a CTE to declare the current date, which MySQL doesn't support</li><li>Resolved by calling `CURDATE()` directly in calculations</li></ul>|
| Q4: Customer Lifetime Value (CLV) Estimation  | Aid the marketing team to estimate CLV using tenure and transaction activity.  | <ul><li>Calculated tenure as months since customer sign-up (`users_customuser.created_on`)</li><li>Counted deposit transactions from `savings_savingsaccount`</li><li>Computed average deposit value and applied the formula:`CLV = (transactions / tenure) * 12 * 0.1% * avg_transaction_value`</li><li>Converted transaction amounts from kobo to naira</li><li>Rounded CLV to 2 decimal places and sorted by highest value</li></ul> | <ul><li>Needed to avoid division-by-zero for customers with 0-month tenure</li><li>Used accurate field (`confirmed_amount`) for deposit values</li></ul>|

---

<details open>

<summary>Bonus Insights</summary>

> What interesting things did I notice while working with this data?

 Working through the SQL assessment, I explored additional insights from the dataset beyond the given questions. These findings reflect business opportunities and areas for deeper product engagement.
- Few customers have exceptionally high CLV driven by high average deposit amounts, not frequency. These may represent premium customers with more capital and lower engagement — a potential upsell target.
- A significant majority of users fall into the **Medium Frequency** segment (3–9 transactions/month). **High Frequency** users are rare, indicating a potential gap in product stickiness or incentive structures.
- Inactive users are not rare, and some hold **multiple dormant accounts**.
- Customers with both savings and investment products tend to have higher total deposit volumes. They can be prioritized in marketing and retention efforts.

Recommendations
- Creating tailored offerings for high CLV users e.g., exclusive savings and investment plans, early access features can greatly improve customer loyalty and referral marketing.
- Launching targeted camapigns through re-engagement emails or app notifications for users with over a year of inactivity.
- To grow High Frequency users, introducing rewards like cashback, badges, weekly / monthly transaction streaks can aid transaction growth.
- Since dual-product users deposit more, investment plans can be promoted directly within the savings experience 

</details>
