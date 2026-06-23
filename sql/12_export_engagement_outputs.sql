-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 11_export_engagement_outputs.sql
-- Purpose: Export engagement analysis results to CSV files
-- Author: Joana Inácio
-- ============================================================

-- ============================================================
-- 1. Export overall engagement KPIs
-- ============================================================

\copy (SELECT COUNT(*) AS total_survey_records, COUNT(DISTINCT employee_id) AS employees_with_survey, ROUND(AVG(engagement_score), 2) AS avg_engagement_score, ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction_score, ROUND(AVG(work_life_balance_score), 2) AS avg_work_life_balance_score, MIN(survey_date) AS first_survey_date, MAX(survey_date) AS last_survey_date FROM engagement_surveys) TO 'outputs/engagement_overall_kpis.csv' WITH CSV HEADER;

-- ============================================================
-- 2. Export engagement score distribution
-- ============================================================

\copy (SELECT engagement_score, COUNT(*) AS total_employees, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage FROM engagement_surveys GROUP BY engagement_score ORDER BY engagement_score) TO 'outputs/engagement_score_distribution.csv' WITH CSV HEADER;

-- ============================================================
-- 3. Export satisfaction score distribution
-- ============================================================

\copy (SELECT satisfaction_score, COUNT(*) AS total_employees, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage FROM engagement_surveys GROUP BY satisfaction_score ORDER BY satisfaction_score) TO 'outputs/satisfaction_score_distribution.csv' WITH CSV HEADER;

-- ============================================================
-- 4. Export work-life balance score distribution
-- ============================================================

\copy (SELECT work_life_balance_score, COUNT(*) AS total_employees, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage FROM engagement_surveys GROUP BY work_life_balance_score ORDER BY work_life_balance_score) TO 'outputs/work_life_balance_distribution.csv' WITH CSV HEADER;

-- ============================================================
-- 5. Export engagement by department
-- ============================================================

\copy (SELECT e.department_type, COUNT(*) AS total_employees, ROUND(AVG(s.engagement_score), 2) AS avg_engagement_score, ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score, ROUND(AVG(s.work_life_balance_score), 2) AS avg_work_life_balance_score FROM engagement_surveys s JOIN employees e ON s.employee_id = e.employee_id GROUP BY e.department_type ORDER BY avg_engagement_score DESC) TO 'outputs/engagement_by_department.csv' WITH CSV HEADER;

-- ============================================================
-- 6. Export engagement by business unit
-- ============================================================

\copy (SELECT e.business_unit, COUNT(*) AS total_employees, ROUND(AVG(s.engagement_score), 2) AS avg_engagement_score, ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score, ROUND(AVG(s.work_life_balance_score), 2) AS avg_work_life_balance_score FROM engagement_surveys s JOIN employees e ON s.employee_id = e.employee_id GROUP BY e.business_unit ORDER BY avg_engagement_score DESC) TO 'outputs/engagement_by_business_unit.csv' WITH CSV HEADER;

-- ============================================================
-- 7. Export engagement by employee status
-- ============================================================

\copy (SELECT e.employee_status, COUNT(*) AS total_employees, ROUND(AVG(s.engagement_score), 2) AS avg_engagement_score, ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score, ROUND(AVG(s.work_life_balance_score), 2) AS avg_work_life_balance_score FROM engagement_surveys s JOIN employees e ON s.employee_id = e.employee_id GROUP BY e.employee_status ORDER BY avg_engagement_score DESC) TO 'outputs/engagement_by_employee_status.csv' WITH CSV HEADER;

-- ============================================================
-- 8. Export engagement by performance score
-- ============================================================

\copy (SELECT e.performance_score, COUNT(*) AS total_employees, ROUND(AVG(s.engagement_score), 2) AS avg_engagement_score, ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score, ROUND(AVG(s.work_life_balance_score), 2) AS avg_work_life_balance_score FROM engagement_surveys s JOIN employees e ON s.employee_id = e.employee_id GROUP BY e.performance_score ORDER BY avg_engagement_score DESC) TO 'outputs/engagement_by_performance_score.csv' WITH CSV HEADER;

-- ============================================================
-- 9. Export engagement segments
-- ============================================================

\copy (SELECT CASE WHEN engagement_score >= 4 THEN 'High Engagement' WHEN engagement_score = 3 THEN 'Medium Engagement' ELSE 'Low Engagement' END AS engagement_segment, COUNT(*) AS total_employees, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage, ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction_score, ROUND(AVG(work_life_balance_score), 2) AS avg_work_life_balance_score FROM engagement_surveys GROUP BY CASE WHEN engagement_score >= 4 THEN 'High Engagement' WHEN engagement_score = 3 THEN 'Medium Engagement' ELSE 'Low Engagement' END ORDER BY total_employees DESC) TO 'outputs/engagement_segments.csv' WITH CSV HEADER;

-- ============================================================
-- 10. Export engagement segment by department
-- ============================================================

\copy (SELECT e.department_type, CASE WHEN s.engagement_score >= 4 THEN 'High Engagement' WHEN s.engagement_score = 3 THEN 'Medium Engagement' ELSE 'Low Engagement' END AS engagement_segment, COUNT(*) AS total_employees, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY e.department_type), 2) AS percentage_within_department FROM engagement_surveys s JOIN employees e ON s.employee_id = e.employee_id GROUP BY e.department_type, CASE WHEN s.engagement_score >= 4 THEN 'High Engagement' WHEN s.engagement_score = 3 THEN 'Medium Engagement' ELSE 'Low Engagement' END ORDER BY e.department_type, total_employees DESC) TO 'outputs/engagement_segment_by_department.csv' WITH CSV HEADER;

-- ============================================================
-- 11. Export low engagement employees by department
-- ============================================================

\copy (SELECT e.department_type, COUNT(*) AS low_engagement_employees, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage_of_all_low_engagement FROM engagement_surveys s JOIN employees e ON s.employee_id = e.employee_id WHERE s.engagement_score <= 2 GROUP BY e.department_type ORDER BY low_engagement_employees DESC) TO 'outputs/low_engagement_by_department.csv' WITH CSV HEADER;

-- ============================================================
-- 12. Export engagement by attrition flag
-- ============================================================

\copy (SELECT CASE WHEN e.employee_status = 'Active' THEN 'Active' ELSE 'Non-Active' END AS employee_status_group, COUNT(*) AS total_employees, ROUND(AVG(s.engagement_score), 2) AS avg_engagement_score, ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score, ROUND(AVG(s.work_life_balance_score), 2) AS avg_work_life_balance_score FROM engagement_surveys s JOIN employees e ON s.employee_id = e.employee_id GROUP BY CASE WHEN e.employee_status = 'Active' THEN 'Active' ELSE 'Non-Active' END ORDER BY avg_engagement_score DESC) TO 'outputs/engagement_by_attrition_flag.csv' WITH CSV HEADER;