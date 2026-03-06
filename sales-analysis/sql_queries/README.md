# SQL Queries

This folder contains the SQL queries used to analyze the Superstore Sales dataset.

The queries were designed to answer key business questions related to sales performance, product performance, and regional trends.

These SQL scripts form the analytical foundation for the insights and the Power BI dashboard included in this project.

---

# Analysis Objectives

The SQL queries in this project aim to answer the following business questions:

- What is the total revenue generated?
- Which regions generate the highest sales?
- Which product categories perform best?
- How do sales change over time?
- Which products generate the most revenue?

---

# Queries Included

The file `sales_analysis_queries.sql` contains the following analyses:

### Total Revenue
Calculates the total sales revenue generated in the dataset.

### Sales by Region
Aggregates sales by region to identify the strongest performing markets.

### Sales by Category
Analyzes total sales by product category.

### Monthly Sales Trend
Examines how sales change over time by month.

### Top Products by Sales
Identifies the top-performing products based on revenue.

---

# Example Query

Example of one of the SQL queries used in this project:

```sql
-- Sales by Region
SELECT
    Region,
    SUM(Sales) AS total_sales
FROM superstore_sales
GROUP BY Region
ORDER BY total_sales DESC;
