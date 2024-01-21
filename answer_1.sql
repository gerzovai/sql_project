-- otázka 1 --
/*Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?*/

SELECT 
	DISTINCT tigpspf.industry_branch,
	tigpspf2.payroll_year AS prev_year, 
	tigpspf.payroll_year AS curr_year,
	tigpspf2.average_value,
	tigpspf.average_value, 	 
	tigpspf.average_value - tigpspf2.average_value AS difference_value
FROM t_ivana_gerzova_project_sql_primary_final AS tigpspf 
JOIN t_ivana_gerzova_project_sql_primary_final AS tigpspf2 
	ON tigpspf.industry_branch = tigpspf2.industry_branch
	AND tigpspf.payroll_year = tigpspf2.payroll_year + 1
WHERE tigpspf.average_value - tigpspf2.average_value < 0
ORDER BY industry_branch, prev_year ;