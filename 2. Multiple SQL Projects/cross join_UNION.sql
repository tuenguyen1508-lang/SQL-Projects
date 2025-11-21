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
