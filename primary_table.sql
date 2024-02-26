CREATE TABLE t_ivana_gerzova_project_SQL_primary_final AS (
	WITH edit_czechia_payroll AS (	
		SELECT 
			ROUND (AVG(cp.value), 2) AS average_value,
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
			ROUND (AVG(cp2.value), 2) AS average_price,
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