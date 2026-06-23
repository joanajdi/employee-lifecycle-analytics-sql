-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 02_import_data.sql
-- Purpose: Import CSV files into PostgreSQL tables
-- Author: Joana Inácio
-- ============================================================

SET datestyle = 'ISO, DMY';

TRUNCATE TABLE training_development RESTART IDENTITY CASCADE;
TRUNCATE TABLE engagement_surveys RESTART IDENTITY CASCADE;
TRUNCATE TABLE recruitment RESTART IDENTITY CASCADE;
TRUNCATE TABLE employees RESTART IDENTITY CASCADE;

-- ============================================================
-- 1. Import employees data
-- ============================================================

\copy employees (employee_id, first_name, last_name, start_date, exit_date, title, supervisor, ad_email, business_unit, employee_status, employee_type, pay_zone, employee_classification_type, termination_type, termination_description, department_type, division, date_of_birth, state, job_function_description, gender_code, location_code, race_description, marital_description, performance_score, current_employee_rating) FROM 'data/employee_data.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- ============================================================
-- 2. Import recruitment data
-- ============================================================

\copy recruitment (applicant_id, application_date, first_name, last_name, gender, date_of_birth, phone_number, email, address, city, state, zip_code, country, education_level, years_of_experience, desired_salary, job_title, status) FROM 'data/recruitment_data.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- ============================================================
-- 3. Import engagement survey data
-- ============================================================

\copy engagement_surveys (employee_id, survey_date, engagement_score, satisfaction_score, work_life_balance_score) FROM 'data/employee_engagement_survey_data.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';');

-- ============================================================
-- 4. Import training and development data
-- ============================================================

\copy training_development (employee_id, training_date, training_program_name, training_type, training_outcome, location, trainer, training_duration_days, training_cost) FROM 'data/training_and_development_data.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');