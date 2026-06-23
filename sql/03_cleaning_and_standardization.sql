-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 03_cleaning_and_standardization.sql
-- Purpose: Create standardized analytical views from imported tables
-- Author: Joana Inácio
-- ============================================================

-- ============================================================
-- 1. Clean employees view
-- ============================================================

CREATE OR REPLACE VIEW vw_employees_clean AS
SELECT
    employee_id,
    INITCAP(TRIM(first_name)) AS first_name,
    INITCAP(TRIM(last_name)) AS last_name,
    start_date,
    exit_date,
    TRIM(title) AS title,
    TRIM(supervisor) AS supervisor,
    LOWER(TRIM(ad_email)) AS ad_email,
    TRIM(business_unit) AS business_unit,
    TRIM(employee_status) AS employee_status,
    CASE
        WHEN employee_status = 'Active' THEN 'Active'
        ELSE 'Non-Active'
    END AS employee_status_group,
    TRIM(employee_type) AS employee_type,
    TRIM(pay_zone) AS pay_zone,
    TRIM(employee_classification_type) AS employee_classification_type,
    TRIM(termination_type) AS termination_type,
    TRIM(termination_description) AS termination_description,
    TRIM(department_type) AS department_type,
    TRIM(division) AS division,
    date_of_birth,
    state,
    TRIM(job_function_description) AS job_function_description,
    TRIM(gender_code) AS gender_code,
    location_code,
    TRIM(race_description) AS race_description,
    TRIM(marital_description) AS marital_description,
    TRIM(performance_score) AS performance_score,
    current_employee_rating,
    CASE
        WHEN employee_status IN ('Voluntarily Terminated', 'Terminated for Cause') THEN 1
        ELSE 0
    END AS termination_flag,
    CASE
        WHEN employee_status = 'Voluntarily Terminated' THEN 1
        ELSE 0
    END AS voluntary_termination_flag,
    CASE
        WHEN employee_status = 'Terminated for Cause' THEN 1
        ELSE 0
    END AS involuntary_termination_flag,
    CASE
        WHEN exit_date IS NOT NULL THEN exit_date - start_date
        ELSE CURRENT_DATE - start_date
    END AS tenure_days,
    ROUND(
        CASE
            WHEN exit_date IS NOT NULL THEN (exit_date - start_date) / 365.0
            ELSE (CURRENT_DATE - start_date) / 365.0
        END,
        2
    ) AS tenure_years
FROM employees;

-- ============================================================
-- 2. Clean recruitment view
-- ============================================================

CREATE OR REPLACE VIEW vw_recruitment_clean AS
SELECT
    applicant_id,
    application_date,
    INITCAP(TRIM(first_name)) AS first_name,
    INITCAP(TRIM(last_name)) AS last_name,
    TRIM(gender) AS gender,
    date_of_birth,
    TRIM(phone_number) AS phone_number,
    LOWER(TRIM(email)) AS email,
    TRIM(address) AS address,
    TRIM(city) AS city,
    TRIM(state) AS state,
    TRIM(zip_code) AS zip_code,
    TRIM(country) AS country,
    TRIM(education_level) AS education_level,
    years_of_experience,
    desired_salary,
    TRIM(job_title) AS job_title,
    TRIM(status) AS recruitment_status,
    DATE_TRUNC('month', application_date)::DATE AS application_month
FROM recruitment;

-- ============================================================
-- 3. Clean engagement view
-- ============================================================

CREATE OR REPLACE VIEW vw_engagement_clean AS
SELECT
    survey_id,
    employee_id,
    survey_date,
    engagement_score,
    satisfaction_score,
    work_life_balance_score,
    CASE
        WHEN engagement_score >= 4 THEN 'High Engagement'
        WHEN engagement_score = 3 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END AS engagement_segment,
    CASE
        WHEN satisfaction_score >= 4 THEN 'High Satisfaction'
        WHEN satisfaction_score = 3 THEN 'Medium Satisfaction'
        ELSE 'Low Satisfaction'
    END AS satisfaction_segment,
    CASE
        WHEN work_life_balance_score >= 4 THEN 'High Work-Life Balance'
        WHEN work_life_balance_score = 3 THEN 'Medium Work-Life Balance'
        ELSE 'Low Work-Life Balance'
    END AS work_life_balance_segment
FROM engagement_surveys;

-- ============================================================
-- 4. Clean training view
-- ============================================================

CREATE OR REPLACE VIEW vw_training_clean AS
SELECT
    t.training_id,
    t.employee_id,
    t.training_date,
    TRIM(t.training_program_name) AS training_program_name,
    TRIM(t.training_type) AS training_type,
    TRIM(t.training_outcome) AS training_outcome,
    TRIM(t.location) AS location,
    TRIM(t.trainer) AS trainer,
    t.training_duration_days,
    t.training_cost,
    CASE
        WHEN t.training_cost >= 750 THEN 'High Cost'
        WHEN t.training_cost >= 500 THEN 'Medium Cost'
        ELSE 'Low Cost'
    END AS training_cost_segment,
    CASE
        WHEN t.training_duration_days >= 4 THEN 'Long Training'
        WHEN t.training_duration_days >= 2 THEN 'Medium Training'
        ELSE 'Short Training'
    END AS training_duration_segment,
    CASE
        WHEN t.training_date < e.start_date THEN 'Before Start Date'
        ELSE 'On or After Start Date'
    END AS training_timing
FROM training_development t
JOIN employees e
    ON t.employee_id = e.employee_id;