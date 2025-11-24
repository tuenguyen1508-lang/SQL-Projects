-- What schools do MLB players attend?
-- How much do teams spend on player salaries
-- What does each player's career look like
-- how do player attributes compare
SELECT * FROM players;
SELECT * FROM salaries;
SELECT * FROM schools;
SELECT * FROM school_details;
-- Task 1: School analysis
-- a) In each decade, how many schools were there that produced MLB players?
SELECT ROUND(yearID, -1) AS decade, COUNT(DISTINCT schoolID) AS num_schools
FROM schools
GROUP BY decade
ORDER BY decade;
-- b) What are the names of the top 5 schools that produced the most players?
SELECT sd.name_full, COUNT(DISTINCT s.playerID) AS num_players
FROM schools s LEFT JOIN school_details sd
ON s.schoolID = sd.schoolID
GROUP BY s.schoolID
ORDER BY num_players DESC
LIMIT 5;
-- c) For each decade, what were the names of the top 3 schools that produced the most players
WITH ds AS (SELECT ROUND(s.yearID, -1) AS decade, sd.name_full, COUNT(DISTINCT s.playerID) AS num_players
FROM schools s LEFT JOIN school_details sd
ON s.schoolID = sd.schoolID
GROUP BY decade, s.schoolID),
rn AS (SELECT decade, name_full, num_players,
ROW_NUMBER() OVER(PARTITION BY decade ORDER BY num_players DESC) AS row_num
FROM ds)
SELECT decade, name_full, num_players
FROM rn
WHERE row_num <= 3
ORDER BY decade DESC, row_num;
-- Task 2: 	Salary analysis
-- a) Return the top 20% of teams in terms of average annual spending
WITH ts AS (SELECT teamID, yearID, SUM(salary) AS total_spend
FROM salaries
GROUP BY teamID, yearID
ORDER BY teamID, yearID),
sp AS (SELECT teamID, AVG(total_spend) AS avg_spend,
NTILE(5) OVER (ORDER BY AVG(total_spend) DESC) AS spend_pct
FROM ts
GROUP BY teamID)
SELECT teamID, ROUND(avg_spend/ 1000000, 1) AS avg_spend_millions
FROM sp
WHERE spend_pct = 1;
-- b) For each team, show the cumulative sum of spending over the years
WITH ts AS (SELECT teamID, yearID, SUM(salary) AS total_spend
FROM salaries
GROUP BY teamID, yearID
ORDER BY teamID, yearID)
SELECT teamID, yearID,
ROUND(SUM(total_spend) OVER (PARTITION BY teamID ORDER BY yearID) / 1000000, 1) AS cumulative_sum_millions
FROM ts;
-- c) Return the first year that each team's cumulative spending surpassed 1 billion
WITH ts AS (SELECT teamID, yearID, SUM(salary) AS total_spend
FROM salaries
GROUP BY teamID, yearID
ORDER BY teamID, yearID),
cs AS (SELECT teamID, yearID,
SUM(total_spend) OVER (PARTITION BY teamID ORDER BY yearID) AS cumulative_sum
FROM ts),
rn AS (SELECT teamID, yearID, cumulative_sum,
ROW_NUMBER() OVER (PARTITION BY teamID ORDER BY cumulative_sum) AS rn
FROM cs
WHERE cumulative_sum > 1000000000)
SELECT teamID, yearID, ROUND(cumulative_sum / 1000000000, 2) AS cumulative_sum_billions
FROM rn
WHERE rn = 1;
-- Task 3: Player career analysis
-- a) For each player, calculate their age at their first (debut) game, their last game, and their career length (all in years). Sort from longest career to shortest career.
SELECT nameGiven, 
TIMESTAMPDIFF(YEAR, CAST(CONCAT(birthYear, '-', birthMonth, '-', birthDay) AS DATE), debut) as starting_age,
TIMESTAMPDIFF(YEAR, CAST(CONCAT(birthYear, '-', birthMonth, '-', birthDay) AS DATE), finalGame) as end_age,
TIMESTAMPDIFF(YEAR, debut, finalGame) as career_length
FROM players
ORDER BY career_length DESC;
-- b) What team did each player play on for their starting and ending years?
SELECT p.nameGiven, 
s.yearID AS starting_year, s.teamID AS starting_team,
e.yearID AS ending_year, e.teamID AS ending_team
FROM players p INNER JOIN salaries s
ON p.playerID = s.playerID
AND YEAR(p.debut) = s.yearID
INNER JOIN salaries e
ON p.playerID = e.playerID
AND YEAR(p.finalGame) = e.yearID;
-- c) How many players started and ended on the same team and also played for over a decade?
SELECT p.nameGiven, 
s.yearID AS starting_year, s.teamID AS starting_team,
e.yearID AS ending_year, e.teamID AS ending_team
FROM players p INNER JOIN salaries s
ON p.playerID = s.playerID
AND YEAR(p.debut) = s.yearID
INNER JOIN salaries e
ON p.playerID = e.playerID
AND YEAR(p.finalGame) = e.yearID
WHERE s.teamID = e.teamID AND e.yearID - s.yearID > 10;
-- Task 4: Player comparison analysis
-- a) Which players have the same birthday?
WITH bn AS (SELECT CAST(CONCAT(birthYear, '-', birthMonth, '-', birthDay) AS DATE) AS birthdate, nameGiven
FROM players)
SELECT birthdate, GROUP_CONCAT(nameGiven SEPARATOR ', ') AS players
FROM bn
WHERE YEAR(birthdate) BETWEEN 1980 AND 1990
GROUP BY birthdate
ORDER BY birthdate;
-- b) Create a summary table that shows for each team, what percent of players bat right, left and both.
SELECT s.teamID,
ROUND(SUM(CASE WHEN p.bats = 'R' THEN 1 ELSE 0 END)  / COUNT(s.playerID)* 100, 1) AS bats_right,
ROUND(SUM(CASE WHEN p.bats = 'L' THEN 1 ELSE 0 END) / COUNT(s.playerID)* 100, 1) AS bats_left,
ROUND(SUM(CASE WHEN p.bats = 'B' THEN 1 ELSE 0 END) / COUNT(s.playerID)* 100, 1) AS bats_both
FROM salaries s LEFT JOIN players p
ON s.playerID = p.playerID
GROUP BY s.teamID;
-- c) How have average height and weight at debut game changed over the years, and what's the decade-over-decade difference?
WITH hw AS (SELECT ROUND(YEAR(debut), -1) AS decade, AVG(height) AS avg_height, AVG(weight) AS avg_weight
FROM players
GROUP BY decade
ORDER BY decade)
SELECT decade,
avg_height - LAG(avg_height) OVER(ORDER BY decade) AS height_diff,
avg_weight - LAG(avg_weight) OVER(ORDER BY decade) AS weight_diff
FROM hw
WHERE decade IS NOT NULL;