-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 05_export_workforce_outputs.sql
-- Purpose: Export workforce overview results to CSV files
-- Author: Joana Inácio
-- ============================================================

-- ============================================================
-- 1. Export overall workforce KPIs
-- ============================================================

\copy (SELECT COUNT(*) AS total_employees, COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees, COUNT(*) FILTER (WHERE employee_status <> 'Active') AS inactive_employees, ROUND(COUNT(*) FILTER (WHERE employee_status = 'Active') * 100.0 / COUNT(*), 2) AS active_employee_percentage, ROUND(COUNT(*) FILTER (WHERE employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS inactive_employee_percentage, ROUND(AVG(current_employee_rating), 2) AS avg_employee_rating FROM employees) TO 'outputs/workforce_overall_kpis.csv' WITH CSV HEADER;

-- ============================================================
-- 2. Export headcount by department
-- ============================================================

\copy (SELECT department_type, COUNT(*) AS total_employees, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage FROM employees GROUP BY department_type ORDER BY total_employees DESC) TO 'outputs/headcount_by_department.csv' WITH CSV HEADER;

-- ============================================================
-- 3. Export performance distribution
-- ============================================================

\copy (SELECT performance_score, COUNT(*) AS total_employees, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage, ROUND(AVG(current_employee_rating), 2) AS avg_employee_rating FROM employees GROUP BY performance_score ORDER BY total_employees DESC) TO 'outputs/performance_distribution.csv' WITH CSV HEADER;

-- ============================================================
-- 4. Export active employees by department
-- ============================================================

\copy (SELECT department_type, COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees, COUNT(*) FILTER (WHERE employee_status <> 'Active') AS inactive_employees, COUNT(*) AS total_employees, ROUND(COUNT(*) FILTER (WHERE employee_status = 'Active') * 100.0 / COUNT(*), 2) AS active_percentage FROM employees GROUP BY department_type ORDER BY total_employees DESC) TO 'outputs/active_employees_by_department.csv' WITH CSV HEADER;

-- ============================================================
-- 5. Export employee type distribution
-- ============================================================

\copy (SELECT employee_type, COUNT(*) AS total_employees, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage FROM employees GROUP BY employee_type ORDER BY total_employees DESC) TO 'outputs/employee_type_distribution.csv' WITH CSV HEADER;