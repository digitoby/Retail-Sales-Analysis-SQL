# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: I created a database in pgAdmin named `sql_project_p1`.
- **Table Creation**: I created a table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age	INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);
```

### 2. Preliminary Data Exploration and Cleaning

- **Brief Data Examination**: Briefly observe the dataset.
- **Record Count**: Determine the total number of records in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
- **Handle Null Values**: Since only 13 null values exist, I decided to delete all transactions with null values.

```sql
SELECT * FROM retail_sales
LIMIT 10

SELECT COUNT(*) FROM retail_sales

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL OR
	sale_date IS NULL OR
	sale_time IS NULL OR
	customer_id IS NULL OR
	gender IS NULL OR
	age IS NULL OR
	category IS NULL OR
	quantity IS NULL OR
	price_per_unit IS NULL OR
	cogs IS NULL OR
	total_sale IS NULL

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL OR
	sale_date IS NULL OR
	sale_time IS NULL OR
	customer_id IS NULL OR
	gender IS NULL OR
	age IS NULL OR
	category IS NULL OR
	quantity IS NULL OR
	price_per_unit IS NULL OR
	cogs IS NULL OR
	total_sale IS NULL
```

### 3. Further Exploration

- **Total Sales**: Examine how many sales are recorded.
- **Number of Unique Customers**: Identify how many unique customers have made a transaction within the time frame.
- **Number of Unique Categories**: Identify how many different product categories we have.

```sql
-- How many sales do we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) as customer_id FROM retail_sales

-- How many product categories do we sell?
SELECT DISTINCT category FROM retail_sales
```

### 4. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'
```

2. **Write a query to retrieve all transactions where the category is clothing and the quantity sold is more than 4 in the month of Nov, 2022.**:
```sql
SELECT * FROM retail_sales
WHERE 
	category = 'Clothing' AND
	quantity >= 4 AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
```

3. **Write a query to calculate the total sales for each category.**:
```sql
SELECT
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

4. **Write a query to find the average age of customers who purchased items from the beauty category.**:
```sql
SELECT
	ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Write a query to find all transactions where the total sale is greater than $1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale >= 1000
```

6. **Write a query to find the total number of transactions made by each gender in each category.**:
```sql
SELECT
	category,
	gender,
	COUNT(*) as total_transactions
FROM retail_sales
GROUP BY 1,2
ORDER BY 1
```

7. **Write a query to calculate the average sales for each month. Find out the best selling month in each year.**:
```sql
SELECT * FROM
(
	SELECT
		EXTRACT(YEAR from sale_date) as year,
		EXTRACT(MONTH from sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY 1, 2
) as t1
WHERE rank = 1
```

8. **Write a query to find the top 5 customers based on their total sales.**:
```sql
SELECT
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Write a query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT
	category,
	COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY 1
```

10. **Write a query to count the number of orders by morning, afternoon, and evening.**:
```sql
WITH hourly_sale AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as time_of_day
FROM retail_sales
)
SELECT
	time_of_day,
	COUNT(transactions_id) as transactions
FROM hourly_sale
GROUP BY 1
ORDER BY 1
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance. Although clothing had the most orders, electronics generated the most sales. Males had the most orders in the electronics and cloths category while females had the most orders in beauty.
- **Trend Analysis**: Insights into sales trends across different months and shifts. July and March were the top performing months in 2022. Febuary and August were the top performing months in 2023. This indicates that our company performs better in the 1st and 3rd quarters.
