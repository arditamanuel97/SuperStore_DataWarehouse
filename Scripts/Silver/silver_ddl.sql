/*
******************************************************************************************************************************
Creates the tables: silver.cust, silver.ct_typ_add, silver.prod, silver.pr_cat, silver.ord, silver.ord_mode, and silver.sales
******************************************************************************************************************************
DESCRIPTION:
	The following script creates the silver.cust, silver.ct_typ_add, silver.prod, silver.pr_cat, silver.ord, silver.ord_mode,
	and silver.sales table based on the customers, ct_type_add, products, pr_cat, orders, ord_mode and sales csv files.

NOTE:
	If any of the tables already exists, it will be deleted. Make sure there are backups before proceeding with the script.
*/

-- Drops table if silver.cust already exists
IF OBJECT_ID('silver.cust','U') IS NOT NULL
	DROP TABLE silver.cust;
GO

-- Creates table silver.cust
CREATE TABLE silver.cust (
	cust_id				NVARCHAR(100),
	cust_fname			NVARCHAR(250),
	cust_lname			NVARCHAR(250),
	cust_crt_date		DATE
);
GO



-- DELETES table if silver.ct_typ_add already exists
IF OBJECT_ID('silver.ct_typ_add','U') IS NOT NULL
	DROP TABLE silver.ct_typ_add;
GO

-- CREATES table silver.ct_typ_add
CREATE TABLE silver.ct_typ_add (
		CID			NVARCHAR(100),
		segment		NVARCHAR(100),
		country		NVARCHAR(100),
		city		NVARCHAR(100),
		state		NVARCHAR(100),
		zipcode		NVARCHAR(100),
		region		NVARCHAR(100),
		date		DATE
);



-- DELETES table if silver.prod already exists
IF OBJECT_ID('silver.prod', 'U') IS NOT NULL
	DROP TABLE silver.prod;
GO

-- CREATES table silver.prod
CREATE TABLE silver.prod (
	prod_id				NVARCHAR(100),
	prod_name			NVARCHAR(MAX),
	prod_crt_date		DATE
);
GO



-- DELETES table if silver.pr_cat already exists
IF OBJECT_ID('silver.pr_cat', 'U') IS NOT NULL
	DROP TABLE silver.pr_cat;
GO

-- CREATES table silver.pr_cat
CREATE TABLE silver.pr_cat (
	PID					NVARCHAR(100),
	category			NVARCHAR(100),
	subcategory			NVARCHAR(100),
	date				DATE
);
GO



-- DELETES table if silver.ord already exists
IF OBJECT_ID('silver.ord','U') IS NOT NULL
	DROP TABLE silver.ord;
GO

-- CREATES table silver.ord
CREATE TABLE silver.ord (
	ord_id					NVARCHAR(100),
	cust_id					NVARCHAR(100),
	ord_date				DATE,
	ord_shipdate			DATE,
);



-- DELETES table if silver.ord_mode already exists
IF OBJECT_ID('silver.ord_mode','U') IS NOT NULL
	DROP TABLE silver.ord_mode;
GO

-- CREATES table silver.ord_mode
CREATE TABLE silver.ord_mode (
	OID					NVARCHAR(100),
	shipmode			NVARCHAR(100),
	date				DATE,
);



-- DELETES table if silver.sales already exists
IF OBJECT_ID('silver.sales', 'U') IS NOT NULL
	DROP TABLE silver.sales;
GO

-- Creates table silver.sales
CREATE TABLE silver.sales (
	ord_id					NVARCHAR(100),
	prod_id					NVARCHAR(100),
	sales_revenue			DECIMAL(18, 2),
	sales_price				DECIMAL(18, 2),
	sales_quantity			INT,
	sales_discount			DECIMAL(18, 2),
	sales_cost				DECIMAL(18, 2),
	sales_profit			DECIMAL(18, 2),
	sales_crt_date			DATE
);
GO