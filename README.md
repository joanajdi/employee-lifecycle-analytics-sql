# Employee Lifecycle Analytics SQL Project

## Executive Summary

- Analyzed 3,000 employee records across recruitment, workforce, engagement, training, performance and attrition data.
- 81.93% of employees are active, while 18.07% are non-active.
- The overall termination rate is 12.90%.
- Voluntary termination is the main attrition category, representing 10.70% of the workforce.
- Production is the largest department, representing 67.33% of employees and concentrating the highest absolute number of terminations.
- Software Engineering has the highest termination rate, at 17.39%.
- Employees in PIP have the highest termination rate among performance groups, at 19.35%.
- Engagement shows only a weak relationship with attrition in this dataset.
- The final view `employee_lifecycle_summary` combines recruitment, engagement, training, performance and attrition data into one reusable employee-level analytical dataset.

## Project Overview

This project analyzes the employee lifecycle using SQL, from recruitment to employee engagement, training and development, performance, and attrition.

The goal of the project is to explore how different stages of the employee lifecycle relate to one another and to identify patterns that can support HR decision-making in areas such as workforce planning, retention, engagement, and training investment.

This project was developed as part of my analytics portfolio, with a focus on applying SQL to a realistic HR analytics business case.

---

## Executive Summary

* The dataset contains 3,000 employees and combines recruitment, workforce, engagement, training and attrition data.
* 2,458 employees are active, representing 81.93% of the workforce.
* The overall termination rate is 12.90%, mostly driven by voluntary terminations.
* Production represents 67.33% of the workforce and concentrates the highest absolute number of terminations.
* Software Engineering has the highest termination rate, at 17.39%.
* Engagement shows only a weak relationship with attrition in this dataset.
* The final analytical view, `employee_lifecycle_summary`, combines all employee lifecycle data into one reusable employee-level dataset.

---

## Business Objective

The main business objective is to answer the following question:

**How can employee lifecycle data be used to better understand workforce composition, recruitment patterns, training investment, engagement levels, and attrition risks?**

To address this question, the project explores:

* Workforce structure and employee composition
* Recruitment pipeline and applicant characteristics
* Training activity, cost, and outcomes
* Employee engagement, satisfaction, and work-life balance
* Attrition and retention patterns
* Cross-functional employee lifecycle insights

---

## Dataset

The project uses four HR-related datasets:

| Dataset                               | Description                                                                         |
| ------------------------------------- | ----------------------------------------------------------------------------------- |
| `employee_data.csv`                   | Employee demographic, employment, performance, department and attrition information |
| `recruitment_data.csv`                | Applicant information, recruitment status, education, experience and desired salary |
| `employee_engagement_survey_data.csv` | Employee engagement, satisfaction and work-life balance survey results              |
| `training_and_development_data.csv`   | Training program, type, outcome, duration and cost information                      |

Each dataset contains 3,000 records.

The employee ID was used as the main linking key across the employee, engagement and training tables. The applicant ID in the recruitment dataset was treated as the corresponding employee identifier for the purpose of this project.

Monetary values are reported as provided in the dataset. The original dataset does not specify a currency.

---

## Tools Used

* PostgreSQL
* SQL
* VS Code
* Terminal
* CSV exports for analytical outputs

---

## Database Structure

The project is based on four main raw tables:

| Table                  | Description                      |
| ---------------------- | -------------------------------- |
| `employees`            | Core employee information        |
| `recruitment`          | Recruitment and applicant data   |
| `engagement_surveys`   | Employee survey results          |
| `training_development` | Training and development records |

In addition to the raw imported tables, standardized analytical views were created:

| View                         | Description                                                                         |
| ---------------------------- | ----------------------------------------------------------------------------------- |
| `vw_employees_clean`         | Standardized employee view with tenure and attrition flags                          |
| `vw_recruitment_clean`       | Standardized recruitment view with application month                                |
| `vw_engagement_clean`        | Engagement view with engagement, satisfaction and work-life balance segments        |
| `vw_training_clean`          | Training view with cost, duration and timing segments                               |
| `employee_lifecycle_summary` | Final analytical view combining employee, recruitment, engagement and training data |

---

## Project Structure

```text
employee-lifecycle-analytics-sql/
│
├── data/
│   ├── employee_data.csv
│   ├── employee_engagement_survey_data.csv
│   ├── recruitment_data.csv
│   └── training_and_development_data.csv
│
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_import_data.sql
│   ├── 03_cleaning_and_standardization.sql
│   ├── 04_data_quality_checks.sql
│   ├── 05_workforce_overview.sql
│   ├── 06_export_workforce_outputs.sql
│   ├── 07_recruitment_funnel.sql
│   ├── 08_export_recruitment_outputs.sql
│   ├── 09_training_analysis.sql
│   ├── 10_export_training_outputs.sql
│   ├── 11_engagement_analysis.sql
│   ├── 12_export_engagement_outputs.sql
│   ├── 13_attrition_analysis.sql
│   ├── 14_export_attrition_outputs.sql
│   ├── 15_final_employee_lifecycle_view.sql
│   └── 16_export_final_view.sql
│
├── outputs/
│   ├── workforce_overall_kpis.csv
│   ├── headcount_by_department.csv
│   ├── recruitment_status_distribution.csv
│   ├── training_outcome_distribution.csv
│   ├── engagement_segments.csv
│   ├── attrition_by_department.csv
│   ├── department_risk_summary.csv
│   └── employee_lifecycle_summary.csv
│
├── docs/
│   ├── data_dictionary.md
│   └── project_notes.md
│
└── README.md
```

---

## Analysis Modules

### 1. Data Cleaning and Standardization

Before running the main analysis, standardized views were created to clean and enrich the imported tables without modifying the raw data.

The standardized views include:

* `vw_employees_clean`
* `vw_recruitment_clean`
* `vw_engagement_clean`
* `vw_training_clean`

These views add fields such as:

* employee status groups;
* tenure in days and years;
* termination flags;
* engagement, satisfaction and work-life balance segments;
* training cost, duration and timing segments;
* application month.

---

### 2. Data Quality Checks

Data quality checks were performed to validate:

* Row counts by table
* Duplicate employee and applicant IDs
* Missing values in key fields
* Date inconsistencies
* Referential integrity across tables
* Categorical value consistency

All four tables were successfully imported, each containing 3,000 records. No duplicate records were found in the main ID fields, and no missing values were identified in the key fields checked.

One data quality issue was identified: 288 training records occurred before the employee start date, representing 9.60% of all training records. These records were not removed because they may represent pre-employment training, onboarding preparation, or data entry inconsistencies. Instead, a training timing flag was created.

---

### 3. Workforce Overview

This module analyzes the overall workforce composition.

Key questions:

* How many employees are active?
* How is the workforce distributed by department?
* Which departments have the highest active employee percentage?
* How is performance distributed?
* How does average employee rating vary by department?

Main findings:

* The dataset contains 3,000 employees.
* 2,458 employees are active, representing 81.93% of the workforce.
* 542 employees are non-active, representing 18.07%.
* Production is the largest department, with 2,020 employees, representing 67.33% of the workforce.
* Production also has one of the lowest active employee percentages, at 78.61%.
* Performance scores are highly concentrated in the `Fully Meets` category, representing 78.70% of employees.
* The overall average employee rating is 2.97.

---

### 4. Recruitment Funnel Analysis

This module explores the recruitment pipeline and applicant characteristics.

Key questions:

* How are applicants distributed across recruitment statuses?
* How do experience and desired salary vary by recruitment status?
* How does desired salary vary by education level?
* What is the application period covered by the dataset?

Main findings:

* The recruitment dataset contains 3,000 applicants.
* Applications range from 2023-05-06 to 2023-08-05.
* The average applicant has 9.96 years of experience.
* The average desired salary is 65,079.06.
* Recruitment statuses are almost evenly distributed, with each status representing around 20% of applicants.
* Experience and desired salary vary only slightly across recruitment statuses.
* Education levels are also evenly distributed, with relatively small differences in average desired salary.

Because the recruitment statuses are highly balanced, funnel conversion interpretations should be made with caution.

---

### 5. Training and Development Analysis

This module analyzes training activity, cost, duration and outcomes.

Key questions:

* What is the total training investment?
* How are training outcomes distributed?
* How do internal and external training compare?
* Which departments receive the highest training investment?
* How do training outcomes relate to performance?

Main findings:

* The dataset contains 3,000 training records, covering 3,000 unique employees.
* The average training duration is 2.98 days.
* Total training cost is 1,675,886.09.
* Average training cost is 558.63.
* Training outcomes are almost evenly distributed across Incomplete, Completed, Passed and Failed.
* Internal and external training are nearly balanced.
* Production accounts for the highest total training cost, mainly due to its large workforce size.
* Software Engineering has the highest average training cost.
* Employees in PIP have the highest average training cost, which may suggest higher investment in corrective or development-oriented training.

---

### 6. Engagement Analysis

This module explores employee engagement, satisfaction and work-life balance.

Key questions:

* What are the average engagement, satisfaction and work-life balance scores?
* How are engagement scores distributed?
* Which departments have higher or lower engagement?
* How does engagement vary by employee status and performance?
* How many employees fall into low, medium and high engagement segments?

Main findings:

* The average engagement score is 2.94.
* The average satisfaction score is 3.02.
* The average work-life balance score is 2.99.
* Low engagement employees represent 42.43% of the workforce.
* High engagement employees represent 38.93%.
* Production has the lowest average engagement score among major departments.
* Admin Offices shows a low average satisfaction score but a relatively high work-life balance score.
* Engagement differences between active and non-active employees are small.
* Performance score does not show a clear linear relationship with engagement.

---

### 7. Attrition and Retention Analysis

This module analyzes employee attrition and retention patterns.

Key questions:

* What is the overall termination rate?
* Which departments have the highest attrition?
* How does voluntary and involuntary termination vary by department?
* How does tenure differ between active and terminated employees?
* How are attrition patterns related to performance, engagement and training?

Main findings:

* The overall termination rate is 12.90%.
* The voluntary termination rate is 10.70%.
* The involuntary termination rate is 2.20%.
* Software Engineering has the highest termination rate, at 17.39%.
* Production has the largest absolute number of terminations.
* Production terminations are mostly voluntary.
* IT/IS terminations are mostly involuntary, with 91.18% of terminations classified as terminated for cause.
* Active employees have an average tenure of 3.72 years.
* Voluntarily terminated employees have an average tenure of 1.44 years.
* Employees terminated for cause have an average tenure of 1.33 years.
* Employees in PIP have the highest termination rate, at 19.35%.
* Engagement segment shows only a weak relationship with attrition.

---

## Final Analytical View

The final view `employee_lifecycle_summary` combines employee, recruitment, engagement and training data into a single analytical layer.

It includes:

* Employee demographics
* Employment status
* Department and business unit
* Tenure
* Attrition flags
* Performance indicators
* Recruitment information
* Engagement scores and segments
* Satisfaction and work-life balance segments
* Training program, cost, duration, outcome and timing
* Analytical flags for low engagement, low performance and training outcomes

This view can be reused for further SQL exploration, reporting, dashboard development or analysis in tools such as Power BI, Excel, Tableau or Python.

---

## SQL Skills Demonstrated

## Key SQL Concepts Demonstrated

This project demonstrates several SQL concepts commonly used in analytics workflows.

| SQL Concept | How It Was Used in This Project |
|---|---|
| `CREATE TABLE` | Used to define the relational database structure for employees, recruitment, engagement surveys and training records. |
| `\copy` | Used to import CSV files into PostgreSQL tables and export analytical query results to CSV outputs. |
| `JOIN` | Used to combine employee data with recruitment, engagement and training information through employee-level identifiers. |
| `LEFT JOIN` | Used in the final analytical view to preserve all employee records even when joining additional lifecycle data. |
| `GROUP BY` | Used to aggregate workforce, recruitment, training, engagement and attrition metrics by department, status, performance score and other categories. |
| Conditional aggregation with `FILTER` | Used to calculate metrics such as active employees, terminated employees, voluntary terminations and inactive employees within the same query. |
| `CASE WHEN` | Used to create analytical segments and flags, such as engagement segment, training timing, attrition flags and performance flags. |
| Window functions | Used to calculate percentages within grouped outputs, such as percentage of employees by department or percentage within training program. |
| Date calculations | Used to calculate employee tenure in days and years using start dates, exit dates and the current date. |
| `CREATE VIEW` | Used to build standardized analytical layers and the final `employee_lifecycle_summary` view. |
| Data quality checks | Used to identify duplicates, missing values, date inconsistencies and referential integrity issues. |
| Analytical flags | Used to create reusable binary variables such as `termination_flag`, `low_engagement_flag`, `positive_training_outcome_flag` and `low_performance_flag`. |
| CSV exports | Used to generate reusable outputs for reporting, documentation or future dashboard development. |

These concepts were applied across a full SQL analytics workflow: database creation, data import, data validation, cleaning and standardization, exploratory analysis, output generation and final analytical data modeling.

---

## Key Outputs

The project generates several CSV outputs, including:

| Output                                | Description                              |
| ------------------------------------- | ---------------------------------------- |
| `workforce_overall_kpis.csv`          | Overall workforce KPIs                   |
| `headcount_by_department.csv`         | Employee count by department             |
| `recruitment_status_distribution.csv` | Recruitment funnel status distribution   |
| `training_outcome_distribution.csv`   | Training outcome distribution            |
| `engagement_segments.csv`             | Low, medium and high engagement segments |
| `attrition_by_department.csv`         | Attrition metrics by department          |
| `department_risk_summary.csv`         | Combined department-level risk summary   |
| `employee_lifecycle_summary.csv`      | Final employee-level analytical dataset  |

---

## How to Run the Project

1. Create the PostgreSQL database:

```bash
createdb employee_lifecycle_db
```

2. Create the database tables:

```bash
psql employee_lifecycle_db -f sql/01_create_tables.sql
```

3. Import the CSV files:

```bash
psql employee_lifecycle_db -f sql/02_import_data.sql
```

4. Create standardized views:

```bash
psql employee_lifecycle_db -f sql/03_cleaning_and_standardization.sql
```

5. Run data quality checks:

```bash
psql employee_lifecycle_db -f sql/04_data_quality_checks.sql
```

6. Run the analysis scripts:

```bash
psql employee_lifecycle_db -f sql/05_workforce_overview.sql
psql employee_lifecycle_db -f sql/07_recruitment_funnel.sql
psql employee_lifecycle_db -f sql/09_training_analysis.sql
psql employee_lifecycle_db -f sql/11_engagement_analysis.sql
psql employee_lifecycle_db -f sql/13_attrition_analysis.sql
```

7. Export analytical outputs:

```bash
psql employee_lifecycle_db -f sql/06_export_workforce_outputs.sql
psql employee_lifecycle_db -f sql/08_export_recruitment_outputs.sql
psql employee_lifecycle_db -f sql/10_export_training_outputs.sql
psql employee_lifecycle_db -f sql/12_export_engagement_outputs.sql
psql employee_lifecycle_db -f sql/14_export_attrition_outputs.sql
```

8. Create and export the final analytical view:

```bash
psql employee_lifecycle_db -f sql/15_final_employee_lifecycle_view.sql
psql employee_lifecycle_db -f sql/16_export_final_view.sql
```

---

## Documentation

Additional documentation is available in the `docs/` folder:

| File                 | Description                                                                        |
| -------------------- | ---------------------------------------------------------------------------------- |
| `data_dictionary.md` | Describes the main tables, views, fields and derived variables                     |
| `project_notes.md`   | Summarizes data quality findings, analytical observations and interpretation notes |

---

## Limitations

Some patterns in the dataset appear highly balanced, especially recruitment statuses, training outcomes and score distributions. This suggests that the dataset may be synthetic or intentionally structured for analytical practice.

For this reason, the insights should be interpreted as exploratory findings rather than causal conclusions.

The project focuses on SQL-based analysis and does not apply statistical modeling or predictive machine learning.

---

## Conclusion

This project shows how SQL can be used to analyze the full employee lifecycle, from recruitment to engagement, training, performance and attrition.

The analysis highlights how HR data can be transformed into structured insights to support decisions around workforce planning, employee experience, training investment and retention.
