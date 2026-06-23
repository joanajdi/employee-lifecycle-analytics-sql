-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 04_workforce_overview.sql
-- Purpose: Analyze the overall workforce composition
-- Author: Joana Inácio
-- ============================================================

-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 04_workforce_overview.sql
-- Purpose: Analyze the overall workforce composition
-- Author: Joana Inácio
-- ============================================================

-- ============================================================
-- 1. Overall workforce KPIs
-- ============================================================

SELECT
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees,
    COUNT(*) FILTER (WHERE employee_status <> 'Active') AS inactive_employees,
    ROUND(
        COUNT(*) FILTER (WHERE employee_status = 'Active') * 100.0 / COUNT(*), 
        2
    ) AS active_employee_percentage,
    ROUND(
        COUNT(*) FILTER (WHERE employee_status <> 'Active') * 100.0 / COUNT(*), 
        2
    ) AS inactive_employee_percentage,
    ROUND(AVG(current_employee_rating), 2) AS avg_employee_rating
FROM employees;

-- ============================================================
-- 2. Employee status distribution
-- ============================================================

SELECT
    employee_status,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM employees
GROUP BY employee_status
ORDER BY total_employees DESC;

-- ============================================================
-- 3. Headcount by department
-- ============================================================

SELECT
    department_type,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM employees
GROUP BY department_type
ORDER BY total_employees DESC;

-- ============================================================
-- 4. Active employees by department
-- ============================================================

SELECT
    department_type,
    COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees,
    COUNT(*) FILTER (WHERE employee_status <> 'Active') AS inactive_employees,
    COUNT(*) AS total_employees,
    ROUND(
        COUNT(*) FILTER (WHERE employee_status = 'Active') * 100.0 / COUNT(*),
        2
    ) AS active_percentage
FROM employees
GROUP BY department_type
ORDER BY total_employees DESC;

-- ============================================================
-- 5. Headcount by business unit
-- ============================================================

SELECT
    business_unit,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM employees
GROUP BY business_unit
ORDER BY total_employees DESC;

-- ============================================================
-- 6. Employee type distribution
-- ============================================================

SELECT
    employee_type,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM employees
GROUP BY employee_type
ORDER BY total_employees DESC;

-- ============================================================
-- 7. Pay zone distribution
-- ============================================================

SELECT
    pay_zone,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM employees
GROUP BY pay_zone
ORDER BY total_employees DESC;

-- ============================================================
-- 8. Gender distribution
-- ============================================================

SELECT
    gender_code,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM employees
GROUP BY gender_code
ORDER BY total_employees DESC;

-- ============================================================
-- 9. Performance score distribution
-- ============================================================

SELECT
    performance_score,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage,
    ROUND(AVG(current_employee_rating), 2) AS avg_employee_rating
FROM employees
GROUP BY performance_score
ORDER BY total_employees DESC;

-- ============================================================
-- 10. Average employee rating by department
-- ============================================================

SELECT
    department_type,
    COUNT(*) AS total_employees,
    ROUND(AVG(current_employee_rating), 2) AS avg_employee_rating
FROM employees
GROUP BY department_type
ORDER BY avg_employee_rating DESC;

-- ============================================================
-- 11. Average employee rating by business unit
-- ============================================================

SELECT
    business_unit,
    COUNT(*) AS total_employees,
    ROUND(AVG(current_employee_rating), 2) AS avg_employee_rating
FROM employees
GROUP BY business_unit
ORDER BY avg_employee_rating DESC;

-- ============================================================
-- 12. Workforce by department and employee type
-- ============================================================

SELECT
    department_type,
    employee_type,
    COUNT(*) AS total_employees
FROM employees
GROUP BY department_type, employee_type
ORDER BY department_type, total_employees DESC;

-- ============================================================
-- 13. Workforce by department and performance score
-- ============================================================

SELECT
    department_type,
    performance_score,
    COUNT(*) AS total_employees,
    ROUND(AVG(current_employee_rating), 2) AS avg_employee_rating
FROM employees
GROUP BY department_type, performance_score
ORDER BY department_type, total_employees DESC;