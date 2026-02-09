/* =========================================================
   Script Purpose: Date Exploration (Gold Layer)
   =========================================================
   This script explores time coverage and customer age ranges
   in the Gold layer to understand dataset boundaries.

   What it does:
   1) Sales Date Coverage (gold.fact_sales)
      - Finds the earliest and latest order dates available.
      - Calculates the overall time span of sales data in:
        * years
        * months
      Use case: confirm how much historical sales data is available
      before building time-series analyses.

   2) Customer Age Range (gold.dim_customers)
      - Identifies the oldest and youngest customers using birthdate.
      - Estimates age in years relative to today's date (GETDATE()).
      Use case: validate customer demographics and check for outliers
      (e.g., unrealistic birthdates).
   ========================================================= */

-- Find the date of the first and last order
-- How many years/ months of sales are available
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(YEAR,  MIN(order_date), MAX(order_date)) AS order_range_years,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;

-- Find the youngest and oldest customer
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;
