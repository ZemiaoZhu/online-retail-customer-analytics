
-- Project: E-commerce Customer Retention & Repeat Purchase Analysis
-- Analysis: One-time vs. repeat customers
-- SQL dialect: SQLite

WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count
    FROM online_retail_clean
    WHERE transaction_type = 'regular_or_other'
      AND CustomerID IS NOT NULL
      AND TRIM(CAST(CustomerID AS TEXT)) <> ''
      AND Quantity > 0
      AND UnitPrice > 0
    GROUP BY CustomerID
)
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count = 1 THEN 1 ELSE 0 END)
        AS one_time_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        AS repeat_customers,
    ROUND(
        100.0 * SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS repeat_customer_rate_pct
FROM customer_orders;
