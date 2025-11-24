-- 1. Duplicate values
CREATE TABLE employee_details (
    region VARCHAR(50),
    employee_name VARCHAR(50),
    salary INTEGER
);

INSERT INTO employee_details (region, employee_name, salary) VALUES
	('East', 'Ava', 85000),
	('East', 'Ava', 85000),
	('East', 'Bob', 72000),
	('East', 'Cat', 59000),
	('West', 'Cat', 63000),
	('West', 'Dan', 85000),
	('West', 'Eve', 72000),
	('West', 'Eve', 75000);

-- View the employee details table
SELECT * FROM employee_details;
-- View duplicate employees
SELECT employee_name, COUNT(employee_name) AS dup_count
FROM employee_details
GROUP BY employee_name
HAVING COUNT(employee_name) > 1;
-- View duplicate region+ employee combos
SELECT region, employee_name, COUNT(*) AS dup_count
FROM employee_details
GROUP BY region, employee_name
HAVING COUNT(*) > 1;
-- View fully duplicate rows
SELECT region, employee_name, salary, COUNT(*) AS dup_count
FROM employee_details
GROUP BY region, employee_name, salary
HAVING COUNT(*) > 1;
-- Exclude fully duplicate rows
SELECT DISTINCT region, employee_name, salary
FROM employee_details;
-- Exclude partially duplicate rows (unique employee name for each row)
SELECT * FROM (SELECT region, employee_name, salary,
ROW_NUMBER() OVER(PARTITION BY region, employee_name ORDER BY salary DESC) AS top_salary
FROM employee_details) AS ts
WHERE top_salary = 1;
-- Assignment 1: generate report of the students and their emails and exclude the duplicate student records
-- View the students data
SELECT * FROM students;
-- Create a column that counts the number of times a student appears in the table
WITH sc AS (SELECT id, student_name, email,
ROW_NUMBER () OVER(PARTITION BY student_name ORDER BY id DESC) AS student_count
FROM students)
SELECT * FROM sc
WHERE student_count = 1;

-- 2. MIN/MAX Value filtering
CREATE TABLE sales (
    id INT PRIMARY KEY,
    sales_rep VARCHAR(50),
    date DATE,
    sales INT
);

INSERT INTO sales (id, sales_rep, date, sales) VALUES 
    (1, 'Emma', '2024-08-01', 6),
    (2, 'Emma', '2024-08-02', 17),
    (3, 'Jack', '2024-08-02', 14),
    (4, 'Emma', '2024-08-04', 20),
    (5, 'Jack', '2024-08-05', 5),
    (6, 'Emma', '2024-08-07', 1);

-- View the sales table
SELECT * FROM sales;
-- Return the most recent sales date for each sales rep
SELECT sales_rep, MAX(date) AS most_recent_date
FROM sales
GROUP BY sales_rep;
-- Number of sales on most recent date
WITH rd AS (SELECT sales_rep, MAX(date) AS most_recent_date
FROM sales
GROUP BY sales_rep)
SELECT rd.sales_rep, rd.most_recent_date, s.sales  
FROM rd LEFT JOIN sales s
ON rd.sales_rep = s.sales_rep
AND rd.most_recent_date = s.date;
-- Window function approach
SELECT * FROM (SELECT sales_rep, date, sales,
ROW_NUMBER() OVER (PARTITION BY sales_rep ORDER BY date DESC) AS row_num
FROM sales) AS rn
WHERE row_num = 1;
-- Assignment 2: Create a report of each student with their highest grade for the sem, as well as which class it was in
-- View the students & student_grades tables
SELECT * FROM students;
SELECT * FROM student_grades;
-- For each student, return the classes they took and their final grades
SELECT s.id, s.student_name, sg.class_name, sg.final_grade
FROM students s LEFT JOIN student_grades sg
ON s.id = sg.student_id;
-- For each student, return their highest grade
SELECT s.id, s.student_name, MAX(sg.final_grade) AS top_grade
FROM students s INNER JOIN student_grades sg
ON s.id = sg.student_id
GROUP BY s.id, s.student_name
ORDER BY s.id;
-- Final GROUP BY + JOIN query
WITH tg AS (SELECT s.id, s.student_name, MAX(sg.final_grade) AS top_grade
FROM students s INNER JOIN student_grades sg
ON s.id = sg.student_id
GROUP BY s.id, s.student_name
ORDER BY s.id)
SELECT tg.id, tg.student_name, tg.top_grade, sg.class_name
FROM tg LEFT JOIN student_grades sg
ON tg.id = sg.student_id AND tg.top_grade = sg.final_grade;
-- Window function approach
-- Rank the student grades for each student
SELECT s.id, s.student_name, sg.class_name, sg.final_grade,
DENSE_RANK() OVER (PARTITION BY s.student_name ORDER BY sg.final_grade DESC) AS grade_rank
FROM students s LEFT JOIN student_grades sg
ON s.id = sg.student_id;
-- Final window function query
SELECT * FROM (SELECT s.id, s.student_name, sg.class_name, sg.final_grade,
DENSE_RANK() OVER (PARTITION BY s.student_name ORDER BY sg.final_grade DESC) AS grade_rank
FROM students s LEFT JOIN student_grades sg
ON s.id = sg.student_id) AS gr
WHERE grade_rank = 1;
-- 3. Pivoting
-- Transform rows into columns to summarize data
CREATE TABLE pizza_table (
    category VARCHAR(50),
    crust_type VARCHAR(50),
    pizza_name VARCHAR(100),
    price DECIMAL(5, 2)
);

INSERT INTO pizza_table (category, crust_type, pizza_name, price) VALUES
    ('Chicken', 'Gluten-Free Crust', 'California Chicken', 21.75),
    ('Chicken', 'Thin Crust', 'Chicken Pesto', 20.75),
    ('Classic', 'Standard Crust', 'Greek', 21.50),
    ('Classic', 'Standard Crust', 'Hawaiian', 19.50),
    ('Classic', 'Standard Crust', 'Pepperoni', 18.75),
    ('Supreme', 'Standard Crust', 'Spicy Italian', 22.75),
    ('Veggie', 'Thin Crust', 'Five Cheese', 18.50),
    ('Veggie', 'Thin Crust', 'Margherita', 19.50),
    ('Veggie', 'Gluten-Free Crust', 'Garden Delight', 21.50);

-- View the pizza table
SELECT * FROM pizza_table;
-- Create 1/0 columns
SELECT *,
CASE WHEN crust_type = 'Standard Crust' THEN 1 ELSE 0 END AS standard_crust,
CASE WHEN crust_type = 'Thin Crust' THEN 1 ELSE 0 END AS thin_crust,
CASE WHEN crust_type = 'Gluten-Free Crust' THEN 1 ELSE 0 END AS gluten_free_crust
FROM pizza_table;
-- A summary table of categories & pizza types
SELECT category,
SUM(CASE WHEN crust_type = 'Standard Crust' THEN 1 ELSE 0 END) AS standard_crust,
SUM(CASE WHEN crust_type = 'Thin Crust' THEN 1 ELSE 0 END) AS thin_crust,
SUM(CASE WHEN crust_type = 'Gluten-Free Crust' THEN 1 ELSE 0 END) AS gluten_free_crust
FROM pizza_table
GROUP BY category;
-- Assignment 3: Create a summary table that shows average grade for each department and grade level
-- View the column of interest
SELECT s.grade_level, sg.department, sg.final_grade
FROM students s LEFT JOIN student_grades sg
ON s.id = sg.student_id;
-- Pivot the grade_level column
SELECT sg.department, sg.final_grade,
CASE WHEN s.grade_level = 9 THEN 1 ELSE 0 END AS fresh_man,
CASE WHEN s.grade_level = 10 THEN 1 ELSE 0 END AS sophomore,
CASE WHEN s.grade_level = 11 THEN 1 ELSE 0 END AS junior,
CASE WHEN s.grade_level = 12 THEN 1 ELSE 0 END AS senior
FROM students s LEFT JOIN student_grades sg
ON s.id = sg.student_id;
-- Update the values to be final grades
SELECT sg.department, 
CASE WHEN s.grade_level = 9 THEN sg.final_grade ELSE 0 END AS fresh_man,
CASE WHEN s.grade_level = 10 THEN sg.final_grade ELSE 0 END AS sophomore,
CASE WHEN s.grade_level = 11 THEN sg.final_grade ELSE 0 END AS junior,
CASE WHEN s.grade_level = 12 THEN sg.final_grade ELSE 0 END AS senior
FROM students s LEFT JOIN student_grades sg
ON s.id = sg.student_id;
-- Create the final summary table
SELECT sg.department, 
ROUND(AVG(CASE WHEN s.grade_level = 9 THEN sg.final_grade END)) AS fresh_man,
ROUND(AVG(CASE WHEN s.grade_level = 10 THEN sg.final_grade END)) AS sophomore,
ROUND(AVG(CASE WHEN s.grade_level = 11 THEN sg.final_grade END)) AS junior,
ROUND(AVG(CASE WHEN s.grade_level = 12 THEN sg.final_grade END)) AS senior
FROM students s LEFT JOIN student_grades sg
ON s.id = sg.student_id
WHERE sg.department IS NOT NULL
GROUP BY sg.department
ORDER BY sg.department;
-- 4. Rolling calculations
-- Create a pizza orders table
CREATE TABLE pizza_orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    order_date DATE,
    pizza_name VARCHAR(100),
    price DECIMAL(5, 2)
);

INSERT INTO pizza_orders (order_id, customer_name, order_date, pizza_name, price) VALUES
    (1, 'Jack', '2024-12-01', 'Pepperoni', 18.75),
    (2, 'Jack', '2024-12-02', 'Pepperoni', 18.75),
    (3, 'Jack', '2024-12-03', 'Pepperoni', 18.75),
    (4, 'Jack', '2024-12-04', 'Pepperoni', 18.75),
    (5, 'Jack', '2024-12-05', 'Spicy Italian', 22.75),
    (6, 'Jill', '2024-12-01', 'Five Cheese', 18.50),
    (7, 'Jill', '2024-12-03', 'Margherita', 19.50),
    (8, 'Jill', '2024-12-05', 'Garden Delight', 21.50),
    (9, 'Jill', '2024-12-05', 'Greek', 21.50),
    (10, 'Tom', '2024-12-02', 'Hawaiian', 19.50),
    (11, 'Tom', '2024-12-04', 'Chicken Pesto', 20.75),
    (12, 'Tom', '2024-12-05', 'Spicy Italian', 22.75),
    (13, 'Jerry', '2024-12-01', 'California Chicken', 21.75),
    (14, 'Jerry', '2024-12-02', 'Margherita', 19.50),
    (15, 'Jerry', '2024-12-04', 'Greek', 21.50);
    
-- View the table
SELECT * FROM pizza_orders;
-- View the total sales for each customer on each date
SELECT customer_name, order_date, SUM(price) AS total_sales
FROM pizza_orders
GROUP BY customer_name, order_date;
-- Include the subtotals
SELECT customer_name, order_date, SUM(price) AS total_sales
FROM pizza_orders
GROUP BY customer_name, order_date WITH ROLLUP;
-- Calculate the total sale for each day
SELECT order_date, SUM(price) AS total_sales
FROM pizza_orders
GROUP BY order_date
ORDER BY order_date;
-- Calculate the cumulative sales over time
WITH ts AS (SELECT order_date, SUM(price) AS total_sales
FROM pizza_orders
GROUP BY order_date
ORDER BY order_date)
SELECT order_date,
SUM(total_sales) OVER(ORDER BY order_date) AS cumulative_sum
FROM ts;
-- View the happiness scores for each country, sorted by year
SELECT country, year, happiness_score
FROM happiness_scores
ORDER BY country, year;
-- Create a basic row number window function
SELECT country, year, happiness_score,
ROW_NUMBER() OVER(PARTITION BY country ORDER BY year) AS row_num
FROM happiness_scores
ORDER BY country, year;
-- Update the function to a moving average calculation
SELECT country, year, happiness_score,
ROUND(AVG(happiness_score) OVER(PARTITION BY country ORDER BY year
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 3) AS row_num
FROM happiness_scores
ORDER BY country, year;
-- Assignment 4: Generate a report that shows the total sales for each month, as well as the cumulative sum of sales
-- and the six-month moving average of sales
-- Calculate the total sales for each month
SELECT YEAR(o.order_date) AS year, MONTH(o.order_date) AS month, SUM(o.units * p.unit_price) AS total_sales
FROM orders o LEFT JOIN products p
ON o.product_id = p.product_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
ORDER BY YEAR(o.order_date), MONTH(o.order_date);
-- Add on the cumulative sales and 6 month moving average
WITH ms AS (SELECT YEAR(o.order_date) AS year, MONTH(o.order_date) AS month, SUM(o.units * p.unit_price) AS total_sales
FROM orders o LEFT JOIN products p
ON o.product_id = p.product_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
ORDER BY YEAR(o.order_date), MONTH(o.order_date))
SELECT *,
SUM(total_sales) OVER (ORDER BY year, month) AS cumulative_sales,
AVG(total_sales) OVER (ORDER BY year, month ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS six_month_ma
FROM ms;
-- 5. Key takeaways
-- Min/max value filtering: allows to filter data within each group
-- Pivoting transforms row values into columns to summarize data
-- Rolling calculations include subtotals, cumulative sums & moving averages
