-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 13_export_attrition_outputs.sql
-- Purpose: Export attrition analysis results to CSV files
-- Author: Joana Inácio
-- ============================================================

-- ============================================================
-- 1. Export overall attrition KPIs
-- ============================================================

\copy (SELECT COUNT(*) AS total_employees, COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees, COUNT(*) FILTER (WHERE employee_status <> 'Active') AS non_active_employees, COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees, COUNT(*) FILTER (WHERE employee_status = 'Voluntarily Terminated') AS voluntarily_terminated_employees, COUNT(*) FILTER (WHERE employee_status = 'Terminated for Cause') AS terminated_for_cause_employees, ROUND(COUNT(*) FILTER (WHERE employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate, ROUND(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate, ROUND(COUNT(*) FILTER (WHERE employee_status = 'Voluntarily Terminated') * 100.0 / COUNT(*), 2) AS voluntary_termination_rate, ROUND(COUNT(*) FILTER (WHERE employee_status = 'Terminated for Cause') * 100.0 / COUNT(*), 2) AS involuntary_termination_rate FROM employees) TO 'outputs/attrition_overall_kpis.csv' WITH CSV HEADER;

-- ============================================================
-- 2. Export attrition by department
-- ============================================================

\copy (SELECT department_type, COUNT(*) AS total_employees, COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees, COUNT(*) FILTER (WHERE employee_status <> 'Active') AS non_active_employees, COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees, ROUND(COUNT(*) FILTER (WHERE employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate, ROUND(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate FROM employees GROUP BY department_type ORDER BY termination_rate DESC) TO 'outputs/attrition_by_department.csv' WITH CSV HEADER;

-- ============================================================
-- 3. Export termination type by department
-- ============================================================

\copy (SELECT department_type, COUNT(*) FILTER (WHERE employee_status = 'Voluntarily Terminated') AS voluntary_terminations, COUNT(*) FILTER (WHERE employee_status = 'Terminated for Cause') AS involuntary_terminations, COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS total_terminations, ROUND(COUNT(*) FILTER (WHERE employee_status = 'Voluntarily Terminated') * 100.0 / NULLIF(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')), 0), 2) AS voluntary_share_of_terminations, ROUND(COUNT(*) FILTER (WHERE employee_status = 'Terminated for Cause') * 100.0 / NULLIF(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')), 0), 2) AS involuntary_share_of_terminations FROM employees GROUP BY department_type ORDER BY total_terminations DESC) TO 'outputs/termination_type_by_department.csv' WITH CSV HEADER;

-- ============================================================
-- 4. Export attrition by business unit
-- ============================================================

\copy (SELECT business_unit, COUNT(*) AS total_employees, COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees, COUNT(*) FILTER (WHERE employee_status <> 'Active') AS non_active_employees, COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees, ROUND(COUNT(*) FILTER (WHERE employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate, ROUND(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate FROM employees GROUP BY business_unit ORDER BY termination_rate DESC) TO 'outputs/attrition_by_business_unit.csv' WITH CSV HEADER;

-- ============================================================
-- 5. Export attrition by employee type
-- ============================================================

\copy (SELECT employee_type, COUNT(*) AS total_employees, COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees, COUNT(*) FILTER (WHERE employee_status <> 'Active') AS non_active_employees, COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees, ROUND(COUNT(*) FILTER (WHERE employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate, ROUND(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate FROM employees GROUP BY employee_type ORDER BY termination_rate DESC) TO 'outputs/attrition_by_employee_type.csv' WITH CSV HEADER;

-- ============================================================
-- 6. Export attrition by pay zone
-- ============================================================

\copy (SELECT pay_zone, COUNT(*) AS total_employees, COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees, COUNT(*) FILTER (WHERE employee_status <> 'Active') AS non_active_employees, COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees, ROUND(COUNT(*) FILTER (WHERE employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate, ROUND(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate FROM employees GROUP BY pay_zone ORDER BY termination_rate DESC) TO 'outputs/attrition_by_pay_zone.csv' WITH CSV HEADER;

-- ============================================================
-- 7. Export tenure by employee status
-- ============================================================

\copy (SELECT employee_status, COUNT(*) AS total_employees, ROUND(AVG(CASE WHEN exit_date IS NOT NULL THEN exit_date - start_date ELSE CURRENT_DATE - start_date END), 2) AS avg_tenure_days, ROUND(AVG(CASE WHEN exit_date IS NOT NULL THEN (exit_date - start_date) / 365.0 ELSE (CURRENT_DATE - start_date) / 365.0 END), 2) AS avg_tenure_years FROM employees GROUP BY employee_status ORDER BY avg_tenure_years DESC) TO 'outputs/tenure_by_employee_status.csv' WITH CSV HEADER;

-- ============================================================
-- 8. Export tenure by department
-- ============================================================

\copy (SELECT department_type, COUNT(*) AS total_employees, ROUND(AVG(CASE WHEN exit_date IS NOT NULL THEN (exit_date - start_date) / 365.0 ELSE (CURRENT_DATE - start_date) / 365.0 END), 2) AS avg_tenure_years, ROUND(AVG(CASE WHEN employee_status IN ('Voluntarily Terminated', 'Terminated for Cause') AND exit_date IS NOT NULL THEN (exit_date - start_date) / 365.0 END), 2) AS avg_tenure_years_terminated FROM employees GROUP BY department_type ORDER BY avg_tenure_years_terminated ASC NULLS LAST) TO 'outputs/tenure_by_department.csv' WITH CSV HEADER;

-- ============================================================
-- 9. Export attrition by performance score
-- ============================================================

\copy (SELECT performance_score, COUNT(*) AS total_employees, COUNT(*) FILTER (WHERE employee_status = 'Active') AS active_employees, COUNT(*) FILTER (WHERE employee_status <> 'Active') AS non_active_employees, COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees, ROUND(COUNT(*) FILTER (WHERE employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate, ROUND(COUNT(*) FILTER (WHERE employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate, ROUND(AVG(current_employee_rating), 2) AS avg_employee_rating FROM employees GROUP BY performance_score ORDER BY termination_rate DESC) TO 'outputs/attrition_by_performance_score.csv' WITH CSV HEADER;

-- ============================================================
-- 10. Export attrition by engagement segment
-- ============================================================

\copy (SELECT CASE WHEN s.engagement_score >= 4 THEN 'High Engagement' WHEN s.engagement_score = 3 THEN 'Medium Engagement' ELSE 'Low Engagement' END AS engagement_segment, COUNT(*) AS total_employees, COUNT(*) FILTER (WHERE e.employee_status = 'Active') AS active_employees, COUNT(*) FILTER (WHERE e.employee_status <> 'Active') AS non_active_employees, COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees, ROUND(COUNT(*) FILTER (WHERE e.employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate, ROUND(COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate FROM employees e JOIN engagement_surveys s ON e.employee_id = s.employee_id GROUP BY CASE WHEN s.engagement_score >= 4 THEN 'High Engagement' WHEN s.engagement_score = 3 THEN 'Medium Engagement' ELSE 'Low Engagement' END ORDER BY termination_rate DESC) TO 'outputs/attrition_by_engagement_segment.csv' WITH CSV HEADER;

-- ============================================================
-- 11. Export attrition by training outcome
-- ============================================================

\copy (SELECT t.training_outcome, COUNT(*) AS total_employees, COUNT(*) FILTER (WHERE e.employee_status = 'Active') AS active_employees, COUNT(*) FILTER (WHERE e.employee_status <> 'Active') AS non_active_employees, COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) AS terminated_employees, ROUND(COUNT(*) FILTER (WHERE e.employee_status <> 'Active') * 100.0 / COUNT(*), 2) AS non_active_rate, ROUND(COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate FROM employees e JOIN training_development t ON e.employee_id = t.employee_id GROUP BY t.training_outcome ORDER BY termination_rate DESC) TO 'outputs/attrition_by_training_outcome.csv' WITH CSV HEADER;

-- ============================================================
-- 12. Export department risk summary
-- ============================================================

\copy (SELECT e.department_type, COUNT(*) AS total_employees, ROUND(COUNT(*) FILTER (WHERE e.employee_status IN ('Voluntarily Terminated', 'Terminated for Cause')) * 100.0 / COUNT(*), 2) AS termination_rate, ROUND(AVG(s.engagement_score), 2) AS avg_engagement_score, ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score, ROUND(AVG(s.work_life_balance_score), 2) AS avg_work_life_balance_score, ROUND(AVG(e.current_employee_rating), 2) AS avg_employee_rating, ROUND(AVG(t.training_cost), 2) AS avg_training_cost FROM employees e JOIN engagement_surveys s ON e.employee_id = s.employee_id JOIN training_development t ON e.employee_id = t.employee_id GROUP BY e.department_type ORDER BY termination_rate DESC) TO 'outputs/department_risk_summary.csv' WITH CSV HEADER;