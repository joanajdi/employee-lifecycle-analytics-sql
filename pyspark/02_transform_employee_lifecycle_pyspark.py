from pathlib import Path

from pyspark.sql import SparkSession
from pyspark.sql.functions import (
    col,
    trim,
    when,
    to_date,
    datediff,
    current_date,
    date_add,
    round as spark_round
)


# ============================================================
# Project: Employee Lifecycle Analytics
# Script: 02_transform_employee_lifecycle_pyspark.py
# Purpose: Transform HR datasets and create an analytical lifecycle table using PySpark
# Author: Joana Inácio
# ============================================================


# ------------------------------------------------------------
# Start Spark session
# ------------------------------------------------------------

spark = (
    SparkSession.builder
    .appName("EmployeeLifecycleTransform")
    .master("local[*]")
    .getOrCreate()
)

spark.sparkContext.setLogLevel("WARN")


# ------------------------------------------------------------
# Paths
# ------------------------------------------------------------

PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_PATH = PROJECT_ROOT / "data"
OUTPUT_PATH = PROJECT_ROOT / "outputs" / "pyspark"

OUTPUT_PATH.mkdir(parents=True, exist_ok=True)


# ------------------------------------------------------------
# Load raw datasets
# ------------------------------------------------------------

employees_raw = (
    spark.read
    .option("header", True)
    .option("inferSchema", True)
    .csv(str(DATA_PATH / "employee_data.csv"))
)

recruitment_raw = (
    spark.read
    .option("header", True)
    .option("inferSchema", True)
    .csv(str(DATA_PATH / "recruitment_data.csv"))
)

engagement_raw = (
    spark.read
    .option("header", True)
    .option("inferSchema", True)
    .option("sep", ";")
    .csv(str(DATA_PATH / "employee_engagement_survey_data.csv"))
)

training_raw = (
    spark.read
    .option("header", True)
    .option("inferSchema", True)
    .csv(str(DATA_PATH / "training_and_development_data.csv"))
)


# ------------------------------------------------------------
# Clean employees dataset
# ------------------------------------------------------------

employees = (
    employees_raw
    .select(
        col("EmpID").alias("employee_id"),
        trim(col("FirstName")).alias("first_name"),
        trim(col("LastName")).alias("last_name"),
        to_date(col("StartDate"), "dd-MMM-yy").alias("start_date"),
        to_date(col("ExitDate"), "dd-MMM-yy").alias("exit_date"),
        trim(col("Title")).alias("title"),
        trim(col("Supervisor")).alias("supervisor"),
        trim(col("ADEmail")).alias("ad_email"),
        trim(col("BusinessUnit")).alias("business_unit"),
        trim(col("EmployeeStatus")).alias("employee_status"),
        trim(col("EmployeeType")).alias("employee_type"),
        trim(col("PayZone")).alias("pay_zone"),
        trim(col("EmployeeClassificationType")).alias("employee_classification_type"),
        trim(col("TerminationType")).alias("termination_type"),
        trim(col("TerminationDescription")).alias("termination_description"),
        trim(col("DepartmentType")).alias("department_type"),
        trim(col("Division")).alias("division"),
        to_date(col("DOB"), "dd-MM-yyyy").alias("date_of_birth"),
        trim(col("State")).alias("state"),
        trim(col("JobFunctionDescription")).alias("job_function_description"),
        trim(col("GenderCode")).alias("gender_code"),
        col("LocationCode").alias("location_code"),
        trim(col("RaceDesc")).alias("race_desc"),
        trim(col("MaritalDesc")).alias("marital_desc"),
        trim(col("Performance Score")).alias("performance_score"),
        col("Current Employee Rating").alias("current_employee_rating")
    )
    .withColumn(
        "active_flag",
        when(col("employee_status") == "Active", 1).otherwise(0)
    )
    .withColumn(
        "non_active_flag",
        when(col("employee_status") != "Active", 1).otherwise(0)
    )
    .withColumn(
        "termination_flag",
        when(
            col("employee_status").isin("Voluntarily Terminated", "Terminated for Cause"),
            1
        ).otherwise(0)
    )
    .withColumn(
        "voluntary_termination_flag",
        when(col("employee_status") == "Voluntarily Terminated", 1).otherwise(0)
    )
    .withColumn(
        "involuntary_termination_flag",
        when(col("employee_status") == "Terminated for Cause", 1).otherwise(0)
    )
    .withColumn(
        "employee_status_group",
        when(col("employee_status") == "Active", "Active")
        .when(col("employee_status").isin("Voluntarily Terminated", "Terminated for Cause"), "Terminated")
        .otherwise("Other Non-Active")
    )
    .withColumn(
        "tenure_days",
        when(
            col("exit_date").isNotNull(),
            datediff(col("exit_date"), col("start_date"))
        ).otherwise(
            datediff(current_date(), col("start_date"))
        )
    )
    .withColumn(
        "tenure_years",
        spark_round(col("tenure_days") / 365.25, 2)
    )
)


# ------------------------------------------------------------
# Clean recruitment dataset
# Assumption: Applicant ID maps to employee_id
# ------------------------------------------------------------

recruitment = (
    recruitment_raw
    .select(
        col("Applicant ID").alias("employee_id"),
        to_date(col("Application Date"), "dd-MMM-yy").alias("application_date"),
        trim(col("Education Level")).alias("education_level"),
        col("Years of Experience").alias("years_of_experience"),
        col("Desired Salary").alias("desired_salary"),
        trim(col("Job Title")).alias("recruitment_job_title"),
        trim(col("Status")).alias("recruitment_status")
    )
)


# ------------------------------------------------------------
# Clean engagement dataset
# ------------------------------------------------------------

engagement = (
    engagement_raw
    .select(
        col("Employee ID").alias("employee_id"),
        to_date(col("Survey Date"), "dd/MM/yy").alias("survey_date"),
        col("Engagement Score").alias("engagement_score"),
        col("Satisfaction Score").alias("satisfaction_score"),
        col("Work-Life Balance Score").alias("work_life_balance_score")
    )
    .withColumn(
        "engagement_segment",
        when(col("engagement_score") <= 2, "Low Engagement")
        .when(col("engagement_score") == 3, "Medium Engagement")
        .otherwise("High Engagement")
    )
)


# ------------------------------------------------------------
# Clean training dataset
# ------------------------------------------------------------

training = (
    training_raw
    .select(
        col("Employee ID").alias("employee_id"),
        to_date(col("Training Date"), "dd-MMM-yy").alias("training_date"),
        trim(col("Training Program Name")).alias("training_program_name"),
        trim(col("Training Type")).alias("training_type"),
        trim(col("Training Outcome")).alias("training_outcome"),
        trim(col("Location")).alias("training_location"),
        trim(col("Trainer")).alias("trainer"),
        col("Training Duration(Days)").alias("training_duration_days"),
        col("Training Cost").alias("training_cost")
    )
)


# ------------------------------------------------------------
# Create employee lifecycle summary
# ------------------------------------------------------------

employee_lifecycle_summary = (
    employees
    .join(recruitment, on="employee_id", how="left")
    .join(engagement, on="employee_id", how="left")
    .join(training, on="employee_id", how="left")
    .withColumn(
        "training_timing",
        when(col("training_date").isNull(), "No Training Date")
        .when(col("training_date") < col("start_date"), "Before Start Date")
        .otherwise("After Start Date")
    )
.withColumn(
    "early_attrition_6m_flag",
    when(
        (col("termination_flag") == 1)
        & (col("exit_date") <= date_add(col("start_date"), 183)),
        1
    ).otherwise(0)
)
.withColumn(
    "early_attrition_12m_flag",
    when(
        (col("termination_flag") == 1)
        & (col("exit_date") <= date_add(col("start_date"), 365)),
        1
    ).otherwise(0)
    )
)


# ------------------------------------------------------------
# Validate final output
# ------------------------------------------------------------

print("\n============================================================")
print("PySpark Employee Lifecycle Summary Validation")
print("============================================================")

print(f"Final row count: {employee_lifecycle_summary.count()}")
print(f"Final column count: {len(employee_lifecycle_summary.columns)}")

print("\nEmployee status distribution:")
employee_lifecycle_summary.groupBy("employee_status").count().orderBy("employee_status").show()

print("\nTermination flags:")
employee_lifecycle_summary.groupBy("termination_flag").count().orderBy("termination_flag").show()

print("\nTraining timing distribution:")
employee_lifecycle_summary.groupBy("training_timing").count().orderBy("training_timing").show()

print("\nEarly attrition flags:")
employee_lifecycle_summary.select(
    "early_attrition_6m_flag",
    "early_attrition_12m_flag"
).groupBy(
    "early_attrition_6m_flag",
    "early_attrition_12m_flag"
).count().show()

print("\nPreview:")
employee_lifecycle_summary.show(5, truncate=False)


# ------------------------------------------------------------
# Export final dataset
# ------------------------------------------------------------

csv_output_path = OUTPUT_PATH / "employee_lifecycle_summary_pyspark_csv"
parquet_output_path = OUTPUT_PATH / "employee_lifecycle_summary_pyspark_parquet"

employee_lifecycle_summary.coalesce(1).write.mode("overwrite").option("header", True).csv(
    str(csv_output_path)
)

employee_lifecycle_summary.write.mode("overwrite").parquet(
    str(parquet_output_path)
)

print("\n============================================================")
print("Exports completed")
print("============================================================")
print(f"CSV folder: {csv_output_path}")
print(f"Parquet folder: {parquet_output_path}")


# ------------------------------------------------------------
# Stop Spark session
# ------------------------------------------------------------

spark.stop()