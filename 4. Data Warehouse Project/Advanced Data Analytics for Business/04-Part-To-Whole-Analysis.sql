/* =========================================================
   Script Purpose: Part-to-Whole Sales Analysis (Gold Layer)
   =========================================================
   This script identifies which product categories contribute
   the most to overall sales (part-to-whole analysis) using:

   - gold.fact_sales      : sales transactions (sales_amount)
   - gold.dim_products    : product attributes (category)

   What it calculates:
   1) Total Sales by Category
      - Aggregates SUM(sales_amount) for each category

   2) Overall Sales (All Categories)
      - Uses a window SUM() OVER () to repeat the grand total
        on every row without collapsing the result set

   3) Percentage Contribution per Category
      - percentage_of_total = (category total_sales / overall_sales) * 100
      - Rounded to 2 decimals and formatted as a % string

   Why window functions are used:
   - SUM(total_sales) OVER ()
     Computes the grand total across all categories while keeping
     each category row visible (useful for part-to-whole reporting).

   Notes:
   - LEFT JOIN ensures sales rows remain even if a product record is missing
     (those rows may appear under NULL category).
   - Consider filtering WHERE category IS NOT NULL if you want to exclude
     uncategorized items.
   - ORDER BY total_sales DESC highlights top-contributing categories first.
   ========================================================= */

-- =========================================================
-- Part-to-Whole: Category contribution to total sales
-- =========================================================
WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    CONCAT(
        ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2),
        '%'
    ) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
