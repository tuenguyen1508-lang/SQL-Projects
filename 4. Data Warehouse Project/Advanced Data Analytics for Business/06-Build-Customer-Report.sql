/* =========================================================
   Script Purpose: Build Customer Report View (Gold Layer)
   =========================================================
   This script creates a reusable customer reporting view:
   gold.report_customers

   Business Goal:
   - Consolidate customer identity, purchasing behavior, and key KPIs
     into a single dataset for dashboards, segmentation, and analysis.

   Data Sources:
   - gold.fact_sales      : order-level transactions (order_number, order_date,
                            sales_amount, quantity, product_key)
   - gold.dim_customers   : customer attributes (customer_number, names, birthdate)

   What the view provides (1 row per customer):
   1) Customer Profile
      - customer_key, customer_number, customer_name
      - age (calculated from birthdate) + age_group bucket

   2) Customer Value & Engagement Segmentation
      - customer_segment:
          * VIP     : lifespan >= 12 months AND total_sales > 5000
          * Regular : lifespan >= 12 months AND total_sales <= 5000
          * New     : lifespan < 12 months

   3) Aggregated Customer Metrics
      - total_orders     : distinct order count
      - total_sales      : total revenue contributed
      - total_quantity   : total items purchased
      - total_products   : distinct products purchased
      - first_order_date / last_order_date
      - lifespan         : months between first and last order

   4) KPIs for Reporting
      - recency          : months since last purchase (DATEDIFF from last_order_date)
      - avg_order_value  : total_sales / total_orders (guarded for divide-by-zero)
      - avg_monthly_spend: total_sales / lifespan (guarded when lifespan = 0)

   Design Notes:
   - Uses CTEs for clarity:
       * base_query            : joins facts + customer attributes and derives age
       * customer_aggregation  : rolls up to customer grain (one row per customer)
   - Filters out NULL order_date to avoid invalid time-based metrics.
   - Output is ideal for Power BI / BI semantic models and customer analytics.
   ========================================================= */

-- =============================================================================
-- Create Report View: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS
WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(year, c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
),
customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        MIN(order_date) AS first_order_date,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age
)
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,

    -- Age banding for demographic analysis
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,

    -- Value-based customer segmentation
    CASE
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    first_order_date,
    last_order_date,
    DATEDIFF(month, last_order_date, GETDATE()) AS recency,

    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,

    -- Compute average order value (AOV)
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales * 1.0 / total_orders
    END AS avg_order_value,

    -- Compute average monthly spend
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales * 1.0 / lifespan
    END AS avg_monthly_spend
FROM customer_aggregation;
GO
