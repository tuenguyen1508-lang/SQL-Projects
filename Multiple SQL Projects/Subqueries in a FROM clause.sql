-- 1. Subqueries in the FROM clause
SELECT * FROM happiness_scores;
-- 2. Average happiness_score for each country
SELECT country, AVG(happiness_score) AS avg_hs_by_country
FROM happiness_scores
GROUP BY country;

-- 3. Return a country's happiness_score for the year as well as the average happiness score for the country across years
SELECT hs.year, hs.country, hs.happiness_score,
country_hs.avg_hs_by_country
FROM happiness_scores hs LEFT JOIN
(SELECT country, AVG(happiness_score) AS avg_hs_by_country
FROM happiness_scores
GROUP BY country) AS country_hs
ON hs.country = country_hs.country;

-- 3. View only 1 country
SELECT hs.year, hs.country, hs.happiness_score,
country_hs.avg_hs_by_country
FROM happiness_scores hs LEFT JOIN
(SELECT country, AVG(happiness_score) AS avg_hs_by_country
FROM happiness_scores
GROUP BY country) AS country_hs
ON hs.country = country_hs.country
WHERE hs.country = 'United States';

-- 4. Multiple subqueries
-- Return happiness score for 2015-2024
SELECT DISTINCT year from happiness_scores;
SELECT * FROM happiness_scores_current;

SELECT year, country, happiness_score FROM happiness_scores
UNION ALL
SELECT 2024, country, ladder_score FROM happiness_scores_current;

-- Return a country's happiness score for the year as well as the average happiness score for the country accross
-- year

SELECT hs.year, hs.country, hs.happiness_score, country_hs.avg_hs_by_country
FROM (SELECT year, country, happiness_score FROM happiness_scores
UNION ALL
SELECT 2024, country, ladder_score FROM happiness_scores_current) AS hs
LEFT JOIN
(SELECT country, AVG(happiness_score) AS avg_hs_by_country FROM happiness_scores GROUP BY country) AS country_hs
ON hs.country = country_hs.country
WHERE happiness_score > avg_hs_by_country + 1;

-- Assignment: Review the products produced by each category. Generate a list of factories, along with the name
-- of the products they produce and the number of products they produce

-- Return all factories and products
SELECT factory, product_name
FROM products;

-- Return all factories and their total number of products
SELECT factory, COUNT(product_id) AS num_products
FROM products
GROUP BY factory;

-- Final queries with subqueries
SELECT fp.factory, fp.product_name, fn.num_products FROM
(SELECT factory, product_name
FROM products) fp
LEFT JOIN
(SELECT factory, COUNT(product_id) AS num_products
FROM products
GROUP BY factory) fn 
ON fp.factory= fn.factory
ORDER BY fp.factory, fp.product_name;