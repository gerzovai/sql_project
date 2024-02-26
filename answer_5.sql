-- otázka 5 --
/*Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
  projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?*/

WITH GDP_increase AS (
	SELECT 
		tigpssf.country,
		tigpssf2.`year`,
		ROUND((tigpssf2.GDP - tigpssf.GDP) / tigpssf.GDP * 100,2) AS GDP_increase 
	FROM t_ivana_gerzova_project_sql_secondary_final AS tigpssf
	JOIN t_ivana_gerzova_project_sql_secondary_final AS tigpssf2
		ON tigpssf.`year` + 1 = tigpssf2.`year` 
	WHERE tigpssf.country = 'Czech Republic'
		AND tigpssf2.country = 'Czech Republic'
),
prev_yearly_price AS (
	SELECT 
		DISTINCT average_value,
		ROUND(AVG(average_price),2) AS yearly_price,
		date_year
	FROM t_ivana_gerzova_project_sql_primary_final AS tigpspf	
	GROUP BY date_year
),	
curr_yearly_price AS (
	SELECT 
		DISTINCT average_value,
		ROUND(AVG(average_price),2) AS yearly_price,
		date_year
	FROM t_ivana_gerzova_project_sql_primary_final AS tigpspf 
	GROUP BY date_year 
),
yearly_price_increase AS (
	SELECT 
		cyp.date_year,
		ROUND((cyp.yearly_price - pyp.yearly_price) / pyp.yearly_price * 100,2) AS yearly_price_increase,
		ROUND((cyp.average_value - pyp.average_value) / pyp.average_value * 100,2) AS yearly_value_increase
	FROM prev_yearly_price AS pyp
	JOIN curr_yearly_price AS cyp
		ON pyp.date_year + 1 = cyp.date_year
)
SELECT 
	gi.`year`,
	gi.GDP_increase,
	ypi.date_year,
	ypi.yearly_price_increase, 
	ypi.yearly_value_increase,
	ypi2.date_year,
	ypi2.yearly_price_increase,
	ypi2.yearly_value_increase
FROM GDP_increase AS gi
JOIN yearly_price_increase AS ypi
	ON gi.`year` = ypi.date_year
JOIN yearly_price_increase AS ypi2
	ON gi.`year`+ 1 = ypi2.date_year
;