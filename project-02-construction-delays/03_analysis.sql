-- ============================================
-- PROJECT 2: Construction Delays Analysis
-- Step 3: Business Analysis & Key Insights
-- Author: Stiven Peña | github.com/stivenpena-data
-- ============================================

USE construction_pm;

-- ============================================
-- INSIGHT 1: Overall Project Performance
-- ============================================

SELECT
    COUNT(*) AS total_tasks,
    SUM(CASE WHEN On_Time = 'No' THEN 1 ELSE 0 END) AS delayed_tasks,
    ROUND(SUM(CASE WHEN On_Time = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS delay_rate_pct,
    SUM(Delay_Days) AS total_delay_days,
    ROUND(AVG(CASE WHEN Delay_Days > 0 THEN Delay_Days END), 1) AS avg_delay_when_delayed,
    ROUND(SUM(Cost_CAD), 0) AS total_cost_CAD
FROM delays_clean;

-- ============================================
-- INSIGHT 2: Delays by Supplier (THE KEY FINDING)
-- ============================================

SELECT
    Supplier,
    COUNT(*) AS total_tasks,
    SUM(CASE WHEN On_Time = 'No' THEN 1 ELSE 0 END) AS delays_caused,
    ROUND(SUM(CASE WHEN On_Time = 'No' THEN 1 ELSE 0 END) * 100.0 /
        (SELECT SUM(CASE WHEN On_Time = 'No' THEN 1 ELSE 0 END) FROM delays_clean), 1) AS pct_of_all_delays,
    SUM(Delay_Days) AS total_delay_days,
    ROUND(AVG(CASE WHEN Delay_Days > 0 THEN Delay_Days END), 1) AS avg_delay_days
FROM delays_clean
GROUP BY Supplier
ORDER BY delays_caused DESC;

-- ============================================
-- INSIGHT 3: Delays by Project
-- ============================================

SELECT
    Project,
    COUNT(*) AS total_tasks,
    SUM(CASE WHEN On_Time = 'No' THEN 1 ELSE 0 END) AS delayed_tasks,
    ROUND(SUM(CASE WHEN On_Time = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS delay_rate_pct,
    SUM(Delay_Days) AS total_delay_days,
    ROUND(SUM(Cost_CAD), 0) AS project_cost
FROM delays_clean
GROUP BY Project
ORDER BY total_delay_days DESC;

-- ============================================
-- INSIGHT 4: Delays by Task Type
-- Which phases get delayed most?
-- ============================================

SELECT
    `Task_Type`,
    COUNT(*) AS total_tasks,
    SUM(CASE WHEN On_Time = 'No' THEN 1 ELSE 0 END) AS delayed_tasks,
    ROUND(SUM(CASE WHEN On_Time = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS delay_rate_pct,
    SUM(Delay_Days) AS total_delay_days
FROM delays_clean
GROUP BY `Task_Type`
ORDER BY delayed_tasks DESC;

-- ============================================
-- INSIGHT 5: Delays by Reason
-- ============================================

SELECT
    Delay_Reason,
    COUNT(*) AS occurrences,
    ROUND(COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM delays_clean WHERE On_Time = 'No'), 1) AS pct_of_delays,
    SUM(Delay_Days) AS total_delay_days
FROM delays_clean
WHERE On_Time = 'No'
GROUP BY Delay_Reason
ORDER BY occurrences DESC;

-- ============================================
-- INSIGHT 6: Worker Performance
-- ============================================

SELECT
    Worker,
    COUNT(*) AS total_tasks,
    SUM(CASE WHEN On_Time = 'No' THEN 1 ELSE 0 END) AS delays,
    ROUND(SUM(CASE WHEN On_Time = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS delay_rate_pct,
    ROUND(SUM(Cost_CAD), 0) AS total_cost
FROM delays_clean
GROUP BY Worker
ORDER BY delay_rate_pct DESC;

-- ============================================
-- INSIGHT 7: Monthly Delay Trend
-- ============================================

SELECT
    DATE_FORMAT(Planned_Start, '%Y-%m') AS month,
    COUNT(*) AS total_tasks,
    SUM(CASE WHEN On_Time = 'No' THEN 1 ELSE 0 END) AS delayed_tasks,
    SUM(Delay_Days) AS total_delay_days
FROM delays_clean
WHERE Planned_Start IS NOT NULL
GROUP BY DATE_FORMAT(Planned_Start, '%Y-%m')
ORDER BY month;

-- ============================================
-- BUSINESS RECOMMENDATIONS SUMMARY
-- ============================================

SELECT '=== KEY FINDINGS ===' AS summary;

WITH stats AS (
    SELECT
        SUM(CASE WHEN On_Time = 'No' THEN 1 ELSE 0 END)                                    AS total_delayed,
        SUM(CASE WHEN Supplier = 'ProBuild Supply' AND On_Time = 'No' THEN 1 ELSE 0 END)   AS pb_delayed,
        SUM(CASE WHEN Supplier = 'ProBuild Supply' THEN Delay_Days ELSE 0 END)              AS pb_delay_days,
        SUM(CASE WHEN On_Time = 'No' THEN Cost_CAD ELSE 0 END)                              AS delayed_cost
    FROM delays_clean
)
SELECT
    CONCAT(
        'ProBuild Supply caused ',
        ROUND(pb_delayed * 100.0 / total_delayed, 0),
        '% of all delays (',
        pb_delay_days,
        ' days lost)'
    ) AS finding_1,
    CONCAT(
        'Total cost of delays: $',
        FORMAT(delayed_cost, 0),
        ' CAD across ',
        total_delayed,
        ' delayed tasks'
    ) AS finding_2
FROM stats;
