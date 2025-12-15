/*
******************************************************************
Creates Views in the Gold Layer
******************************************************************
DESCRIPTION:
	The following represents the Gold Layer modeled by the
	Star Schema in a data warehouse. It builds on top of clean
	data from the Silver Layer for business-ready analytics
	and reporting.
	
*/

-- REMOVES gold.dim_customers if it exists
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW gold.dim_customers;
GO

-- CREATES the view for customers dimension in the Gold Layer
CREATE VIEW gold.dim_customers AS
	SELECT
		-- Primary Key
		cu.cust_id			AS customer_key,

		-- Columns in silver.cust
		cu.cust_fname		first_name,
		cu.cust_lname		last_name,

		-- Columns in silver.ct_typ_add
		ct.segment,
		ct.country,
		ct.city,
		ct.state,
		ct.zipcode,
		ct.region,

		cu.cust_crt_date	create_date
	FROM silver.cust cu
		LEFT JOIN silver.ct_typ_add ct
			ON cu.cust_id = ct.CID
GO

-- REMOVES gold.dim_products if it exists
IF OBJECT_ID('gold.dim_products','V') IS NOT NULL
	DROP VIEW gold.dim_products
GO

-- CREATES the view for products dimension in the Gold Layer
CREATE VIEW gold.dim_products AS
	SELECT
		-- Generates Primary key
		ROW_NUMBER() OVER (ORDER BY p.prod_id) AS product_key,

		p.prod_id				product_id,
	
		-- Column in silver.prod
		p.prod_name				product_name,

		-- Columns in silver.pr_cat
		pr.category,
		pr.subcategory,

		p.prod_crt_date			create_date

	FROM silver.prod p
		LEFT JOIN silver.pr_cat pr
			ON p.prod_id = pr.PID
GO

-- REMOVES gold.dim_orders if it exists
IF OBJECT_ID('gold.dim_orders', 'V') IS NOT NULL
	DROP VIEW gold.dim_orders
GO

-- CREATES the view for orders dimension in the Gold Layer
CREATE VIEW gold.dim_orders AS
	SELECT
		-- Generates Primary Key
		ROW_NUMBER() OVER (ORDER BY ord.ord_id) AS order_key,

		-- Columns in silver.ord
		ord.ord_id				order_id,
		ord.cust_id				customer_id,
		ord.ord_date			order_date,
		ord.ord_shipdate		order_ship_date,

		-- Columns in silver.ord_mode
		ordm.shipmode			ship_mode

	FROM silver.ord ord
		LEFT JOIN silver.ord_mode ordm
			ON ord.ord_id = ordm.OID
GO

-- REMOVES gold.fact_sales if it exists
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales
GO

-- CREATES the view for sales fact in the Gold Layer
CREATE VIEW gold.fact_sales AS
	SELECT
		-- Foreign Keys
		ord.order_key					AS  order_key,
		prd.product_key					AS  product_key,

		-- Measures
		sls.sales_revenue				AS revenue, 
		sls.sales_price					AS price,
		sls.sales_quantity				AS quantity,
		sls.sales_discount				AS discount,
		sls.sales_cost					AS cost,
		sls.sales_profit				AS profit

	FROM silver.sales sls
		LEFT JOIN gold.dim_orders ord
			ON sls.ord_id = ord.order_id
		LEFT JOIN gold.dim_products prd
			ON sls.prod_id = prd.product_id
GO
