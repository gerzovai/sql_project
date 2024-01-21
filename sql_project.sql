drop TABLE t_ivana_gerzova_project_SQL_primary_final;

-- primární tabulka --

CREATE TABLE t_ivana_gerzova_project_SQL_primary_final AS (
	WITH edit_czechia_payroll AS (	
		SELECT 
			round(avg(cp.value), 2) AS average_value,
			cpvt.name AS value_type,
			cpu.name AS unit,
			cpib.name AS industry_branch,
			cp.payroll_year
		FROM czechia_payroll AS cp 
		LEFT JOIN czechia_payroll_value_type AS cpvt
			ON cp.value_type_code = cpvt.code 
		LEFT JOIN czechia_payroll_unit AS cpu 
			ON cp.unit_code = cpu.code  
		LEFT JOIN czechia_payroll_industry_branch AS cpib 
			ON cp.industry_branch_code = cpib.code
		WHERE value_type_code = 5958
		GROUP BY industry_branch_code, payroll_year
	),
	edit_czechia_price AS (
		SELECT 
			cpc.name AS category,
			round(avg (cp2.value), 2) AS average_price,
			YEAR (cp2.date_from) AS date_year
		FROM czechia_price AS cp2 
		LEFT JOIN czechia_price_category AS cpc 
			ON cp2.category_code = cpc.code 
		LEFT JOIN czechia_region AS cr 
			ON cp2.region_code = cr.code
		WHERE cp2.region_code IS NULL 
		GROUP BY category, date_year
	)
	SELECT *
	FROM edit_czechia_payroll AS ecp
	CROSS JOIN edit_czechia_price AS ecp2
		ON ecp.payroll_year = ecp2.date_year
);
	
SELECT * FROM t_ivana_gerzova_project_sql_primary_final AS tigpspf;

-- sekundární tabulka --

CREATE TABLE t_ivana_gerzova_project_SQL_secondary_final AS (
	SELECT
		country,
		`year`,
		GDP,
		gini,
		population 
	FROM economies AS e
	WHERE `year` >= 2006
		AND `year` <= 2018
);
	

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
	AND tigpspf.category = tigpspf2.category 
	AND tigpspf.payroll_year = tigpspf2.payroll_year + 1
WHERE tigpspf.average_value - tigpspf2.average_value < 0
ORDER BY industry_branch, prev_year, difference_value ;
	
-- otázka 2 --
/*Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?*/

SELECT 
	industry_branch,
	category,
	payroll_year,
	average_value / average_price AS amount
FROM t_ivana_gerzova_project_sql_primary_final AS tigpspf 
WHERE (category LIKE 'Mléko%' OR category LIKE 'Chléb%')
	AND (payroll_year = 2006 OR payroll_year = 2018)
	AND industry_branch IS NOT NULL 
ORDER BY industry_branch, category ;

-- otázka 3 --
/*Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?*/

SELECT 
	tigpspf.category,
	avg(((tigpspf2.average_price - tigpspf.average_price) / tigpspf.average_price) * 100) AS percentage_increase
FROM t_ivana_gerzova_project_sql_primary_final AS tigpspf 
JOIN t_ivana_gerzova_project_sql_primary_final AS tigpspf2 
	ON tigpspf.category = tigpspf2.category 
	AND tigpspf.date_year + 1  = tigpspf2.date_year
GROUP BY category 
ORDER BY percentage_increase ;

-- otázka 4 --
/*Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?*/

SELECT 
	tigpspf.payroll_year,
	tigpspf2.payroll_year,
	((tigpspf2.average_value - tigpspf.average_value) / tigpspf.average_value ) * 100 AS percentage_increase_value, 
	avg ((tigpspf2.average_price - tigpspf.average_price) / tigpspf.average_price ) * 100 AS percentage_increase_price,
	(((tigpspf2.average_value - tigpspf.average_value) / tigpspf.average_value ) * 100) - (avg ((tigpspf2.average_price - tigpspf.average_price) / tigpspf.average_price ) * 100) AS increase_difference
FROM t_ivana_gerzova_project_sql_primary_final AS tigpspf 
JOIN t_ivana_gerzova_project_sql_primary_final AS tigpspf2  
	ON tigpspf.category = tigpspf2.category  
	AND tigpspf.date_year + 1  = tigpspf2.date_year
WHERE tigpspf.industry_branch IS NULL 
	AND tigpspf2.industry_branch IS NULL
GROUP BY tigpspf.payroll_year ;


-- otázka 5 --
/*Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
  projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?*/

WITH GDP_increase AS (
	SELECT 
		tigpssf.country,
		tigpssf2.`year`,
		round((tigpssf2.GDP - tigpssf.GDP) / tigpssf.GDP * 100,2) AS GDP_increase 
	FROM t_ivana_gerzova_project_sql_secondary_final AS tigpssf
	JOIN t_ivana_gerzova_project_sql_secondary_final AS tigpssf2
		ON tigpssf.`year` + 1 = tigpssf2.`year` 
	WHERE tigpssf.country = 'Czech Republic'
		AND tigpssf2.country = 'Czech Republic'
),
prev_yearly_price AS (
	SELECT 
		DISTINCT average_value,
		round (avg(average_price),2) AS yearly_price,
		date_year
	FROM t_ivana_gerzova_project_sql_primary_final AS tigpspf	
	GROUP BY date_year
),	
curr_yearly_price AS (
	SELECT 
		DISTINCT average_value,
		round(avg(average_price),2) AS yearly_price,
		date_year
	FROM t_ivana_gerzova_project_sql_primary_final AS tigpspf 
	GROUP BY date_year 
),
yearly_price_increase AS (
	SELECT 
		cyp.date_year,
		round((cyp.yearly_price - pyp.yearly_price) / pyp.yearly_price * 100,2) AS yearly_price_increase,
		round((cyp.average_value - pyp.average_value) / pyp.average_value * 100,2) AS yearly_value_increase
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




)

SELECT 
	cp.payroll_year,
	cp2.payroll_year,
	cp.value,
	cp2.value,
	cp.value - cp2.value AS year_diff
FROM czechia_payroll AS cp
JOIN czechia_payroll AS cp2 
	ON cp.industry_branch_code  = cp2.industry_branch_code  
	AND cp.payroll_year = cp2.payroll_year + 1
WHERE cp.value_type_code = 5958
	AND cp2.value_type_code = 5958
	AND cp.payroll_quarter = 4
	AND cp2.payroll_quarter = 4;


	
	
SELECT *,
	avg(value) 
FROM czechia_payroll
WHERE industry_branch_code = 'A'
	AND value_type_code = 5958
	AND payroll_year = 2018
	AND calculation_code = 100
GROUP BY payroll_year;


