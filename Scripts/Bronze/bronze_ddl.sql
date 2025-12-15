/*
******************************************************************************************************************************
Creates the tables: bronze.cust, bronze.ct_typ_add, bronze.prod, bronze.pr_cat, bronze.ord, bronze.ord_mode, and bronze.sales
******************************************************************************************************************************
DESCRIPTION:
	The following script creates the bronze.cust, bronze.ct_typ_add, bronze.prod, bronze.pr_cat, bronze.ord, bronze.ord_mode,
	and bronze.sales table based on the customers, ct_type_add, products, pr_cat, orders, ord_mode and sales csv files.

NOTE:
	If any of the tables already exists, it will be deleted. Make sure there are backups before proceeding with the script.
*/



-- Drops table if bronze.cust already exists
IF OBJECT_ID('bronze.cust','U') IS NOT NULL
	DROP TABLE bronze.cust;
GO

-- Creates table bronze.cust
CREATE TABLE bronze.cust (
	cust_id				NVARCHAR(100),
	cust_fname			NVARCHAR(250),
	cust_lname			NVARCHAR(250),
	cust_crt_date		DATE
);
GO



-- DELETES table if bronze.ct_typ_add already exists
IF OBJECT_ID('bronze.ct_typ_add','U') IS NOT NULL
	DROP TABLE bronze.ct_typ_add;
GO

-- CREATES table bronze.ct_typ_add
CREATE TABLE bronze.ct_typ_add (
		CID			NVARCHAR(100),
		segment		NVARCHAR(100),
		country		NVARCHAR(100),
		city		NVARCHAR(100),
		state		NVARCHAR(100),
		zipcode		NVARCHAR(100),
		region		NVARCHAR(100),
		date		DATE
);



-- DELETES table if bronze.prod already exists
IF OBJECT_ID('bronze.prod', 'U') IS NOT NULL
	DROP TABLE bronze.prod;
GO

-- CREATES table bronze.prod
CREATE TABLE bronze.prod (
	prod_id				NVARCHAR(100),
	prod_name			NVARCHAR(MAX),
	prod_crt_date		DATE
);
GO



-- DELETES table if bronze.pr_cat already exists
IF OBJECT_ID('bronze.pr_cat', 'U') IS NOT NULL
	DROP TABLE bronze.pr_cat;
GO

-- CREATES table bronze.pr_cat
CREATE TABLE bronze.pr_cat (
	PID					NVARCHAR(100),
	category			NVARCHAR(100),
	subcategory			NVARCHAR(100),
	date				DATE
);
GO



-- DELETES table if bronze.ord already exists
IF OBJECT_ID('bronze.ord','U') IS NOT NULL
	DROP TABLE bronze.ord;
GO

-- CREATES table bronze.ord
CREATE TABLE bronze.ord (
	ord_id					NVARCHAR(100),
	cust_id					NVARCHAR(100),
	ord_date				DATE,
	ord_shipdate			DATE,
);



-- DELETES table if bronze.ord_mode already exists
IF OBJECT_ID('bronze.ord_mode','U') IS NOT NULL
	DROP TABLE bronze.ord_mode;
GO

-- CREATES table bronze.ord_mode
CREATE TABLE bronze.ord_mode (
	OID					NVARCHAR(100),
	shipmode			NVARCHAR(100),
	date				DATE,
);



-- DELETES table if bronze.sales already exists
IF OBJECT_ID('bronze.sales', 'U') IS NOT NULL
	DROP TABLE bronze.sales;
GO

-- Creates table bronze.sales
CREATE TABLE bronze.sales (
	ord_id				NVARCHAR(100),
	prod_id					NVARCHAR(100),
	sales_revenue			DECIMAL(18, 2),
	sales_quantity			INT,
	sales_discount			DECIMAL(18, 2),
	sales_profit			DECIMAL(18, 2),
	sales_crt_date			DATE
);
GO

	