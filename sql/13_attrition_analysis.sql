-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 12_attrition_analysis.sql
-- Purpose: Analyze employee attrition and retention patterns
-- Author: Joana Inácio
-- ============================================================

-- ============================================================
-- 1. Overall attrition KPIs
-- ============================================================

SELECT
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees,
    COUNT(*) FILTER (WHERE employee_status <> 'Active') AS non_active_employees,
    COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees,
    COUNT(*) FILTER (WHERE employee_status = 'Voluntarily Terminated') AS voluntarily_terminated_employees,
    COUNT(*) FILTER (WHERE employee_status = 'Terminated for Cause') AS terminated_for_cause_employees,
    ROUND(COUNT(*) FILTER (WHERE employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate,
    ROUND(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate,
    ROUND(COUNT(*) FILTER (WHERE employee_status = 'Voluntarily Terminated') * 100.0 / COUNT(*), 2) AS voluntary_termination_rate,
    ROUND(COUNT(*) FILTER (WHERE employee_status = 'Terminated for Cause') * 100.0 / COUNT(*), 2) AS involuntary_termination_rate
FROM employees;

-- ============================================================
-- 2. Termination type distribution
-- ============================================================

SELECT
    employee_status,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM employees
WHERE employee_status <> 'Active'
GROUP BY employee_status
ORDER BY total_employees DESC;

-- ============================================================
-- 3. Attrition by department
-- ============================================================

SELECT
    department_type,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees,
    COUNT(*) FILTER (WHERE employee_status <> 'Active') AS non_active_employees,
    COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees,
    ROUND(COUNT(*) FILTER (WHERE employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate,
    ROUND(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate
FROM employees
GROUP BY department_type
ORDER BY termination_rate DESC;

-- ============================================================
-- 4. Voluntary vs involuntary termination by department
-- ============================================================

SELECT
    department_type,
    COUNT(*) FILTER (WHERE employee_status = 'Voluntarily Terminated') AS voluntary_terminations,
    COUNT(*) FILTER (WHERE employee_status = 'Terminated for Cause') AS involuntary_terminations,
    COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS total_terminations,
    ROUND(COUNT(*) FILTER (WHERE employee_status = 'Voluntarily Terminated') * 100.0 / NULLIF(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')), 0), 2) AS voluntary_share_of_terminations,
    ROUND(COUNT(*) FILTER (WHERE employee_status = 'Terminated for Cause') * 100.0 / NULLIF(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')), 0), 2) AS involuntary_share_of_terminations
FROM employees
GROUP BY department_type
ORDER BY total_terminations DESC;

-- ============================================================
-- 5. Attrition by business unit
-- ============================================================

SELECT
    business_unit,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees,
    COUNT(*) FILTER (WHERE employee_status <> 'Active') AS non_active_employees,
    COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees,
    ROUND(COUNT(*) FILTER (WHERE employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate,
    ROUND(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate
FROM employees
GROUP BY business_unit
ORDER BY termination_rate DESC;

-- ============================================================
-- 6. Attrition by employee type
-- ============================================================

SELECT
    employee_type,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees,
    COUNT(*) FILTER (WHERE employee_status <> 'Active') AS non_active_employees,
    COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees,
    ROUND(COUNT(*) FILTER (WHERE employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate,
    ROUND(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate
FROM employees
GROUP BY employee_type
ORDER BY termination_rate DESC;

-- ============================================================
-- 7. Attrition by pay zone
-- ============================================================

SELECT
    pay_zone,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees,
    COUNT(*) FILTER (WHERE employee_status <> 'Active') AS non_active_employees,
    COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees,
    ROUND(COUNT(*) FILTER (WHERE employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate,
    ROUND(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate
FROM employees
GROUP BY pay_zone
ORDER BY termination_rate DESC;

-- ============================================================
-- 8. Tenure analysis by employee status
-- ============================================================

SELECT
    employee_status,
    COUNT(*) AS total_employees,
    ROUND(AVG(
        CASE
            WHEN exit_date IS NOT NULL THEN exit_date - start_date
            ELSE CURRENT_DATE - start_date
        END
    ), 2) AS avg_tenure_days,
    ROUND(AVG(
        CASE
            WHEN exit_date IS NOT NULL THEN (exit_date - start_date) / 365.0
            ELSE (CURRENT_DATE - start_date) / 365.0
        END
    ), 2) AS avg_tenure_years
FROM employees
GROUP BY employee_status
ORDER BY avg_tenure_years DESC;

-- ============================================================
-- 9. Tenure analysis by department
-- ============================================================

SELECT
    department_type,
    COUNT(*) AS total_employees,
    ROUND(AVG(
        CASE
            WHEN exit_date IS NOT NULL THEN (exit_date - start_date) / 365.0
            ELSE (CURRENT_DATE - start_date) / 365.0
        END
    ), 2) AS avg_tenure_years,
    ROUND(AVG(
        CASE
            WHEN employee_status IN ('Voluntarily Terminated', 'Terminated for Cause') AND exit_date IS NOT NULL
                THEN (exit_date - start_date) / 365.0
        END
    ), 2) AS avg_tenure_years_terminated
FROM employees
GROUP BY department_type
ORDER BY avg_tenure_years_terminated ASC NULLS LAST;

-- ============================================================
-- 10. Attrition by performance score
-- ============================================================

SELECT
    performance_score,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees,
    COUNT(*) FILTER (WHERE employee_status <> 'Active') AS non_active_employees,
    COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees,
    ROUND(COUNT(*) FILTER (WHERE employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate,
    ROUND(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate,
    ROUND(AVG(current_employee_rating), 2) AS avg_employee_rating
FROM employees
GROUP BY performance_score
ORDER BY termination_rate DESC;

-- ============================================================
-- 11. Attrition by engagement segment
-- ============================================================

SELECT
    CASE
        WHEN s.engagement_score >= 4 THEN 'High Engagement'
        WHEN s.engagement_score = 3 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END AS engagement_segment,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE e.employee_status = 'Active') AS active_employees,
    COUNT(*) FILTER (WHERE e.employee_status <> 'Active') AS non_active_employees,
    COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees,
    ROUND(COUNT(*) FILTER (WHERE e.employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate,
    ROUND(COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate
FROM employees e
JOIN engagement_surveys s
    ON e.employee_id = s.employee_id
GROUP BY
    CASE
        WHEN s.engagement_score >= 4 THEN 'High Engagement'
        WHEN s.engagement_score = 3 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END
ORDER BY termination_rate DESC;

-- ============================================================
-- 12. Attrition by satisfaction score
-- ============================================================

SELECT
    s.satisfaction_score,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE e.employee_status = 'Active') AS active_employees,
    COUNT(*) FILTER (WHERE e.employee_status <> 'Active') AS non_active_employees,
    COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees,
    ROUND(COUNT(*) FILTER (WHERE e.employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate,
    ROUND(COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate
FROM employees e
JOIN engagement_surveys s
    ON e.employee_id = s.employee_id
GROUP BY s.satisfaction_score
ORDER BY s.satisfaction_score;

-- ============================================================
-- 13. Attrition by work-life balance score
-- ============================================================

SELECT
    s.work_life_balance_score,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE e.employee_status = 'Active') AS active_employees,
    COUNT(*) FILTER (WHERE e.employee_status <> 'Active') AS non_active_employees,
    COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees,
    ROUND(COUNT(*) FILTER (WHERE e.employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate,
    ROUND(COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate
FROM employees e
JOIN engagement_surveys s
    ON e.employee_id = s.employee_id
GROUP BY s.work_life_balance_score
ORDER BY s.work_life_balance_score;

-- ============================================================
-- 14. Attrition by training outcome
-- ============================================================

SELECT
    t.training_outcome,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE e.employee_status = 'Active') AS active_employees,
    COUNT(*) FILTER (WHERE e.employee_status <> 'Active') AS non_active_employees,
    COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees,
    ROUND(COUNT(*) FILTER (WHERE e.employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate,
    ROUND(COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate
FROM employees e
JOIN training_development t
    ON e.employee_id = t.employee_id
GROUP BY t.training_outcome
ORDER BY termination_rate DESC;

-- ============================================================
-- 15. Attrition by training timing
-- ============================================================

SELECT
    CASE
        WHEN t.training_date < e.start_date THEN 'Before Start Date'
        ELSE 'On or After Start Date'
    END AS training_timing,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE e.employee_status = 'Active') AS active_employees,
    COUNT(*) FILTER (WHERE e.employee_status <> 'Active') AS non_active_employees,
    COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees,
    ROUND(COUNT(*) FILTER (WHERE e.employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate,
    ROUND(COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate
FROM employees e
JOIN training_development t
    ON e.employee_id = t.employee_id
GROUP BY
    CASE
        WHEN t.training_date < e.start_date THEN 'Before Start Date'
        ELSE 'On or After Start Date'
    END
ORDER BY termination_rate DESC;

-- ============================================================
-- 16. Department risk summary
-- ============================================================

SELECT
    e.department_type,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate,
    ROUND(AVG(s.engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score,
    ROUND(AVG(s.work_life_balance_score), 2) AS avg_work_life_balance_score,
    ROUND(AVG(e.current_employee_rating), 2) AS avg_employee_rating,
    ROUND(AVG(t.training_cost), 2) AS avg_training_cost
FROM employees e
JOIN engagement_surveys s
    ON e.employee_id = s.employee_id
JOIN training_development t
    ON e.employee_id = t.employee_id
GROUP BY e.department_type
ORDER BY termination_rate DESC;