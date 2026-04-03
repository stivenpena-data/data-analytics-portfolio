-- ============================================
-- PROJECT 2: Construction Delays Analysis
-- Step 2: Data Quality Assessment & Cleaning
-- Author: Stiven Peña | github.com/stivenpena-data
-- ============================================

USE construction_pm;

-- ============================================
-- SECTION A: DATA QUALITY ASSESSMENT
-- Run these first to document the problems
-- ============================================

-- Check 1: Total rows and duplicates
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Task_ID) AS unique_tasks,
    COUNT(*) - COUNT(DISTINCT Task_ID) AS duplicate_rows
FROM delays_raw;

-- Check 2: NULL or empty suppliers
SELECT COUNT(*) AS missing_suppliers
FROM delays_raw
WHERE Supplier IS NULL OR TRIM(Supplier) = '';

-- Check 3: Supplier name inconsistencies
SELECT Supplier, COUNT(*) AS count
FROM delays_raw
GROUP BY Supplier
ORDER BY count DESC;

-- Check 4: Negative delay days (impossible values)
SELECT Task_ID, Project, Task_Type, Delay_Days
FROM delays_raw
WHERE CAST(Delay_Days AS SIGNED) < 0;

-- Check 5: On_Time = Yes but Delay_Days > 0 (logical inconsistency)
SELECT Task_ID, Project, On_Time, Delay_Days
FROM delays_raw
WHERE On_Time = 'Yes' AND CAST(Delay_Days AS SIGNED) > 0;

-- Check 6: Missing delay reason when delayed
SELECT Task_ID, Project, Delay_Days, Delay_Reason
FROM delays_raw
WHERE CAST(Delay_Days AS SIGNED) > 0
  AND (Delay_Reason IS NULL OR TRIM(Delay_Reason) = '');

-- Check 7: Wrong date format (should be YYYY-MM-DD)
SELECT Task_ID, Planned_Start, Planned_End, Actual_End
FROM delays_raw
WHERE Planned_Start NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- Check 8: Zero or missing costs
SELECT Task_ID, Project, Cost_CAD
FROM delays_raw
WHERE Cost_CAD IS NULL OR TRIM(Cost_CAD) = '' OR CAST(Cost_CAD AS DECIMAL) = 0;

-- Check 9: Worker name inconsistencies
SELECT Worker, COUNT(*) AS count
FROM delays_raw
GROUP BY Worker
ORDER BY Worker;

-- ============================================
-- SECTION B: DATA CLEANING
-- ============================================

-- Step 1: Remove duplicates (keep first occurrence)
DELETE d1 FROM delays_raw d1
INNER JOIN delays_raw d2
WHERE d1.Task_ID = d2.Task_ID
  AND d1.Cost_CAD > d2.Cost_CAD;  -- keeps one row per Task_ID

-- Step 2: Fix supplier name inconsistencies
UPDATE delays_raw SET Supplier = 'ProBuild Supply'
WHERE Supplier IN ('Probuild Supply', 'ProBuild supply', 'PROBUILD SUPPLY', 'Pro Build Supply');

UPDATE delays_raw SET Supplier = 'CanMat Inc.'
WHERE Supplier IN ('Canmat Inc.', 'CanMat Inc', 'CANMAT INC.', 'Canmat');

UPDATE delays_raw SET Supplier = 'QuickBuild Co.'
WHERE Supplier IN ('Quickbuild Co.', 'Quick Build Co.', 'QuickBuild co.');

-- Step 3: Fix NULL suppliers — flag as 'Unknown'
UPDATE delays_raw
SET Supplier = 'Unknown'
WHERE Supplier IS NULL OR TRIM(Supplier) = '';

-- Step 4: Fix negative delay days — set to 0
UPDATE delays_raw
SET Delay_Days = 0, On_Time = 'Yes', Delay_Reason = 'On time'
WHERE CAST(Delay_Days AS SIGNED) < 0;

-- Step 5: Fix On_Time inconsistency
UPDATE delays_raw
SET On_Time = 'No'
WHERE On_Time = 'Yes' AND CAST(Delay_Days AS SIGNED) > 0;

-- Step 6: Fill missing delay reason
UPDATE delays_raw
SET Delay_Reason = 'Unknown'
WHERE CAST(Delay_Days AS SIGNED) > 0
  AND (Delay_Reason IS NULL OR TRIM(Delay_Reason) = '');

-- Step 7: Fix date formats (MM/DD/YYYY → YYYY-MM-DD)
UPDATE delays_raw
SET Planned_Start = STR_TO_DATE(Planned_Start, '%m/%d/%Y')
WHERE Planned_Start REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$';

-- Step 8: Fix zero/missing costs - replace with avg cost
UPDATE delays_raw
SET Cost_CAD = (SELECT avg_cost FROM (SELECT AVG(CAST(Cost_CAD AS DECIMAL(10,2))) AS avg_cost FROM delays_raw WHERE Cost_CAD REGEXP '^[0-9]+\\.?[0-9]*$' AND CAST(Cost_CAD AS DECIMAL(10,2)) > 0) t)
WHERE Cost_CAD IS NULL OR TRIM(Cost_CAD) = '' OR Cost_CAD = '0';

-- Step 9: Standardize worker names
UPDATE delays_raw SET Worker = 'Carlos M.'
WHERE UPPER(TRIM(Worker)) = 'CARLOS M.' OR Worker = 'Carlos M' OR Worker = 'carlos m.';

-- ============================================
-- SECTION C: CREATE CLEAN TABLE
-- ============================================

DROP TABLE IF EXISTS delays_clean;

CREATE TABLE delays_clean AS
SELECT
    Task_ID,
    Project,
    Task_Type,
    TRIM(Worker) AS Worker,
    TRIM(Supplier) AS Supplier,
    STR_TO_DATE(Planned_Start, '%Y-%m-%d') AS Planned_Start,
    STR_TO_DATE(Planned_End, '%Y-%m-%d') AS Planned_End,
    STR_TO_DATE(Actual_End, '%Y-%m-%d') AS Actual_End,
    CAST(Delay_Days AS UNSIGNED) AS Delay_Days,
    Delay_Reason,
    On_Time,
    CAST(Cost_CAD AS DECIMAL(10,2)) AS Cost_CAD
FROM delays_raw;

-- Final verification
SELECT
    COUNT(*) AS clean_rows,
    SUM(CASE WHEN Supplier = 'Unknown' THEN 1 ELSE 0 END) AS unknown_suppliers,
    SUM(CASE WHEN Delay_Days < 0 THEN 1 ELSE 0 END) AS negative_delays,
    SUM(CASE WHEN On_Time = 'Yes' AND Delay_Days > 0 THEN 1 ELSE 0 END) AS inconsistent_ontime
FROM delays_clean;

SELECT 'Data cleaning complete.' AS status;
