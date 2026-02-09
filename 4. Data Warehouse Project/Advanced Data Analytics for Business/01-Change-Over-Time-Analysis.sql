/* =========================================================
   Script Purpose: Change Over Time Analysis (Gold Layer)
   =========================================================
   This script analyzes how key business metrics change over
   time using the Gold fact table (gold.fact_sales).

   Metrics tracked per time period:
   - Total Sales (SUM of sales_amount)
   - Total Customers (distinct customer_key)
   - Total Quantity Sold (SUM of quantity)

   Why multiple approaches:
   1) YEAR() + MONTH()
      - Works in all SQL Server versions
      - Produces separate year/month columns for grouping

   2) DATETRUNC(month, ...)
      - Cleanly groups dates to the first day of the month
      - Best for time-series analysis

   3) FORMAT(order_date, 'yyyy-MMM')
      - Creates a readable month label (e.g., 2025-Jan)
      - Useful for display, but can be slower and may sort as text
        (best used for presentation, not heavy workloads)

   Notes:
   - Filters out NULL order_date values to avoid invalid groupings.
   - Ordering ensures results appear chronologically.
   ========================================================= */

-- =========================================================
-- Option 1: YEAR() + MONTH() grouping
-- =========================================================
SELECT
    YEAR(order_date)  AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity)     AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- =========================================================
-- Option 2: DATETRUNC() grouping (SQL Server 2022+)
-- =========================================================
SELECT
    DATETRUNC(MONTH, order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date);

-- =========================================================
-- Option 3: FORMAT() for readable month labels
-- =========================================================
SELECT
    FORMAT(order_date, 'yyyy-MMM') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');
