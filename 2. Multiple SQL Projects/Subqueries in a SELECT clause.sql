-- Eg: Return the difference between each country's happiness score and the average
SELECT country, happiness_score - (SELECT AVG(happiness_score) FROM happiness_scores) AS diff_from_avg
FROM happiness_scores;
-- 1. Subqueries in the select clause
SELECT * FROM happiness_scores;
-- 2. Average happiness score
SELECT AVG(happiness_score) FROM happiness_scores;
-- 3. Happiness score deviation from the average
SELECT year, country, happiness_score,
(SELECT AVG(happiness_score) FROM happiness_scores) AS avg_hs,
happiness_score - (SELECT AVG(happiness_score) FROM happiness_scores) AS diff_from_avg
FROM happiness_scores;

-- Assignment: product team plans on evaluating product prices later this week to see if any adjustments
-- needs to be made. Please give a list of products from most to least expensive, along with how much each product
-- differs from the average unit price?

-- View the products table
SELECT * FROM products;
SELECT AVG(unit_price) from products;
-- Return the product_id, product name, unit price, average unit price
-- and the difference between each unit price and the average unit price
SELECT product_id, product_name, unit_price,
(SELECT AVG(unit_price) from products) AS avg_unit_price,
unit_price - (SELECT AVG(unit_price) from products) AS diff_price
FROM products;
-- Order the result from most to least expensive
SELECT product_id, product_name, unit_price,
(SELECT AVG(unit_price) from products) AS avg_unit_price,
unit_price - (SELECT AVG(unit_price) from products) AS diff_price
FROM products
ORDER BY unit_price DESC;

