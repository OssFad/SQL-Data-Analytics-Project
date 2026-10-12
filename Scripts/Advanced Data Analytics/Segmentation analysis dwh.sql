
select* from gold.dim_customers;
select* from gold.dim_products;
select* from gold.fact_sales;

--========================================================
--Segmentation Analysis
--========================================================

/*Segment products into cost ranges and 
count how many products fall into each segment*/

WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        product_cost,
        CASE 
            WHEN product_cost < 100 THEN 'Below 100'
            WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
select 
	cost_range,
	
	count(product_key) as nbr_product
from product_segments
group by cost_range
order by cost_range desc

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/ 
with customer_spending as (
select 
	c.customer_key,
	min(s.order_date) as first_order,
	max(s.order_date) as last_order,
	DATEDIFF(month,min(s.order_date),max(s.order_date)) as lifespan,
	sum(s.sale_amount) as total_sales
from gold.fact_sales s
left join gold.dim_customers c
on c.customer_key=s.customer_key
group by c.customer_key

),
customer_segment2 as (
select 
	customer_key,

	case when lifespan>= 12 and total_sales >5000 then 'VIP'
		 when lifespan>= 12 and total_sales <=5000 then 'Regular'
		 else 'New'
	end as customer_segment
from customer_spending
)
select
	customer_segment,
	count(customer_key) as nbr_customer	
from customer_segment2
group by customer_segment
order by nbr_customer desc


