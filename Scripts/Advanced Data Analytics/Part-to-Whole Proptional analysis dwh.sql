
select* from gold.dim_customers;
select* from gold.dim_products;
select* from gold.fact_sales;
--========================================================
--Part-to-Whole Proptional analysis Analysis
--========================================================
--Which categories contribute the most to overall sales?
with sales_by_cat as (
select
	p.category,
	sum(s.sale_amount) as total_sales
from gold.fact_sales s
left join gold.dim_products p
on p.product_key=s.product_key
group by p.category
)
select category,
	total_sales,
	sum(total_sales) over() as overall_sales,
	concat(round(cast(total_sales as float) / sum(total_sales) over()*100,2),' ','%') as percentage_of_total
from sales_by_cat
order by total_sales desc