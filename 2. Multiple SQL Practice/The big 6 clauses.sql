-- DISTINCT
SELECT DISTINCT grade_level
FROM student;
-- COUNT
SELECT COUNT(DISTINCT grade_level)
FROM students;
-- MAX and MIN
SELECT MAX(gpa) - MIN(gpa) AS gpa_range
FROM students;
-- AND
SELECT * FROM students
WHERE grade_level < 12 AND school_lunch = 'Yes';
-- IN
SELECT * FROM students
WHERE grade_level IN (10, 11, 12);
-- LIKE
SELECT * FROM students
WHERE email LIKE '%.com';

SELECT * FROM students
WHERE email LIKE '%.edu';
-- LIMIT
SELECT * FROM students
LIMIT 10;
-- SELECT WHEN-THEN
SELECT student_name, grade_level,
CASE WHEN grade_level = 9 THEN 'Freshman'
WHEN grade_level = 10 THEN 'Sophomore'
WHEN grade_level = 11 THEN 'Junior'
ELSE 'Senior' END AS grade_class
FROM students;

-- 2. The big 6
SELECT grade_level, AVG(gpa) AS avg_gpa
FROM students
WHERE school_lunch = 'Yes'
GROUP BY grade_level
HAVING avg_gpa > 3.3
ORDER BY grade_level;
 -- NULL
SELECT * FROM students
WHERE email is NOT NULL
-- ORDER BY


