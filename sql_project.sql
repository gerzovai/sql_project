SELECT *
FROM czechia_payroll_value_type AS cpvt;

-- primární tabulka --
/*
v základní payroll mám kody - přiřadit k nim popis
některé sloupce vynechat
vybrat jen potřebné sloupce a value_type_code omezit na 5958,
*/

zkusit propojit payroll a price podle DATA za rok, obe napřed zprůměrovat

CREATE TABLE t_ivana_gerzova_project_SQL_primary_final AS
	(SELECT 
		cp.id,
		cp.value,
		cpvt.name AS value_type,
		cpu.name AS unit,
		cpc.name AS calculation,
		cpib.name AS industry_branch,
		cp.payroll_year,
		cp.payroll_quarter 
	FROM czechia_payroll AS cp 
	JOIN czechia_payroll_value_type AS cpvt
		ON cp.value_type_code = cpvt.code 
	JOIN czechia_payroll_unit AS cpu 
		ON cp.unit_code = cpu.code 
	JOIN czechia_payroll_calculation AS cpc 
		ON cp.calculation_code = cpc.code 
	JOIN czechia_payroll_industry_branch AS cpib 
		ON cp.industry_branch_code = cpib.code);

SELECT 
	cp.id,
	cp.value,
	cpc.name AS category,
	cp.date_from,
	cp.date_to,
	cr.name AS region
FROM czechia_price AS cp 
JOIN czechia_price_category AS cpc 
	ON cp.category_code = cpc.code 
JOIN czechia_region AS cr 
	ON cp.region_code = cr.code;
	
SELECT * FROM czechia_price_category AS cpc 
	
SELECT *
FROM t_ivana_gerzova_project_sql_primary_final AS tigpspf ;

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
	
	
SELECT * FROM czechia_payroll;

SELECT * FROM czechia_price;

SELECT * FROM czechia_district AS cd;
