/* =========================================================
   Script Purpose: Measure Exploration (Gold Layer)
   =========================================================
   This script explores core business metrics from the Gold
   layer to provide a quick snapshot of overall performance.

   What it does:
   1) Sales & Volume Metrics (gold.fact_sales)
      - Total Sales: total revenue across all sales lines
      - Total Quantity: total units sold
      - Average Price: average unit price across sales lines
      - Total Orders:
        * COUNT(order_number) shows total rows (line items)
        * COUNT(DISTINCT order_number) shows unique orders

   2) Entity Counts (Dimensions / Fact)
      - Total Products: number of products in gold.dim_products
      - Total Customers: number of customers in gold.dim_customers
      - Active Customers: distinct customers who placed at least one order

   3) KPI Summary Report
      - Produces a single output table of key metrics using UNION ALL
        for easy reporting/validation and quick dashboard inputs.
   ========================================================= */

-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity
FROM gold.fact_sales;

-- Find the average selling price
SELECT AVG(price) AS avg_price
FROM gold.fact_sales;

-- Find the Total number of Orders
-- Note: COUNT(order_number) counts rows (order line items)
SELECT COUNT(order_number) AS total_orders
FROM gold.fact_sales;

-- Note: COUNT(DISTINCT order_number) counts unique orders
SELECT COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

-- Find the Total number of Products
SELECT COUNT(product_key) AS total_products
FROM gold.dim_products;

-- Find the Total number of Customers
SELECT COUNT(customer_key) AS total_customers
FROM gold.dim_customers;

-- Find the Total number of Customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value
FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity)
FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price)
FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number)
FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name)
FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key)
FROM gold.dim_customers;
