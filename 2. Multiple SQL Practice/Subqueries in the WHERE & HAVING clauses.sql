-- Average happiness_score
SELECT AVG(happiness_score) FROM happiness_scores;

-- Above average happiness_scores (WHERE)
SELECT * FROM happiness_scores
WHERE happiness_score > (SELECT AVG(happiness_score) FROM happiness_scores);
-- Above average happiness scores for each region (HAVING)
SELECT region, AVG(happiness_score) AS avg_hs
FROM happiness_scores
GROUP BY region
HAVING avg_hs > (SELECT AVG(happiness_score) FROM happiness_scores);

-- ANY/ ALL, example: return happiness score that greater than ANY/ ALL of the current
-- happiness scores
-- Scores that greater than any 2024 scores
SELECT COUNT(*) FROM happiness_scores
WHERE happiness_score > ANY(SELECT ladder_score FROM happiness_scores_current);
-- Scores that greater than all 2024 scores
SELECT * FROM happiness_scores
WHERE happiness_score > ALL(SELECT ladder_score FROM happiness_scores_current);

-- EXISTS (provide more specific filtering logic)
-- Eg: only return happiness score for countries that EXIST in the inflation rates table
SELECT * FROM happiness_scores h
WHERE EXISTS (SELECT i.country_name FROM inflation_rates i WHERE i.country_name = h.country);

-- Example: Identify products that have a unit price less than the unit price of all products from Wicked Choccy.
-- Include which facotyr is currently producing them.
-- View all products from Wicked Choccy's
SELECT * FROM products
WHERE factory = "Wicked Choccy's"; 

-- Return the products where the unit price is less than the unit price of all products from Wicked Choccy
SELECT * FROM products 
WHERE unit_price < ALL(SELECT unit_price FROM products
WHERE factory = "Wicked Choccy's");

-- Common table expression
WITH country_hs AS (SELECT country, AVG(happiness_score) AS avg_hs FROM happiness_scores GROUP BY country)
SELECT hs.year, hs.country, hs.happiness_score, country_hs.avg_hs
FROM happiness_scores hs
LEFT JOIN country_hs
ON hs.country = country_hs.country;

-- Subquery: compare the happiness scores within each region in 2023
SELECT * FROM happiness_scores WHERE year = 2023;

SELECT hs1.region, hs1.country, hs1.happiness_score,
hs2.country, hs2.happiness_score
FROM happiness_scores hs1 INNER JOIN happiness_scores hs2
ON hs1.region = hs2.region;
-- CTE: compare the happiness scores within each region in 2023
WITH hs AS (SELECT * FROM happiness_scores WHERE year = 2023)
SELECT hs1.region, hs1.country, hs1.happiness_score,
hs2.country, hs2.happiness_score
FROM hs hs1 INNER JOIN hs hs2
ON hs1.region = hs2.region
WHERE hs1.country < hs2.country;
-- Eg: a list of biggest orders. In addition to sending over a list of all the orders over $200,
-- generate the number of orders over $200
-- Return all orders over $200
SELECT * FROM products;
SELECT * FROM orders;
-- Return all orders over $200
SELECT o.order_id,
SUM(o.units * p.unit_price) AS total_amount_spent
FROM orders o LEFT JOIN products p
ON o.product_id = p.product_id
GROUP BY o.order_id
HAVING total_amount_spent > 200
ORDER BY total_amount_spent DESC;
-- Return the number of orders > 200
WITH tas AS (SELECT o.order_id,
SUM(o.units * p.unit_price) AS total_amount_spent
FROM orders o LEFT JOIN products p
ON o.product_id = p.product_id
GROUP BY o.order_id
HAVING total_amount_spent > 200
ORDER BY total_amount_spent DESC)
SELECT COUNT(*)
FROM tas;
-- Typically, order bys are not necessary within a CTE because the final ordering comes from your main
-- You can use multiple CTEs in a query, and even combine them with subqueries
-- Step 1: Compare 2023 & 2024 happiness scores side by side
SELECT * FROM
(WITH hs23 AS (SELECT * FROM happiness_scores WHERE year = 2023),
hs24 AS (SELECT * FROM happiness_scores_current)
SELECT hs23.country, hs23.happiness_score AS hs_2023, hs24.ladder_score AS hs_2024
FROM hs23 LEFT JOIN hs24
ON hs23.country = hs24.country) AS hs_23_24
WHERE hs_2024 > hs_2023;
-- CTESs only
WITH hs23 AS (SELECT * FROM happiness_scores WHERE year = 2023),
hs24 AS (SELECT * FROM happiness_scores_current),
hs_23_24 AS (SELECT hs23.country, hs23.happiness_score AS hs_2023, hs24.ladder_score AS hs_2024
FROM hs23 LEFT JOIN hs24
ON hs23.country = hs24.country) 
SELECT * FROM hs_23_24
WHERE hs_2024 > hs_2023;

-- Eg: review the products by each factory, give a list of factories, aling with the name of
-- the products they produce and the number of products they produce
WITH fp AS (SELECT factory, product_name FROM products),
fn AS (SELECT factory, COUNT(product_id) AS num_products
FROM products GROUP BY factory)
SELECT fp.factory, fp.product_name, fn.num_products 
FROM fp LEFT JOIN fn
ON fp.factory = fn.factory
ORDER BY fp.factory, fp.product_name; 
