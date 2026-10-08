
/*==============================================================================
    PROJECT       : SQL Data Warehouse - Exploratory Data Analysis (EDA)
    LAYER         : Gold
    PURPOSE       : Explore and understand the structure, content, and
                    temporal characteristics of the Gold-layer data.
 
    DATA SOURCES
    ------------------------------------------------------------------------------
    - gold.dim_customers
    - gold.dim_products
    - gold.fact_sales

    ANALYSIS AREAS
    ------------------------------------------------------------------------------
    - Database Exploration
    - Dimension Exploration
    - Date Exploration

    NOTES
    ------------------------------------------------------------------------------
    - This script is designed for exploratory analysis and data profiling.
    - No data is modified by this script.
    - All queries are read-only SELECT statements.
    - Existing column names have been preserved exactly as provided.
==============================================================================*/


/*==============================================================================
    1. DATABASE EXPLORATION
==============================================================================*/

------------------------------------------------------------
-- 1.1 Explore available tables
------------------------------------------------------------
-- Purpose:
-- Identify the tables available in the current database and
-- understand their catalog, schema, and table names.

SELECT *
FROM INFORMATION_SCHEMA.TABLES;


------------------------------------------------------------
-- 1.2 Explore columns of the product dimension
------------------------------------------------------------
-- Purpose:
-- Inspect the structure of gold.dim_products by retrieving
-- column names and their ordinal positions.
--
-- This helps understand the table structure before performing
-- further analysis.

SELECT
    TABLE_CATALOG,
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products';


/*==============================================================================
    2. DIMENSION EXPLORATION
==============================================================================*/

------------------------------------------------------------
-- 2.1 Explore customer countries
------------------------------------------------------------
-- Purpose:
-- Identify the distinct countries represented in the
-- customer dimension.

SELECT DISTINCT
    country
FROM gold.dim_customers;


------------------------------------------------------------
-- 2.2 Explore customer marital status
------------------------------------------------------------
-- Purpose:
-- Identify the distinct marital-status categories
-- available in the customer dimension.

SELECT DISTINCT
    marital_status
FROM gold.dim_customers;


------------------------------------------------------------
-- 2.3 Explore customer gender
------------------------------------------------------------
-- Purpose:
-- Identify the distinct gender categories available
-- in the customer dimension.

SELECT DISTINCT
    gender
FROM gold.dim_customers;


------------------------------------------------------------
-- 2.4 Explore product names
------------------------------------------------------------
-- Purpose:
-- Identify the unique products available in the
-- product dimension.

SELECT DISTINCT
    product_name
FROM gold.dim_products;


------------------------------------------------------------
-- 2.5 Explore product categories
------------------------------------------------------------
-- Purpose:
-- Identify the unique product categories available.

SELECT DISTINCT
    category
FROM gold.dim_products;


------------------------------------------------------------
-- 2.6 Explore product subcategories
------------------------------------------------------------
-- Purpose:
-- Identify the unique product subcategories available.

SELECT DISTINCT
    subcategory
FROM gold.dim_products;


------------------------------------------------------------
-- 2.7 Explore product lines
------------------------------------------------------------
-- Purpose:
-- Identify the unique product lines available.

SELECT DISTINCT
    poduct_line
FROM gold.dim_products;


------------------------------------------------------------
-- 2.8 Explore the product hierarchy
------------------------------------------------------------
-- Purpose:
-- Examine the relationship between category,
-- subcategory, and individual products.
--
-- Sorting by category, subcategory, and product name
-- makes the product hierarchy easier to inspect.

SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY
    1,
    2,
    3;


/*==============================================================================
    3. DATE EXPLORATION
==============================================================================*/

------------------------------------------------------------
-- 3.1 Analyze customer age range
------------------------------------------------------------
-- Purpose:
-- Identify the oldest and youngest customers based on
-- their birth dates and estimate their current ages.
--
-- Business questions:
-- - What is the birth date of the oldest customer?
-- - What is the estimated age of the oldest customer?
-- - What is the birth date of the youngest customer?
-- - What is the estimated age of the youngest customer?

SELECT
    MIN(birthate) AS old_customer,
    DATEDIFF(
        YEAR,
        MIN(birthate),
        GETDATE()
    ) AS age_old_customer,

    MAX(birthate) AS young_customer,
    DATEDIFF(
        YEAR,
        MAX(birthate),
        GETDATE()
    ) AS age_young_customer
FROM gold.dim_customers;


------------------------------------------------------------
-- 3.2 Analyze sales date coverage
------------------------------------------------------------
-- Purpose:
-- Determine the overall time period covered by the sales
-- fact table.
--
-- Business questions:
-- - When was the first recorded order?
-- - When was the most recent order?
-- - How many months of sales history are available?

SELECT
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    DATEDIFF(
        MONTH,
        MIN(order_date),
        MAX(order_date)
    ) AS duration_between_orders
FROM gold.fact_sales;


------------------------------------------------------------
-- 3.3 Analyze order-to-shipment duration
------------------------------------------------------------
-- Purpose:
-- Measure the number of days between order placement
-- and shipment.
--
-- Ordering by the calculated difference allows the analyst
-- to identify the shortest order-to-shipment intervals first.

SELECT
    *,
    DATEDIFF(
        DAY,
        order_date,
        ship_date
    ) AS date_diff
FROM gold.fact_sales
ORDER BY
    date_diff;


------------------------------------------------------------
-- 3.4 Analyze shipment-to-due-date duration
------------------------------------------------------------
-- Purpose:
-- Measure the number of days between shipment and
-- the expected/due date.
--
-- Ordering in descending order highlights the largest
-- intervals first.

SELECT
    *,
    DATEDIFF(
        DAY,
        ship_date,
        due_date
    ) AS date_diff1
FROM gold.fact_sales
ORDER BY
    date_diff1 DESC;




