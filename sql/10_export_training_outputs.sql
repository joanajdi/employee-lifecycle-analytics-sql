-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 09_export_training_outputs.sql
-- Purpose: Export training analysis results to CSV files
-- Author: Joana Inácio
-- ============================================================

-- ============================================================
-- 1. Export overall training KPIs
-- ============================================================

\copy (SELECT COUNT(*) AS total_training_records, COUNT(DISTINCT employee_id) AS employees_with_training, ROUND(AVG(training_duration_days), 2) AS avg_training_duration_days, ROUND(SUM(training_cost), 2) AS total_training_cost, ROUND(AVG(training_cost), 2) AS avg_training_cost FROM training_development) TO 'outputs/training_overall_kpis.csv' WITH CSV HEADER;

-- ============================================================
-- 2. Export training outcome distribution
-- ============================================================

\copy (SELECT training_outcome, COUNT(*) AS total_trainings, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage FROM training_development GROUP BY training_outcome ORDER BY total_trainings DESC) TO 'outputs/training_outcome_distribution.csv' WITH CSV HEADER;

-- ============================================================
-- 3. Export training type distribution
-- ============================================================

\copy (SELECT training_type, COUNT(*) AS total_trainings, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage, ROUND(AVG(training_cost), 2) AS avg_training_cost, ROUND(AVG(training_duration_days), 2) AS avg_training_duration_days FROM training_development GROUP BY training_type ORDER BY total_trainings DESC) TO 'outputs/training_type_distribution.csv' WITH CSV HEADER;

-- ============================================================
-- 4. Export training program overview
-- ============================================================

\copy (SELECT training_program_name, COUNT(*) AS total_trainings, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage, ROUND(AVG(training_duration_days), 2) AS avg_training_duration_days, ROUND(SUM(training_cost), 2) AS total_training_cost, ROUND(AVG(training_cost), 2) AS avg_training_cost FROM training_development GROUP BY training_program_name ORDER BY total_trainings DESC) TO 'outputs/training_program_overview.csv' WITH CSV HEADER;

-- ============================================================
-- 5. Export training timing distribution
-- ============================================================

\copy (SELECT CASE WHEN t.training_date < e.start_date THEN 'Before Start Date' ELSE 'On or After Start Date' END AS training_timing, COUNT(*) AS total_trainings, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage, ROUND(AVG(t.training_cost), 2) AS avg_training_cost, ROUND(AVG(t.training_duration_days), 2) AS avg_training_duration_days FROM training_development t JOIN employees e ON t.employee_id = e.employee_id GROUP BY CASE WHEN t.training_date < e.start_date THEN 'Before Start Date' ELSE 'On or After Start Date' END ORDER BY total_trainings DESC) TO 'outputs/training_timing_distribution.csv' WITH CSV HEADER;

-- ============================================================
-- 6. Export training by department
-- ============================================================

\copy (SELECT e.department_type, COUNT(*) AS total_trainings, COUNT(DISTINCT t.employee_id) AS employees_with_training, ROUND(SUM(t.training_cost), 2) AS total_training_cost, ROUND(AVG(t.training_cost), 2) AS avg_training_cost, ROUND(AVG(t.training_duration_days), 2) AS avg_training_duration_days FROM training_development t JOIN employees e ON t.employee_id = e.employee_id GROUP BY e.department_type ORDER BY total_training_cost DESC) TO 'outputs/training_by_department.csv' WITH CSV HEADER;

-- ============================================================
-- 7. Export training outcome by department
-- ============================================================

\copy (SELECT e.department_type, t.training_outcome, COUNT(*) AS total_trainings, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY e.department_type), 2) AS percentage_within_department FROM training_development t JOIN employees e ON t.employee_id = e.employee_id GROUP BY e.department_type, t.training_outcome ORDER BY e.department_type, total_trainings DESC) TO 'outputs/training_outcome_by_department.csv' WITH CSV HEADER;

-- ============================================================
-- 8. Export training outcome by performance score
-- ============================================================

\copy (SELECT e.performance_score, t.training_outcome, COUNT(*) AS total_trainings, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY e.performance_score), 2) AS percentage_within_performance_score FROM training_development t JOIN employees e ON t.employee_id = e.employee_id GROUP BY e.performance_score, t.training_outcome ORDER BY e.performance_score, total_trainings DESC) TO 'outputs/training_outcome_by_performance_score.csv' WITH CSV HEADER;

-- ============================================================
-- 9. Export training cost by performance score
-- ============================================================

\copy (SELECT e.performance_score, COUNT(*) AS total_trainings, ROUND(SUM(t.training_cost), 2) AS total_training_cost, ROUND(AVG(t.training_cost), 2) AS avg_training_cost, ROUND(AVG(t.training_duration_days), 2) AS avg_training_duration_days FROM training_development t JOIN employees e ON t.employee_id = e.employee_id GROUP BY e.performance_score ORDER BY total_training_cost DESC) TO 'outputs/training_cost_by_performance_score.csv' WITH CSV HEADER;