
-- Project: E-commerce Customer Retention & Repeat Purchase Analysis
-- File: 01_data_quality.sql
-- Purpose: Initial data quality checks
-- SQL dialect: SQLite

-- 1. Check total rows
SELECT COUNT(*) AS total_rows
FROM online_retail;

-- 2. Check missing CustomerID values
SELECT
    COUNT(*) AS total_rows,
    SUM(
        CASE
            WHEN CustomerID IS NULL
              OR TRIM(CAST(CustomerID AS TEXT)) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_customer_id_rows,
    COUNT(DISTINCT CustomerID) AS distinct_customer_ids
FROM online_retail;

-- 3. Check negative quantities, zero quantities and nonpositive prices
SELECT
    SUM(CASE WHEN Quantity < 0 THEN 1 ELSE 0 END)
        AS negative_quantity_count,
    SUM(CASE WHEN Quantity = 0 THEN 1 ELSE 0 END)
        AS zero_quantity_count,
    SUM(CASE WHEN UnitPrice <= 0 THEN 1 ELSE 0 END)
        AS nonpositive_price_count
FROM online_retail;

-- 4. Check cancellation records
SELECT
    SUM(
        CASE WHEN InvoiceNo LIKE 'C%' THEN 1 ELSE 0 END
    ) AS cancellation_rows
FROM online_retail;

-- 5. Check date range as text (not yet parsed as real dates)
SELECT
    MIN(InvoiceDate) AS min_invoice_date_text,
    MAX(InvoiceDate) AS max_invoice_date_text
FROM online_retail;
