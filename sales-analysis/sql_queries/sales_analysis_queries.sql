-- Sales Analysis Queries

-- Total Revenue
SELECT
    SUM(Sales) AS total_revenue
FROM superstore_sales;

-- Sales by Region
SELECT
    Region,
    SUM(Sales) AS total_sales
FROM superstore_sales
GROUP BY Region
ORDER BY total_sales DESC;

-- Sales by Category
SELECT
    Category,
    SUM(Sales) AS total_sales
FROM superstore_sales
GROUP BY Category
ORDER BY total_sales DESC;

-- Monthly Sales Trend
SELECT
    MONTH(Date) AS month,
    SUM(Sales) AS monthly_sales
FROM superstore_sales
GROUP BY MONTH(Date)
ORDER BY month;
