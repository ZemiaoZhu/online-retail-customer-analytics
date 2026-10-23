
-- 04_customer_segmentation.sql
-- Goal: Segment customers by purchase frequency
-- Source: online_retail_clean
-- Rules: One-time = 1 order, Regular = 2-10 orders, Frequent = 11+ orders
-- Only include identified customers and positive-quantity, positive-price transactions.

WITH customer_summary AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count,
        SUM(Quantity * UnitPrice) AS total_spend
    FROM online_retail_clean
    WHERE transaction_type = 'regular_or_other'
      AND CustomerID IS NOT NULL
      AND TRIM(CAST(CustomerID AS TEXT)) <> ''
      AND Quantity > 0
      AND UnitPrice > 0
    GROUP BY CustomerID
),
customer_segments AS (
    SELECT
        CustomerID,
        order_count,
        total_spend,
        CASE
            WHEN order_count = 1 THEN 'One-time'
            WHEN order_count BETWEEN 2 AND 10 THEN 'Regular'
            ELSE 'Frequent'
        END AS customer_segment
    FROM customer_summary
)
SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(total_spend), 2) AS segment_sales,
    ROUND(AVG(total_spend), 2) AS avg_customer_spend,
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM customer_summary),
        2
    ) AS customer_pct,
    ROUND(
        100.0 * SUM(total_spend) /
        (SELECT SUM(total_spend) FROM customer_summary),
        2
    ) AS sales_pct
FROM customer_segments
GROUP BY customer_segment
ORDER BY
    CASE customer_segment
        WHEN 'One-time' THEN 1
        WHEN 'Regular' THEN 2
        WHEN 'Frequent' THEN 3
    END;
