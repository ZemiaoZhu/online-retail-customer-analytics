
-- Project: E-commerce Customer Retention & Repeat Purchase Analysis
-- File: 02_cleaning_flags.sql
-- Purpose: Classify transaction types without deleting records
-- SQL dialect: SQLite

-- Note:
-- online_retail remains unchanged.
-- online_retail_clean already exists in the playground.
-- This is the SQL used to create the classification table originally.
-- Do not rerun CREATE TABLE unless creating a fresh table intentionally.

CREATE TABLE online_retail_clean AS
SELECT *,
    CASE
        WHEN StockCode = 'B'
         AND Description = 'Adjust bad debt'
            THEN 'bad_debt_adjustment'
        WHEN InvoiceNo LIKE 'C%'
            THEN 'cancellation'
        WHEN Quantity < 0
            THEN 'negative_quantity_other'
        WHEN UnitPrice < 0
            THEN 'negative_price_other'
        WHEN UnitPrice = 0
            THEN 'zero_price'
        ELSE 'regular_or_other'
    END AS transaction_type
FROM online_retail;

-- Validation query: confirm row count
SELECT COUNT(*) AS total_rows
FROM online_retail_clean;

-- Validation query: review transaction categories
SELECT
    transaction_type,
    COUNT(*) AS row_count
FROM online_retail_clean
GROUP BY transaction_type
ORDER BY row_count DESC;
