select* from gold.dim_customers;
select* from gold.dim_products;
select* from gold.fact_sales;

--========================================================
--Performance analysis Analysis
--========================================================
/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */
with sales_by_product as (
select
	year(s.order_date) as order_year,
	p.product_name,
	sum(s.sale_amount) as current_sales
from gold.fact_sales s
left join gold.dim_products p
on  p.product_key= s.product_key
where s.order_date is not null
group by year(s.order_date),p.product_name

)
select
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) over(partition by product_name) as average,
	current_sales - AVG(current_sales) over(partition by product_name) as diff_avg,
	case when current_sales - AVG(current_sales) over(partition by product_name)<0 then 'below average'
		 when current_sales - AVG(current_sales) over(partition by product_name)>0 then 'abve average'
		 else 'average'
	end as avg_change,
	current_sales - lag(current_sales) over(partition by product_name order by order_year) as yoy,
	lag(current_sales) over(partition by product_name order by order_year) as previous_year,
	case when lag(current_sales) over(partition by product_name order by order_year)<0 then 'decreasing'
		 when lag(current_sales) over(partition by product_name order by order_year)>0 then 'increasing'
		 else 'no change'
	end as py_change
	
from sales_by_product
order by product_name,order_year
