/* =========================================================
   Script Purpose: gold_layer_quality_check
   =========================================================
   This script validates the Gold layer (reporting layer) to
   ensure the star schema is reliable for analytics and BI.

   What it checks:
   1) Key Uniqueness (Dimensions)
      - Confirms gold.dim_customers has unique customer_key values
      - Confirms gold.dim_products has unique product_key values
      Expectation: no duplicate rows returned.

   2) Model Connectivity / Referential Integrity (Fact -> Dimensions)
      - Verifies every row in gold.fact_sales successfully links
        to a matching customer in gold.dim_customers and a matching
        product in gold.dim_products.
      - Flags rows where the customer_key or product_key is missing
        in the corresponding dimension (broken relationships).
      Expectation: no rows returned.

   Outcome:
   - If all queries return no rows, the Gold layer keys are unique
     and the fact table joins cleanly to the dimension tables.
   ========================================================= */

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
-- Expectation: No results
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL
   OR c.customer_key IS NULL;
