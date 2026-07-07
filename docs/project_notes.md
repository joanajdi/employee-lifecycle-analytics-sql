# Project Notes

This document summarizes the main data quality findings, analytical observations and interpretation notes from the **Employee Lifecycle Analytics SQL Project**.

The purpose of this file is to document the reasoning behind the analysis, highlight relevant patterns found in the data, and record important limitations that should be considered when interpreting the results.

Monetary values are reported as provided in the dataset. The original dataset does not specify a currency.

---

## Data Quality Findings

### Key Findings

All four tables were successfully imported into PostgreSQL, each containing 3,000 records:

* `employees`: 3,000 records
* `recruitment`: 3,000 records
* `engagement_surveys`: 3,000 records
* `training_development`: 3,000 records

No duplicate records were found for:

* employee IDs;
* applicant IDs;
* employee survey records;
* employee training records.

No missing values were found in the key fields checked across the four tables.

The main data quality issue identified was related to training dates. A total of 288 training records occurred before the employee start date, representing 9.60% of all training records.

Training records before employee start date by training type:

| Training Type | Records |
| ------------- | ------: |
| External      |     158 |
| Internal      |     130 |

Training records before employee start date by program:

| Training Program       | Records |
| ---------------------- | ------: |
| Customer Service       |      60 |
| Leadership Development |      58 |
| Communication Skills   |      58 |
| Technical Skills       |      56 |
| Project Management     |      56 |

### Interpretation Notes

The training records that occurred before the employee start date were not removed. These records may represent pre-employment training, onboarding preparation, or data entry inconsistencies.

Instead of deleting them, a training timing flag was created to distinguish between:

* training before the employee start date;
* training on or after the employee start date.

This approach preserves the original data while making the potential inconsistency explicit in later analysis.

---

## Workforce Overview Findings

### Key Findings

The workforce overview analysis showed that the dataset contains 3,000 employees.

Out of these:

| Employee Group | Employees | Percentage |
| -------------- | --------: | ---------: |
| Active         |     2,458 |     81.93% |
| Non-active     |       542 |     18.07% |

The largest employee status group after active employees is `Voluntarily Terminated`, with 321 employees, representing 10.70% of the workforce. This is substantially higher than `Terminated for Cause`, which represents 2.20% of employees.

The workforce is highly concentrated in the Production department:

| Department           | Employees | Percentage |
| -------------------- | --------: | ---------: |
| Production           |     2,020 |     67.33% |
| IT/IS                |       430 |     14.33% |
| Sales                |       331 |     11.03% |
| Software Engineering |       115 |      3.83% |
| Admin Offices        |        80 |      2.67% |
| Executive Office     |        24 |      0.80% |

Production also has one of the lowest active employee percentages, with 78.61% active employees. In contrast, Admin Offices and Executive Office show the highest active employee percentages, with 97.50% and 100.00%, respectively.

Business units are evenly distributed, with each unit representing approximately 10% of the workforce.

Employee type is also relatively balanced:

| Employee Type | Percentage |
| ------------- | ---------: |
| Full-Time     |     34.60% |
| Contract      |     33.60% |
| Part-Time     |     31.80% |

The workforce has a higher proportion of female employees, representing 56.07% of the total population, compared with 43.93% male employees.

Performance scores are strongly concentrated in the `Fully Meets` category, which includes 78.70% of employees. The overall average employee rating is 2.97, with limited variation across departments.

### Interpretation Notes

The concentration of employees in Production should be considered when interpreting company-level metrics. Since Production represents more than two-thirds of the workforce, overall trends may be strongly influenced by this department.

The Executive Office has the highest active employee percentage, but it only includes 24 employees. As a result, department-level percentages for this group should be interpreted with caution.

---

## Recruitment Funnel Findings

### Key Findings

The recruitment dataset contains 3,000 applicants, covering applications submitted between 2023-05-06 and 2023-08-05.

Applicants have:

* an average of 9.96 years of experience;
* an average desired salary of 65,079.06.

Recruitment statuses are almost evenly distributed:

| Recruitment Status | Applicants | Percentage |
| ------------------ | ---------: | ---------: |
| Applied            |        611 |     20.37% |
| Offered            |        610 |     20.33% |
| In Review          |        595 |     19.83% |
| Rejected           |        594 |     19.80% |
| Interviewing       |        590 |     19.67% |

Average years of experience varies only slightly across recruitment statuses:

| Recruitment Status | Avg. Years of Experience |
| ------------------ | -----------------------: |
| Rejected           |                    10.32 |
| Interviewing       |                    10.10 |
| Offered            |                    10.00 |
| Applied            |                     9.83 |
| In Review          |                     9.57 |

Average desired salary also varies moderately across recruitment statuses. Applied candidates have the highest average desired salary, while Rejected candidates have the lowest. However, the difference between the highest and lowest status-level averages is relatively small.

Education levels are also evenly distributed. Average desired salary is similar across education levels, with `Master's Degree` and `Bachelor's Degree` showing slightly higher averages than `PhD` and `High School`.

### Interpretation Notes

The balanced distribution of recruitment statuses suggests that the dataset may be synthetic or intentionally balanced. In a real recruitment funnel, it would be more common to observe a larger proportion of applicants in early-stage or rejected statuses and a smaller proportion in offered statuses.

For this reason, recruitment funnel conversion interpretations should be made with caution.

Job title-level salary analysis should also be interpreted carefully because many job titles have very small applicant counts, making averages unstable.

---

## Training and Development Findings

### Key Findings

The training dataset contains 3,000 training records, covering 3,000 unique employees. This means that each employee has one associated training record in the dataset.

Overall training metrics:

| Metric                    |        Value |
| ------------------------- | -----------: |
| Average training duration |    2.98 days |
| Average training cost     |       558.63 |
| Total training investment | 1,675,886.09 |

Training outcomes are almost evenly distributed across four categories:

| Training Outcome | Percentage |
| ---------------- | ---------: |
| Incomplete       |     25.83% |
| Completed        |     25.67% |
| Passed           |     24.63% |
| Failed           |     23.87% |

Internal and external training are also almost evenly distributed:

| Training Type | Percentage |
| ------------- | ---------: |
| Internal      |     50.30% |
| External      |     49.70% |

Average cost and duration are very similar across both training types, indicating no major cost or duration differences between internal and external training in this dataset.

`Communication Skills` is the most common training program, accounting for 22.43% of training records. It also represents the highest total training cost, followed by:

* Project Management;
* Leadership Development;
* Technical Skills;
* Customer Service.

Training investment is strongly concentrated in the Production department, which accounts for the highest total training cost. However, this is mainly explained by the size of the Production department.

When looking at average training cost, Software Engineering shows the highest average cost per training record.

Training outcomes vary moderately by department:

* IT/IS has the highest percentage of failed training outcomes.
* Sales and Software Engineering show the highest percentages of completed training outcomes.

Employees in PIP have the highest average training cost.

### Interpretation Notes

The balanced distribution of training outcomes suggests that outcome-based interpretations should be made with caution.

The fact that Production has the highest total training investment should not be interpreted as higher investment intensity by itself, because Production is also the largest department. Average training cost is a better metric for comparing training investment across departments.

The higher average training cost among employees in PIP may suggest higher investment in corrective or development-oriented training. However, this should be interpreted as a hypothesis rather than a causal conclusion.

Training outcomes do not show a clear relationship with performance score. Employees in PIP and Needs Improvement categories do not necessarily show worse training outcomes.

---

## Engagement and Employee Experience Findings

### Key Findings

The engagement survey dataset contains 3,000 survey records, covering 3,000 unique employees. This means that each employee has one survey response in the dataset.

The survey period ranges from 2022-08-05 to 2023-08-05.

Overall survey metrics:

| Metric                          | Value |
| ------------------------------- | ----: |
| Average engagement score        |  2.94 |
| Average satisfaction score      |  3.02 |
| Average work-life balance score |  2.99 |

These scores are close to the midpoint of the 1-to-5 scale.

Engagement scores are relatively evenly distributed across the five score levels.

Engagement segments:

| Engagement Segment | Employees | Percentage |
| ------------------ | --------: | ---------: |
| Low Engagement     |     1,273 |     42.43% |
| Medium Engagement  |       559 |     18.63% |
| High Engagement    |     1,168 |     38.93% |

At department level:

| Department           | Avg. Engagement Score |
| -------------------- | --------------------: |
| Executive Office     |                  3.38 |
| IT/IS                |                  3.03 |
| Sales                |                  2.99 |
| Software Engineering |                  2.97 |
| Admin Offices        |                  2.93 |
| Production           |                  2.91 |

Production has the lowest average engagement score and represents the largest department in the workforce.

Admin Offices shows an interesting pattern:

| Metric                          | Value |
| ------------------------------- | ----: |
| Average engagement score        |  2.93 |
| Average satisfaction score      |  2.51 |
| Average work-life balance score |  3.19 |

Engagement differences by employee status are small:

| Employee Status Group | Avg. Engagement Score |
| --------------------- | --------------------: |
| Active                |                  2.95 |
| Non-active            |                  2.90 |

Performance score does not show a clear linear relationship with engagement. Employees classified as `Fully Meets` have the highest average engagement score, while employees classified as `Exceeds` do not show the highest engagement levels.

Most low engagement employees are located in Production, which accounts for 69.52% of all low engagement employees.

### Interpretation Notes

Although Production contains most low engagement employees, this is strongly influenced by the size of the Production department. When interpreting engagement by department, both absolute counts and within-department percentages should be considered.

Executive Office has the highest average engagement score, but this department includes only 24 employees. This result should therefore be interpreted with caution.

The Admin Offices pattern suggests that satisfaction and work-life balance may not move together in this dataset. Employees in this department report relatively high work-life balance but lower satisfaction.

The difference in average engagement between active and non-active employees is small, suggesting that engagement alone may not strongly explain employee status in this dataset.

---

## Attrition and Retention Findings

### Key Findings

The attrition analysis showed that 387 out of 3,000 employees were terminated, resulting in an overall termination rate of 12.90%.

Attrition metrics:

| Metric                       |  Value |
| ---------------------------- | -----: |
| Total employees              |  3,000 |
| Active employees             |  2,458 |
| Non-active employees         |    542 |
| Terminated employees         |    387 |
| Termination rate             | 12.90% |
| Voluntary termination rate   | 10.70% |
| Involuntary termination rate |  2.20% |

Voluntary termination is the main attrition category.

Attrition varies significantly across departments:

| Department           | Termination Rate |
| -------------------- | ---------------: |
| Software Engineering |           17.39% |
| Production           |           15.94% |
| IT/IS                |            7.91% |
| Sales                |            3.02% |
| Admin Offices        |            1.25% |
| Executive Office     |            0.00% |

Although Software Engineering has the highest termination rate, Production accounts for the largest absolute number of terminations, with 322 terminated employees, due to its large workforce size.

Termination patterns differ by department:

* Production terminations are mostly voluntary.
* IT/IS terminations are mostly involuntary.
* In IT/IS, 91.18% of terminations are classified as terminated for cause.

Tenure analysis shows that active employees have a higher average tenure than terminated employees:

| Employee Status        | Avg. Tenure |
| ---------------------- | ----------: |
| Active                 |  3.72 years |
| Voluntarily Terminated |  1.44 years |
| Terminated for Cause   |  1.33 years |

Performance score shows some relationship with attrition:

| Performance Score | Termination Rate |
| ----------------- | ---------------: |
| PIP               |           19.35% |
| Fully Meets       |           13.09% |
| Needs Improvement |           11.30% |
| Exceeds           |           10.84% |

Engagement segment shows only a weak relationship with attrition:

| Engagement Segment | Termination Rate |
| ------------------ | ---------------: |
| Low Engagement     |           13.28% |
| Medium Engagement  |           12.88% |
| High Engagement    |           12.50% |

Work-life balance shows a slightly clearer pattern, with employees scoring 5 having the lowest termination rate, at 11.19%. However, the relationship is still not fully linear.

Training outcome does not show a simple relationship with attrition. Employees with `Completed` training have the lowest termination rate, while employees with `Passed` training have the highest.

The department risk summary shows that Software Engineering and Production have the highest termination rates. Software Engineering also has the highest average training cost, while Production combines high attrition volume with the lowest average engagement score among major departments.

### Interpretation Notes

Attrition appears to be more concentrated among employees with shorter organizational tenure. Active employees have substantially longer average tenure than voluntarily terminated employees and employees terminated for cause.

The relationship between performance and attrition is not fully linear. Employees in PIP have the highest termination rate, which is expected, but employees classified as Needs Improvement have a lower termination rate than Fully Meets employees.

The relationship between engagement and attrition is weak in this dataset. Lower engagement is associated with a slightly higher termination rate, but the difference across engagement segments is small.

The IT/IS termination pattern is distinctive because most terminations are involuntary. This may indicate different performance, role fit, management, or workforce planning dynamics in that department, but further investigation would be needed.

---

## Overall Takeaways

The analysis shows that the dataset provides a complete view of the employee lifecycle, connecting recruitment, workforce structure, training, engagement, performance and attrition.

Across the project, several variables appear highly balanced, including recruitment status, training outcomes and survey scores. This suggests that the dataset may be synthetic or designed for analytical practice. As a result, the findings should be interpreted as exploratory rather than causal.

The strongest business insights are related to department-level patterns. Production represents the majority of the workforce and concentrates the highest absolute number of terminations, while Software Engineering has the highest termination rate. IT/IS also shows a distinctive pattern, with most terminations classified as terminated for cause.

Tenure also appears to be an important dimension. Active employees have a much higher average tenure than terminated employees, suggesting that attrition is more concentrated among employees with shorter organizational tenure.

Engagement, satisfaction, work-life balance, training outcomes and performance scores show some differences across employee groups, but most relationships are not strong enough to support causal conclusions.

The final analytical view, `employee_lifecycle_summary`, enables further analysis by combining employee profile, recruitment, engagement, training, performance and attrition data into a single employee-level dataset.

---
## Cohort and Early Attrition Findings

### Key Findings

The cohort and early attrition analysis added a temporal perspective to the attrition analysis by examining when employees leave after joining the organization.

Overall, 96 employees left within the first 6 months, representing 3.20% of the workforce. A total of 176 employees left within the first 12 months, representing 5.87% of the workforce.

Among the 387 terminated employees, approximately 24.8% left within their first 6 months and approximately 45.5% left within their first 12 months. This suggests that a substantial share of attrition occurs during the first year of employment.

At department level, Software Engineering had the highest 12-month early attrition rate, at 8.70%, followed by Production, at 6.98%. However, Production had the highest absolute number of early attrition cases, reflecting its large workforce size.

By employee type, Full-Time employees had the highest 12-month early attrition rate, at 7.13%, followed by Part-Time employees at 5.45% and Contract employees at 4.96%.

By performance score, employees in PIP had the highest 12-month early attrition rate, at 7.53%. However, differences across performance groups were not extremely large.

Engagement segment did not show a clear linear relationship with early attrition. High Engagement employees had the highest 12-month early attrition rate, at 6.25%, followed by Low Engagement at 5.89% and Medium Engagement at 5.01%.

By recruitment status, employees associated with the Rejected category had the highest 12-month early attrition rate, at 7.41%. However, this result should be interpreted with caution because the recruitment-to-employee relationship is based on the project assumption that `applicant_id` corresponds to `employee_id`.

### Visualization Notes

A Python notebook was created to visualize the cohort and early attrition outputs generated in SQL.

The visualizations show that older start-year cohorts generally have higher termination rates, while the 2023 cohort has the lowest termination rate. This should be interpreted carefully because more recent cohorts had less time to experience attrition.

The early attrition visualizations also reinforce that Software Engineering has the highest proportional early attrition risk, while Production represents the largest operational impact due to its workforce size.

### Interpretation Notes

The cohort analysis by start year showed that older cohorts generally had higher termination rates. However, this should be interpreted carefully because older cohorts had more time to experience attrition.

Early attrition metrics provide a fairer comparison by focusing on fixed time windows, such as the first 6 or 12 months after start date.

The results suggest that early attrition may be particularly relevant in Software Engineering and Production. In practical HR terms, this could point to the need to further investigate onboarding, role expectations, job fit and early employee experience in these areas.

The lack of a clear relationship between engagement segment and early attrition reinforces a broader finding from the project: engagement alone does not strongly explain attrition patterns in this dataset.

## PySpark Data Engineering Extension

A PySpark extension was added to simulate how the employee lifecycle analytics pipeline could be implemented in a Spark-based data engineering environment.

The extension uses the same raw HR CSV files as the SQL pipeline and performs the following steps:

- loads the raw employee, recruitment, engagement and training datasets;
- profiles row counts, schemas, duplicate IDs and missing values in key fields;
- standardizes column names and date formats;
- creates employee-level analytical flags;
- creates engagement and training timing segments;
- joins the four HR datasets into an employee-level analytical output;
- exports the final dataset to CSV and Parquet;
- validates key KPIs against the SQL pipeline outputs.

The PySpark pipeline produced 3,000 employee-level rows, matching the SQL analytical output row count.

The validation script confirmed consistency between the SQL and PySpark pipelines for the main comparable KPIs, including total employees, active employees, terminated employees, voluntary terminations and involuntary terminations.

This extension adds a data engineering perspective to the project and shows how the workflow could be adapted to a Spark-based lakehouse environment such as Databricks.

## Notes for Future Analysis

This project provides a strong analytical foundation. Future extensions could include:

- building a Power BI dashboard using the exported CSV outputs;
- comparing voluntary and involuntary attrition drivers separately;
- creating department-level HR risk scores;
- exploring whether engagement and training variables interact with performance outcomes;
- extending predictive modeling with additional historical HR variables, such as promotion history, salary progression, absenteeism, manager changes and repeated engagement surveys.
