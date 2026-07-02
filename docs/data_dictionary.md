# Data Dictionary

This document describes the main tables, views, fields and derived variables used in the **Employee Lifecycle Analytics SQL Project**.

The project uses four raw CSV datasets imported into PostgreSQL, several standardized analytical views, and one final employee-level analytical view.

Monetary values are reported as provided in the original dataset. The dataset does not specify a currency.

---

## 1. Raw Tables

The raw tables correspond to the imported CSV files. These tables preserve the original structure of the source data as much as possible.

---

## 1.1 `employees`

The `employees` table contains employee demographic, employment, department, performance and attrition-related information.

| Column                         | Description                                                                                                              |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------ |
| `employee_id`                  | Unique employee identifier. Primary key of the employees table.                                                          |
| `first_name`                   | Employee first name.                                                                                                     |
| `last_name`                    | Employee last name.                                                                                                      |
| `start_date`                   | Employee start date in the organization.                                                                                 |
| `exit_date`                    | Employee exit date, when applicable. Null for employees without an exit date.                                            |
| `title`                        | Employee job title.                                                                                                      |
| `supervisor`                   | Employee supervisor.                                                                                                     |
| `ad_email`                     | Employee work email address.                                                                                             |
| `business_unit`                | Business unit to which the employee belongs.                                                                             |
| `employee_status`              | Current employee status, such as Active, Voluntarily Terminated, Leave of Absence, Future Start or Terminated for Cause. |
| `employee_type`                | Type of employment, such as Full-Time, Part-Time or Contract.                                                            |
| `pay_zone`                     | Pay zone associated with the employee.                                                                                   |
| `employee_classification_type` | Employee classification category.                                                                                        |
| `termination_type`             | Type of termination, when applicable.                                                                                    |
| `termination_description`      | Description of the termination reason, when available.                                                                   |
| `department_type`              | Department to which the employee belongs.                                                                                |
| `division`                     | Employee division.                                                                                                       |
| `date_of_birth`                | Employee date of birth.                                                                                                  |
| `state`                        | Employee state/location field.                                                                                           |
| `job_function_description`     | Description of the employee job function.                                                                                |
| `gender_code`                  | Employee gender category.                                                                                                |
| `location_code`                | Location identifier or code.                                                                                             |
| `race_description`             | Employee race/ethnicity category as provided in the dataset.                                                             |
| `marital_description`          | Employee marital status category.                                                                                        |
| `performance_score`            | Employee performance category, such as Fully Meets, Exceeds, Needs Improvement or PIP.                                   |
| `current_employee_rating`      | Numeric employee rating.                                                                                                 |

---

## 1.2 `recruitment`

The `recruitment` table contains applicant-level information and recruitment pipeline status.

| Column                | Description                                                                                 |
| --------------------- | ------------------------------------------------------------------------------------------- |
| `applicant_id`        | Unique applicant identifier. Used as the link to `employee_id` for this project.            |
| `application_date`    | Date when the application was submitted.                                                    |
| `first_name`          | Applicant first name.                                                                       |
| `last_name`           | Applicant last name.                                                                        |
| `gender`              | Applicant gender category.                                                                  |
| `date_of_birth`       | Applicant date of birth.                                                                    |
| `phone_number`        | Applicant phone number.                                                                     |
| `email`               | Applicant email address.                                                                    |
| `address`             | Applicant address.                                                                          |
| `city`                | Applicant city.                                                                             |
| `state`               | Applicant state.                                                                            |
| `zip_code`            | Applicant zip code.                                                                         |
| `country`             | Applicant country.                                                                          |
| `education_level`     | Applicant highest education level.                                                          |
| `years_of_experience` | Applicant years of professional experience.                                                 |
| `desired_salary`      | Applicant desired salary. Currency is not specified in the dataset.                         |
| `job_title`           | Job title associated with the application.                                                  |
| `status`              | Recruitment pipeline status, such as Applied, In Review, Interviewing, Offered or Rejected. |

---

## 1.3 `engagement_surveys`

The `engagement_surveys` table contains employee survey results related to engagement, satisfaction and work-life balance.

| Column                    | Description                                                         |
| ------------------------- | ------------------------------------------------------------------- |
| `survey_id`               | Unique survey record identifier generated during table creation.    |
| `employee_id`             | Employee identifier. Foreign key linked to `employees.employee_id`. |
| `survey_date`             | Date of the engagement survey.                                      |
| `engagement_score`        | Employee engagement score on a 1-to-5 scale.                        |
| `satisfaction_score`      | Employee satisfaction score on a 1-to-5 scale.                      |
| `work_life_balance_score` | Employee work-life balance score on a 1-to-5 scale.                 |

---

## 1.4 `training_development`

The `training_development` table contains employee training activity, program, outcome, duration and cost data.

| Column                   | Description                                                         |
| ------------------------ | ------------------------------------------------------------------- |
| `training_id`            | Unique training record identifier generated during table creation.  |
| `employee_id`            | Employee identifier. Foreign key linked to `employees.employee_id`. |
| `training_date`          | Date when the training occurred.                                    |
| `training_program_name`  | Name of the training program.                                       |
| `training_type`          | Type of training, such as Internal or External.                     |
| `training_outcome`       | Training result, such as Completed, Passed, Failed or Incomplete.   |
| `location`               | Training location.                                                  |
| `trainer`                | Trainer responsible for the training.                               |
| `training_duration_days` | Training duration in days.                                          |
| `training_cost`          | Training cost. Currency is not specified in the dataset.            |

---

## 2. Standardized Views

Standardized views were created to clean and enrich the raw imported tables without modifying the original data.

---

## 2.1 `vw_employees_clean`

The `vw_employees_clean` view standardizes employee fields and adds tenure and attrition-related variables.

| Column                         | Description                                                                              |
| ------------------------------ | ---------------------------------------------------------------------------------------- |
| `employee_id`                  | Unique employee identifier.                                                              |
| `first_name`                   | Cleaned employee first name.                                                             |
| `last_name`                    | Cleaned employee last name.                                                              |
| `ad_email`                     | Lowercase and trimmed employee email.                                                    |
| `employee_status`              | Employee status.                                                                         |
| `employee_status_group`        | Groups employees into Active and Non-Active.                                             |
| `department_type`              | Employee department.                                                                     |
| `business_unit`                | Employee business unit.                                                                  |
| `employee_type`                | Employment type.                                                                         |
| `pay_zone`                     | Employee pay zone.                                                                       |
| `performance_score`            | Employee performance category.                                                           |
| `current_employee_rating`      | Numeric employee rating.                                                                 |
| `termination_flag`             | Equals 1 if the employee is Voluntarily Terminated or Terminated for Cause; otherwise 0. |
| `voluntary_termination_flag`   | Equals 1 if the employee is Voluntarily Terminated; otherwise 0.                         |
| `involuntary_termination_flag` | Equals 1 if the employee is Terminated for Cause; otherwise 0.                           |
| `tenure_days`                  | Employee tenure in days. Uses exit date when available, otherwise current date.          |
| `tenure_years`                 | Employee tenure in years. Uses exit date when available, otherwise current date.         |

---

## 2.2 `vw_recruitment_clean`

The `vw_recruitment_clean` view standardizes recruitment fields and adds an application month field.

| Column                | Description                                            |
| --------------------- | ------------------------------------------------------ |
| `applicant_id`        | Unique applicant identifier.                           |
| `application_date`    | Date when the application was submitted.               |
| `application_month`   | Month of application, derived from `application_date`. |
| `education_level`     | Applicant education level.                             |
| `years_of_experience` | Applicant years of professional experience.            |
| `desired_salary`      | Applicant desired salary.                              |
| `job_title`           | Job title associated with the application.             |
| `recruitment_status`  | Renamed version of the raw `status` field.             |

---

## 2.3 `vw_engagement_clean`

The `vw_engagement_clean` view adds engagement, satisfaction and work-life balance segments.

| Column                      | Description                                                           |
| --------------------------- | --------------------------------------------------------------------- |
| `survey_id`                 | Unique survey record identifier.                                      |
| `employee_id`               | Employee identifier.                                                  |
| `survey_date`               | Date of the engagement survey.                                        |
| `engagement_score`          | Employee engagement score on a 1-to-5 scale.                          |
| `engagement_segment`        | Groups engagement into Low, Medium and High Engagement.               |
| `satisfaction_score`        | Employee satisfaction score on a 1-to-5 scale.                        |
| `satisfaction_segment`      | Groups satisfaction into Low, Medium and High Satisfaction.           |
| `work_life_balance_score`   | Employee work-life balance score on a 1-to-5 scale.                   |
| `work_life_balance_segment` | Groups work-life balance into Low, Medium and High Work-Life Balance. |

Segmentation logic:

| Segment Type | Logic        |
| ------------ | ------------ |
| Low          | Score 1 or 2 |
| Medium       | Score 3      |
| High         | Score 4 or 5 |

---

## 2.4 `vw_training_clean`

The `vw_training_clean` view standardizes training fields and adds training cost, duration and timing segments.

| Column                      | Description                                                                         |
| --------------------------- | ----------------------------------------------------------------------------------- |
| `training_id`               | Unique training record identifier.                                                  |
| `employee_id`               | Employee identifier.                                                                |
| `training_date`             | Date when the training occurred.                                                    |
| `training_program_name`     | Training program name.                                                              |
| `training_type`             | Training type, such as Internal or External.                                        |
| `training_outcome`          | Training result.                                                                    |
| `training_duration_days`    | Training duration in days.                                                          |
| `training_duration_segment` | Groups training duration into Short, Medium and Long Training.                      |
| `training_cost`             | Training cost. Currency is not specified in the dataset.                            |
| `training_cost_segment`     | Groups training cost into Low, Medium and High Cost.                                |
| `training_timing`           | Indicates whether the training occurred before or on/after the employee start date. |

Training cost segmentation logic:

| Segment     | Logic                               |
| ----------- | ----------------------------------- |
| Low Cost    | Training cost below 500             |
| Medium Cost | Training cost from 500 to below 750 |
| High Cost   | Training cost equal to or above 750 |

Training duration segmentation logic:

| Segment         | Logic                                      |
| --------------- | ------------------------------------------ |
| Short Training  | Training duration below 2 days             |
| Medium Training | Training duration from 2 to 3 days         |
| Long Training   | Training duration equal to or above 4 days |

Training timing logic:

| Segment                | Logic                                       |
| ---------------------- | ------------------------------------------- |
| Before Start Date      | `training_date` is before `start_date`      |
| On or After Start Date | `training_date` is on or after `start_date` |

---

## 3. Final Analytical View

## 3.1 `employee_lifecycle_summary`

The `employee_lifecycle_summary` view is the final employee-level analytical view. It combines employee, recruitment, engagement and training data into one table.

This view is designed to support cross-functional analysis across the employee lifecycle.

Main areas included:

| Area                   | Examples of Fields                                                                                                                                                                                                                  |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Employee profile       | `employee_id`, `department_type`, `business_unit`, `title`, `employee_type`, `pay_zone`                                                                                                                                             |
| Demographics           | `gender_code`, `race_description`, `marital_description`, `date_of_birth`                                                                                                                                                           |
| Employment information | `start_date`, `exit_date`, `employee_status`, `employee_status_group`                                                                                                                                                               |
| Attrition and tenure   | `termination_flag`, `voluntary_termination_flag`, `involuntary_termination_flag`, `tenure_days`, `tenure_years`                                                                                                                     |
| Performance            | `performance_score`, `current_employee_rating`                                                                                                                                                                                      |
| Recruitment            | `application_date`, `application_month`, `recruitment_status`, `education_level`, `years_of_experience`, `desired_salary`, `applied_job_title`                                                                                      |
| Engagement             | `engagement_score`, `engagement_segment`, `satisfaction_score`, `satisfaction_segment`, `work_life_balance_score`, `work_life_balance_segment`                                                                                      |
| Training               | `training_date`, `training_program_name`, `training_type`, `training_outcome`, `training_duration_days`, `training_cost`, `training_timing`                                                                                         |
| Analytical flags       | `active_flag`, `non_active_flag`, `low_engagement_flag`, `low_satisfaction_flag`, `low_work_life_balance_flag`, `positive_training_outcome_flag`, `negative_training_outcome_flag`, `low_performance_flag`, `high_performance_flag` |

---

## 4. Derived Fields and Analytical Flags

This section explains the main derived fields created during the project.

| Field                            | Description                                                                         |
| -------------------------------- | -------------------------------------------------------------------------------     |
| `employee_status_group`          | Groups employees into Active and Non-Active.                                        |
| `termination_flag`               | Indicates whether the employee has a termination status.                            |
| `voluntary_termination_flag`     | Indicates whether the employee was voluntarily terminated.                          |
| `involuntary_termination_flag`   | Indicates whether the employee was terminated for cause.                            | 
| `active_flag`                    | Equals 1 for active employees, otherwise 0.                                         |
| `non_active_flag`                | Equals 1 for non-active employees, otherwise 0.                                     |
| `tenure_days`                    | Employee tenure calculated in days.                                                 |
| `tenure_years`                   | Employee tenure calculated in years.                                                |
| `application_month`              | Month extracted from the application date.                                          |
| `engagement_segment`             | Groups engagement score into Low, Medium and High Engagement.                       |
| `satisfaction_segment`           | Groups satisfaction score into Low, Medium and High Satisfaction.                   |
| `work_life_balance_segment`      | Groups work-life balance score into Low, Medium and High Work-Life Balance.         |
| `training_cost_segment`          | Groups training cost into Low, Medium and High Cost.                                |
| `training_duration_segment`      | Groups training duration into Short, Medium and Long Training.                      |
| `training_timing`                | Indicates whether training occurred before or on/after the employee start date.     |
| `low_engagement_flag`            | Equals 1 when engagement score is 1 or 2.                                           | 
| `low_satisfaction_flag`          | Equals 1 when satisfaction score is 1 or 2.                                         |
| `low_work_life_balance_flag`     | Equals 1 when work-life balance score is 1 or 2.                                    |
| `positive_training_outcome_flag` | Equals 1 when training outcome is Completed or Passed.                              |
| `negative_training_outcome_flag` | Equals 1 when training outcome is Incomplete or Failed.                             |
| `low_performance_flag`           | Equals 1 when performance score is Needs Improvement or PIP.                        |
| `high_performance_flag`          | Equals 1 when performance score is Exceeds.                                         |
| `early_attrition_6m_flag`        | Indicates whether a terminated employee exited within 6 months of their start date. |
| `early_attrition_12m_flag`       | Indicates whether a terminated employee exited within 12 months of their start date.|

---

## 5. Table Relationships

The main relationship key is the employee identifier.

| Source                             | Relationship                                                      |
| ---------------------------------- | ----------------------------------------------------------------- |
| `employees.employee_id`            | Main employee identifier                                          |
| `engagement_surveys.employee_id`   | Links engagement survey records to employees                      |
| `training_development.employee_id` | Links training records to employees                               |
| `recruitment.applicant_id`         | Treated as the corresponding employee identifier for this project |

Conceptual relationship:

```text
recruitment.applicant_id
        │
        ▼
employees.employee_id
        │
        ├── engagement_surveys.employee_id
        │
        └── training_development.employee_id
```

---

## 6. Notes and Assumptions

The `employees` table is treated as the central table in the project.

The `applicant_id` field in the recruitment dataset is assumed to correspond to `employee_id` for the purpose of this analysis. In a real HR system, applicant and employee identifiers may be stored separately and linked through a dedicated hiring or onboarding table.

Each employee has one engagement survey record and one training record in this dataset. This means the analysis does not capture repeated surveys or multiple training events over time.

Some distributions, such as recruitment status, training outcomes and survey scores, appear highly balanced. This suggests that the dataset may be synthetic or intentionally structured for analytical practice.

The project focuses on exploratory SQL analysis. The findings should not be interpreted as causal conclusions.
