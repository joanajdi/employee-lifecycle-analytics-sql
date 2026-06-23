-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 16_export_final_view.sql
-- Purpose: Export final employee lifecycle analytical view to CSV
-- Author: Joana Inácio
-- ============================================================

\copy (SELECT * FROM employee_lifecycle_summary) TO 'outputs/employee_lifecycle_summary.csv' WITH CSV HEADER;