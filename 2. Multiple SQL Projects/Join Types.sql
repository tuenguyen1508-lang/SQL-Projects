-- Basic JOIN options include INNER JOIN, LEFT JOIN, RIGHT JOIN and FULL OUTER JOIN
SELECT * FROM happiness_scores hs
INNER JOIN country_stats cs
ON hs.country = cs.country;

SELECT * FROM happiness_scores;

SELECT
  hs.year,
  hs.country,
  hs.happiness_score,
  cs.continent
FROM happiness_scores AS hs
INNER JOIN country_stats AS cs
  ON hs.country = cs.country;
-- LEFT JOIN
SELECT
  hs.year,
  hs.country,
  hs.happiness_score,
  cs.continent
FROM happiness_scores AS hs
LEFT JOIN country_stats AS cs
ON hs.country = cs.country
WHERE cs.country IS NULL;

-- RIGHT JOIN
SELECT
  hs.year,
  hs.country,
  hs.happiness_score,
  cs.continent
FROM happiness_scores AS hs
RIGHT JOIN country_stats AS cs
ON hs.country = cs.country
WHERE hs.country IS NULL;
-- Display country that exist in happiness_scores table but not in country_stats table
SELECT DISTINCT hs.country
FROM happiness_scores AS hs
LEFT JOIN country_stats AS cs
ON hs.country = cs.country
WHERE cs.country IS NULL;