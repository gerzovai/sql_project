-- otázka 4 --
/*Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?*/

SELECT 
	tigpspf.payroll_year,
	tigpspf2.payroll_year,
	((tigpspf2.average_value - tigpspf.average_value) / tigpspf.average_value) * 100 AS percentage_increase_value, 
	AVG((tigpspf2.average_price - tigpspf.average_price) / tigpspf.average_price) * 100 AS percentage_increase_price,
	ROUND((AVG((tigpspf2.average_price - tigpspf.average_price) / tigpspf.average_price) * 100) - (((tigpspf2.average_value - tigpspf.average_value) / tigpspf.average_value) * 100), 2) AS increase_difference
FROM t_ivana_gerzova_project_sql_primary_final AS tigpspf 
JOIN t_ivana_gerzova_project_sql_primary_final AS tigpspf2  
	ON tigpspf.category = tigpspf2.category  
	AND tigpspf.date_year + 1  = tigpspf2.date_year
WHERE tigpspf.industry_branch IS NULL 
	AND tigpspf2.industry_branch IS NULL
GROUP BY tigpspf.payroll_year 
ORDER BY increase_difference DESC ;
