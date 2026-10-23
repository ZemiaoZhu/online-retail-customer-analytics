
-- 06_monthly_sales_trend.sql
-- Project: E-commerce Customer Retention & Repeat Purchase Analysis
-- Purpose: Analyze monthly sales trends and order performance
-- Source: online_retail_clean
-- SQL dialect: SQLite
--
-- Analysis rules:
-- 1. Include regular_or_other transactions only.
-- 2. Include identified customers only.
-- 3. Include positive quantities and positive unit prices.
-- 4. Sales amount = Quantity * UnitPrice.
-- 5. December 2011 is a partial month in this dataset.
-- 6. Original data is preserved; this script is read-only.

SELECT
    printf(
        '%04d-%02d',
        CAST(
            SUBSTR(
                InvoiceDate,
                1,
                INSTR(InvoiceDate, '/') - 1
            ) AS INTEGER
        ),
        CAST(
            SUBSTR(
                InvoiceDate,
                INSTR(InvoiceDate, '/') + 1,
                INSTR(
                    SUBSTR(
                        InvoiceDate,
                        INSTR(InvoiceDate, '/') + 1
                    ),
                    '/'
                ) - 1
            ) AS INTEGER
        )
    ) AS invoice_month,

    COUNT(DISTINCT InvoiceNo) AS order_count,

    ROUND(
        SUM(Quantity * UnitPrice),
        2
    ) AS monthly_sales,

    ROUND(
        SUM(Quantity * UnitPrice)
        / COUNT(DISTINCT InvoiceNo),
        2
    ) AS avg_order_value

FROM online_retail_clean

WHERE transaction_type = 'regular_or_other'
  AND CustomerID IS NOT NULL
  AND TRIM(CAST(CustomerID AS TEXT)) <> ''
  AND Quantity > 0
  AND UnitPrice > 0

GROUP BY invoice_month
ORDER BY invoice_month;
