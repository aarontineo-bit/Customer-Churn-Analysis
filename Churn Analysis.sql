
-- ============================================================
-- CUSTOMER CHURN & RETENTION ANALYSIS
-- Tools: Google BigQuery | SQL
-- Dataset: IBM Telco Customer Churn (7,043 customers)
-- Purpose: Identify churn patterns and high-risk segments
-- ============================================================


-- 1. CUSTOMER CHURN BY PAYMENT METHOD AND INTERNET SERVICE
-- Compare customer counts and churn across payment methods
-- and internet service types.

SELECT
    payment_method,
    internet_service,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers
FROM `the-beginning-491218.Churn.Telco Churn`
GROUP BY payment_method, internet_service
ORDER BY churned_customers DESC;


-- 2. ONLINE SECURITY AND CHURN
-- Focus on month-to-month fiber-optic customers.

SELECT
    online_security,
    internet_service,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(100 * SUM(churn_value) / COUNT(*), 1) AS churn_rate
FROM `the-beginning-491218.Churn.Telco Churn`
WHERE internet_service = 'Fiber optic'
    AND contract = 'Month-to-month'
GROUP BY online_security, internet_service
ORDER BY churn_rate DESC;


-- 3. TECH SUPPORT AND CHURN
-- Compare churn rates based on tech support availability
-- among month-to-month fiber-optic customers.

SELECT
    tech_support,
    internet_service,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(100 * SUM(churn_value) / COUNT(*), 1) AS churn_rate
FROM `the-beginning-491218.Churn.Telco Churn`
WHERE internet_service = 'Fiber optic'
    AND contract = 'Month-to-month'
GROUP BY tech_support, internet_service
ORDER BY churn_rate DESC;


-- 4. PAYMENT METHOD AND CHURN IN HIGH-RISK SEGMENT
-- Investigate payment methods among month-to-month
-- fiber-optic customers.

SELECT
    payment_method,
    internet_service,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(100 * SUM(churn_value) / COUNT(*), 1) AS churn_rate
FROM `the-beginning-491218.Churn.Telco Churn`
WHERE internet_service = 'Fiber optic'
    AND contract = 'Month-to-month'
GROUP BY payment_method, internet_service
ORDER BY churn_rate DESC;


-- 5. CHURN RATE BY INTERNET SERVICE AND CONTRACT
-- Identify combinations with the highest churn rates.

SELECT
    internet_service,
    contract,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(100 * SUM(churn_value) / COUNT(*), 2) AS churn_rate_percent
FROM `the-beginning-491218.Churn.Telco Churn`
GROUP BY internet_service, contract
ORDER BY churn_rate_percent DESC;


-- 6. CHURN RATE BY INTERNET SERVICE
-- Compare churn rates across internet service types.

SELECT
    internet_service,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(100 * SUM(churn_value) / COUNT(*), 2) AS churn_rate_percent
FROM `the-beginning-491218.Churn.Telco Churn`
GROUP BY internet_service
ORDER BY churn_rate_percent DESC;


-- 7. CUSTOMER TENURE SEGMENTATION
-- Group customers by tenure and compare churn rates.

SELECT
    CASE
        WHEN tenure_months <= 12 THEN 'NEW'
        WHEN tenure_months <= 24 THEN 'DEVELOPING'
        WHEN tenure_months <= 48 THEN 'ESTABLISHED'
        ELSE 'LONG_TERM'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_value = 1 THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100 * SUM(CASE WHEN churn_value = 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate_percent
FROM `the-beginning-491218.Churn.Telco Churn`
GROUP BY tenure_group
ORDER BY churn_rate_percent DESC;

