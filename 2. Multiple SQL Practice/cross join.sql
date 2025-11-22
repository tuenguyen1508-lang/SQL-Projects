-- Cross Join- returns all combinations of rows within two or more tables
DROP TABLE IF EXISTS tops;
CREATE TABLE tops (
    id INT,
    item VARCHAR(50)
);
DROP TABLE IF EXISTS sizes;
CREATE TABLE sizes (
    id INT,
    size VARCHAR(50)
);
DROP TABLE IF EXISTS outerwear;
CREATE TABLE outerwear (
    id INT,
    item VARCHAR(50)
);

INSERT INTO tops (id, item) VALUES
	(1, 'T-Shirt'),
	(2, 'Hoodie');
INSERT INTO sizes (id, size) VALUES
	(101, 'Small'),
	(102, 'Medium'),
	(103, 'Large');
INSERT INTO outerwear (id, item) VALUES
	(2, 'Hoodie'),
	(3, 'Jacket'),
	(4, 'Coat');
-- 1. View the 3 tables
SELECT * FROM tops;
SELECT * FROM sizes;
SELECT * FROM outerwear;

-- UNION & UNION ALL: Use a UNION to stack multiple tables or queries on top of one another, UNION removes duplicates why UNION ALL retains them
SELECT * FROM tops
UNION
SELECT * FROM outerwear;

-- UNION with different column names
SELECT * FROM happiness_scores;
SELECT * FROM happiness_scores_current;

SELECT year, country, happiness_score FROM happiness_scores
UNION 
SELECT 2024, country, ladder_score FROM happiness_scores_current;

-- Key takeaways
-- 1. A JOIN combines data from two or more tables based on related columns
-- 2. SELF JOIN and CROSS JOIN are additional JOIN options to use
-- SELF JOIN are usefull for side-by-side comparisons of rows within the same table
-- CROSS JOIN return all combination of rows within two or more tables, but are less commonly used
-- 3. UNION & UNION ALL (stack the results of 2 or more queries)

