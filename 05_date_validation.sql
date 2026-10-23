
-- 05_date_validation.sql
-- Project: E-commerce Customer Retention & Repeat Purchase Analysis
-- Purpose: Normalize and validate InvoiceDate
-- Source: online_retail
-- Note: Original data is preserved; no rows are updated or deleted.

-- 1. Normalize InvoiceDate into YYYY-MM-DD format
WITH date_parts AS (
    SELECT
        InvoiceDate,
        CAST(
            SUBSTR(InvoiceDate, 1, INSTR(InvoiceDate, '/') - 1)
            AS INTEGER
        ) AS year_num,
        CAST(
            SUBSTR(
                InvoiceDate,
                INSTR(InvoiceDate, '/') + 1,
                INSTR(
                    SUBSTR(InvoiceDate, INSTR(InvoiceDate, '/') + 1),
                    '/'
                ) - 1
            ) AS INTEGER
        ) AS month_num,
        CAST(
            SUBSTR(
                InvoiceDate,
                INSTR(InvoiceDate, '/') +
                INSTR(
                    SUBSTR(InvoiceDate, INSTR(InvoiceDate, '/') + 1),
                    '/'
                ) + 1,
                INSTR(InvoiceDate, ' ') -
                INSTR(InvoiceDate, '/') -
                INSTR(
                    SUBSTR(InvoiceDate, INSTR(InvoiceDate, '/') + 1),
                    '/'
                ) - 1
            ) AS INTEGER
        ) AS day_num
    FROM online_retail
),
normalized_dates AS (
    SELECT
        InvoiceDate,
        year_num,
        month_num,
        day_num,
        printf(
            '%04d-%02d-%02d',
            year_num,
            month_num,
            day_num
        ) AS normalized_date
    FROM date_parts
)

-- 2. Validate total rows, date range, and basic date values
SELECT
    COUNT(*) AS total_rows,
    SUM(
        CASE
            WHEN year_num IS NULL
              OR month_num NOT BETWEEN 1 AND 12
              OR day_num NOT BETWEEN 1 AND 31
              OR normalized_date = '0000-00-00'
            THEN 1
            ELSE 0
        END
    ) AS invalid_date_rows,
    MIN(normalized_date) AS earliest_date,
    MAX(normalized_date) AS latest_date
FROM normalized_dates;


-- 3. Monthly record counts
-- Run this section separately in SQL Boy Playground.
WITH date_parts AS (
    SELECT
        CAST(
            SUBSTR(InvoiceDate, 1, INSTR(InvoiceDate, '/') - 1)
            AS INTEGER
        ) AS year_num,
        CAST(
            SUBSTR(
                InvoiceDate,
                INSTR(InvoiceDate, '/') + 1,
                INSTR(
                    SUBSTR(InvoiceDate, INSTR(InvoiceDate, '/') + 1),
                    '/'
                ) - 1
            ) AS INTEGER
        ) AS month_num
    FROM online_retail
)
SELECT
    printf('%04d-%02d', year_num, month_num) AS invoice_month,
    COUNT(*) AS row_count
FROM date_parts
GROUP BY year_num, month_num
ORDER BY year_num, month_num;
