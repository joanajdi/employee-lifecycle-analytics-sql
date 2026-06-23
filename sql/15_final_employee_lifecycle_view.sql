-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 15_final_employee_lifecycle_view.sql
-- Purpose: Create final employee lifecycle analytical view
-- Author: Joana Inácio
-- ============================================================

DROP VIEW IF EXISTS employee_lifecycle_summary;

CREATE VIEW employee_lifecycle_summary AS
SELECT
    -- Employee identifiers
    e.employee_id,
    e.first_name,
    e.last_name,

    -- Employee profile
    e.department_type,
    e.division,
    e.business_unit,
    e.title,
    e.job_function_description,
    e.supervisor,
    e.state,
    e.location_code,

    -- Demographics
    e.gender_code,
    e.race_description,
    e.marital_description,
    e.date_of_birth,

    -- Employment information
    e.start_date,
    e.exit_date,
    e.employee_status,
    e.employee_status_group,
    e.employee_type,
    e.pay_zone,
    e.employee_classification_type,

    -- Attrition and tenure
    e.termination_type,
    e.termination_description,
    e.termination_flag,
    e.voluntary_termination_flag,
    e.involuntary_termination_flag,
    e.tenure_days,
    e.tenure_years,

    -- Performance
    e.performance_score,
    e.current_employee_rating,

    -- Recruitment
    r.application_date,
    r.application_month,
    r.recruitment_status,
    r.education_level,
    r.years_of_experience,
    r.desired_salary,
    r.job_title AS applied_job_title,

    -- Engagement
    s.survey_date,
    s.engagement_score,
    s.engagement_segment,
    s.satisfaction_score,
    s.satisfaction_segment,
    s.work_life_balance_score,
    s.work_life_balance_segment,

    -- Training
    t.training_date,
    t.training_program_name,
    t.training_type,
    t.training_outcome,
    t.training_duration_days,
    t.training_duration_segment,
    t.training_cost,
    t.training_cost_segment,
    t.training_timing,

    -- Analytical flags
    CASE
        WHEN e.employee_status = 'Active' THEN 1
        ELSE 0
    END AS active_flag,

    CASE
        WHEN e.employee_status <> 'Active' THEN 1
        ELSE 0
    END AS non_active_flag,

    CASE
        WHEN s.engagement_score <= 2 THEN 1
        ELSE 0
    END AS low_engagement_flag,

    CASE
        WHEN s.satisfaction_score <= 2 THEN 1
        ELSE 0
    END AS low_satisfaction_flag,

    CASE
        WHEN s.work_life_balance_score <= 2 THEN 1
        ELSE 0
    END AS low_work_life_balance_flag,

    CASE
        WHEN t.training_outcome IN ('Completed', 'Passed') THEN 1
        ELSE 0
    END AS positive_training_outcome_flag,

    CASE
        WHEN t.training_outcome IN ('Incomplete', 'Failed') THEN 1
        ELSE 0
    END AS negative_training_outcome_flag,

    CASE
        WHEN e.performance_score IN ('Needs Improvement', 'PIP') THEN 1
        ELSE 0
    END AS low_performance_flag,

    CASE
        WHEN e.performance_score = 'Exceeds' THEN 1
        ELSE 0
    END AS high_performance_flag

FROM vw_employees_clean e
LEFT JOIN vw_recruitment_clean r
    ON e.employee_id = r.applicant_id
LEFT JOIN vw_engagement_clean s
    ON e.employee_id = s.employee_id
LEFT JOIN vw_training_clean t
    ON e.employee_id = t.employee_id;