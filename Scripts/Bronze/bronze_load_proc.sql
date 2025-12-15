/*
*************************************************************************************************************************************
Creates a Stored Procedure labeled, bronze.load_bronze, which inserts data to the tables: bronze.cust, bronze.ct_typ_add,
bronze.prod, bronze.pr_cat, bronze.ord, bronze.ord_mode and bronze.sales
*************************************************************************************************************************************
DESCRIPTION:
	The following script inserts data into the tables: bronze.cust, bronze.ct_typ_add, bronze.prod, bronze.pr_cat, bronze.ord, 
	bronze.ord_mode and bronze.sales from the csv files: customers, ct_typ_add, products, pr_cat, orders, ord_mode and sales,
	respectively.

NOTE:
	If any of the tables are populated, the respective table's data will be dropped.
	Make sure there are backups before proceeding with the script.

Stored Procedure Name: bronze.load_bronze
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		PRINT '**********************************************************************';
		PRINT 'LOADING BRONZE LAYER';
		PRINT '**********************************************************************';

		SET @batch_start_time = GETDATE();

		PRINT '**********************************************************************';
		PRINT 'LOADING bronze.cust';
		PRINT '**********************************************************************';

		SET @start_time = GETDATE();

		-- Empties the table bronze.cust
		PRINT '>> TRUNCATING Table: bronze.cust';
		TRUNCATE TABLE SuperStoreDataWarehouse.bronze.cust;

		-- Bulk Insert into the table bronze.cust from the customers csv
		PRINT '>> BULK INSERTING data into bronze.cust';
		BULK INSERT SuperStoreDataWarehouse.bronze.cust
		FROM '..\customers.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';



		PRINT '**********************************************************************';
		PRINT 'LOADING bronze.ct_typ_add';
		PRINT '**********************************************************************';

		SET @start_time = GETDATE();

		-- Empties the table bronze.ct_typ_add
		PRINT '>> TRUNCATING Table: bronze.ct_typ_add';
		TRUNCATE TABLE SuperStoreDataWarehouse.bronze.ct_typ_add;

		-- Bulk Insert into the table bronze.ct_typ_add from the ct_typ_add csv
		PRINT '>> BULK INSERTING data into bronze.ct_typ_add';
		BULK INSERT SuperStoreDataWarehouse.bronze.ct_typ_add
		FROM '..\ct_typ_add.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';



		PRINT '**********************************************************************';
		PRINT 'LOADING bronze.prod';
		PRINT '**********************************************************************';

		SET @start_time = GETDATE();

		-- Empties the table bronze.prod
		PRINT '>> TRUNCATING Table: bronze.prod';
		TRUNCATE TABLE SuperStoreDataWarehouse.bronze.prod

		-- Bulk Insert into the table bronze.prod from the products csv
		PRINT '>> BULK INSERTING data into bronze.prod';
		BULK INSERT SuperStoreDataWarehouse.bronze.prod
		FROM '..\products.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';
		


		PRINT '**********************************************************************';
		PRINT 'LOADING bronze.pr_cat';
		PRINT '**********************************************************************';

		SET @start_time = GETDATE();

		-- Empties the table bronze.pr_cat
		PRINT '>> TRUNCATING Table: bronze.pr_cat';
		TRUNCATE TABLE SuperStoreDataWarehouse.bronze.pr_cat

		-- Bulk Insert into the table bronze.pr_cat from the pr_cat csv
		PRINT '>> BULK INSERTING data into bronze.pr_cat';
		BULK INSERT SuperStoreDataWarehouse.bronze.pr_cat
		FROM '..\pr_cat.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';



		PRINT '**********************************************************************';
		PRINT 'LOADING bronze.ord';
		PRINT '**********************************************************************';

		SET @start_time = GETDATE();

		PRINT '>> TRUNCATING Table: bronze.ord';
		-- Empties the table bronze.ord
		TRUNCATE TABLE SuperStoreDataWarehouse.bronze.ord;

		-- Bulk Insert into the table bronze.ord from the orders csv
		PRINT '>> BULK INSERTING data into bronze.ord';
		BULK INSERT SuperStoreDataWarehouse.bronze.ord
		FROM '..\orders.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';


		PRINT '**********************************************************************';
		PRINT 'LOADING bronze.ord_mode';
		PRINT '**********************************************************************';

		SET @start_time = GETDATE();

		PRINT '>> TRUNCATING Table: bronze.ord_mode';
		-- Empties the table bronze.ord
		TRUNCATE TABLE SuperStoreDataWarehouse.bronze.ord_mode;

		-- Bulk Insert into the table bronze.ord_mode from the ord_mode csv
		PRINT '>> BULK INSERTING data into bronze.ord_mode';
		BULK INSERT SuperStoreDataWarehouse.bronze.ord_mode
		FROM '..\ord_mode.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';



		PRINT '**********************************************************************';
		PRINT 'LOADING bronze.sales';
		PRINT '**********************************************************************';
		
		-- Empties the table bronze.sales
		PRINT '>> TRUNCATING Table: bronze.sales';
		TRUNCATE TABLE SuperStoreDataWarehouse.bronze.sales;

		-- Bulk Insert into the table bronze.sales from the sales csv
		PRINT '>> BULK INSERTING data into bronze.sales';
		BULK INSERT SuperStoreDataWarehouse.bronze.sales
		FROM '..\sales.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		
		SET @end_time = GETDATE();

		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';

		SET @batch_end_time = GETDATE();
		PRINT '**********************************************************************';
		PRINT 'LOADING Bronze Layer COMPLETED';
		PRINT '		TOTAL DURATION: ' + CAST (DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';
	END TRY

	BEGIN CATCH
		PRINT '**********************************************************************';
		PRINT 'ERROR occurred in the Bronze Layer';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE(); 
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);
	END CATCH
END
