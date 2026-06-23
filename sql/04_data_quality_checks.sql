-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 03_data_quality_checks.sql
-- Purpose: Check data quality issues before analysis
-- Author: Joana Inácio
-- ============================================================

-- ============================================================
-- 1. Row count by table
-- ============================================================

SELECT 'employees' AS table_name, COUNT(*) AS total_rows FROM employees
UNION ALL
SELECT 'recruitment' AS table_name, COUNT(*) AS total_rows FROM recruitment
UNION ALL
SELECT 'engagement_surveys' AS table_name, COUNT(*) AS total_rows FROM engagement_surveys
UNION ALL
SELECT 'training_development' AS table_name, COUNT(*) AS total_rows FROM training_development;

-- ============================================================
-- 2. Check duplicate primary IDs
-- ============================================================

SELECT
    employee_id,
    COUNT(*) AS duplicate_count
FROM employees
GROUP BY employee_id
HAVING COUNT(*) > 1;

SELECT
    applicant_id,
    COUNT(*) AS duplicate_count
FROM recruitment
GROUP BY applicant_id
HAVING COUNT(*) > 1;

-- Engagement can have multiple surveys per employee in theory,
-- so here we check duplicate records by employee and survey date.

SELECT
    employee_id,
    survey_date,
    COUNT(*) AS duplicate_count
FROM engagement_surveys
GROUP BY employee_id, survey_date
HAVING COUNT(*) > 1;

-- Training can also have multiple records per employee,
-- so here we check duplicate records by employee, training date and program.

SELECT
    employee_id,
    training_date,
    training_program_name,
    COUNT(*) AS duplicate_count
FROM training_development
GROUP BY employee_id, training_date, training_program_name
HAVING COUNT(*) > 1;

-- ============================================================
-- 3. Check null values in important columns
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE employee_id IS NULL) AS null_employee_id,
    COUNT(*) FILTER (WHERE first_name IS NULL) AS null_first_name,
    COUNT(*) FILTER (WHERE last_name IS NULL) AS null_last_name,
    COUNT(*) FILTER (WHERE start_date IS NULL) AS null_start_date,
    COUNT(*) FILTER (WHERE employee_status IS NULL) AS null_employee_status,
    COUNT(*) FILTER (WHERE department_type IS NULL) AS null_department_type,
    COUNT(*) FILTER (WHERE performance_score IS NULL) AS null_performance_score,
    COUNT(*) FILTER (WHERE current_employee_rating IS NULL) AS null_current_employee_rating
FROM employees;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE applicant_id IS NULL) AS null_applicant_id,
    COUNT(*) FILTER (WHERE application_date IS NULL) AS null_application_date,
    COUNT(*) FILTER (WHERE education_level IS NULL) AS null_education_level,
    COUNT(*) FILTER (WHERE years_of_experience IS NULL) AS null_years_of_experience,
    COUNT(*) FILTER (WHERE desired_salary IS NULL) AS null_desired_salary,
    COUNT(*) FILTER (WHERE status IS NULL) AS null_status
FROM recruitment;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE employee_id IS NULL) AS null_employee_id,
    COUNT(*) FILTER (WHERE survey_date IS NULL) AS null_survey_date,
    COUNT(*) FILTER (WHERE engagement_score IS NULL) AS null_engagement_score,
    COUNT(*) FILTER (WHERE satisfaction_score IS NULL) AS null_satisfaction_score,
    COUNT(*) FILTER (WHERE work_life_balance_score IS NULL) AS null_work_life_balance_score
FROM engagement_surveys;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE employee_id IS NULL) AS null_employee_id,
    COUNT(*) FILTER (WHERE training_date IS NULL) AS null_training_date,
    COUNT(*) FILTER (WHERE training_program_name IS NULL) AS null_training_program_name,
    COUNT(*) FILTER (WHERE training_type IS NULL) AS null_training_type,
    COUNT(*) FILTER (WHERE training_outcome IS NULL) AS null_training_outcome,
    COUNT(*) FILTER (WHERE training_duration_days IS NULL) AS null_training_duration_days,
    COUNT(*) FILTER (WHERE training_cost IS NULL) AS null_training_cost
FROM training_development;

-- ============================================================
-- 4. Check date consistency
-- ============================================================

-- Employees with exit date before start date

SELECT
    employee_id,
    start_date,
    exit_date
FROM employees
WHERE exit_date IS NOT NULL
    AND exit_date < start_date;

-- Employees with date of birth after start date

SELECT
    employee_id,
    start_date,
    date_of_birth
FROM employees
WHERE date_of_birth > start_date;

-- Recruitment applications with date of birth after application date

SELECT
    applicant_id,
    date_of_birth,
    application_date
FROM recruitment
WHERE date_of_birth > application_date;

-- Training records before employee start date

SELECT 
    e.employee_id,
    t.training_date,
    e.start_date
FROM employees e
JOIN training_development t
    ON e.employee_id = t.employee_id
WHERE t.training_date < e.start_date;

CASE
    WHEN t.training_date < e.start_date THEN 'Before Start Date'
    ELSE 'After Start Date'
END AS training_timing

-- Survey records before employee start date

SELECT
    es.survey_id,
    e.employee_id,
    e.start_date,
    es.survey_date
FROM employees e
JOIN engagement_surveys es
    ON e.employee_id = es.employee_id
WHERE es.survey_date < e.start_date;

-- ============================================================
-- 5. Check referential integrity
-- ============================================================

-- Engagement records without matching employee

SELECT
    es.employee_id,
    es.survey_id
FROM engagement_surveys es
LEFT JOIN employees e
    ON es.employee_id = e.employee_id
WHERE e.employee_id IS NULL;

-- Training records without matching employee

SELECT 
    t.employee_id,
    t.training_id
FROM training_development t
LEFT JOIN employees e 
    ON t.employee_id = e.employee_id
WHERE e.employee_id IS NULL;

-- Recruitment applicants that do not match employees

SELECT 
    r.applicant_id
FROM recruitment r
LEFT JOIN employees e
    ON r.applicant_id = e.employee_id
WHERE e.employee_id IS NULL;

-- ============================================================
-- 6. Check categorical values
-- ============================================================

SELECT DISTINCT employee_status FROM employees ORDER BY employee_status;
SELECT DISTINCT employee_type FROM employees ORDER BY employee_type;
SELECT DISTINCT department_type FROM employees ORDER BY department_type;
SELECT DISTINCT performance_score FROM employees ORDER BY performance_score;
SELECT DISTINCT termination_type FROM employees ORDER BY termination_type;

SELECT DISTINCT status FROM recruitment ORDER BY status;
SELECT DISTINCT education_level FROM recruitment ORDER BY education_level;

SELECT DISTINCT training_type FROM training_development ORDER BY training_type;
SELECT DISTINCT training_outcome FROM training_development ORDER BY training_outcome;