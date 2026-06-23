-- ============================================================
-- Project: Employee Lifecycle Analytics SQL
-- Script: 01_create_tables.sql
-- Purpose: Create the database tables used in the project
-- Author: Joana Inácio
-- ============================================================

DROP TABLE IF EXISTS training_development;
DROP TABLE IF EXISTS engagement_surveys;
DROP TABLE IF EXISTS recruitment;
DROP TABLE IF EXISTS employees;

-- ============================================================
-- 1. Employees table
-- ============================================================

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    start_date DATE,
    exit_date DATE, 
    title TEXT,
    supervisor TEXT,
    ad_email TEXT,
    business_unit TEXT,
    employee_status TEXT,
    employee_type TEXT,
    pay_zone TEXT,
    employee_classification_type TEXT,
    termination_type TEXT,
    termination_description TEXT,
    department_type TEXT,
    division TEXT,
    date_of_birth DATE,
    state TEXT,
    job_function_description TEXT,
    gender_code TEXT,
    location_code TEXT,
    race_description TEXT,
    marital_description TEXT,
    performance_score TEXT,
    current_employee_rating INT
);

-- ============================================================
-- 2. Recruitment table
-- ============================================================

CREATE TABLE recruitment (
    applicant_id INT PRIMARY KEY,
    application_date DATE,
    first_name TEXT,
    last_name TEXT,
    gender TEXT,
    date_of_birth DATE,
    phone_number TEXT,
    email TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    country TEXT,
    education_level TEXT,
    years_of_experience INT,
    desired_salary NUMERIC(10,2),
    job_title TEXT,
    status TEXT
);

-- ============================================================
-- 3. Engagement surveys table
-- ============================================================

CREATE TABLE engagement_surveys (
    survey_id SERIAL PRIMARY KEY,
    employee_id INT,
    survey_date DATE,
    engagement_score INT,
    satisfaction_score INT,
    work_life_balance_score INT,

    CONSTRAINT fk_engagement_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);

-- ============================================================
-- 4. Training and development table
-- ============================================================

CREATE TABLE training_development (
    training_id SERIAL PRIMARY KEY,
    employee_id INT,
    training_date DATE,
    training_program_name TEXT,
    training_type TEXT,
    training_outcome TEXT,
    location TEXT,
    trainer TEXT,
    training_duration_days INT,
    training_cost NUMERIC(10,2),

    CONSTRAINT fk_training_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);