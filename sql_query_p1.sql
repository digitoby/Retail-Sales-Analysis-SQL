-- SQL Retail Sales Analysis - P1

-- Create TABLE
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

-- Data Cleaning
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

-- Data Exploration

-- How many sales do we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) as customer_id FROM retail_sales

-- How many product categories do we sell?
SELECT DISTINCT category FROM retail_sales

-- Data analysis & business key problems and answers

-- Q1. Write a query to retrieve all entries for sales made on 2022-11-05
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'

-- Q2. Write a query to retrieve all transactions where the category is clothing and the quantity sold is more than 4 in the month of Nov, 2022
SELECT * FROM retail_sales
WHERE 
	category = 'Clothing' AND
	quantity >= 4 AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'

-- Q3. Write a query to calculate the total sales for each category
SELECT
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Q4. Write a query to find the average age of customers who purchased items from the beauty category
SELECT
	ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- Q5. Write a query to find all transactions where the total sale is greater than $1000
SELECT * FROM retail_sales
WHERE total_sale >= 1000

-- Q6. Write a query to find the total number of transactions made by each gender in each category
SELECT
	category,
	gender,
	COUNT(*) as total_transactions
FROM retail_sales
GROUP BY 1,2
ORDER BY 1

-- Q7. Write a query to calculate the average sales for each month. Find out the best selling month in each year
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

-- Q8. Write a query to find the top 5 customers based on their total sales
SELECT
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q9. Write a query to find the number of unique customers who purchased items from each category
SELECT
	category,
	COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY 1

-- Q10. Write a query to count the number of orders by morning, afternoon, and evening
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

-- END OF PROJECT