-- primární tabulka --
/*
v základní payroll mám kody - přiřadit k nim popis
některé sloupce vynechat
vybrat jen potřebné sloupce a value_type_code omezit na 5958,
*/

zkusit propojit payroll a price podle DATA za rok, obe napřed zprůměrovat

drop TABLE t_ivana_gerzova_project_SQL_primary_final;
	
	
	
-- tabulka mezd--	
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
	
SELECT * FROM czechia_price_category AS cpc 
	
SELECT *
FROM t_ivana_gerzova_project_sql_primary_final AS tigpspf ;


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
;



-- otázka 1 --
/*
porovnám rok- (rok-1)
seřadit vzestupně podle rozdílu
*/
/*
SELECT 
	cp.payroll_year,
	cp2.payroll_year, 
	cp2.value - cp.value AS year_diff 
	*/

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

SELECT *
FROM czechia_payroll
WHERE value_type_code = 5958
	AND calculation_code = 200
	
	
SELECT *,
	avg(value) 
FROM czechia_payroll
WHERE industry_branch_code = 'A'
	AND value_type_code = 5958
	AND payroll_year = 2018
	AND calculation_code = 100
GROUP BY payroll_year;

SELECT * FROM czechia_price;

SELECT * FROM czechia_district AS cd;

SELECT * FROM czechia_payroll_value_type AS cpvt;
