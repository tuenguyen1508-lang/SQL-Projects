-- 1. View the orders and products tables
SELECT * FROM orders;
SELECT * FROM products;
-- 2. View the number of product_id from both tables
SELECT COUNT(DISTINCT product_id) FROM orders;
SELECT COUNT(DISTINCT product_id) FROM products;

-- Join the tables using various join types & note the number of rows in the output
-- 3. LEFT JOIN
SELECT COUNT(*)
FROM orders o LEFT JOIN products p
ON o.product_id = p.product_id; -- 8549
-- 4. RIGHT JOIN
SELECT COUNT(*)
FROM orders o RIGHT JOIN products p
ON o.product_id = p.product_id; -- 8552

-- 5. View the product_id in products table but not in orders table
SELECT *
FROM orders o RIGHT JOIN products p
ON o.product_id = p.product_id
WHERE o.product_id IS NULL;

-- 6. Use a LEFT JOIN to join products and orders (maybe new product has not been ordered yet)
SELECT p.product_id, p.product_name, o.product_id AS product_id_in_orders
FROM products p LEFT JOIN orders o
ON p.product_id = o.product_id
WHERE o.product_id IS NULL;

-- 7. Join on multiple columns
SELECT hs.year, hs.country, hs.happiness_score, ir.inflation_rate
FROM happiness_scores hs INNER JOIN inflation_rates ir
ON hs.year = ir.year AND hs.country = ir.country_name;

-- 8. Joining multiple tables
SELECT * FROM happiness_scores;
SELECT * FROM country_stats;
SELECT * FROM inflation_rates;
-- Join 3 tables
SELECT hs.year, hs.country, hs.happiness_score, cs.continent, ir.inflation_rate
FROM happiness_scores hs LEFT JOIN country_stats cs
ON hs.country = cs.country 
LEFT JOIN inflation_rates ir ON hs.year = ir.year AND hs.country = ir.country_name;


