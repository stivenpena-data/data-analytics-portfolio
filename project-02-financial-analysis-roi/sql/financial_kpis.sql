-- ============================================================
-- Financial Analysis & ROI — KPI Calculations
-- Author: Stiven Pena | Data Analytics Portfolio
-- ============================================================

-- ============================================================
-- 1. ANNUAL P&L SUMMARY
-- ============================================================
SELECT
    department,
    SUM(revenue)            AS total_revenue,
    SUM(cogs)               AS total_cogs,
    SUM(gross_profit)       AS total_gross_profit,
    SUM(operating_expenses) AS total_opex,
    SUM(ebitda)             AS total_ebitda,
    ROUND(SUM(gross_profit) * 100.0 / NULLIF(SUM(revenue), 0), 1) AS gross_margin_pct,
    ROUND(SUM(ebitda) * 100.0 / NULLIF(SUM(revenue), 0), 1)       AS ebitda_margin_pct
FROM monthly_financials
GROUP BY department
ORDER BY total_revenue DESC;


-- ============================================================
-- 2. MONTHLY REVENUE TREND + MoM GROWTH
-- ============================================================
WITH monthly_totals AS (
    SELECT
        month,
        SUM(revenue) AS total_revenue,
        SUM(ebitda)  AS total_ebitda
    FROM monthly_financials
    GROUP BY month
),
with_lag AS (
    SELECT
        month,
        total_revenue,
        total_ebitda,
        LAG(total_revenue) OVER (ORDER BY month) AS prev_revenue
    FROM monthly_totals
)
SELECT
    month,
    total_revenue,
    total_ebitda,
    ROUND((total_revenue - prev_revenue) * 100.0 / NULLIF(prev_revenue, 0), 1) AS mom_growth_pct
FROM with_lag
ORDER BY month;


-- ============================================================
-- 3. COST STRUCTURE BREAKDOWN
-- ============================================================
SELECT
    department,
    SUM(operating_expenses) AS total_opex,
    SUM(marketing_spend)    AS total_marketing,
    SUM(capex)              AS total_capex,
    SUM(headcount)          AS avg_headcount,
    ROUND(SUM(operating_expenses) * 1.0 / NULLIF(AVG(headcount), 0), 0) AS cost_per_head,
    ROUND(SUM(marketing_spend) * 100.0 / NULLIF(SUM(operating_expenses), 0), 1) AS marketing_as_pct_opex
FROM monthly_financials
GROUP BY department
ORDER BY total_opex DESC;


-- ============================================================
-- 4. ROI RANKING BY INITIATIVE
-- ============================================================
SELECT
    initiative_id,
    initiative_name,
    department,
    category,
    benefit_type,
    investment_usd,
    annual_benefit_usd,
    payback_months,
    roi_pct,
    npv_3yr,
    RANK() OVER (ORDER BY roi_pct DESC) AS roi_rank,
    RANK() OVER (ORDER BY npv_3yr DESC) AS npv_rank
FROM project_roi
ORDER BY roi_pct DESC;


-- ============================================================
-- 5. ROI BY CATEGORY
-- ============================================================
SELECT
    category,
    COUNT(*)                             AS initiatives,
    SUM(investment_usd)                  AS total_invested,
    SUM(annual_benefit_usd)              AS total_annual_benefit,
    ROUND(AVG(roi_pct), 1)               AS avg_roi_pct,
    ROUND(AVG(payback_months), 1)        AS avg_payback_months,
    SUM(npv_3yr)                         AS total_npv_3yr
FROM project_roi
GROUP BY category
ORDER BY avg_roi_pct DESC;


-- ============================================================
-- 6. PAYBACK PERIOD SEGMENTATION
-- ============================================================
SELECT
    CASE
        WHEN payback_months <= 6  THEN '0-6 months (Quick Win)'
        WHEN payback_months <= 12 THEN '7-12 months (Fast)'
        WHEN payback_months <= 18 THEN '13-18 months (Standard)'
        ELSE '18+ months (Long-term)'
    END AS payback_bucket,
    COUNT(*)                      AS count,
    SUM(investment_usd)           AS total_investment,
    ROUND(AVG(roi_pct), 1)        AS avg_roi_pct
FROM project_roi
GROUP BY payback_bucket
ORDER BY MIN(payback_months);


-- ============================================================
-- 7. DEPARTMENT-LEVEL ROI SUMMARY
-- ============================================================
SELECT
    department,
    COUNT(*)                              AS initiatives,
    SUM(investment_usd)                   AS total_invested,
    SUM(annual_benefit_usd)               AS total_benefits,
    ROUND(SUM(annual_benefit_usd) * 100.0
          / NULLIF(SUM(investment_usd), 0) - 100, 1)  AS portfolio_roi_pct,
    ROUND(AVG(payback_months), 1)         AS avg_payback_months,
    SUM(npv_3yr)                          AS total_npv
FROM project_roi
GROUP BY department
ORDER BY portfolio_roi_pct DESC;


-- ============================================================
-- 8. BENEFIT TYPE DISTRIBUTION
-- ============================================================
SELECT
    benefit_type,
    COUNT(*)                             AS initiatives,
    SUM(investment_usd)                  AS investment,
    SUM(annual_benefit_usd)              AS annual_benefit,
    ROUND(AVG(roi_pct), 1)               AS avg_roi_pct,
    ROUND(COUNT(*) * 100.0
          / (SELECT COUNT(*) FROM project_roi), 1) AS pct_of_portfolio
FROM project_roi
GROUP BY benefit_type
ORDER BY investment DESC;


-- ============================================================
-- 9. QUARTERLY OPEX TREND
-- ============================================================
SELECT
    CASE
        WHEN SUBSTR(month,6,2) IN ('01','02','03') THEN 'Q1-2023'
        WHEN SUBSTR(month,6,2) IN ('04','05','06') THEN 'Q2-2023'
        WHEN SUBSTR(month,6,2) IN ('07','08','09') THEN 'Q3-2023'
        ELSE 'Q4-2023'
    END AS quarter,
    SUM(operating_expenses) AS total_opex,
    SUM(marketing_spend)    AS total_marketing,
    SUM(capex)              AS total_capex,
    SUM(revenue)            AS total_revenue,
    ROUND(SUM(operating_expenses)*100.0/NULLIF(SUM(revenue),0),1) AS opex_ratio_pct
FROM monthly_financials
GROUP BY quarter
ORDER BY quarter;


-- ============================================================
-- 10. EXECUTIVE FINANCIAL SCORECARD
-- ============================================================
SELECT
    SUM(revenue)                                                  AS annual_revenue,
    SUM(gross_profit)                                             AS annual_gross_profit,
    ROUND(SUM(gross_profit)*100.0/NULLIF(SUM(revenue),0),1)      AS gross_margin_pct,
    SUM(ebitda)                                                   AS annual_ebitda,
    ROUND(SUM(ebitda)*100.0/NULLIF(SUM(revenue),0),1)            AS ebitda_margin_pct,
    SUM(marketing_spend)                                          AS total_marketing_spend,
    ROUND(SUM(marketing_spend)*100.0/NULLIF(SUM(revenue),0),1)   AS marketing_as_pct_revenue,
    SUM(capex)                                                    AS total_capex
FROM monthly_financials;
