/* =========================================================
   Script Purpose: Cumulative Sales & Trend Analysis (Gold Layer)
   =========================================================
   This script summarizes sales over time and adds cumulative
   (running) metrics to reveal long-term trends using the Gold
   fact table (gold.fact_sales).

   Metrics produced per time period:
   - Total Sales (SUM of sales_amount)
   - Running Total Sales (cumulative SUM of total_sales)
   - Average Price per period (AVG of price)
   - Moving Average Price over time (windowed AVG of avg_price)

   Why this approach:
   - The inner query aggregates the fact table into one row per
     time period (using DATETRUNC).
   - The outer query applies window functions to calculate
     cumulative totals and smoothed price trends.

   Notes:
   - Filters out NULL order_date values to avoid invalid groupings.
   - ORDER BY in window functions ensures results follow time order.
   - Current moving_average_price is a running average across all
     prior periods. For a true "rolling" average (e.g., 3-month),
     add a ROWS BETWEEN frame.
   ========================================================= */

-- =========================================================
-- Cumulative Sales + Running Average Price (by period)
-- =========================================================
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
    AVG(avg_price)  OVER (ORDER BY order_date) AS moving_average_price
FROM (
    SELECT
        DATETRUNC(year, order_date) AS order_date,   -- change year -> month for monthly trend
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) t
ORDER BY order_date;
