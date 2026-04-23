# Data Dictionary — Financial Analysis & ROI

## Table: monthly_financials

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| month | DATE (YYYY-MM) | Reporting period | 2023-01 |
| department | STRING | Business unit | Sales, IT, Finance |
| revenue | INTEGER | Total revenue generated (USD) | 1240000 |
| cogs | INTEGER | Cost of goods/services sold (USD) | 496000 |
| gross_profit | INTEGER | Revenue minus COGS | 744000 |
| operating_expenses | INTEGER | SG&A + salaries + overhead (USD) | 312000 |
| ebitda | INTEGER | Gross profit minus OpEx | 432000 |
| headcount | INTEGER | Active FTEs in period | 18 |
| marketing_spend | INTEGER | Paid media + campaigns (USD) | 85000 |
| capex | INTEGER | Capital expenditure (USD) | 12000 |

## Table: project_roi

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| initiative_id | STRING | Unique initiative ID | I001 |
| initiative_name | STRING | Initiative description | ERP Migration |
| department | STRING | Owning department | IT |
| category | STRING | Investment type | Technology, Digital, Process, Security, Regulatory |
| investment_date | DATE | Date of initial investment | 2024-01-01 |
| investment_usd | INTEGER | Total investment (USD) | 341500 |
| annual_benefit_usd | INTEGER | Projected/realized annual benefit (USD) | 280000 |
| payback_months | FLOAT | Months to break even | 14.6 |
| roi_pct | FLOAT | ROI % = (benefit - investment) / investment * 100 | 81.9 |
| npv_3yr | INTEGER | Net Present Value over 3 years at 10% discount rate | 357800 |
| status | STRING | Realized or In Progress | Realized |
| benefit_type | STRING | Nature of benefit | Cost Reduction, Revenue Growth, Efficiency, Risk Mitigation |

## Derived Metrics

| Metric | Formula |
|--------|---------|
| gross_margin_pct | gross_profit / revenue * 100 |
| ebitda_margin_pct | ebitda / revenue * 100 |
| mom_growth | (current_revenue - prev_revenue) / prev_revenue * 100 |
| portfolio_roi | (total_benefits - total_investment) / total_investment * 100 |
| cost_per_head | operating_expenses / headcount |
