-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 17_cohort_early_attrition_analysis.sql
-- Purpose: Analyze employee cohorts and early attrition patterns
-- Author: Joana Inácio
-- ============================================================

\echo '============================================================'
\echo 'Cohort and Early Attrition Analysis'
\echo '============================================================'

-- ============================================================
-- 1. Validate final analytical view
-- ============================================================

\echo '1. Validate final analytical view'

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT employee_id) AS unique_employees
FROM employee_lifecycle_summary;

-- ============================================================
-- 2. Attrition by start year
-- ============================================================

\echo '2. Attrition by start year'

SELECT
    EXTRACT(YEAR FROM start_date)::INT AS start_year,
    COUNT(*) AS employees_started,
    COUNT(*) FILTER (WHERE termination_flag = 1) AS terminated_employees,
    ROUND(
        COUNT(*) FILTER (WHERE termination_flag = 1)::NUMERIC
        / COUNT(*) * 100,
        2
    ) AS termination_rate_pct
FROM employee_lifecycle_summary
GROUP BY EXTRACT(YEAR FROM start_date)
ORDER BY start_year;

-- ============================================================
-- 3. Attrition by start month
-- ============================================================

\echo '3. Attrition by start month'

SELECT
    DATE_TRUNC('month', start_date)::DATE AS start_month,
    COUNT(*) AS employees_started,
    COUNT(*) FILTER (WHERE termination_flag = 1) AS terminated_employees,
    ROUND(
        COUNT(*) FILTER (WHERE termination_flag = 1)::NUMERIC
        / COUNT(*) * 100,
        2
    ) AS termination_rate_pct
FROM employee_lifecycle_summary
GROUP BY DATE_TRUNC('month', start_date)
ORDER BY start_month;

-- ============================================================
-- 4. Early attrition overall
-- ============================================================

\echo '4. Early attrition overall'

WITH early_attrition_flags AS (
    SELECT
        employee_id,
        start_date,
        exit_date,
        termination_flag,
        CASE
            WHEN termination_flag = 1
                 AND exit_date IS NOT NULL
                 AND exit_date <= start_date + INTERVAL '6 months'
            THEN 1
            ELSE 0
        END AS early_attrition_6m_flag,
        CASE
            WHEN termination_flag = 1
                 AND exit_date IS NOT NULL
                 AND exit_date <= start_date + INTERVAL '12 months'
            THEN 1
            ELSE 0
        END AS early_attrition_12m_flag
    FROM employee_lifecycle_summary
)

SELECT
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE termination_flag = 1) AS terminated_employees,
    SUM(early_attrition_6m_flag) AS early_attrition_6m_employees,
    ROUND(
        SUM(early_attrition_6m_flag)::NUMERIC / COUNT(*) * 100,
        2
    ) AS early_attrition_6m_rate_pct,
    SUM(early_attrition_12m_flag) AS early_attrition_12m_employees,
    ROUND(
        SUM(early_attrition_12m_flag)::NUMERIC / COUNT(*) * 100,
        2
    ) AS early_attrition_12m_rate_pct
FROM early_attrition_flags;

-- ============================================================
-- 5. Early attrition by department
-- ============================================================

\echo '5. Early attrition by department'

WITH early_attrition_flags AS (
    SELECT
        employee_id,
        department_type,
        start_date,
        exit_date,
        termination_flag,
        CASE
            WHEN termination_flag = 1
                 AND exit_date IS NOT NULL
                 AND exit_date <= start_date + INTERVAL '6 months'
            THEN 1
            ELSE 0
        END AS early_attrition_6m_flag,
        CASE
            WHEN termination_flag = 1
                 AND exit_date IS NOT NULL
                 AND exit_date <= start_date + INTERVAL '12 months'
            THEN 1
            ELSE 0
        END AS early_attrition_12m_flag
    FROM employee_lifecycle_summary
)

SELECT
    department_type,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE termination_flag = 1) AS terminated_employees,
    ROUND(
        COUNT(*) FILTER (WHERE termination_flag = 1)::NUMERIC / COUNT(*) * 100,
        2
    ) AS termination_rate_pct,
    SUM(early_attrition_6m_flag) AS early_attrition_6m_employees,
    ROUND(
        SUM(early_attrition_6m_flag)::NUMERIC / COUNT(*) * 100,
        2
    ) AS early_attrition_6m_rate_pct,
    SUM(early_attrition_12m_flag) AS early_attrition_12m_employees,
    ROUND(
        SUM(early_attrition_12m_flag)::NUMERIC / COUNT(*) * 100,
        2
    ) AS early_attrition_12m_rate_pct
FROM early_attrition_flags
GROUP BY department_type
ORDER BY early_attrition_12m_rate_pct DESC;

-- ============================================================
-- 6. Early attrition by employee type
-- ============================================================

\echo '6. Early attrition by employee type'

WITH early_attrition_flags AS (
    SELECT
        employee_id,
        employee_type,
        start_date,
        exit_date,
        termination_flag,
        CASE
            WHEN termination_flag = 1
                 AND exit_date IS NOT NULL
                 AND exit_date <= start_date + INTERVAL '6 months'
            THEN 1
            ELSE 0
        END AS early_attrition_6m_flag,
        CASE
            WHEN termination_flag = 1
                 AND exit_date IS NOT NULL
                 AND exit_date <= start_date + INTERVAL '12 months'
            THEN 1
            ELSE 0
        END AS early_attrition_12m_flag
    FROM employee_lifecycle_summary
)

SELECT
    employee_type,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE termination_flag = 1) AS terminated_employees,
    ROUND(
        COUNT(*) FILTER (WHERE termination_flag = 1)::NUMERIC / COUNT(*) * 100,
        2
    ) AS termination_rate_pct,
    SUM(early_attrition_6m_flag) AS early_attrition_6m_employees,
    ROUND(
        SUM(early_attrition_6m_flag)::NUMERIC / COUNT(*) * 100,
        2
    ) AS early_attrition_6m_rate_pct,
    SUM(early_attrition_12m_flag) AS early_attrition_12m_employees,
    ROUND(
        SUM(early_attrition_12m_flag)::NUMERIC / COUNT(*) * 100,
        2
    ) AS early_attrition_12m_rate_pct
FROM early_attrition_flags
GROUP BY employee_type
ORDER BY early_attrition_12m_rate_pct DESC;

-- ============================================================
-- 7. Early attrition by performance score
-- ============================================================

\echo '7. Early attrition by performance score'

WITH early_attrition_flags AS (
    SELECT
        employee_id,
        performance_score,
        start_date,
        exit_date,
        termination_flag,
        CASE
            WHEN termination_flag = 1
                 AND exit_date IS NOT NULL
                 AND exit_date <= start_date + INTERVAL '6 months'
            THEN 1
            ELSE 0
        END AS early_attrition_6m_flag,
        CASE
            WHEN termination_flag = 1
                 AND exit_date IS NOT NULL
                 AND exit_date <= start_date + INTERVAL '12 months'
            THEN 1
            ELSE 0
        END AS early_attrition_12m_flag
    FROM employee_lifecycle_summary
)

SELECT
    performance_score,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE termination_flag = 1) AS terminated_employees,
    ROUND(
        COUNT(*) FILTER (WHERE termination_flag = 1)::NUMERIC / COUNT(*) * 100,
        2
    ) AS termination_rate_pct,
    SUM(early_attrition_6m_flag) AS early_attrition_6m_employees,
    ROUND(
        SUM(early_attrition_6m_flag)::NUMERIC / COUNT(*) * 100,
        2
    ) AS early_attrition_6m_rate_pct,
    SUM(early_attrition_12m_flag) AS early_attrition_12m_employees,
    ROUND(
        SUM(early_attrition_12m_flag)::NUMERIC / COUNT(*) * 100,
        2
    ) AS early_attrition_12m_rate_pct
FROM early_attrition_flags
GROUP BY performance_score
ORDER BY early_attrition_12m_rate_pct DESC;

-- ============================================================
-- 8. Early attrition by engagement segment
-- ============================================================

\echo '8. Early attrition by engagement segment'

WITH early_attrition_flags AS (
    SELECT
        employee_id,
        engagement_segment,
        start_date,
        exit_date,
        termination_flag,
        CASE
            WHEN termination_flag = 1
                 AND exit_date IS NOT NULL
                 AND exit_date <= start_date + INTERVAL '6 months'
            THEN 1
            ELSE 0
        END AS early_attrition_6m_flag,
        CASE
            WHEN termination_flag = 1
                 AND exit_date IS NOT NULL
                 AND exit_date <= start_date + INTERVAL '12 months'
            THEN 1
            ELSE 0
        END AS early_attrition_12m_flag
    FROM employee_lifecycle_summary
)

SELECT
    engagement_segment,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE termination_flag = 1) AS terminated_employees,
    ROUND(
        COUNT(*) FILTER (WHERE termination_flag = 1)::NUMERIC / COUNT(*) * 100,
        2
    ) AS termination_rate_pct,
    SUM(early_attrition_6m_flag) AS early_attrition_6m_employees,
    ROUND(
        SUM(early_attrition_6m_flag)::NUMERIC / COUNT(*) * 100,
        2
    ) AS early_attrition_6m_rate_pct,
    SUM(early_attrition_12m_flag) AS early_attrition_12m_employees,
    ROUND(
        SUM(early_attrition_12m_flag)::NUMERIC / COUNT(*) * 100,
        2
    ) AS early_attrition_12m_rate_pct
FROM early_attrition_flags
GROUP BY engagement_segment
ORDER BY early_attrition_12m_rate_pct DESC;

-- ============================================================
-- 9. Early attrition by recruitment status
-- ============================================================

\echo '9. Early attrition by recruitment status'

WITH early_attrition_flags AS (
    SELECT
        employee_id,
        recruitment_status,
        start_date,
        exit_date,
        termination_flag,
        CASE
            WHEN termination_flag = 1
                 AND exit_date IS NOT NULL
                 AND exit_date <= start_date + INTERVAL '6 months'
            THEN 1
            ELSE 0
        END AS early_attrition_6m_flag,
        CASE
            WHEN termination_flag = 1
                 AND exit_date IS NOT NULL
                 AND exit_date <= start_date + INTERVAL '12 months'
            THEN 1
            ELSE 0
        END AS early_attrition_12m_flag
    FROM employee_lifecycle_summary
)

SELECT
    recruitment_status,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE termination_flag = 1) AS terminated_employees,
    ROUND(
        COUNT(*) FILTER (WHERE termination_flag = 1)::NUMERIC / COUNT(*) * 100,
        2
    ) AS termination_rate_pct,
    SUM(early_attrition_6m_flag) AS early_attrition_6m_employees,
    ROUND(
        SUM(early_attrition_6m_flag)::NUMERIC / COUNT(*) * 100,
        2
    ) AS early_attrition_6m_rate_pct,
    SUM(early_attrition_12m_flag) AS early_attrition_12m_employees,
    ROUND(
        SUM(early_attrition_12m_flag)::NUMERIC / COUNT(*) * 100,
        2
    ) AS early_attrition_12m_rate_pct
FROM early_attrition_flags
GROUP BY recruitment_status
ORDER BY early_attrition_12m_rate_pct DESC;