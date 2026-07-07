# PySpark Data Engineering Extension

This folder contains a PySpark-based extension of the Employee Lifecycle Analytics project.

The goal of this extension is to simulate how the original SQL-based HR analytics pipeline could be implemented in a Spark-based data engineering environment, such as Databricks.

## Purpose

The main project was originally built using PostgreSQL and SQL. This extension adds a distributed data processing perspective by using PySpark to:

- load raw HR CSV datasets;
- inspect schemas and row counts;
- run basic data quality checks;
- clean and standardize fields;
- create employee-level analytical features;
- join workforce, recruitment, engagement and training datasets;
- export the final analytical dataset to CSV and Parquet;
- validate key KPIs against the SQL pipeline outputs.

## Files

| File | Description |
|---|---|
| `01_load_and_profile_hr_data_pyspark.py` | Loads the four raw HR datasets and performs basic profiling, including row counts, schemas, duplicate checks and missing value checks. |
| `02_transform_employee_lifecycle_pyspark.py` | Cleans and transforms the raw datasets, creates employee-level flags and segments, joins the datasets and exports the final PySpark analytical output. |
| `03_validate_pyspark_outputs.py` | Compares key KPIs from the SQL and PySpark outputs to validate consistency between the two pipelines. |

## Data Sources

The extension uses the same raw CSV files as the main SQL project:

- `data/employee_data.csv`
- `data/recruitment_data.csv`
- `data/employee_engagement_survey_data.csv`
- `data/training_and_development_data.csv`

## Output Files

The PySpark transformation script exports results to:

```text
outputs/pyspark/
```

Main outputs:

| Output | Description |
|---|---|
| `employee_lifecycle_summary_pyspark_csv/` | Spark-generated CSV output folder containing the final analytical dataset. |
| `employee_lifecycle_summary_pyspark_parquet/` | Parquet version of the final analytical dataset. |
| `sql_vs_pyspark_validation.csv` | Validation file comparing key SQL and PySpark KPIs. |

## Key Transformations

The PySpark pipeline creates a final employee-level analytical dataset by:

- standardizing column names;
- converting date fields;
- creating active, non-active and termination flags;
- separating voluntary and involuntary termination;
- creating employee status groups;
- calculating tenure;
- creating engagement segments;
- identifying whether training happened before or after the employee start date;
- creating early attrition flags for 6-month and 12-month windows;
- joining employee, recruitment, engagement and training data.

## Validation

The validation script compares the PySpark output with the SQL analytical output on the main KPIs:

- total employees;
- active employees;
- terminated employees;
- voluntary terminations;
- involuntary terminations;
- early attrition, when comparable SQL outputs are available.

This ensures that the PySpark pipeline produces results that are consistent with the SQL-based pipeline.

## Databricks Relevance

Although this extension was developed locally using PySpark, the logic is compatible with a Spark-based cloud environment such as Databricks.

In a Databricks implementation, the same workflow could be adapted to:

- read raw files from cloud storage;
- write transformed outputs as Delta tables;
- schedule notebook workflows;
- create a lakehouse-style HR analytics pipeline;
- connect the final analytical dataset to BI or machine learning workflows.

## How to Run

From the project root, run:

```bash
python3 pyspark/01_load_and_profile_hr_data_pyspark.py
```

Then:

```bash
python3 pyspark/02_transform_employee_lifecycle_pyspark.py
```

Finally:

```bash
python3 pyspark/03_validate_pyspark_outputs.py
```

## Requirements

This extension requires:

- Python
- PySpark
- Java
- pandas
- pyarrow

Install the required Python packages with:

```bash
pip install -r requirements.txt
```