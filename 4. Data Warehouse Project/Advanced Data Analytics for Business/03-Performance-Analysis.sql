/* =========================================================
   Script Purpose: Product Performance Analysis (Gold Layer)
   =========================================================
   This script evaluates yearly product performance using the
   Gold sales fact table and product dimension:
   - gold.fact_sales (transaction sales)
   - gold.dim_products (product attributes)

   What it analyzes:
   1) Yearly Sales by Product
      - Aggregates total sales_amount per product per year

   2) Performance vs Product Average
      - Compares each year’s sales to the product’s multi-year average
      - Outputs:
        * avg_sales  : average yearly sales for that product
        * diff_avg  : current_sales - avg_sales
        * avg_change: Above Avg / Below Avg / Avg

   3) Year-over-Year (YoY) Change
      - Compares current year sales to previous year sales using LAG()
      - Outputs:
        * py_sales  : previous year sales
        * diff_py  : current_sales - py_sales
        * py_change: Increase / Decrease / No Change

   Why window functions are used:
   - AVG(...) OVER (PARTITION BY product_name)
     Calculates the product’s average across all years without
     collapsing rows (keeps one row per product-year).

   - LAG(...) OVER (PARTITION BY product_name ORDER BY order_year)
     Pulls the prior year’s sales to enable YoY comparison.

   Notes:
   - Filters out NULL order_date values to prevent invalid year groupings.
   - LEFT JOIN keeps sales rows even if product attributes are missing
     (product_name may be NULL in that case).
   - Ordering groups results by product then year for readability.
   ========================================================= */

-- =========================================================
-- Product yearly performance vs average + YoY comparison
-- =========================================================
WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        YEAR(f.order_date),
        p.product_name
)
SELECT
    order_year,
    product_name,
    current_sales,

    -- Compare to product average sales across all years
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
    CASE
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,

    -- Year-over-year (YoY) comparison
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
    CASE
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;
