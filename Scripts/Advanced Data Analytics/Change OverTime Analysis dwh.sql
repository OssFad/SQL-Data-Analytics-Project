select* from gold.dim_customers;
select* from gold.dim_products;
select* from gold.fact_sales;


-- Total Sales by Year and Month:
select year(order_date) as order_year,
	   month(order_date) as order_month,
	   sum(sale_amount) as total_revenue
from gold.fact_sales
where order_date is not null
group by year(order_date),month(order_date)
order by year(order_date),month(order_date)


-- Totol Customers by Year and Month
select Year(order_date) as year_order,
	--month(order_date) as month_order,
	count(distinct customer_key) as total_customers
from gold.fact_sales
where order_date is not null
group by year(order_date)--,month(order_date)
order by year(order_date)--,month(order_date)

-- Total Products by Year and Month:
select year(order_date) as year_order,
	--month(order_date) as month_order,
	count(distinct product_key) as total_product
from gold.fact_sales
where order_date is not null
group by year(order_date)--,month(order_date)
order by  year(order_date)--,month(order_date)

--Total Quantity,Sales,Products, and Customers by Year and Month
select DATETRUNC(year,order_date) as year_order,
	--DATETRUNC(month, order_date) as month_order,
	sum(sale_amount) as total_revenue,
	sum(Quantity) as total_quantity,
	count(distinct customer_key) as total_customers,
	count(distinct product_key) as total_product
from gold.fact_sales
where order_date is not null
group by DATETRUNC(year,order_date)
		 --,DATETRUNC(month, order_date)
order by DATETRUNC(year,order_date)--,DATETRUNC(month, order_date)




