from pathlib import Path

import pandas as pd


# ============================================================
# Project: Employee Lifecycle Analytics
# Script: 03_validate_pyspark_outputs.py
# Purpose: Compare SQL and PySpark analytical outputs
# Author: Joana Inácio
# ============================================================


# ------------------------------------------------------------
# Paths
# ------------------------------------------------------------

PROJECT_ROOT = Path(__file__).resolve().parents[1]
OUTPUTS_PATH = PROJECT_ROOT / "outputs"
PYSPARK_OUTPUT_PATH = OUTPUTS_PATH / "pyspark" / "employee_lifecycle_summary_pyspark_csv"


# ------------------------------------------------------------
# Load SQL output
# ------------------------------------------------------------

sql_summary = pd.read_csv(OUTPUTS_PATH / "employee_lifecycle_summary.csv")


# ------------------------------------------------------------
# Load PySpark output
# Spark exports CSV as a folder with a part-*.csv file
# ------------------------------------------------------------

pyspark_csv_files = list(PYSPARK_OUTPUT_PATH.glob("part-*.csv"))

if not pyspark_csv_files:
    raise FileNotFoundError("No PySpark part CSV file found.")

pyspark_summary = pd.read_csv(pyspark_csv_files[0])


# ------------------------------------------------------------
# Basic validation
# ------------------------------------------------------------

print("\n============================================================")
print("SQL vs PySpark Output Validation")
print("============================================================")

print(f"SQL row count: {len(sql_summary)}")
print(f"PySpark row count: {len(pyspark_summary)}")

print(f"SQL column count: {len(sql_summary.columns)}")
print(f"PySpark column count: {len(pyspark_summary.columns)}")

print(
    "\nNote: Column counts may differ because the PySpark extension "
    "does not reproduce every field from the SQL analytical view. "
    "The validation focuses on the main comparable KPIs."
)


# ------------------------------------------------------------
# KPI comparison
# ------------------------------------------------------------

validation_results = {
    "total_employees": {
        "sql": len(sql_summary),
        "pyspark": len(pyspark_summary)
    },
    "active_employees": {
        "sql": int(sql_summary["active_flag"].sum()),
        "pyspark": int(pyspark_summary["active_flag"].sum())
    },
    "terminated_employees": {
        "sql": int(sql_summary["termination_flag"].sum()),
        "pyspark": int(pyspark_summary["termination_flag"].sum())
    },
    "voluntary_terminations": {
        "sql": int(sql_summary["voluntary_termination_flag"].sum()),
        "pyspark": int(pyspark_summary["voluntary_termination_flag"].sum())
    },
    "involuntary_terminations": {
        "sql": int(sql_summary["involuntary_termination_flag"].sum()),
        "pyspark": int(pyspark_summary["involuntary_termination_flag"].sum())
    }
}

validation_df = pd.DataFrame(validation_results).T
validation_df["match"] = validation_df["sql"] == validation_df["pyspark"]

print("\nKPI comparison:")
print(validation_df)


# ------------------------------------------------------------
# Optional early attrition validation
# ------------------------------------------------------------

early_attrition_file = OUTPUTS_PATH / "early_attrition_overall.csv"

if early_attrition_file.exists():
    early_attrition_sql = pd.read_csv(early_attrition_file)

    sql_early_6m = int(early_attrition_sql["early_attrition_6m_employees"].iloc[0])
    sql_early_12m = int(early_attrition_sql["early_attrition_12m_employees"].iloc[0])

    pyspark_early_6m = int(pyspark_summary["early_attrition_6m_flag"].sum())
    pyspark_early_12m = int(pyspark_summary["early_attrition_12m_flag"].sum())

    early_validation_results = {
        "early_attrition_6m": {
            "sql": sql_early_6m,
            "pyspark": pyspark_early_6m
        },
        "early_attrition_12m": {
            "sql": sql_early_12m,
            "pyspark": pyspark_early_12m
        }
    }

    early_validation_df = pd.DataFrame(early_validation_results).T
    early_validation_df["match"] = (
        early_validation_df["sql"] == early_validation_df["pyspark"]
    )

    print("\nEarly attrition comparison:")
    print(early_validation_df)

    validation_df = pd.concat([validation_df, early_validation_df])


# ------------------------------------------------------------
# Save validation output
# ------------------------------------------------------------

validation_output_path = OUTPUTS_PATH / "pyspark" / "sql_vs_pyspark_validation.csv"
validation_df.to_csv(validation_output_path)

print("\n============================================================")
print("Validation export completed")
print("============================================================")
print(f"Validation file: {validation_output_path}")


# ------------------------------------------------------------
# Final check
# ------------------------------------------------------------

if validation_df["match"].all():
    print("\nAll validation checks passed.")
else:
    print("\nSome validation checks did not match. Review the differences above.")