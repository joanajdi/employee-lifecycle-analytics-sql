-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 10_engagement_analysis.sql
-- Purpose: Analyze employee engagement, satisfaction and work-life balance
-- Author: Joana Inácio
-- ============================================================

-- ============================================================
-- 1. Overall engagement KPIs
-- ============================================================

SELECT
    COUNT(*) AS total_survey_records,
    COUNT(DISTINCT employee_id) AS employees_with_survey,
    ROUND(AVG(engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction_score,
    ROUND(AVG(work_life_balance_score), 2) AS avg_work_life_balance_score,
    MIN(survey_date) AS first_survey_date,
    MAX(survey_date) AS last_survey_date
FROM engagement_surveys;

-- ============================================================
-- 2. Engagement score distribution
-- ============================================================

SELECT
    engagement_score,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM engagement_surveys
GROUP BY engagement_score
ORDER BY engagement_score;

-- ============================================================
-- 3. Satisfaction score distribution
-- ============================================================

SELECT
    satisfaction_score,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM engagement_surveys
GROUP BY satisfaction_score
ORDER BY satisfaction_score;

-- ============================================================
-- 4. Work-life balance score distribution
-- ============================================================

SELECT
    work_life_balance_score,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM engagement_surveys
GROUP BY work_life_balance_score
ORDER BY work_life_balance_score;

-- ============================================================
-- 5. Engagement by department
-- ============================================================

SELECT
    e.department_type,
    COUNT(*) AS total_employees,
    ROUND(AVG(s.engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score,
    ROUND(AVG(s.work_life_balance_score), 2) AS avg_work_life_balance_score
FROM engagement_surveys s
JOIN employees e
    ON s.employee_id = e.employee_id
GROUP BY e.department_type
ORDER BY avg_engagement_score DESC;

-- ============================================================
-- 6. Engagement by business unit
-- ============================================================

SELECT
    e.business_unit,
    COUNT(*) AS total_employees,
    ROUND(AVG(s.engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score,
    ROUND(AVG(s.work_life_balance_score), 2) AS avg_work_life_balance_score
FROM engagement_surveys s
JOIN employees e
    ON s.employee_id = e.employee_id
GROUP BY e.business_unit
ORDER BY avg_engagement_score DESC;

-- ============================================================
-- 7. Engagement by employee status
-- ============================================================

SELECT
    e.employee_status,
    COUNT(*) AS total_employees,
    ROUND(AVG(s.engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score,
    ROUND(AVG(s.work_life_balance_score), 2) AS avg_work_life_balance_score
FROM engagement_surveys s
JOIN employees e
    ON s.employee_id = e.employee_id
GROUP BY e.employee_status
ORDER BY avg_engagement_score DESC;

-- ============================================================
-- 8. Engagement by performance score
-- ============================================================

SELECT
    e.performance_score,
    COUNT(*) AS total_employees,
    ROUND(AVG(s.engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score,
    ROUND(AVG(s.work_life_balance_score), 2) AS avg_work_life_balance_score
FROM engagement_surveys s
JOIN employees e
    ON s.employee_id = e.employee_id
GROUP BY e.performance_score
ORDER BY avg_engagement_score DESC;

-- ============================================================
-- 9. Engagement segments
-- ============================================================

SELECT
    CASE
        WHEN engagement_score >= 4 THEN 'High Engagement'
        WHEN engagement_score = 3 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END AS engagement_segment,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction_score,
    ROUND(AVG(work_life_balance_score), 2) AS avg_work_life_balance_score
FROM engagement_surveys
GROUP BY
    CASE
        WHEN engagement_score >= 4 THEN 'High Engagement'
        WHEN engagement_score = 3 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END
ORDER BY total_employees DESC;

-- ============================================================
-- 10. Engagement segment by department
-- ============================================================

SELECT
    e.department_type,
    CASE
        WHEN s.engagement_score >= 4 THEN 'High Engagement'
        WHEN s.engagement_score = 3 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END AS engagement_segment,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY e.department_type), 2) AS percentage_within_department
FROM engagement_surveys s
JOIN employees e
    ON s.employee_id = e.employee_id
GROUP BY
    e.department_type,
    CASE
        WHEN s.engagement_score >= 4 THEN 'High Engagement'
        WHEN s.engagement_score = 3 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END
ORDER BY e.department_type, total_employees DESC;

-- ============================================================
-- 11. Engagement segment by employee status
-- ============================================================

SELECT
    e.employee_status,
    CASE
        WHEN s.engagement_score >= 4 THEN 'High Engagement'
        WHEN s.engagement_score = 3 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END AS engagement_segment,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY e.employee_status), 2) AS percentage_within_status
FROM engagement_surveys s
JOIN employees e
    ON s.employee_id = e.employee_id
GROUP BY
    e.employee_status,
    CASE
        WHEN s.engagement_score >= 4 THEN 'High Engagement'
        WHEN s.engagement_score = 3 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END
ORDER BY e.employee_status, total_employees DESC;

-- ============================================================
-- 12. Low engagement employees by department
-- ============================================================

SELECT
    e.department_type,
    COUNT(*) AS low_engagement_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage_of_all_low_engagement
FROM engagement_surveys s
JOIN employees e
    ON s.employee_id = e.employee_id
WHERE s.engagement_score <= 2
GROUP BY e.department_type
ORDER BY low_engagement_employees DESC;

-- ============================================================
-- 13. Average engagement by employee type
-- ============================================================

SELECT
    e.employee_type,
    COUNT(*) AS total_employees,
    ROUND(AVG(s.engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score,
    ROUND(AVG(s.work_life_balance_score), 2) AS avg_work_life_balance_score
FROM engagement_surveys s
JOIN employees e
    ON s.employee_id = e.employee_id
GROUP BY e.employee_type
ORDER BY avg_engagement_score DESC;

-- ============================================================
-- 14. Engagement, satisfaction and work-life balance by attrition flag
-- ============================================================

SELECT
    CASE
        WHEN e.employee_status = 'Active' THEN 'Active'
        ELSE 'Non-Active'
    END AS employee_status_group,
    COUNT(*) AS total_employees,
    ROUND(AVG(s.engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score,
    ROUND(AVG(s.work_life_balance_score), 2) AS avg_work_life_balance_score
FROM engagement_surveys s
JOIN employees e
    ON s.employee_id = e.employee_id
GROUP BY
    CASE
        WHEN e.employee_status = 'Active' THEN 'Active'
        ELSE 'Non-Active'
    END
ORDER BY avg_engagement_score DESC;