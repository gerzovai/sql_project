CREATE TABLE t_ivana_gerzova_project_SQL_secondary_final AS (
	SELECT
		e.country,
		e.`year`,
		e.GDP,
		e.gini,
		e.population 
	FROM economies AS e
	JOIN countries AS c 
		ON e.country = c.country 
	WHERE e.`year` >= 2006
		AND e.`year` <= 2018
		AND c.continent = 'Europe'
);