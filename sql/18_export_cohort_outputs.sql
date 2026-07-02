-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 18_export_cohort_outputs.sql
-- Purpose: Export cohort and early attrition analysis outputs
-- Author: Joana Inácio
-- ============================================================

\echo '============================================================'
\echo 'Exporting Cohort and Early Attrition Outputs'
\echo '============================================================'


-- ============================================================
-- 1. Attrition by start year
-- ============================================================

CREATE OR REPLACE TEMP VIEW tmp_attrition_by_start_year AS
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

\copy (SELECT * FROM tmp_attrition_by_start_year) TO 'outputs/attrition_by_start_year.csv' WITH CSV HEADER;


-- ============================================================
-- 2. Attrition by start month
-- ============================================================

CREATE OR REPLACE TEMP VIEW tmp_attrition_by_start_month AS
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

\copy (SELECT * FROM tmp_attrition_by_start_month) TO 'outputs/attrition_by_start_month.csv' WITH CSV HEADER;


-- ============================================================
-- 3. Early attrition overall
-- ============================================================

CREATE OR REPLACE TEMP VIEW tmp_early_attrition_overall AS
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
    ) AS early_attrition_12m_rate_pct,
    ROUND(
        SUM(early_attrition_6m_flag)::NUMERIC
        / NULLIF(COUNT(*) FILTER (WHERE termination_flag = 1), 0) * 100,
        2
    ) AS pct_terminated_within_6m,
    ROUND(
        SUM(early_attrition_12m_flag)::NUMERIC
        / NULLIF(COUNT(*) FILTER (WHERE termination_flag = 1), 0) * 100,
        2
    ) AS pct_terminated_within_12m
FROM early_attrition_flags;

\copy (SELECT * FROM tmp_early_attrition_overall) TO 'outputs/early_attrition_overall.csv' WITH CSV HEADER;


-- ============================================================
-- 4. Early attrition by department
-- ============================================================

CREATE OR REPLACE TEMP VIEW tmp_early_attrition_by_department AS
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

\copy (SELECT * FROM tmp_early_attrition_by_department) TO 'outputs/early_attrition_by_department.csv' WITH CSV HEADER;


-- ============================================================
-- 5. Early attrition by employee type
-- ============================================================

CREATE OR REPLACE TEMP VIEW tmp_early_attrition_by_employee_type AS
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

\copy (SELECT * FROM tmp_early_attrition_by_employee_type) TO 'outputs/early_attrition_by_employee_type.csv' WITH CSV HEADER;


-- ============================================================
-- 6. Early attrition by performance score
-- ============================================================

CREATE OR REPLACE TEMP VIEW tmp_early_attrition_by_performance_score AS
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

\copy (SELECT * FROM tmp_early_attrition_by_performance_score) TO 'outputs/early_attrition_by_performance_score.csv' WITH CSV HEADER;


-- ============================================================
-- 7. Early attrition by engagement segment
-- ============================================================

CREATE OR REPLACE TEMP VIEW tmp_early_attrition_by_engagement_segment AS
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

\copy (SELECT * FROM tmp_early_attrition_by_engagement_segment) TO 'outputs/early_attrition_by_engagement_segment.csv' WITH CSV HEADER;


-- ============================================================
-- 8. Early attrition by recruitment status
-- ============================================================

CREATE OR REPLACE TEMP VIEW tmp_early_attrition_by_recruitment_status AS
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

\copy (SELECT * FROM tmp_early_attrition_by_recruitment_status) TO 'outputs/early_attrition_by_recruitment_status.csv' WITH CSV HEADER;


\echo '============================================================'
\echo 'Cohort and early attrition outputs exported successfully.'
\echo '============================================================'