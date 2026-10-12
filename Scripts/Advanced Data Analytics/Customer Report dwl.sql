

--========================================================
--Customer Report
--========================================================

/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
with base_query as (
select
	s.order_number,
	s.product_key,
	s.customer_key,
	s.order_date,
	s.sale_amount,
	s.quantity,
	concat(c.first_name,' ', c.last_name) as customer_name,
	datediff(year,c.birthate,getdate()) as age
	
from gold.fact_sales s
left join gold.dim_customers c
on c.customer_key=s.customer_key
left join gold.dim_products p
on p.product_key=s.product_key
where s.order_date is not null
),
customer_aggregation as (

select
	customer_key,
	customer_name,
	age,
	sum(sale_amount) as total_sales,
	count(distinct order_date)as total_orders,
	sum(quantity) as total_quantity,
	count(distinct product_key) as total_products,
	max(order_date) as last_order_date,
	datediff(month,min(order_date),max(order_date)) as lifespan
from base_query
group by 
	customer_key,
	customer_name,
	age
)

SELECT 
	customer_key,
	customer_name,
	age,
	CASE 
	 WHEN age < 20 THEN 'Under 20'
	 WHEN age between 20 and 29 THEN '20-29'
	 WHEN age between 30 and 39 THEN '30-39'
	 WHEN age between 40 and 49 THEN '40-49'
	 ELSE '50 and above'
END AS age_group,
CASE 
    WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
    WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
    ELSE 'New'
END AS customer_segment,
last_order_date,
DATEDIFF(month,last_order_date,getdate()) as recency,
total_sales,
total_orders,
total_products,
lifespan,
--average order value AVO
case when total_orders = 0 then 0
	 else total_orders/total_sales
end as avg_order_value,
--average monthly spend:
case when lifespan =0 then total_sales
	 else lifespan/total_sales
end as avg_monthly_spned
FROM customer_aggregation