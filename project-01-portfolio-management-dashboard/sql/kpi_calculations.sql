-- ============================================================
-- Portfolio Management Dashboard — KPI Calculations
-- Author: Stiven Pena | Data Analytics Portfolio
-- ============================================================

-- ============================================================
-- 1. PORTFOLIO HEALTH SUMMARY
-- ============================================================
SELECT
    COUNT(*)                                                      AS total_projects,
    SUM(CASE WHEN status = 'Completed'  THEN 1 ELSE 0 END)       AS completed,
    SUM(CASE WHEN status = 'In Progress' THEN 1 ELSE 0 END)      AS in_progress,
    SUM(CASE WHEN status = 'At Risk'    THEN 1 ELSE 0 END)       AS at_risk,
    SUM(CASE WHEN status = 'On Hold'    THEN 1 ELSE 0 END)       AS on_hold,
    ROUND(SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 1)                                  AS completion_rate_pct,
    SUM(planned_budget)                                           AS total_budget,
    SUM(actual_cost)                                              AS total_spend,
    SUM(actual_cost) - SUM(planned_budget)                        AS portfolio_variance
FROM projects_data;


-- ============================================================
-- 2. ON-TIME DELIVERY RATE (Completed projects only)
-- ============================================================
SELECT
    COUNT(*)                                                             AS completed_projects,
    SUM(CASE WHEN actual_end_date <= planned_end_date THEN 1 ELSE 0 END) AS delivered_on_time,
    ROUND(SUM(CASE WHEN actual_end_date <= planned_end_date THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 1)                                         AS on_time_rate_pct,
    ROUND(AVG(JULIANDAY(actual_end_date) - JULIANDAY(planned_end_date)), 1) AS avg_delay_days
FROM projects_data
WHERE status = 'Completed';


-- ============================================================
-- 3. BUDGET PERFORMANCE BY DEPARTMENT
-- ============================================================
SELECT
    department,
    COUNT(*)                                                AS projects,
    SUM(planned_budget)                                     AS total_budget,
    SUM(actual_cost)                                        AS total_spend,
    SUM(actual_cost) - SUM(planned_budget)                  AS variance,
    ROUND((SUM(actual_cost) - SUM(planned_budget))
          * 100.0 / SUM(planned_budget), 1)                 AS variance_pct,
    SUM(CASE WHEN actual_cost <= planned_budget THEN 1 ELSE 0 END) AS under_budget_count
FROM projects_data
GROUP BY department
ORDER BY variance_pct DESC;


-- ============================================================
-- 4. RISK DISTRIBUTION
-- ============================================================
SELECT
    risk_level,
    COUNT(*)                                                AS project_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM projects_data), 1) AS pct_of_portfolio,
    SUM(planned_budget)                                     AS budget_at_risk,
    ROUND(AVG(completion_pct), 1)                           AS avg_completion_pct
FROM projects_data
GROUP BY risk_level
ORDER BY CASE risk_level WHEN 'High' THEN 1 WHEN 'Medium' THEN 2 ELSE 3 END;


-- ============================================================
-- 5. PROJECT MANAGER SCORECARD
-- ============================================================
SELECT
    project_manager,
    COUNT(*)                                                                      AS total_projects,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END)                        AS completed,
    SUM(CASE WHEN status = 'At Risk'   THEN 1 ELSE 0 END)                        AS at_risk,
    ROUND(AVG(completion_pct), 1)                                                 AS avg_completion_pct,
    SUM(planned_budget)                                                           AS budget_managed,
    ROUND((SUM(actual_cost) - SUM(planned_budget)) * 100.0 / SUM(planned_budget), 1) AS budget_variance_pct,
    SUM(team_size)                                                                AS total_headcount
FROM projects_data
GROUP BY project_manager
ORDER BY completed DESC, budget_variance_pct ASC;


-- ============================================================
-- 6. PROJECTS AT RISK DETAIL
-- ============================================================
SELECT
    project_id,
    project_name,
    department,
    project_manager,
    status,
    risk_level,
    planned_budget,
    actual_cost,
    ROUND((actual_cost - planned_budget) * 100.0 / planned_budget, 1) AS budget_overrun_pct,
    completion_pct,
    planned_end_date
FROM projects_data
WHERE status IN ('At Risk', 'On Hold')
   OR (actual_cost > planned_budget * 1.10)
ORDER BY risk_level DESC, budget_overrun_pct DESC;


-- ============================================================
-- 7. MONTHLY SPEND TREND (approximated from start dates)
-- ============================================================
SELECT
    STRFTIME('%Y-%m', start_date)           AS month_started,
    COUNT(*)                                AS projects_started,
    SUM(planned_budget)                     AS budget_committed,
    SUM(actual_cost)                        AS spend_to_date
FROM projects_data
GROUP BY STRFTIME('%Y-%m', start_date)
ORDER BY month_started;


-- ============================================================
-- 8. COST EFFICIENCY SCORE PER PROJECT
-- ============================================================
SELECT
    project_id,
    project_name,
    department,
    planned_budget,
    actual_cost,
    completion_pct,
    ROUND(actual_cost * 1.0 / NULLIF(completion_pct, 0), 0) AS cost_per_pct_complete,
    ROUND(planned_budget * 1.0 / NULLIF(completion_pct, 0), 0) AS expected_cost_per_pct,
    CASE
        WHEN actual_cost <= planned_budget THEN 'Under Budget'
        WHEN actual_cost <= planned_budget * 1.05 THEN 'On Budget (±5%)'
        WHEN actual_cost <= planned_budget * 1.15 THEN 'Over Budget (5-15%)'
        ELSE 'Significantly Over Budget (>15%)'
    END AS budget_health
FROM projects_data
ORDER BY cost_per_pct_complete DESC;


-- ============================================================
-- 9. TEAM SIZE VS PERFORMANCE CORRELATION
-- ============================================================
SELECT
    team_size,
    COUNT(*)                                AS project_count,
    ROUND(AVG(completion_pct), 1)           AS avg_completion_pct,
    SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END) AS completed_count,
    ROUND(AVG(actual_cost * 1.0 / NULLIF(team_size,0)), 0) AS avg_cost_per_member
FROM projects_data
GROUP BY team_size
ORDER BY team_size;


-- ============================================================
-- 10. EXECUTIVE PORTFOLIO SCORECARD (single-row summary)
-- ============================================================
SELECT
    COUNT(*)                                                              AS total_projects,
    ROUND(SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END)*100.0/COUNT(*),1) AS delivery_rate_pct,
    ROUND(SUM(CASE WHEN risk_level='High' THEN 1 ELSE 0 END)*100.0/COUNT(*),1)  AS high_risk_pct,
    SUM(planned_budget)                                                   AS total_portfolio_budget,
    SUM(actual_cost)                                                      AS total_spend,
    ROUND((SUM(actual_cost)-SUM(planned_budget))*100.0/SUM(planned_budget),1)   AS overall_budget_variance_pct,
    ROUND(AVG(completion_pct),1)                                          AS avg_portfolio_completion,
    SUM(team_size)                                                        AS total_headcount
FROM projects_data;
