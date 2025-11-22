-- Window functions are used to apply a function to a "window" of data. Windows are essentially groups of
-- rows of data
-- Different to GROUP BY
-- Aggregate functions collapse the rows in each group and apply a calculation
-- Window functions leave the rows as they are and apply calculations by window 

-- 1. Window function basic
SELECT country, year, happiness_score
ROW_NUMBER() OVER(PARTITION BY country) AS row_num
FROM happiness_scores
ORDER BY country, year;

-- Where the rows are ordered by happiness score
SELECT country, year, happiness_score,
ROW_NUMBER() OVER(PARTITION BY country ORDER BY happiness_score) AS row_num
FROM happiness_scores
ORDER BY country, row_num;

-- Assignment: Order report with customer, order and transaction IDs, would like to add additional column
-- that contains the transaction number for each customer as well
-- View the order table
SELECT * 
FROM orders;

-- View the column of interest
SELECT customer_id, order_id, order_date, transaction_id
FROM orders
ORDER BY customer_id, transaction_id;

-- For each customer, add a column for transaction number
SELECT customer_id, order_id, order_date, transaction_id,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY transaction_id) AS transaction_number
FROM orders
ORDER BY customer_id, transaction_number;

-- 3 different ways of numbering rows within a window:
-- ROW_NUMBER() gives every row a unique number
-- RANK() accounts for ties
-- DENSE_RANK() accounts for ties and leaves no missing numbers in between
-- 2. ROW_NUMBER vs RANK vs DENSE_RANK
CREATE TABLE baby_girl_names (
    name VARCHAR(50),
    babies INT);

INSERT INTO baby_girl_names (name, babies) VALUES
	('Olivia', 99),
	('Emma', 80),
	('Charlotte', 80),
	('Amelia', 75),
	('Sophia', 72),
	('Isabella', 70),
	('Ava', 70),
	('Mia', 64);
    
-- View the table
SELECT * FROM baby_girl_names;

-- Compare ROW_NUMER, RANK, DENSE_RANK
SELECT name, babies,
ROW_NUMBER() OVER(ORDER BY babies DESC) AS babies_rn,
RANK() OVER(ORDER BY babies DESC) AS babies_rank,
DENSE_RANK() OVER(ORDER BY babies DESC) AS babies_drank
FROM baby_girl_names;

-- Eg: which products are most popular within each order.
-- create a product rank field that returns a 1 for most popular product in an order.
-- 2 for second most
-- View the column of interest, use ROW_NUMBER
SELECT order_id, product_id, units,
ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY units DESC) AS product_rn
FROM orders
ORDER BY order_id, product_id;
-- Use Rank()
SELECT order_id, product_id, units,
RANK() OVER(PARTITION BY order_id ORDER BY units DESC) AS product_rank
FROM orders
ORDER BY order_id, product_rank;
-- Use Dense_Rank
SELECT order_id, product_id, units,
DENSE_RANK() OVER(PARTITION BY order_id ORDER BY units DESC) AS product_rank
FROM orders
ORDER BY order_id, product_rank;
-- Check the order ends with '44262'
SELECT order_id, product_id, units,
DENSE_RANK() OVER(PARTITION BY order_id ORDER BY units DESC) AS product_rank
FROM orders
WHERE order_id LIKE '%44262'
ORDER BY order_id, product_rank;

-- 3. FIRST_VALUE, LAST_VALUE, NTH_VALUE
CREATE TABLE baby_names (
    gender VARCHAR(10),
    name VARCHAR(50),
    babies INT);

INSERT INTO baby_names (gender, name, babies) VALUES
	('Female', 'Charlotte', 80),
	('Female', 'Emma', 82),
	('Female', 'Olivia', 99),
	('Male', 'James', 85),
	('Male', 'Liam', 110),
	('Male', 'Noah', 95);
    
-- View the table
SELECT * FROM baby_names;
-- FIRST_VALUE: extracts the first value in a window, in dequential row order
SELECT gender, name, babies,
FIRST_VALUE(name) OVER (PARTITION BY gender ORDER BY babies DESC) AS top_name
FROM baby_names;
-- LAST_VALUE: extracts the last value
-- NTH_VALUE: extracts the value at a specified position (returns the second name in each window)
-- NULL Values because the second value has not been encountered yet when scanning these first rows
SELECT gender, name, babies,
NTH_VALUE(name, 2) OVER (PARTITION BY gender ORDER BY babies DESC) AS second_name
FROM baby_names;
-- Return the 2nd most popular name for each gender
SELECT * FROM
(SELECT gender, name, babies,
NTH_VALUE(name, 2) OVER (PARTITION BY gender ORDER BY babies DESC) AS second_name
FROM baby_names) AS Sc
WHERE name = second_name;
-- Return the top_name for each gender
SELECT * FROM
(SELECT gender, name, babies,
FIRST_VALUE(name) OVER (PARTITION BY gender ORDER BY babies DESC) AS top_name
FROM baby_names) AS tn
WHERE name = top_name;

-- CTE Alternative
WITH top_name AS
(SELECT gender, name, babies,
FIRST_VALUE(name) OVER (PARTITION BY gender ORDER BY babies DESC) AS top_name
FROM baby_names) 
SELECT *
FROM top_name
WHERE name = top_name;

-- Alternatively using ROW_NUMBER
SELECT gender, name, babies,
ROW_NUMBER() OVER (PARTITION BY gender ORDER BY babies DESC) AS popularity
FROM baby_names;
-- Return the 2nd most popular for each gender
SELECT * FROM
(SELECT gender, name, babies,
ROW_NUMBER() OVER (PARTITION BY gender ORDER BY babies DESC) AS popularity
FROM baby_names) AS pop
WHERE popularity = 2;

-- Eg: a list of 2nd most popular product within each order
-- View the ranking
SELECT order_id, product_id, units,
DENSE_RANK() OVER(PARTITION BY order_id ORDER BY units DESC) AS product_rank
FROM orders
ORDER BY order_id, product_rank;

-- Add a column that contains the 2nd most popular product
-- Shows all rows, and labels which product is 2nd in each order
SELECT COUNT(*) FROM
(SELECT order_id, product_id, units,
NTH_VALUE(product_id, 2) OVER(PARTITION BY order_id ORDER BY units DESC) AS second_product
FROM orders
ORDER BY order_id, second_product) AS np;
-- Return the 2nd most popular product for each order
-- Shows only the rows where the product is the 2nd one in that order
SELECT COUNT(*) FROM
(SELECT order_id, product_id, units,
NTH_VALUE(product_id, 2) OVER(PARTITION BY order_id ORDER BY units DESC) AS second_product
FROM orders
ORDER BY order_id, second_product) AS sp
WHERE product_id = second_product;
-- Another way using DENSE_RANK
SELECT * FROM
(SELECT order_id, product_id, units,
DENSE_RANK() OVER(PARTITION BY order_id ORDER BY units DESC) AS product_rank
FROM orders
ORDER BY order_id, product_rank) AS pr
WHERE product_rank = 2;

-- 4. LEAD() and LAG(): allow to return the value from the next and previous row, respectively, within each window
-- Return the prior year's happiness score
SELECT country, year, happiness_score,
LAG(happiness_score) OVER(PARTITION BY country ORDER BY year) AS prior_happiness_score
FROM happiness_scores;
-- Return the difference between yearly scores
WITH hs_prior AS (SELECT country, year, happiness_score,
LAG(happiness_score) OVER(PARTITION BY country ORDER BY year) AS prior_happiness_score
FROM happiness_scores)
SELECT country, year, happiness_score, prior_happiness_score,
happiness_score - prior_happiness_score AS hs_change
FROM hs_prior;

-- Eg: produce a table that contains infor abt customer and their orders, the number of units in each order,
-- the change in units from order to order
-- View the column of interest
SELECT customer_id, order_id, product_id, transaction_id, order_date, units
FROM orders;
-- For each customer, return the total units within each order
SELECT customer_id, order_id, SUM(units) AS total_units
FROM orders
GROUP BY customer_id, order_id
ORDER BY customer_id;

-- Add on the transaction id to keep track of the order of the orders
SELECT customer_id, order_id, MIN(transaction_id) AS min_tid, SUM(units) AS total_units
FROM orders
GROUP BY customer_id, order_id
ORDER BY customer_id, min_tid;

-- Turn the column into CTE and view the columns of interest
WITH my_cte AS (SELECT customer_id, order_id, MIN(transaction_id) AS min_tid, SUM(units) AS total_units
FROM orders
GROUP BY customer_id, order_id
ORDER BY customer_id, min_tid)
SELECT customer_id, order_id, total_units FROM my_cte;

-- Create a prior unit column
WITH my_cte AS (SELECT customer_id, order_id, MIN(transaction_id) AS min_tid, SUM(units) AS total_units
FROM orders
GROUP BY customer_id, order_id
ORDER BY customer_id, min_tid)
SELECT customer_id, order_id, total_units,
LAG(total_units) OVER(PARTITION BY customer_id ORDER BY min_tid) AS prior_units
FROM my_cte;
-- For each customer, find the change in the units per order over time
WITH my_cte AS (SELECT customer_id, order_id, MIN(transaction_id) AS min_tid, SUM(units) AS total_units
FROM orders
GROUP BY customer_id, order_id
ORDER BY customer_id, min_tid),
prior_cte AS (SELECT customer_id, order_id, total_units,
LAG(total_units) OVER(PARTITION BY customer_id ORDER BY min_tid) AS prior_units
FROM my_cte)
SELECT customer_id, order_id, total_units, prior_units,
total_units - prior_units AS diff_units FROM prior_cte;

-- 5. NTILE() divides the rows in a window into a specified number of percentiles
-- View the top 25% of happiness score for each region
-- because we specified NTILE(4), the range of 100% of the rows in each window is divided into 4 groups of 25%
-- 1 representing the top percentile group, and 4 the bottom

-- Add a percentile to each row of data
SELECT region, country, happiness_score, 
NTILE(4) OVER(PARTITION BY region ORDER BY happiness_score DESC) AS hs_percentile
FROM happiness_scores
WHERE year = 2023
ORDER BY region, happiness_score DESC;

-- For each region, return the top 25% of countries, in terms of happiness score
WITH hs_pct AS (SELECT region, country, happiness_score, 
NTILE(4) OVER(PARTITION BY region ORDER BY happiness_score DESC) AS hs_percentile
FROM happiness_scores
WHERE year = 2023
)
SELECT * FROM hs_pct
WHERE hs_percentile = 1;

-- Eg: create a rewards program for top 1% of customer
-- pull a list of top 1% of customers in terms of how much they have spent
-- View the data from orders table
SELECT customer_id, product_id, units
FROM orders;
-- View the data from products table
SELECT product_id, unit_price
FROM products;

-- Combine the 2 tables
SELECT o.customer_id, o.product_id, o.units, p.unit_price
FROM orders o LEFT JOIN products p
ON o.product_id = p.product_id;
-- Calculate the total spending by each customer and sort the results from highest to lowest
SELECT o.customer_id, SUM(o.units * p.unit_price) AS total_spend
FROM orders o LEFT JOIN products p
ON o.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY total_spend DESC;
-- Turn the query into a CTE and apply the percentile calculation
WITH ts AS (SELECT o.customer_id, SUM(o.units * p.unit_price) AS total_spend
FROM orders o LEFT JOIN products p
ON o.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY total_spend DESC)
SELECT *,
NTILE(100) OVER(ORDER BY total_spend DESC) AS spend_pct
FROM ts;

-- Return the top 1% customers in terms of spending
WITH ts AS (SELECT o.customer_id, SUM(o.units * p.unit_price) AS total_spend
FROM orders o LEFT JOIN products p
ON o.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY total_spend DESC),
 sp AS (SELECT *,
NTILE(100) OVER(ORDER BY total_spend DESC) AS spend_pct
FROM ts)
SELECT * FROM sp
WHERE spend_pct = 1;
-- 6. Key takeaways
-- Window functions are used to apply a function accross windows of data
-- Windows refer to groups of rows in a table
-- Aggregate functions collapse the rows in each group, but window function leaves the rows untouched
-- The general syntax is FUNCTION OVER(PARTITION BY X ORDER BY Y)
-- (OVER: indicate we are writing a window function)
-- (PARTITION BY: states how we'd like to split up the rows into groups)
-- (ORDER BY: states how the rows within each window should be ordered before applying the function)
-- You can number rows with ROW_NUMBER(), RANK(), DENSE_RANK()
-- Identify values within a window with FIRST_VALUE(), LAST_VALUE(), NTH_VALUE()
-- Return values from relative rows with LEAD(), LAG()
-- Use NTILE() for making percentile calculations(25% = NTILE(4) - 100%:25%=4)

