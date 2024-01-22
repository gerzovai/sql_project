-- otázka 2 --
/*Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?*/

SELECT 
	industry_branch,
	category,
	payroll_year,
	floor( average_value / average_price) AS amount
FROM t_ivana_gerzova_project_sql_primary_final AS tigpspf 
WHERE (category LIKE 'Mléko%' OR category LIKE 'Chléb%')
	AND (payroll_year = 2006 OR payroll_year = 2018)
	AND industry_branch IS NOT NULL 
ORDER BY industry_branch, category ;