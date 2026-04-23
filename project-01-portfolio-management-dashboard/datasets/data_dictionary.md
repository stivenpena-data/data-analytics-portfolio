# Data Dictionary — Portfolio Management Dashboard

## Table: projects_data

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| project_id | STRING | Unique project identifier | P001 |
| project_name | STRING | Descriptive project name | ERP System Migration |
| department | STRING | Owning business unit | IT, Finance, HR, Sales, Operations, Marketing, Data & Analytics |
| project_manager | STRING | Assigned PM name | Sarah Johnson |
| priority | STRING | Business priority level | High, Medium, Low |
| status | STRING | Current project state | Completed, In Progress, At Risk, On Hold |
| risk_level | STRING | Overall risk assessment | Low, Medium, High |
| start_date | DATE | Project kick-off date | 2024-01-08 |
| planned_end_date | DATE | Originally scheduled completion | 2024-06-30 |
| actual_end_date | DATE | Real completion date (NULL if ongoing) | 2024-07-12 |
| planned_budget | INTEGER | Approved budget in USD | 320000 |
| actual_cost | INTEGER | Spend to date in USD | 341500 |
| completion_pct | INTEGER | % of work completed (0–100) | 100 |
| team_size | INTEGER | Number of team members | 8 |

## Derived Metrics (calculated in SQL)

| Metric | Formula | Interpretation |
|--------|---------|----------------|
| budget_variance | actual_cost - planned_budget | Positive = over budget |
| budget_variance_pct | (actual_cost - planned_budget) / planned_budget * 100 | % over/under |
| days_delay | actual_end_date - planned_end_date | Positive = late |
| on_time_flag | 1 if actual_end_date <= planned_end_date | Binary KPI |
| burn_rate | actual_cost / completion_pct | Cost per % complete |
| cost_efficiency | planned_budget / actual_cost | >1 = under budget |

## Status Definitions

| Status | Definition |
|--------|-----------|
| Completed | Delivered and closed |
| In Progress | Active execution, on track |
| At Risk | Active but behind schedule or over budget |
| On Hold | Paused — pending decision or resources |

## Risk Level Definitions

| Risk | Criteria |
|------|----------|
| Low | Minimal blockers, stable scope |
| Medium | Some uncertainty, manageable issues |
| High | Significant scope, tech, or resource risks |
