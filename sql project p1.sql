---SQL Retail Sales Analysis - p1--
CREATE DATABASE project p1  

CREATE TABLE retail_sales
  (
     transaction_id INTEGER PRIMARY KEY,
	 sale_date DATE,
	 sale_time TIME,
	 customer_id INTEGER,
	 gender VARCHAR(45),
	 age INT,
     category VARCHAR(45),
	 quantity INTEGER,
	 price_per_unit FLOAT,
	 cogs FLOAT,
	 total_sale FLOAT
  );
--- cleaning 

select * from retail_sales
limit 10;
  
select count(*)
from retail_sales;

-- Data Exploration
-- How many customer in retailsale?
SELECT customer_id FROM retail_sales;

--Data Analysis & Business Key Problems & Answers

--My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


--Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT* from retail_sales
WHERE sale_date='11-05-2022';

--Q.2 Write a SQL query to retrive all transactionds where the category is 'clothing'and the quantity is more than or equal to 4 in the month of nov-2022
SELECT 
   *
FROM retail_sales
WHERE
    category='Clothing'
	AND
	TO_CHAR (sale_date,'YYYY-MM')='2022-11'
	AND
	quantity>=4

--- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
	sum(total_sale) AS net_sale,
	count(*) AS total_order
FROM retail_sales
GROUP BY 1
	
--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
  AVG(age)
FROM retail_sales
WHERE 
   category='Beauty'

--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.  

SELECT *
FROM retail_sales
WHERE 
   total_sale >1000

--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
   category,
   gender,
   count(*)as total_trans
FROM retail_sales
GROUP BY 
  1,2
ORDER BY 1  

--Q.7 Write a SQL query to calculate average sale for each month. Find out best selling month in each year

SELECT
     year,
	 month,
     avg_sale
FROM
(
SELECT 
    EXTRACT ( year from sale_date)AS year,
	EXTRACT ( month from sale_date) AS month, 
	AVG(total_sale) AS avg_sale,
	rank()over(partition by extract(year from sale_date)order by avg(total_sale)DESC)as rank
FROM retail_sales
GROUP BY 1,2
) 
WHERE rank =1

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
    customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
   category,   
   COUNT(DISTINCT(customer_id)) AS customs_unq
FROM retail_sales
GROUP BY category
	
--Q.10 Write a SQL query to create each shift and number of orders(EXAMPLE Morning <12,Afternoon Between 12 and 17 ,Evening >17)

WITH sales_s
as
(
SELECT *,
  CASE
    WHEN EXTRACT(HOUR FROM sale_time)<12THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time)BETWEEN 12 AND 17THEN'Afternoon'
    ELSE 'Evening'
  end as shift  
FROM retail_sales
)
SELECT 
   shift,
   count(*)as total_orders
FROM sales_s
GROUP BY shift 

-- End of Project--


   