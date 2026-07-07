from pathlib import Path

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, count, when


# ============================================================
# Project: Employee Lifecycle Analytics
# Script: 01_load_and_profile_hr_data_pyspark.py
# Purpose: Load and profile HR datasets using PySpark
# Author: Joana Inácio
# ============================================================


# ------------------------------------------------------------
# Start Spark session
# ------------------------------------------------------------

spark = (
    SparkSession.builder
    .appName("EmployeeLifecycleLoadAndProfile")
    .master("local[*]")
    .getOrCreate()
)

spark.sparkContext.setLogLevel("WARN")


# ------------------------------------------------------------
# Paths
# ------------------------------------------------------------

PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_PATH = PROJECT_ROOT / "data"


# ------------------------------------------------------------
# Load datasets
# ------------------------------------------------------------

employees = (
    spark.read
    .option("header", True)
    .option("inferSchema", True)
    .csv(str(DATA_PATH / "employee_data.csv"))
)

recruitment = (
    spark.read
    .option("header", True)
    .option("inferSchema", True)
    .csv(str(DATA_PATH / "recruitment_data.csv"))
)

engagement = (
    spark.read
    .option("header", True)
    .option("inferSchema", True)
    .option("sep", ";")
    .csv(str(DATA_PATH / "employee_engagement_survey_data.csv"))
)

training = (
    spark.read
    .option("header", True)
    .option("inferSchema", True)
    .csv(str(DATA_PATH / "training_and_development_data.csv"))
)


# ------------------------------------------------------------
# Basic profiling
# ------------------------------------------------------------

datasets = {
    "employees": employees,
    "recruitment": recruitment,
    "engagement": engagement,
    "training": training
}

print("\n============================================================")
print("Dataset Row Counts")
print("============================================================")

for name, df in datasets.items():
    print(f"{name}: {df.count()} rows, {len(df.columns)} columns")


print("\n============================================================")
print("Schemas")
print("============================================================")

for name, df in datasets.items():
    print(f"\n{name.upper()} SCHEMA")
    df.printSchema()


# ------------------------------------------------------------
# Duplicate checks
# ------------------------------------------------------------

print("\n============================================================")
print("Duplicate ID Checks")
print("============================================================")

employees_duplicates = (
    employees
    .groupBy("EmpID")
    .count()
    .filter(col("count") > 1)
    .count()
)

recruitment_duplicates = (
    recruitment
    .groupBy("Applicant ID")
    .count()
    .filter(col("count") > 1)
    .count()
)

print(f"Duplicate employee IDs: {employees_duplicates}")
print(f"Duplicate applicant IDs: {recruitment_duplicates}")


# ------------------------------------------------------------
# Missing values in key fields
# ------------------------------------------------------------

print("\n============================================================")
print("Missing Values in Key Fields")
print("============================================================")

key_fields = {
    "employees": ["EmpID", "StartDate", "EmployeeStatus", "DepartmentType"],
    "recruitment": ["Applicant ID", "Application Date", "Status"],
    "engagement": ["Employee ID", "Survey Date", "Engagement Score"],
    "training": ["Employee ID", "Training Date", "Training Outcome"]
}

for name, fields in key_fields.items():
    df = datasets[name]

    print(f"\n{name.upper()}")

    missing_exprs = [
        count(when(col(field).isNull(), field)).alias(field)
        for field in fields
        if field in df.columns
    ]

    df.select(missing_exprs).show()


# ------------------------------------------------------------
# Preview datasets
# ------------------------------------------------------------

print("\n============================================================")
print("Dataset Previews")
print("============================================================")

for name, df in datasets.items():
    print(f"\n{name.upper()} PREVIEW")
    df.show(5, truncate=False)


# ------------------------------------------------------------
# Stop Spark session
# ------------------------------------------------------------

spark.stop()