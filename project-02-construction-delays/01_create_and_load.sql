-- ============================================
-- PROJECT 2: Construction Delays Analysis
-- Step 1: Create Database and Load Data
-- Author: Stiven Peña | github.com/stivenpena-data
-- ============================================

CREATE DATABASE IF NOT EXISTS construction_pm;
USE construction_pm;

-- Drop table if exists (for re-runs)
DROP TABLE IF EXISTS delays_raw;

-- Create raw table (dirty data goes here first)
CREATE TABLE delays_raw (
    Task_ID         INT,
    Project         VARCHAR(100),
    Task_Type       VARCHAR(50),
    Worker          VARCHAR(50),
    Supplier        VARCHAR(100),
    Planned_Start   VARCHAR(20),   -- VARCHAR to catch bad date formats
    Planned_End     VARCHAR(20),
    Actual_End      VARCHAR(20),
    Delay_Days      VARCHAR(10),   -- VARCHAR to catch negative/non-numeric values
    Delay_Reason    VARCHAR(100),
    On_Time         VARCHAR(10),
    Cost_CAD        VARCHAR(20)    -- VARCHAR to catch missing/zero costs
);

-- ⚠️ LOAD DATA: Update path to your CSV file location
-- In MySQL Workbench: Server > Data Import > Import from CSV
-- OR run this (adjust path):
/*
LOAD DATA INFILE 'D:/Business Analytics Course/construction_delays_dirty.csv'
INTO TABLE delays_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
*/

-- Verify load
SELECT COUNT(*) AS total_rows FROM delays_raw;
SELECT * FROM delays_raw LIMIT 5;
