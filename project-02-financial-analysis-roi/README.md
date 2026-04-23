# Project 02 — Financial Analysis & ROI Dashboard

> **Skills demonstrated:** SQL · Financial Modeling · ROI Analysis · Cost-Benefit · Power BI · Business Strategy

## Overview

End-to-end financial analysis covering FY 2023 P&L performance across 7 departments and ROI evaluation of 18 technology/process initiatives ($2.9M invested).

Built to simulate the financial reporting a CFO, Finance Business Partner, or senior PM would produce to guide budget allocation decisions.

---

## Problem Statement

Finance teams and PMs often struggle to answer:
- Which departments are generating positive EBITDA — and which are cost centers?
- What is the real ROI of our technology investments?
- Which initiatives should get more funding next cycle?

This project answers those questions using two linked datasets + advanced SQL + structured financial analysis.

---

## Datasets

### 1. `monthly_financials.csv`
- 12 months × 7 departments = 84 rows
- Columns: revenue, COGS, gross profit, EBITDA, OpEx, headcount, marketing spend, CapEx
- Revenue range: $1.24M → $2.1M/month (Sales, growing 69.8% YoY)

### 2. `project_roi.csv`
- 18 initiatives across 5 categories
- Total invested: $2.87M | Total annual benefits: $3.88M
- ROI range: 81.9% (ERP Migration) → 326.8% (Fraud Detection)

See `datasets/data_dictionary.md` for full definitions.

---

## SQL Analysis (`sql/financial_kpis.sql`)

10 production-ready queries:

| Query | Business Question |
|-------|------------------|
| Annual P&L Summary | What is each department's margin profile? |
| Monthly Revenue Trend | What is MoM growth and EBITDA trend? |
| Cost Structure Breakdown | Where are we spending per head? |
| ROI Ranking | Which initiatives deliver the most return? |
| ROI by Category | Do Digital beats Technology? |
| Payback Segmentation | How many are quick wins vs long-term bets? |
| Department ROI Summary | Who gets more budget next cycle? |
| Benefit Type Distribution | Is cost reduction or revenue growth driving value? |
| Quarterly OpEx Trend | Are costs trending up or down vs revenue? |
| Executive Scorecard | One-row C-level financial summary |

---

## Key Results

| Metric | Value |
|--------|-------|
| FY 2023 Revenue | $19.66M |
| Gross Margin | 60.1% ✅ |
| EBITDA Margin | 18.4% ✅ |
| Portfolio ROI | 35.1% |
| Best Initiative ROI | 326.8% (Fraud Detection) |
| Fastest Payback | 3.7 months (Fraud Detection) |
| Best ROI Dept | Data & Analytics (56.5%) |

Full narrative in `analysis/executive_summary.md`.

---

## Dashboard Design (Power BI)

| Page | Content |
|------|---------|
| P&L Overview | Revenue/EBITDA trend + gross margin by dept |
| Cost Analysis | OpEx breakdown + cost per head + CapEx vs OpEx |
| ROI Portfolio | ROI scatter plot + payback bar chart + ranking table |
| Initiative Detail | Filterable ROI table with conditional formatting |

---

## Tools & Technologies

| Tool | Use |
|------|-----|
| SQL (SQLite/BigQuery syntax) | Financial KPI calculations |
| CSV | Synthetic dataset (P&L + ROI) |
| Power BI | Interactive 4-page dashboard |
| Markdown | Documentation and analysis |

---

## How to Run

1. Import both CSVs into your SQL tool or Power BI
2. Run `sql/financial_kpis.sql` queries in order
3. Build Power BI visuals following the dashboard design above
4. Use `analysis/executive_summary.md` as the report narrative

---

## Author

**Stiven Pena** — PM & Data Analyst | [GitHub](https://github.com/stivenpena-data) | [LinkedIn](https://linkedin.com/in/stivenpena)
