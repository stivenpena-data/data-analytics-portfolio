-- Sales Analysis Queries
-- Dataset: Superstore Sales
-- Purpose: Answer key business questions using SQL

-- 1. Total Revenue
SELECT
    SUM(Sales) AS total_revenue
FROM superstore_sales;

-- 2. Sales by Region
SELECT
    Region,
    SUM(Sales) AS total_sales
FROM superstore_sales
GROUP BY Region
ORDER BY total_sales DESC;

-- 3. Sales by Category
SELECT
    Category,
    SUM(Sales) AS total_sales
FROM superstore_sales
GROUP BY Category
ORDER BY total_sales DESC;

-- 4. Monthly Sales Trend
SELECT
    MONTH(Order_Date) AS month,
    SUM(Sales) AS monthly_sales
FROM superstore_sales
GROUP BY MONTH(Order_Date)
ORDER BY month;

-- 5. Top 10 Products by Sales
SELECT
    Product_Name,
    SUM(Sales) AS total_sales
FROM superstore_sales
GROUP BY Product_Name
ORDER BY total_sales DESC
LIMIT 10;
