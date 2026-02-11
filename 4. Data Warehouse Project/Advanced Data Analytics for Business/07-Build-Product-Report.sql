/* =========================================================
   Script Purpose: Build Product Report View (Gold Layer)
   =========================================================
   This script creates a reusable product reporting view:
   gold.report_products

   Business Goal:
   - Consolidate product attributes, sales performance, customer reach,
     and KPI metrics into one dataset for dashboards and analytics.

   Data Sources:
   - gold.fact_sales      : order-level transactions (order_number, order_date,
                            customer_key, sales_amount, quantity)
   - gold.dim_products    : product attributes (product_name, category,
                            subcategory, cost)

   What the view provides (1 row per product):
   1) Product Profile
      - product_key, product_name, category, subcategory, cost

   2) Product Segmentation (by revenue)
      - product_segment:
          * High-Performer : total_sales > 50000
          * Mid-Range      : total_sales >= 10000 AND <= 50000
          * Low-Performer  : total_sales < 10000

   3) Aggregated Product Metrics
      - total_orders     : distinct order count per product
      - total_sales      : total revenue per product
      - total_quantity   : total units sold per product
      - total_customers  : distinct customers who purchased the product
      - last_sale_date   : most recent sale date
      - lifespan         : months between first and last sale

   4) KPIs for Reporting
      - avg_selling_price :
          Average unit selling price computed per row as
          (sales_amount / quantity), excluding quantity = 0 rows via NULLIF,
          then rounded to 1 decimal.
      - avg_order_revenue (AOR):
          total_sales / total_orders (guarded for divide-by-zero)
      - avg_monthly_revenue:
          total_sales / lifespan (guarded when lifespan = 0)

   Design Notes:
   - Uses CTEs for clarity and maintainability:
       * base_query            : joins sales facts to product attributes
       * product_aggregation   : rolls up to product grain (one row per product)
   - Filters out NULL order_date values to avoid invalid time-based metrics.
   - Output is ideal for Power BI semantic models and product performance reviews.
   ========================================================= */

-- =============================================================================
-- Create Report View: gold.report_products
-- =============================================================================
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS
WITH base_query AS (
    /*---------------------------------------------------------------------------
      1) Base Query: Retrieve core columns from fact_sales and dim_products
    ---------------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),
product_aggregation AS (
    /*---------------------------------------------------------------------------
      2) Product Aggregations: Summarize key metrics at the product level
    ---------------------------------------------------------------------------*/
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,

    -- Segment products by revenue contribution
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,

    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

    -- Average Order Revenue (AOR)
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales * 1.0 / total_orders
    END AS avg_order_revenue,

    -- Average Monthly Revenue
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales * 1.0 / lifespan
    END AS avg_monthly_revenue
FROM product_aggregation;
GO
