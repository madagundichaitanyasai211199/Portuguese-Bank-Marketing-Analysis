-- Check if table is correctly uploded 

SELECT TOP 10 *
FROM bank_marketing_raw;

-- Check if all data types are correct

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'bank_marketing_raw';

--TOTAL CUSTOMERS
SELECT COUNT(*) AS Total_customers
FROM bank_marketing_raw;

--SUBSCRIPTION RATE
SELECT y ,COUNT(*) AS customer_count
FROM bank_marketing_raw
GROUP BY y ;

--CONVERSION RATE (%)
SELECT
    CAST(SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS FLOAT)
    / NULLIF(COUNT(*), 0) * 100 AS conversion_rate
FROM bank_marketing_raw;

--JOB-WISE PERFORMANCE
SELECT job,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS successful_subscriptions
FROM bank_marketing_raw
GROUP BY job
ORDER BY successful_subscriptions DESC;

--HOUSING LOAN IMPACT
SELECT housing,
    COUNT(*) AS total_customers,
    AVG(CASE WHEN y = 'yes' THEN 1.0 ELSE 0.0 END) * 100 AS conversion_rate
FROM bank_marketing_raw
GROUP BY housing;

--CUSTOMER SEGMENTATION
SELECT
    *,
    CASE
        WHEN campaign <= 2 AND previous > 0 THEN 'High Potential'
        WHEN campaign <= 4 THEN 'Medium Potential'
        ELSE 'Low Potential'
    END AS customer_segment
FROM bank_marketing_raw;

--CREATE VIEW
CREATE VIEW campaign_summary AS
SELECT
    job,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS successful_subscriptions,
    CAST(SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS FLOAT)
    / COUNT(*) * 100 AS conversion_rate
FROM bank_marketing_raw
GROUP BY job;