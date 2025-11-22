
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
  employee_id   INT PRIMARY KEY,
  employee_name VARCHAR(100),
  salary        INT,
  manager_id    INT
);

INSERT INTO employees (employee_id, employee_name, salary, manager_id) VALUES
	(1, 'Ava', 85000, NULL),
	(2, 'Bob', 72000, 1),
	(3, 'Cat', 59000, 1),
	(4, 'Dan', 85000, 2);
-- 1. View created employees
SELECT * FROM employees;
-- 2. Employees with the same salary
SELECT e1.employee_id, e1.employee_name, e1.salary, e2.employee_id, e2.employee_name, e2.salary
FROM employees e1 INNER JOIN employees e2
ON e1.salary = e2.salary
WHERE e1.employee_name <> e2.employee_name;

-- 3. Employee that have greater salary
SELECT e1.employee_id, e1.employee_name, e1.salary, e2.employee_id, e2.employee_name, e2.salary
FROM employees e1 INNER JOIN employees e2
ON e1.salary > e2.salary
ORDER BY e1.employee_id;

-- 4. Employees with their managers
SELECT e1.employee_id, e1.employee_name, e1.manager_id, e2.employee_name AS manager_name
FROM employees e1 LEFT JOIN employees e2
ON e1.manager_id = e2.employee_id;

-- 5. View the products table
SELECT * FROM products;

-- 6. Join the products table with itself so each candy is paired with a different candy
SELECT p1.product_name, p1.unit_price, p2.product_name, p2.unit_price
FROM products p1 INNER JOIN products p2
ON p1.product_id <> p2.product_id;

-- 7. Calculate the price difference, do a self join, and then return only price differences under 25c
SELECT p1.product_name, p1.unit_price, p2.product_name, p2.unit_price,
p1.unit_price - p2.unit_price AS price_diff
FROM products p1 INNER JOIN products p2
ON p1.product_id <> p2.product_id
WHERE ABS(p1.unit_price - p2.unit_price) < 0.25 -- (between -0.25 and 0.25) 
AND p1.product_name < p2.product_name -- (alphabetical order)
ORDER BY price_diff DESC;
