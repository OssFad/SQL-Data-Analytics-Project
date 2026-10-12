

--========================================================
--Cumulative Analysis
--========================================================
-- Calculate the total sales per month 
-- and the running total that restarts every year 

with total_sales_per_month as (
select DATETRUNC(month,order_date) as Months,
	sum(sale_amount) as total_sales	
from gold.fact_sales
where order_date is not null
group by DATETRUNC(month,order_date)

)
select Months,total_sales,
	sum(total_sales) over(partition by year(Months) order by Months) as running_sales
from total_sales_per_month


-- Calculate the average total sales per month 
-- and the moving average that restarts every year 

with total_average_sales as (
SELECT 
        DATETRUNC(year, order_date) AS order_date,
        SUM(sale_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
)
select
	order_date,
	total_sales,
	avg_price,
	sum(total_sales) over( order by order_date) as running_total,
	avg(avg_price) over( order by order_date rows between 2 preceding and current row) as moving_average
from total_average_sales




