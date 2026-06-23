-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 07_export_recruitment_outputs.sql
-- Purpose: Export recruitment funnel results to CSV files
-- Author: Joana Inácio
-- ============================================================

-- ============================================================
-- 1. Export overall recruitment KPIs
-- ============================================================

\copy (SELECT COUNT(*) AS total_applicants, ROUND(AVG(years_of_experience), 2) AS avg_years_of_experience, ROUND(AVG(desired_salary), 2) AS avg_desired_salary, MIN(application_date) AS first_application_date, MAX(application_date) AS last_application_date FROM recruitment) TO 'outputs/recruitment_overall_kpis.csv' WITH CSV HEADER;

-- ============================================================
-- 2. Export recruitment status distribution
-- ============================================================

\copy (SELECT status, COUNT(*) AS total_applicants, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage FROM recruitment GROUP BY status ORDER BY total_applicants DESC) TO 'outputs/recruitment_status_distribution.csv' WITH CSV HEADER;

-- ============================================================
-- 3. Export experience by recruitment status
-- ============================================================

\copy (SELECT status, COUNT(*) AS total_applicants, ROUND(AVG(years_of_experience), 2) AS avg_years_of_experience, MIN(years_of_experience) AS min_years_of_experience, MAX(years_of_experience) AS max_years_of_experience FROM recruitment GROUP BY status ORDER BY avg_years_of_experience DESC) TO 'outputs/experience_by_recruitment_status.csv' WITH CSV HEADER;

-- ============================================================
-- 4. Export salary by recruitment status
-- ============================================================

\copy (SELECT status, COUNT(*) AS total_applicants, ROUND(AVG(desired_salary), 2) AS avg_desired_salary, MIN(desired_salary) AS min_desired_salary, MAX(desired_salary) AS max_desired_salary FROM recruitment GROUP BY status ORDER BY avg_desired_salary DESC) TO 'outputs/salary_by_recruitment_status.csv' WITH CSV HEADER;

-- ============================================================
-- 5. Export salary by education level
-- ============================================================

\copy (SELECT education_level, COUNT(*) AS total_applicants, ROUND(AVG(years_of_experience), 2) AS avg_years_of_experience, ROUND(AVG(desired_salary), 2) AS avg_desired_salary FROM recruitment GROUP BY education_level ORDER BY avg_desired_salary DESC) TO 'outputs/salary_by_education_level.csv' WITH CSV HEADER;

-- ============================================================
-- 6. Export applications by month
-- ============================================================

\copy (SELECT DATE_TRUNC('month', application_date)::DATE AS application_month, COUNT(*) AS total_applications FROM recruitment GROUP BY DATE_TRUNC('month', application_date) ORDER BY application_month) TO 'outputs/applications_by_month.csv' WITH CSV HEADER;

-- ============================================================
-- 7. Export monthly applications by recruitment status
-- ============================================================

\copy (SELECT DATE_TRUNC('month', application_date)::DATE AS application_month, status, COUNT(*) AS total_applications FROM recruitment GROUP BY DATE_TRUNC('month', application_date), status ORDER BY application_month, status) TO 'outputs/monthly_applications_by_status.csv' WITH CSV HEADER;