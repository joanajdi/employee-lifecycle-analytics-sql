from pathlib import Path

import pandas as pd
import plotly.express as px
import streamlit as st


# ============================================================
# Employee Lifecycle Analytics Streamlit App
# ============================================================


# ------------------------------------------------------------
# Page configuration
# ------------------------------------------------------------

st.set_page_config(
    page_title="Employee Lifecycle Analytics",
    page_icon="📊",
    layout="wide",
)


# ------------------------------------------------------------
# Theme
# ------------------------------------------------------------

DARK = "#2F2C3F"
DARK_2 = "#454158"
YELLOW = "#F6C431"
GREEN = "#0F5C45"
GREEN_2 = "#1F7A5C"
BACKGROUND = "#F4F3F0"
CARD = "#FFFFFF"
TEXT = "#202431"
MUTED = "#71717A"
BORDER = "#E5E1DA"

COLOR_SEQUENCE = [
    DARK,
    GREEN,
    GREEN_2,
    YELLOW,
    "#F4A261",
    "#9CA3AF",
    "#C7D2FE",
    "#A7F3D0",
]


# ------------------------------------------------------------
# CSS
# ------------------------------------------------------------

def inject_css():
    st.markdown(
        f"""
        <style>
        .stApp {{
            background: {BACKGROUND};
        }}

        .block-container {{
            max-width: 1420px;
            padding-top: 1.4rem;
            padding-bottom: 3rem;
        }}

        section[data-testid="stSidebar"] {{
            background: linear-gradient(180deg, {DARK} 0%, {DARK_2} 100%);
            border-right: none;
        }}

        section[data-testid="stSidebar"] * {{
            color: white;
        }}

        section[data-testid="stSidebar"] label,
        section[data-testid="stSidebar"] .stMarkdown,
        section[data-testid="stSidebar"] p {{
            color: white !important;
        }}

        #MainMenu {{visibility: hidden;}}
        footer {{visibility: hidden;}}

        h1, h2, h3 {{
            color: {TEXT};
            letter-spacing: -0.04em;
        }}

        .dashboard-title {{
            font-size: 2.1rem;
            font-weight: 900;
            color: {TEXT};
            letter-spacing: -0.055em;
            margin-bottom: 0.2rem;
        }}

        .dashboard-subtitle {{
            color: {MUTED};
            font-size: 0.96rem;
            margin-bottom: 1.25rem;
            line-height: 1.5;
        }}

        .kpi-card {{
            background: linear-gradient(135deg, {DARK} 0%, {DARK_2} 100%);
            border-radius: 16px;
            padding: 22px 22px;
            min-height: 132px;
            box-shadow: 0 12px 28px rgba(47,44,63,0.16);
        }}

        .kpi-value {{
            color: {YELLOW};
            font-size: 2.1rem;
            font-weight: 900;
            letter-spacing: -0.04em;
            line-height: 1;
        }}

        .kpi-label {{
            color: white;
            font-size: 0.92rem;
            font-weight: 700;
            margin-top: 0.75rem;
        }}

        .kpi-note {{
            color: rgba(255,255,255,0.72);
            font-size: 0.76rem;
            margin-top: 0.35rem;
        }}

        .white-card {{
            background: {CARD};
            border: 1px solid {BORDER};
            border-radius: 16px;
            padding: 20px 20px 16px 20px;
            box-shadow: 0 8px 22px rgba(47,44,63,0.06);
            margin-bottom: 18px;
        }}

        .card-title {{
            color: {TEXT};
            font-size: 1.05rem;
            font-weight: 850;
            margin-bottom: 0.15rem;
        }}

        .card-subtitle {{
            color: {MUTED};
            font-size: 0.82rem;
            margin-bottom: 0.8rem;
            line-height: 1.4;
        }}

        .sidebar-brand {{
            padding: 18px 6px 18px 6px;
        }}

        .brand-logo {{
            width: 64px;
            height: 64px;
            border-radius: 20px;
            background: rgba(246,196,49,0.14);
            border: 1px solid rgba(246,196,49,0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            color: {YELLOW};
            font-size: 1.55rem;
            font-weight: 900;
            margin-bottom: 14px;
        }}

        .brand-title {{
            color: white;
            font-size: 1.35rem;
            line-height: 1.08;
            font-weight: 900;
            letter-spacing: -0.045em;
        }}

        .brand-subtitle {{
            color: rgba(255,255,255,0.72);
            font-size: 0.82rem;
            margin-top: 10px;
            line-height: 1.45;
        }}

        div[role="radiogroup"] label {{
            background: rgba(255,255,255,0.08);
            border-radius: 14px;
            padding: 8px 10px;
            margin-bottom: 4px;
        }}

        div[role="radiogroup"] label:hover {{
            background: rgba(255,255,255,0.15);
        }}

        .stCheckbox label {{
            font-size: 0.85rem !important;
        }}

        div[data-testid="stDataFrame"] {{
            border-radius: 14px;
            overflow: hidden;
        }}

        button[kind="secondary"] {{
            border-radius: 12px;
        }}

        .small-muted {{
            color: {MUTED};
            font-size: 0.82rem;
            line-height: 1.45;
        }}
        </style>
        """,
        unsafe_allow_html=True,
    )


inject_css()


# ------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------

def kpi_card(label: str, value: str, note: str = ""):
    st.markdown(
        f"""
        <div class="kpi-card">
            <div class="kpi-value">{value}</div>
            <div class="kpi-label">{label}</div>
            <div class="kpi-note">{note}</div>
        </div>
        """,
        unsafe_allow_html=True,
    )


def page_header(title: str, subtitle: str):
    st.markdown(
        f"""
        <div class="dashboard-title">{title}</div>
        <div class="dashboard-subtitle">{subtitle}</div>
        """,
        unsafe_allow_html=True,
    )


def card_header(title: str, subtitle: str = ""):
    st.markdown(
        f"""
        <div class="card-title">{title}</div>
        <div class="card-subtitle">{subtitle}</div>
        """,
        unsafe_allow_html=True,
    )


def fmt_num(value):
    if pd.isna(value):
        return "N/A"
    return f"{value:,.0f}"


def fmt_pct(value):
    if pd.isna(value):
        return "N/A"
    return f"{value:.1f}%"


def fmt_dec(value):
    if pd.isna(value):
        return "N/A"
    return f"{value:.2f}"


def style_fig(fig, height=360):
    fig.update_layout(
        height=height,
        plot_bgcolor="white",
        paper_bgcolor="white",
        font=dict(color=TEXT, size=12),
        title_font=dict(color=TEXT, size=15),
        margin=dict(l=20, r=20, t=50, b=30),
        legend_title_text="",
        hoverlabel=dict(bgcolor="white", font_size=12, font_color=TEXT),
    )

    fig.update_xaxes(
        showgrid=False,
        tickfont=dict(color=MUTED),
        title_font=dict(color=MUTED),
    )

    fig.update_yaxes(
        gridcolor="#EDEAE4",
        tickfont=dict(color=MUTED),
        title_font=dict(color=MUTED),
    )

    return fig


def optional_csv(path: Path):
    if path.exists():
        return pd.read_csv(path)
    return pd.DataFrame()


def safe_group_rate(df, group_col, numerator_col, id_col="employee_id", rate_name="rate_pct"):
    grouped = (
        df.groupby(group_col, as_index=False)
        .agg(
            employees=(id_col, "count"),
            numerator=(numerator_col, "sum"),
        )
    )

    grouped[rate_name] = (grouped["numerator"] / grouped["employees"] * 100).round(2)
    return grouped


def checkbox_filter(label, options, key_prefix):
    st.sidebar.markdown(f"**{label}**")

    all_key = f"{key_prefix}_all"
    select_all = st.sidebar.checkbox("All", value=True, key=all_key)

    if select_all:
        return list(options)

    selected = []

    for option in options:
        checked = st.sidebar.checkbox(str(option), value=False, key=f"{key_prefix}_{option}")
        if checked:
            selected.append(option)

    return selected


# ------------------------------------------------------------
# Paths and data
# ------------------------------------------------------------

PROJECT_ROOT = Path(__file__).resolve().parents[1]
OUTPUTS_PATH = PROJECT_ROOT / "outputs"
PYSPARK_OUTPUTS_PATH = OUTPUTS_PATH / "pyspark"


@st.cache_data
def load_data():
    return {
        "employee": pd.read_csv(OUTPUTS_PATH / "employee_lifecycle_summary.csv"),
        "early_overall": optional_csv(OUTPUTS_PATH / "early_attrition_overall.csv"),
        "early_department": optional_csv(OUTPUTS_PATH / "early_attrition_by_department.csv"),
        "early_type": optional_csv(OUTPUTS_PATH / "early_attrition_by_employee_type.csv"),
        "early_performance": optional_csv(OUTPUTS_PATH / "early_attrition_by_performance_score.csv"),
        "early_engagement": optional_csv(OUTPUTS_PATH / "early_attrition_by_engagement_segment.csv"),
        "early_recruitment": optional_csv(OUTPUTS_PATH / "early_attrition_by_recruitment_status.csv"),
        "start_year": optional_csv(OUTPUTS_PATH / "attrition_by_start_year.csv"),
        "validation": optional_csv(PYSPARK_OUTPUTS_PATH / "sql_vs_pyspark_validation.csv"),
    }


data = load_data()
employee = data["employee"]


# ------------------------------------------------------------
# Sidebar
# ------------------------------------------------------------

st.sidebar.markdown(
    f"""
    <div class="sidebar-brand">
        <div class="brand-logo">HR</div>
        <div class="brand-title">Employee<br>Lifecycle Analytics</div>
        <div class="brand-subtitle">
            SQL, Python, PySpark and interactive analytics dashboard.
        </div>
    </div>
    """,
    unsafe_allow_html=True,
)

page = st.sidebar.radio(
    "Dashboard pages",
    [
        "Overview",
        "Workforce",
        "Recruitment",
        "Training",
        "Engagement",
        "Attrition",
        "Early Attrition",
        "Data Engineering",
        "Data Explorer",
    ],
)

st.sidebar.markdown("---")
st.sidebar.markdown("### Filters")

filtered = employee.copy()

if "department_type" in employee.columns:
    departments = sorted(employee["department_type"].dropna().unique())
    selected_departments = checkbox_filter("Department", departments, "dept")
    if selected_departments:
        filtered = filtered[filtered["department_type"].isin(selected_departments)]

if "employee_type" in employee.columns:
    employee_types = sorted(employee["employee_type"].dropna().unique())
    selected_types = checkbox_filter("Employee type", employee_types, "type")
    if selected_types:
        filtered = filtered[filtered["employee_type"].isin(selected_types)]

if "performance_score" in employee.columns:
    performance_scores = sorted(employee["performance_score"].dropna().unique())
    selected_performance = checkbox_filter("Performance score", performance_scores, "perf")
    if selected_performance:
        filtered = filtered[filtered["performance_score"].isin(selected_performance)]

if "engagement_segment" in employee.columns:
    engagement_segments = sorted(employee["engagement_segment"].dropna().unique())
    selected_engagement = checkbox_filter("Engagement segment", engagement_segments, "eng")
    if selected_engagement:
        filtered = filtered[filtered["engagement_segment"].isin(selected_engagement)]

st.sidebar.markdown("---")
st.sidebar.metric("Filtered records", f"{len(filtered):,}")


# ------------------------------------------------------------
# Shared KPIs
# ------------------------------------------------------------

total = len(filtered)
active = int(filtered["active_flag"].sum()) if "active_flag" in filtered else 0
terminated = int(filtered["termination_flag"].sum()) if "termination_flag" in filtered else 0
voluntary = int(filtered["voluntary_termination_flag"].sum()) if "voluntary_termination_flag" in filtered else 0
involuntary = int(filtered["involuntary_termination_flag"].sum()) if "involuntary_termination_flag" in filtered else 0

active_rate = active / total * 100 if total else 0
termination_rate = terminated / total * 100 if total else 0
voluntary_rate = voluntary / total * 100 if total else 0
involuntary_rate = involuntary / total * 100 if total else 0

avg_engagement = filtered["engagement_score"].mean() if "engagement_score" in filtered else None
avg_satisfaction = filtered["satisfaction_score"].mean() if "satisfaction_score" in filtered else None
avg_wlb = filtered["work_life_balance_score"].mean() if "work_life_balance_score" in filtered else None
avg_tenure = filtered["tenure_years"].mean() if "tenure_years" in filtered else None
avg_rating = filtered["current_employee_rating"].mean() if "current_employee_rating" in filtered else None
avg_training_cost = filtered["training_cost"].mean() if "training_cost" in filtered else None
avg_salary = filtered["desired_salary"].mean() if "desired_salary" in filtered else None


# ============================================================
# Overview
# ============================================================

if page == "Overview":
    page_header(
        "Executive Overview",
        "A complete HR analytics dashboard covering workforce, recruitment, training, engagement, attrition, early attrition and data engineering validation.",
    )

    c1, c2, c3, c4, c5 = st.columns(5)

    with c1:
        kpi_card("Employees", fmt_num(total), "selected population")
    with c2:
        kpi_card("Active rate", fmt_pct(active_rate), f"{fmt_num(active)} active")
    with c3:
        kpi_card("Termination rate", fmt_pct(termination_rate), f"{fmt_num(terminated)} terminated")
    with c4:
        kpi_card("Avg engagement", fmt_dec(avg_engagement), "1 to 5 scale")
    with c5:
        kpi_card("Avg tenure", fmt_dec(avg_tenure), "years")

    st.markdown("<br>", unsafe_allow_html=True)

    left, right = st.columns([1.15, 1])

    with left:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Workforce by Department", "Headcount distribution across departments.")

        dept = (
            filtered.groupby("department_type", as_index=False)
            .agg(employees=("employee_id", "count"))
            .sort_values("employees", ascending=True)
        )

        fig = px.bar(
            dept,
            x="employees",
            y="department_type",
            orientation="h",
            title="Headcount by Department",
            labels={"employees": "Employees", "department_type": ""},
            color_discrete_sequence=[DARK],
        )

        st.plotly_chart(style_fig(fig, 390), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    with right:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Employee Status", "Status distribution shown as horizontal bars.")

        status = (
            filtered.groupby("employee_status", as_index=False)
            .agg(employees=("employee_id", "count"))
            .sort_values("employees", ascending=True)
        )

        fig = px.bar(
            status,
            x="employees",
            y="employee_status",
            orientation="h",
            title="Employee Status Distribution",
            labels={"employees": "Employees", "employee_status": ""},
            color="employee_status",
            color_discrete_sequence=COLOR_SEQUENCE,
        )

        fig.update_layout(showlegend=False)
        st.plotly_chart(style_fig(fig, 390), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    left2, right2 = st.columns(2)

    with left2:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Termination Rate by Department", "Proportional attrition risk by department.")

        dept_attr = safe_group_rate(filtered, "department_type", "termination_flag", rate_name="termination_rate_pct")
        dept_attr = dept_attr.sort_values("termination_rate_pct", ascending=True)

        fig = px.bar(
            dept_attr,
            x="termination_rate_pct",
            y="department_type",
            orientation="h",
            title="Termination Rate by Department",
            labels={"termination_rate_pct": "Termination Rate (%)", "department_type": ""},
            color_discrete_sequence=[GREEN],
        )

        st.plotly_chart(style_fig(fig, 360), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    with right2:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Engagement by Department", "Average engagement score by department.")

        dept_eng = (
            filtered.groupby("department_type", as_index=False)
            .agg(avg_engagement=("engagement_score", "mean"))
        )

        dept_eng["avg_engagement"] = dept_eng["avg_engagement"].round(2)
        dept_eng = dept_eng.sort_values("avg_engagement", ascending=True)

        fig = px.bar(
            dept_eng,
            x="avg_engagement",
            y="department_type",
            orientation="h",
            title="Average Engagement by Department",
            labels={"avg_engagement": "Avg Engagement", "department_type": ""},
            color_discrete_sequence=[YELLOW],
        )

        st.plotly_chart(style_fig(fig, 360), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)


# ============================================================
# Workforce
# ============================================================

elif page == "Workforce":
    page_header(
        "Workforce Analysis",
        "Understand the workforce structure by department, type, business unit, performance and tenure.",
    )

    c1, c2, c3, c4, c5 = st.columns(5)

    with c1:
        kpi_card("Employees", fmt_num(total), "filtered")
    with c2:
        kpi_card("Active employees", fmt_num(active), fmt_pct(active_rate))
    with c3:
        kpi_card("Avg rating", fmt_dec(avg_rating), "current rating")
    with c4:
        kpi_card("Avg tenure", fmt_dec(avg_tenure), "years")
    with c5:
        kpi_card("Departments", fmt_num(filtered["department_type"].nunique()), "represented")

    st.markdown("<br>", unsafe_allow_html=True)

    a, b, c = st.columns(3)

    with a:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Employee Type Mix", "Employee count by type.")

        type_df = filtered.groupby("employee_type", as_index=False).agg(employees=("employee_id", "count"))

        fig = px.bar(
            type_df.sort_values("employees", ascending=False),
            x="employee_type",
            y="employees",
            title="Employee Type Distribution",
            color_discrete_sequence=[DARK],
        )

        st.plotly_chart(style_fig(fig, 340), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    with b:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Performance Distribution", "Employee count by performance score.")

        perf_df = filtered.groupby("performance_score", as_index=False).agg(employees=("employee_id", "count"))

        fig = px.bar(
            perf_df.sort_values("employees", ascending=False),
            x="performance_score",
            y="employees",
            title="Performance Distribution",
            color_discrete_sequence=[GREEN],
        )

        st.plotly_chart(style_fig(fig, 340), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    with c:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Tenure Distribution", "Tenure spread across selected employees.")

        fig = px.histogram(
            filtered,
            x="tenure_years",
            nbins=24,
            title="Tenure Distribution",
            labels={"tenure_years": "Tenure Years"},
            color_discrete_sequence=[YELLOW],
        )

        st.plotly_chart(style_fig(fig, 340), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    st.markdown('<div class="white-card">', unsafe_allow_html=True)
    card_header("Department Workforce Table", "Headcount, active rate, termination rate, engagement and tenure by department.")

    dept_table = (
        filtered.groupby("department_type", as_index=False)
        .agg(
            employees=("employee_id", "count"),
            active=("active_flag", "sum"),
            terminated=("termination_flag", "sum"),
            avg_engagement=("engagement_score", "mean"),
            avg_tenure=("tenure_years", "mean"),
            avg_rating=("current_employee_rating", "mean"),
        )
    )

    dept_table["active_rate_pct"] = (dept_table["active"] / dept_table["employees"] * 100).round(2)
    dept_table["termination_rate_pct"] = (dept_table["terminated"] / dept_table["employees"] * 100).round(2)
    dept_table["avg_engagement"] = dept_table["avg_engagement"].round(2)
    dept_table["avg_tenure"] = dept_table["avg_tenure"].round(2)
    dept_table["avg_rating"] = dept_table["avg_rating"].round(2)

    st.dataframe(dept_table, use_container_width=True, hide_index=True)
    st.markdown("</div>", unsafe_allow_html=True)


# ============================================================
# Recruitment
# ============================================================

elif page == "Recruitment":
    page_header(
        "Recruitment Analysis",
        "Analyze applicant profile, recruitment status, education, experience and desired salary.",
    )

    c1, c2, c3, c4 = st.columns(4)

    with c1:
        kpi_card("Linked applicants", fmt_num(total), "assumed ID match")
    with c2:
        kpi_card("Avg experience", fmt_dec(filtered["years_of_experience"].mean()), "years")
    with c3:
        kpi_card("Avg desired salary", fmt_dec(avg_salary), "currency unspecified")
    with c4:
        kpi_card("Recruitment statuses", fmt_num(filtered["recruitment_status"].nunique()), "categories")

    st.markdown("<br>", unsafe_allow_html=True)

    a, b = st.columns(2)

    with a:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Recruitment Status", "Pipeline status distribution.")

        rec = filtered.groupby("recruitment_status", as_index=False).agg(applicants=("employee_id", "count"))

        fig = px.bar(
            rec.sort_values("applicants", ascending=True),
            x="applicants",
            y="recruitment_status",
            orientation="h",
            title="Recruitment Status Distribution",
            color_discrete_sequence=[DARK],
        )

        st.plotly_chart(style_fig(fig, 360), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    with b:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Education Level", "Applicant education distribution.")

        edu = filtered.groupby("education_level", as_index=False).agg(applicants=("employee_id", "count"))

        fig = px.bar(
            edu.sort_values("applicants", ascending=True),
            x="applicants",
            y="education_level",
            orientation="h",
            title="Education Level Distribution",
            color_discrete_sequence=[GREEN],
        )

        st.plotly_chart(style_fig(fig, 360), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    a2, b2 = st.columns(2)

    with a2:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Desired Salary by Education", "Salary distribution by education level.")

        fig = px.box(
            filtered,
            x="education_level",
            y="desired_salary",
            color="education_level",
            title="Desired Salary by Education Level",
            color_discrete_sequence=COLOR_SEQUENCE,
        )

        fig.update_layout(showlegend=False)
        st.plotly_chart(style_fig(fig, 380), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    with b2:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Experience by Recruitment Status", "Experience distribution across statuses.")

        fig = px.box(
            filtered,
            x="recruitment_status",
            y="years_of_experience",
            color="recruitment_status",
            title="Experience by Recruitment Status",
            color_discrete_sequence=COLOR_SEQUENCE,
        )

        fig.update_layout(showlegend=False)
        st.plotly_chart(style_fig(fig, 380), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    st.markdown('<div class="white-card">', unsafe_allow_html=True)
    card_header("Recruitment Status vs Later Attrition", "Exploratory termination rate by recruitment status.")

    rec_attr = safe_group_rate(filtered, "recruitment_status", "termination_flag", rate_name="termination_rate_pct")

    fig = px.bar(
        rec_attr.sort_values("termination_rate_pct", ascending=False),
        x="recruitment_status",
        y="termination_rate_pct",
        title="Termination Rate by Recruitment Status",
        color_discrete_sequence=[YELLOW],
    )

    st.plotly_chart(style_fig(fig, 360), use_container_width=True)
    st.markdown("</div>", unsafe_allow_html=True)


# ============================================================
# Training
# ============================================================

elif page == "Training":
    page_header(
        "Training Analysis",
        "Analyze training investment, timing, duration, program outcomes and attrition patterns.",
    )

    c1, c2, c3, c4 = st.columns(4)

    with c1:
        kpi_card("Training records", fmt_num(total), "one per employee")
    with c2:
        kpi_card("Avg training cost", fmt_dec(avg_training_cost), "per employee")
    with c3:
        kpi_card("Avg duration", fmt_dec(filtered["training_duration_days"].mean()), "days")
    with c4:
        kpi_card("Programs", fmt_num(filtered["training_program_name"].nunique()), "unique")

    st.markdown("<br>", unsafe_allow_html=True)

    a, b, c = st.columns(3)

    with a:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Training Outcomes", "Outcome distribution.")

        out = filtered.groupby("training_outcome", as_index=False).agg(records=("employee_id", "count"))

        fig = px.bar(
            out.sort_values("records", ascending=False),
            x="training_outcome",
            y="records",
            title="Training Outcome Distribution",
            color_discrete_sequence=[DARK],
        )

        st.plotly_chart(style_fig(fig, 330), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    with b:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Training Type", "Internal vs external.")

        typ = filtered.groupby("training_type", as_index=False).agg(records=("employee_id", "count"))

        fig = px.bar(
            typ,
            x="training_type",
            y="records",
            title="Training Type Distribution",
            color_discrete_sequence=[GREEN],
        )

        st.plotly_chart(style_fig(fig, 330), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    with c:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Training Timing", "Before vs after start date.")

        timing = filtered.groupby("training_timing", as_index=False).agg(records=("employee_id", "count"))

        fig = px.bar(
            timing,
            x="training_timing",
            y="records",
            title="Training Timing",
            color_discrete_sequence=[YELLOW],
        )

        st.plotly_chart(style_fig(fig, 330), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    a2, b2 = st.columns(2)

    with a2:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Average Training Cost by Department", "Cost comparison by department.")

        cost = filtered.groupby("department_type", as_index=False).agg(avg_training_cost=("training_cost", "mean"))
        cost["avg_training_cost"] = cost["avg_training_cost"].round(2)

        fig = px.bar(
            cost.sort_values("avg_training_cost", ascending=True),
            x="avg_training_cost",
            y="department_type",
            orientation="h",
            title="Avg Training Cost by Department",
            color_discrete_sequence=[GREEN],
        )

        st.plotly_chart(style_fig(fig, 380), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    with b2:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Training Outcome vs Attrition", "Termination rate by training outcome.")

        train_attr = safe_group_rate(filtered, "training_outcome", "termination_flag", rate_name="termination_rate_pct")

        fig = px.bar(
            train_attr.sort_values("termination_rate_pct", ascending=False),
            x="training_outcome",
            y="termination_rate_pct",
            title="Termination Rate by Training Outcome",
            color_discrete_sequence=[YELLOW],
        )

        st.plotly_chart(style_fig(fig, 380), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)


# ============================================================
# Engagement
# ============================================================

elif page == "Engagement":
    page_header(
        "Engagement Analysis",
        "Analyze engagement, satisfaction, work-life balance and their relationship with attrition.",
    )

    c1, c2, c3, c4 = st.columns(4)

    with c1:
        kpi_card("Avg engagement", fmt_dec(avg_engagement), "1 to 5 scale")
    with c2:
        kpi_card("Avg satisfaction", fmt_dec(avg_satisfaction), "1 to 5 scale")
    with c3:
        kpi_card("Avg WLB", fmt_dec(avg_wlb), "work-life balance")
    with c4:
        low_count = int((filtered["engagement_segment"] == "Low Engagement").sum())
        kpi_card("Low engagement", fmt_num(low_count), "employees")

    st.markdown("<br>", unsafe_allow_html=True)

    a, b = st.columns(2)

    with a:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Engagement Segments", "Distribution by engagement level.")

        seg = filtered.groupby("engagement_segment", as_index=False).agg(employees=("employee_id", "count"))

        fig = px.bar(
            seg.sort_values("employees", ascending=False),
            x="engagement_segment",
            y="employees",
            title="Engagement Segment Distribution",
            color_discrete_sequence=[DARK],
        )

        st.plotly_chart(style_fig(fig, 360), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    with b:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header(
            "Engagement and Satisfaction Matrix",
            "Number of employees by engagement and satisfaction score combination.",
        )

        engagement_matrix = (
            filtered
            .groupby(["engagement_score", "satisfaction_score"], as_index=False)
            .agg(employees=("employee_id", "count"))
        )

        matrix_pivot = engagement_matrix.pivot(
            index="satisfaction_score",
            columns="engagement_score",
            values="employees",
        ).fillna(0)

        fig = px.imshow(
            matrix_pivot,
            text_auto=True,
            aspect="auto",
            title="Employee Count by Engagement and Satisfaction Score",
            labels=dict(
                x="Engagement Score",
                y="Satisfaction Score",
                color="Employees",
            ),
            color_continuous_scale=[
                "#F6F3EA",
                "#DFF3EA",
                "#8ABFA6",
                "#0F5C45",
            ],
        )

        fig.update_layout(coloraxis_showscale=True)
        st.plotly_chart(style_fig(fig, 360), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    a2, b2 = st.columns(2)

    with a2:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Average Engagement by Department", "Department comparison.")

        dept = filtered.groupby("department_type", as_index=False).agg(avg_engagement=("engagement_score", "mean"))
        dept["avg_engagement"] = dept["avg_engagement"].round(2)

        fig = px.bar(
            dept.sort_values("avg_engagement", ascending=True),
            x="avg_engagement",
            y="department_type",
            orientation="h",
            title="Avg Engagement by Department",
            color_discrete_sequence=[GREEN],
        )

        st.plotly_chart(style_fig(fig, 380), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    with b2:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Engagement Segment vs Attrition", "Termination rate by engagement segment.")

        eng_attr = safe_group_rate(filtered, "engagement_segment", "termination_flag", rate_name="termination_rate_pct")

        fig = px.bar(
            eng_attr.sort_values("termination_rate_pct", ascending=False),
            x="engagement_segment",
            y="termination_rate_pct",
            title="Termination Rate by Engagement Segment",
            color_discrete_sequence=[YELLOW],
        )

        st.plotly_chart(style_fig(fig, 380), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)


# ============================================================
# Attrition
# ============================================================

elif page == "Attrition":
    page_header(
        "Attrition Analysis",
        "Analyze voluntary and involuntary attrition patterns by department, performance, engagement and tenure.",
    )

    c1, c2, c3, c4, c5 = st.columns(5)

    with c1:
        kpi_card("Terminated", fmt_num(terminated), "employees")
    with c2:
        kpi_card("Termination rate", fmt_pct(termination_rate), "overall")
    with c3:
        kpi_card("Voluntary", fmt_pct(voluntary_rate), f"{fmt_num(voluntary)} employees")
    with c4:
        kpi_card("Involuntary", fmt_pct(involuntary_rate), f"{fmt_num(involuntary)} employees")
    with c5:
        kpi_card("Avg tenure", fmt_dec(avg_tenure), "years")

    st.markdown("<br>", unsafe_allow_html=True)

    a, b = st.columns(2)

    with a:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Voluntary vs Involuntary", "Binary split shown as donut.")

        split = pd.DataFrame(
            {"type": ["Voluntary", "Involuntary"], "employees": [voluntary, involuntary]}
        )

        fig = px.pie(
            split,
            names="type",
            values="employees",
            hole=0.58,
            title="Termination Type Split",
            color_discrete_sequence=[GREEN, YELLOW],
        )

        st.plotly_chart(style_fig(fig, 360), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    with b:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Attrition by Performance", "Termination rate by performance group.")

        perf = safe_group_rate(filtered, "performance_score", "termination_flag", rate_name="termination_rate_pct")

        fig = px.bar(
            perf.sort_values("termination_rate_pct", ascending=False),
            x="performance_score",
            y="termination_rate_pct",
            title="Termination Rate by Performance",
            color_discrete_sequence=[DARK],
        )

        st.plotly_chart(style_fig(fig, 360), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    a2, b2 = st.columns(2)

    with a2:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Attrition by Department", "Termination rate by department.")

        dept = safe_group_rate(filtered, "department_type", "termination_flag", rate_name="termination_rate_pct")

        fig = px.bar(
            dept.sort_values("termination_rate_pct", ascending=True),
            x="termination_rate_pct",
            y="department_type",
            orientation="h",
            title="Termination Rate by Department",
            color_discrete_sequence=[GREEN],
        )

        st.plotly_chart(style_fig(fig, 380), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)

    with b2:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Termination Type by Department", "Absolute voluntary and involuntary volume.")

        dept_split = (
            filtered.groupby("department_type", as_index=False)
            .agg(
                voluntary=("voluntary_termination_flag", "sum"),
                involuntary=("involuntary_termination_flag", "sum"),
            )
        )

        dept_long = dept_split.melt(
            id_vars="department_type",
            value_vars=["voluntary", "involuntary"],
            var_name="termination_type",
            value_name="employees",
        )

        fig = px.bar(
            dept_long,
            x="employees",
            y="department_type",
            color="termination_type",
            orientation="h",
            barmode="stack",
            title="Termination Volume by Department and Type",
            color_discrete_sequence=[GREEN, YELLOW],
        )

        st.plotly_chart(style_fig(fig, 380), use_container_width=True)
        st.markdown("</div>", unsafe_allow_html=True)


# ============================================================
# Early Attrition
# ============================================================

elif page == "Early Attrition":
    page_header(
        "Cohort & Early Attrition",
        "Analyze attrition by hiring cohort and first-year exit patterns.",
    )

    early_overall = data["early_overall"]

    if not early_overall.empty:
        c1, c2, c3, c4 = st.columns(4)

        with c1:
            kpi_card("Early attrition 6M", fmt_num(early_overall["early_attrition_6m_employees"].iloc[0]), "employees")
        with c2:
            kpi_card("6M rate", fmt_pct(early_overall["early_attrition_6m_rate_pct"].iloc[0]), "workforce")
        with c3:
            kpi_card("Early attrition 12M", fmt_num(early_overall["early_attrition_12m_employees"].iloc[0]), "employees")
        with c4:
            kpi_card("12M rate", fmt_pct(early_overall["early_attrition_12m_rate_pct"].iloc[0]), "workforce")

    st.markdown("<br>", unsafe_allow_html=True)

    a, b = st.columns(2)

    with a:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("Termination Rate by Start Year", "Cohort-level termination rate.")

        start_year = data["start_year"]

        if not start_year.empty:
            fig = px.line(
                start_year,
                x="start_year",
                y="termination_rate_pct",
                markers=True,
                title="Termination Rate by Start Year",
            )

            fig.update_traces(line=dict(color=DARK, width=3), marker=dict(size=9, color=YELLOW))
            st.plotly_chart(style_fig(fig, 360), use_container_width=True)

        st.markdown("</div>", unsafe_allow_html=True)

    with b:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("12M Early Attrition by Department", "First-year attrition by department.")

        early_dept = data["early_department"]

        if not early_dept.empty:
            fig = px.bar(
                early_dept.sort_values("early_attrition_12m_rate_pct", ascending=True),
                x="early_attrition_12m_rate_pct",
                y="department_type",
                orientation="h",
                title="12M Early Attrition by Department",
                color_discrete_sequence=[GREEN],
            )

            st.plotly_chart(style_fig(fig, 360), use_container_width=True)

        st.markdown("</div>", unsafe_allow_html=True)

    a2, b2, c2 = st.columns(3)

    with a2:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("By Employee Type")

        early_type = data["early_type"]

        if not early_type.empty:
            fig = px.bar(
                early_type.sort_values("early_attrition_12m_rate_pct", ascending=False),
                x="employee_type",
                y="early_attrition_12m_rate_pct",
                title="12M Early Attrition by Type",
                color_discrete_sequence=[DARK],
            )

            st.plotly_chart(style_fig(fig, 320), use_container_width=True)

        st.markdown("</div>", unsafe_allow_html=True)

    with b2:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("By Performance")

        early_perf = data["early_performance"]

        if not early_perf.empty:
            fig = px.bar(
                early_perf.sort_values("early_attrition_12m_rate_pct", ascending=False),
                x="performance_score",
                y="early_attrition_12m_rate_pct",
                title="12M Early Attrition by Performance",
                color_discrete_sequence=[GREEN],
            )

            st.plotly_chart(style_fig(fig, 320), use_container_width=True)

        st.markdown("</div>", unsafe_allow_html=True)

    with c2:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header("By Engagement")

        early_eng = data["early_engagement"]

        if not early_eng.empty:
            fig = px.bar(
                early_eng.sort_values("early_attrition_12m_rate_pct", ascending=False),
                x="engagement_segment",
                y="early_attrition_12m_rate_pct",
                title="12M Early Attrition by Engagement",
                color_discrete_sequence=[YELLOW],
            )

            st.plotly_chart(style_fig(fig, 320), use_container_width=True)

        st.markdown("</div>", unsafe_allow_html=True)


# ============================================================
# Data Engineering
# ============================================================

elif page == "Data Engineering":
    page_header(
        "PySpark Data Engineering Validation",
        "Validate consistency between the SQL pipeline and the PySpark extension, including CSV and Parquet outputs.",
    )

    validation = data["validation"]

    c1, c2, c3, c4 = st.columns(4)

    with c1:
        kpi_card("SQL pipeline", "PostgreSQL", "analytical views")
    with c2:
        kpi_card("Spark pipeline", "PySpark", "local Spark")
    with c3:
        kpi_card("Storage", "Parquet", "lakehouse-ready")
    with c4:
        if not validation.empty and "match" in validation.columns:
            passed = validation["match"].astype(str).str.lower().eq("true").sum()
            kpi_card("Checks passed", f"{passed}/{len(validation)}", "KPI validation")
        else:
            kpi_card("Checks passed", "N/A", "file missing")

    st.markdown("<br>", unsafe_allow_html=True)

    st.markdown('<div class="white-card">', unsafe_allow_html=True)
    card_header("SQL vs PySpark KPI Validation", "Comparable KPI outputs from both pipelines.")

    if not validation.empty:
        st.dataframe(validation, use_container_width=True, hide_index=True)
    else:
        st.warning("Validation file not found.")

    st.markdown("</div>", unsafe_allow_html=True)

    st.markdown('<div class="white-card">', unsafe_allow_html=True)
    card_header("Pipeline Architecture", "How the project is structured.")

    st.markdown(
        """
        **Raw CSV files** → **PostgreSQL SQL pipeline** → **analytical CSV outputs** → **Python modeling and visualizations**

        **Raw CSV files** → **PySpark transformation pipeline** → **CSV and Parquet outputs** → **SQL vs Spark validation**

        This demonstrates how the HR analytics workflow could be adapted to a Spark-based cloud/lakehouse environment such as Databricks.
        """
    )

    st.markdown("</div>", unsafe_allow_html=True)


# ============================================================
# Data Explorer
# ============================================================

elif page == "Data Explorer":
    page_header(
        "Data Explorer",
        "Explore the final employee-level analytical dataset with clean table views, selected columns and export-ready summaries.",
    )

    c1, c2, c3, c4 = st.columns(4)

    with c1:
        kpi_card("Rows", fmt_num(len(filtered)), "filtered records")
    with c2:
        kpi_card("Columns", fmt_num(len(filtered.columns)), "available fields")
    with c3:
        kpi_card("Departments", fmt_num(filtered["department_type"].nunique()), "selected")
    with c4:
        kpi_card("Employees", fmt_num(filtered["employee_id"].nunique()), "unique IDs")

    st.markdown("<br>", unsafe_allow_html=True)

    st.markdown('<div class="white-card">', unsafe_allow_html=True)
    card_header(
        "Dataset View",
        "Choose a curated view of the analytical dataset instead of manually selecting many columns.",
    )

    view_option = st.radio(
        "Select dataset view",
        [
            "Executive view",
            "Workforce view",
            "Engagement view",
            "Training view",
            "Attrition view",
            "Recruitment view",
            "Full dataset",
        ],
        horizontal=True,
    )

    column_views = {
        "Executive view": [
            "employee_id",
            "department_type",
            "employee_status",
            "employee_type",
            "performance_score",
            "current_employee_rating",
            "engagement_score",
            "satisfaction_score",
            "work_life_balance_score",
            "training_outcome",
            "tenure_years",
            "termination_flag",
        ],
        "Workforce view": [
            "employee_id",
            "department_type",
            "business_unit",
            "employee_status",
            "employee_type",
            "pay_zone",
            "performance_score",
            "current_employee_rating",
            "tenure_years",
        ],
        "Engagement view": [
            "employee_id",
            "department_type",
            "employee_status",
            "engagement_score",
            "satisfaction_score",
            "work_life_balance_score",
            "engagement_segment",
            "termination_flag",
        ],
        "Training view": [
            "employee_id",
            "department_type",
            "training_program_name",
            "training_type",
            "training_outcome",
            "training_duration_days",
            "training_cost",
            "training_timing",
            "performance_score",
            "termination_flag",
        ],
        "Attrition view": [
            "employee_id",
            "department_type",
            "employee_status",
            "employee_status_group",
            "termination_type",
            "termination_description",
            "termination_flag",
            "voluntary_termination_flag",
            "involuntary_termination_flag",
            "tenure_years",
            "performance_score",
            "engagement_segment",
        ],
        "Recruitment view": [
            "employee_id",
            "department_type",
            "recruitment_status",
            "education_level",
            "years_of_experience",
            "desired_salary",
            "recruitment_job_title",
            "employee_status",
            "termination_flag",
        ],
        "Full dataset": list(filtered.columns),
    }

    selected_columns = [
        column for column in column_views[view_option]
        if column in filtered.columns
    ]

    st.dataframe(
        filtered[selected_columns].head(500),
        use_container_width=True,
        height=420,
        hide_index=True,
    )

    st.markdown("</div>", unsafe_allow_html=True)

    left, right = st.columns([1.1, 1])

    with left:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header(
            "Column Groups",
            "A cleaner overview of the types of fields available in the analytical dataset.",
        )

        column_groups = pd.DataFrame(
            {
                "Group": [
                    "Employee identifiers",
                    "Workforce attributes",
                    "Recruitment attributes",
                    "Engagement attributes",
                    "Training attributes",
                    "Attrition attributes",
                    "Analytical flags",
                ],
                "Examples": [
                    "employee_id, first_name, last_name, ad_email",
                    "department_type, business_unit, employee_type, pay_zone, tenure_years",
                    "recruitment_status, education_level, years_of_experience, desired_salary",
                    "engagement_score, satisfaction_score, work_life_balance_score, engagement_segment",
                    "training_program_name, training_type, training_outcome, training_cost",
                    "employee_status, termination_type, termination_description",
                    "active_flag, termination_flag, voluntary_termination_flag, involuntary_termination_flag",
                ],
            }
        )

        st.dataframe(column_groups, use_container_width=True, hide_index=True)
        st.markdown("</div>", unsafe_allow_html=True)

    with right:
        st.markdown('<div class="white-card">', unsafe_allow_html=True)
        card_header(
            "Filtered Data Quality Snapshot",
            "Basic completeness checks for the selected data.",
        )

        key_columns = [
            "employee_id",
            "department_type",
            "employee_status",
            "performance_score",
            "engagement_score",
            "training_outcome",
            "termination_flag",
        ]

        available_key_columns = [
            column for column in key_columns
            if column in filtered.columns
        ]

        quality_snapshot = pd.DataFrame(
            {
                "Column": available_key_columns,
                "Missing values": [
                    int(filtered[column].isna().sum())
                    for column in available_key_columns
                ],
                "Unique values": [
                    int(filtered[column].nunique())
                    for column in available_key_columns
                ],
            }
        )

        st.dataframe(quality_snapshot, use_container_width=True, hide_index=True)
        st.markdown("</div>", unsafe_allow_html=True)

    st.markdown('<div class="white-card">', unsafe_allow_html=True)
    card_header(
        "Download Filtered Dataset",
        "Export the currently filtered dataset as a CSV file.",
    )

    csv_data = filtered[selected_columns].to_csv(index=False).encode("utf-8")

    st.download_button(
        label="Download filtered dataset",
        data=csv_data,
        file_name="filtered_employee_lifecycle_dataset.csv",
        mime="text/csv",
    )

    st.markdown("</div>", unsafe_allow_html=True)