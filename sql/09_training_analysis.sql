-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 08_training_analysis.sql
-- Purpose: Analyze training and development activity, cost and outcomes
-- Author: Joana Inácio
-- ============================================================

-- ============================================================
-- 1. Overall training KPIs
-- ============================================================

SELECT
    COUNT(*) AS total_training_records,
    COUNT(DISTINCT employee_id) AS employees_with_training,
    ROUND(AVG(training_duration_days), 2) AS avg_training_duration_days,
    ROUND(SUM(training_cost), 2) AS total_training_cost,
    ROUND(AVG(training_cost), 2) AS avg_training_cost
FROM training_development;

-- ============================================================
-- 2. Training outcome distribution
-- ============================================================

SELECT
    training_outcome,
    COUNT(*) AS total_trainings,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM training_development
GROUP BY training_outcome
ORDER BY total_trainings DESC;

-- ============================================================
-- 3. Training type distribution
-- ============================================================

SELECT
    training_type,
    COUNT(*) AS total_trainings,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage,
    ROUND(AVG(training_cost), 2) AS avg_training_cost,
    ROUND(AVG(training_duration_days), 2) AS avg_training_duration_days
FROM training_development
GROUP BY training_type
ORDER BY total_trainings DESC;

-- ============================================================
-- 4. Training program overview
-- ============================================================

SELECT
    training_program_name,
    COUNT(*) AS total_trainings,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage,
    ROUND(AVG(training_duration_days), 2) AS avg_training_duration_days,
    ROUND(SUM(training_cost), 2) AS total_training_cost,
    ROUND(AVG(training_cost), 2) AS avg_training_cost
FROM training_development
GROUP BY training_program_name
ORDER BY total_trainings DESC;

-- ============================================================
-- 5. Training outcome by program
-- ============================================================

SELECT
    training_program_name,
    training_outcome,
    COUNT(*) AS total_trainings,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY training_program_name), 2) AS percentage_within_program
FROM training_development
GROUP BY training_program_name, training_outcome
ORDER BY training_program_name, total_trainings DESC;

-- ============================================================
-- 6. Training cost by program and outcome
-- ============================================================

SELECT
    training_program_name,
    training_outcome,
    COUNT(*) AS total_trainings,
    ROUND(SUM(training_cost), 2) AS total_training_cost,
    ROUND(AVG(training_cost), 2) AS avg_training_cost
FROM training_development
GROUP BY training_program_name, training_outcome
ORDER BY training_program_name, total_training_cost DESC;

-- ============================================================
-- 7. Training timing relative to employee start date
-- ============================================================

SELECT
    CASE
        WHEN t.training_date < e.start_date THEN 'Before Start Date'
        ELSE 'On or After Start Date'
    END AS training_timing,
    COUNT(*) AS total_trainings,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage,
    ROUND(AVG(t.training_cost), 2) AS avg_training_cost,
    ROUND(AVG(t.training_duration_days), 2) AS avg_training_duration_days
FROM training_development t
JOIN employees e
    ON t.employee_id = e.employee_id
GROUP BY 
    CASE
        WHEN t.training_date < e.start_date THEN 'Before Start Date'
        ELSE 'On or After Start Date'
    END
ORDER BY total_trainings DESC;

-- ============================================================
-- 8. Training timing by training type
-- ============================================================

SELECT
    t.training_type,
    CASE
        WHEN t.training_date < e.start_date THEN 'Before Start Date'
        ELSE 'On or After Start Date'
    END AS training_timing,
    COUNT(*) AS total_trainings
FROM training_development t
JOIN employees e
    ON t.employee_id = e.employee_id
GROUP BY
    t.training_type,
    CASE
        WHEN t.training_date < e.start_date THEN 'Before Start Date'
        ELSE 'On or After Start Date'
    END
ORDER BY t.training_type, total_trainings DESC;

-- ============================================================
-- 9. Training by department
-- ============================================================

SELECT
    e.department_type,
    COUNT(*) AS total_trainings,
    COUNT(DISTINCT t.employee_id) AS employees_with_training,
    ROUND(SUM(t.training_cost), 2) AS total_training_cost,
    ROUND(AVG(t.training_cost), 2) AS avg_training_cost,
    ROUND(AVG(t.training_duration_days), 2) AS avg_training_duration_days
FROM training_development t
JOIN employees e
    ON t.employee_id = e.employee_id
GROUP BY e.department_type
ORDER BY total_training_cost DESC;

-- ============================================================
-- 10. Training outcome by department
-- ============================================================

SELECT
    e.department_type,
    t.training_outcome,
    COUNT(*) AS total_trainings,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY e.department_type), 2) AS percentage_within_department
FROM training_development t
JOIN employees e
    ON t.employee_id = e.employee_id
GROUP BY e.department_type, t.training_outcome
ORDER BY e.department_type, total_trainings DESC;

-- ============================================================
-- 11. Training outcome by performance score
-- ============================================================

SELECT
    e.performance_score,
    t.training_outcome,
    COUNT(*) AS total_trainings,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY e.performance_score), 2) AS percentage_within_performance_score
FROM training_development t
JOIN employees e
    ON t.employee_id = e.employee_id
GROUP BY e.performance_score, t.training_outcome
ORDER BY e.performance_score, total_trainings DESC;

-- ============================================================
-- 12. Training cost by performance score
-- ============================================================

SELECT
    e.performance_score,
    COUNT(*) AS total_trainings,
    ROUND(SUM(t.training_cost), 2) AS total_training_cost,
    ROUND(AVG(t.training_cost), 2) AS avg_training_cost,
    ROUND(AVG(t.training_duration_days), 2) AS avg_training_duration_days
FROM training_development t
JOIN employees e
    ON t.employee_id = e.employee_id
GROUP BY e.performance_score
ORDER BY total_training_cost DESC;

-- ============================================================
-- 13. Training by employee status
-- ============================================================

SELECT
    e.employee_status,
    COUNT(*) AS total_trainings,
    COUNT(DISTINCT t.employee_id) AS employees_with_training,
    ROUND(SUM(t.training_cost), 2) AS total_training_cost,
    ROUND(AVG(t.training_cost), 2) AS avg_training_cost
FROM training_development t
JOIN employees e
    ON t.employee_id = e.employee_id
GROUP BY e.employee_status
ORDER BY total_training_cost DESC;

-- ============================================================
-- 14. Top 10 employees by total training cost
-- ============================================================

SELECT
    t.employee_id,
    e.department_type,
    e.employee_status,
    e.performance_score,
    COUNT(*) AS total_trainings,
    ROUND(SUM(t.training_cost), 2) AS total_training_cost,
    ROUND(AVG(t.training_cost), 2) AS avg_training_cost
FROM training_development t
JOIN employees e
    ON t.employee_id = e.employee_id
GROUP BY
    t.employee_id,
    e.department_type,
    e.employee_status,
    e.performance_score
ORDER BY total_training_cost DESC
LIMIT 10;