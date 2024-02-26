-- otázka 3 --
/*Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?*/

SELECT 
	tigpspf.category,
	ROUND(AVG(((tigpspf2.average_price - tigpspf.average_price) / tigpspf.average_price) * 100), 2) AS percentage_increase
FROM t_ivana_gerzova_project_sql_primary_final AS tigpspf 
JOIN t_ivana_gerzova_project_sql_primary_final AS tigpspf2 
	ON tigpspf.category = tigpspf2.category 
	AND tigpspf.date_year + 1  = tigpspf2.date_year
GROUP BY category 
ORDER BY percentage_increase ;