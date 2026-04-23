# Project 01 — Portfolio Management Dashboard

> **Skills demonstrated:** SQL · Data Analysis · KPI Design · Power BI · Project Management

## Overview

A data-driven portfolio management system that tracks 25 cross-departmental projects ($5M+ budget) across KPIs including delivery rate, budget variance, risk distribution, and PM performance.

Built to simulate the kind of reporting a PMO or IT Director would use to make resource allocation decisions.

---

## Problem Statement

Organizations running 20+ concurrent projects often lack a single view to answer:
- Which projects are at risk right now?
- Which departments consistently overspend?
- Which project managers deliver on time and under budget?

This dashboard answers those questions using structured data + SQL + Power BI.

---

## Dataset

**File:** `datasets/projects_data.csv`
- 25 projects | 7 departments | 5 PMs
- Period: Jan – Jun 2024
- Total budget: $5,045,000
- Statuses: Completed (9), In Progress (13), At Risk (2), On Hold (2)

See `datasets/data_dictionary.md` for full column definitions.

---

## SQL Analysis (`sql/kpi_calculations.sql`)

10 queries covering:

| Query | Purpose |
|-------|---------|
| Portfolio Health Summary | Completion rate, total spend, variance |
| On-Time Delivery Rate | % completed on schedule, avg delay |
| Budget by Department | Variance per business unit |
| Risk Distribution | Budget exposure by risk level |
| PM Scorecard | Performance ranking per manager |
| Projects at Risk | Actionable list for immediate intervention |
| Monthly Spend Trend | Budget commitment over time |
| Cost Efficiency Score | Cost per % complete per project |
| Team Size vs Performance | Headcount-to-output correlation |
| Executive Scorecard | Single-row C-level summary |

---

## Key Insights

- **On-time delivery: 56%** — below 80% target; IT and Product are the main laggards
- **Budget variance: +4.8%** — within 5% threshold but concentrated in 3 high-risk projects
- **High-risk exposure: 26% of budget** — 6 projects flagged requiring immediate PMO attention
- **Best efficiency:** Data & Analytics team delivers at 52% spend for 51% completion — benchmark for the org

Full analysis in `insights/executive_summary.md`.

---

## Dashboard Design (Power BI)

4-page report layout:

| Page | Content |
|------|---------|
| Executive Summary | KPI cards + status donut + risk bar |
| Department Performance | Budget variance table + on-time bar chart |
| Risk & Budget | Scatter plot (budget vs completion) + at-risk table |
| Project Detail | Filterable project table with conditional formatting |

---

## Tools & Technologies

| Tool | Use |
|------|-----|
| SQL (SQLite syntax) | Data transformation, KPI calculation |
| Excel / CSV | Dataset creation and validation |
| Power BI | Interactive dashboard |
| Markdown | Documentation |

---

## How to Run

1. Load `datasets/projects_data.csv` into any SQL tool (DB Browser, BigQuery, SQL Server)
2. Run queries from `sql/kpi_calculations.sql` in order
3. Import CSV into Power BI and build visuals per the page layout above

---

## Author

**Stiven Pena** — PM & Data Analyst | [GitHub](https://github.com/stivenpena-data) | [LinkedIn](https://linkedin.com/in/stivenpena)
