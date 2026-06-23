-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 06_recruitment_funnel.sql
-- Purpose: Analyze the recruitment pipeline and applicant characteristics
-- Author: Joana Inácio
-- ============================================================

-- ============================================================
-- 1. Overall recruitment KPIs
-- ============================================================

SELECT
    COUNT(*) AS total_applicants,
    ROUND(AVG(years_of_experience), 2) AS avg_years_of_experience,
    ROUND(AVG(desired_salary), 2) AS avg_desired_salary,
    MIN(application_date) AS first_application_date,
    MAX(application_date) AS last_application_date
FROM recruitment;

-- ============================================================
-- 2. Recruitment status distribution
-- ============================================================

SELECT
    status,
    COUNT(*) AS total_applicants,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM recruitment
GROUP BY status
ORDER BY total_applicants DESC;

-- ============================================================
-- 3. Applicant experience by recruitment status
-- ============================================================

SELECT
    status,
    COUNT(*) AS total_applicants,
    ROUND(AVG(years_of_experience), 2) AS avg_years_of_experience,
    MIN(years_of_experience) AS min_years_of_experience,
    MAX(years_of_experience) AS max_years_of_experience
FROM recruitment
GROUP BY status
ORDER BY avg_years_of_experience DESC;

-- ============================================================
-- 4. Desired salary by recruitment status
-- ============================================================

SELECT
    status,
    COUNT(*) AS total_applicants,
    ROUND(AVG(desired_salary), 2) AS avg_desired_salary,
    MIN(desired_salary) AS min_desired_salary,
    MAX(desired_salary) AS max_desired_salary
FROM recruitment
GROUP BY status
ORDER BY avg_desired_salary DESC;

-- ============================================================
-- 5. Desired salary by education level
-- ============================================================

SELECT
    education_level,
    COUNT(*) AS total_applicants,
    ROUND(AVG(years_of_experience), 2) AS avg_years_of_experience,
    ROUND(AVG(desired_salary), 2) AS avg_desired_salary
FROM recruitment
GROUP BY education_level
ORDER BY avg_desired_salary DESC;

-- ============================================================
-- 6. Desired salary by job title
-- ============================================================

SELECT
    job_title,
    COUNT(*) AS total_applicants,
    ROUND(AVG(years_of_experience), 2) AS avg_years_of_experience,
    ROUND(AVG(desired_salary), 2) AS avg_desired_salary
FROM recruitment
GROUP BY job_title
ORDER BY avg_desired_salary DESC;

-- ============================================================
-- 7. Applications by month
-- ============================================================

SELECT
    DATE_TRUNC('month', application_date)::DATE AS application_month,
    COUNT(*) AS total_applications
FROM recruitment
GROUP BY DATE_TRUNC('month', application_date)
ORDER BY application_month;

-- ============================================================
-- 8. Recruitment status by job title
-- ============================================================

SELECT
    job_title,
    status,
    COUNT(*) AS total_applicants
FROM recruitment
GROUP BY job_title, status
ORDER BY job_title, total_applicants DESC;

-- ============================================================
-- 9. Hired applicants by job title
-- ============================================================

SELECT
    job_title,
    COUNT(*) AS hired_applicants
FROM recruitment
WHERE status = 'Hired'
GROUP BY job_title
ORDER BY hired_applicants DESC;

-- ============================================================
-- 10. Applicant-to-employee match check
-- ============================================================

SELECT
    COUNT(*) AS applicants_matching_employee_records
FROM recruitment r
JOIN employees e
    ON r.applicant_id = e.employee_id;

-- ============================================================
-- 11. Job titles with at least 10 applicants
-- ============================================================

SELECT
    job_title,
    COUNT(*) AS total_applicants,
    ROUND(AVG(years_of_experience), 2) AS avg_years_of_experience,
    ROUND(AVG(desired_salary), 2) AS avg_desired_salary
FROM recruitment
GROUP BY job_title
HAVING COUNT(*) >= 10
ORDER BY avg_desired_salary DESC;

-- ============================================================
-- 12. Monthly applications by recruitment status
-- ============================================================

SELECT
    DATE_TRUNC('month', application_date)::DATE AS application_month,
    status,
    COUNT(*) AS total_applications
FROM recruitment
GROUP BY DATE_TRUNC('month', application_date), status
ORDER BY application_month, status;