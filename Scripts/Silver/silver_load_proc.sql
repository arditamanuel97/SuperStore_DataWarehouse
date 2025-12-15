/*
*************************************************************************************************************************************
Creates a Stored Procedure labeled, silver.load_silver, which inserts data to the tables: silver.cust, silver.ct_typ_add,
silver.prod, silver.pr_cat, silver.ord, silver.ord_mode and silver.sales
*************************************************************************************************************************************
DESCRIPTION:
	The following script cleans and transforms data from the tables in the bronze layer:
        bronze.cust, bronze.ct_typ_add, bronze.prod, bronze.pr_cat, bronze.ord, bronze.ord_mode and bronze.sales

    into the tables in the silver layer:
        silver.cust, silver.ct_typ_add, silver.prod, silver.pr_cat, silver.ord, silver.ord_mode and silver.sales, respectively.

NOTE:
	If any of the tables are populated, the respective table's data will be dropped.
	Make sure there are backups before proceeding with the script.

Stored Procedure Name: silver.load_silver
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        PRINT '**********************************************************************';
		PRINT 'LOADING SILVER LAYER';
		PRINT '**********************************************************************';

        SET @batch_start_time = GETDATE();

        PRINT '**********************************************************************';
		PRINT 'LOADING silver.cust';
		PRINT '**********************************************************************';

        SET @start_time = GETDATE();

        -- Empties the table silver.cust
		PRINT '>> TRUNCATING Table: silver.cust';
		TRUNCATE TABLE SuperStoreDataWarehouse.silver.cust;

        -- DATA CLEANING operations in the table silver.cust
        INSERT INTO silver.cust (
            cust_id, cust_fname, cust_lname, cust_crt_date
        )
        SELECT
            -- ENSURES that the first two letters of cust_id corresponds to capitalized first and last name initials
            -- REMOVES trailing spaces
            CASE WHEN SUBSTRING(TRIM(cust_id), 1, 2) != UPPER(CONCAT(SUBSTRING(TRIM(cust_fname), 1,1), SUBSTRING(TRIM(cust_lname), 1,1)))
                      THEN UPPER(CONCAT(SUBSTRING(TRIM(cust_fname), 1, 1), SUBSTRING(TRIM(cust_lname), 1, 1), SUBSTRING(TRIM(cust_id), 3, LEN(cust_id) - 2)))
                 ELSE cust_id
            END cust_id,    
    
            -- CAPITALIZES the first letter of cust_fname and REMOVES trailing spaces
            CONCAT(UPPER(SUBSTRING(TRIM(cust_fname), 1, 1)), SUBSTRING(TRIM(cust_fname), 2, LEN(cust_fname) - 1)) as cust_fname,
    
            -- CAPITALIZES the first letter of cust_lname and REMOVES trailing spaces
            CONCAT(UPPER(SUBSTRING(TRIM(cust_lname), 1, 1)), SUBSTRING(TRIM(cust_lname), 2, LEN(cust_lname) - 1)) as cust_lname, cust_crt_date
        FROM
            -- For every cust_id, RANKS entries by the most recent cust_crt_date
            (SELECT *, ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY cust_crt_date DESC) as most_recent
            FROM bronze.cust) t
            WHERE
                -- REMOVES duplicates and CHOOSES the most recent entry
                most_recent = 1 AND                 

                -- REMOVES NULLs
                cust_id IS NOT NULL AND             
                cust_fname IS NOT NULL AND 
                cust_lname IS NOT NULL AND

                -- REMOVES BLANKs
                cust_id != '' AND
                cust_fname != '' AND
                cust_lname != ''

        SET @end_time = GETDATE();

		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';



        PRINT '**********************************************************************';
		PRINT 'LOADING silver.ct_typ_add';
		PRINT '**********************************************************************';

		SET @start_time = GETDATE();

		-- Empties the table silver.ct_typ_add
		PRINT '>> TRUNCATING Table: silver.ct_typ_add';
		TRUNCATE TABLE SuperStoreDataWarehouse.silver.ct_typ_add;

        -- DATA CLEANING operations in the table silver.ct_typ_add 
        INSERT INTO silver.ct_typ_add (
            CID, segment, country, city, state, zipcode, region, date
        )
        SELECT
            -- ADDs '-' between the first 2 letters and the following numbers. REMOVES trailing spaces
            CONCAT(SUBSTRING(TRIM(CID), 1, 2), '-', SUBSTRING(TRIM(CID), 3, LEN(TRIM(CID)) - 2)) as CID,                                                          
    
            -- Data Standardization by expanding abbreviations in segment
            CASE WHEN UPPER(TRIM(segment)) = 'CORP' THEN 'Corporate'                  
                 WHEN UPPER(TRIM(segment)) = 'HOME' THEN 'Home Office'
                 WHEN UPPER(TRIM(segment)) = 'CONS' THEN 'Consumer'
                 ELSE 'Other'
            END segment,
    
            -- Ensures data consistency in country
            CASE WHEN UPPER(TRIM(country)) = 'US' THEN 'United States'                 
                 WHEN UPPER(TRIM(country)) = 'USA' THEN 'United States'
                 WHEN UPPER(TRIM(country)) = 'AMERICA' THEN 'United States'
                 ELSE TRIM(country)
            END country,

            TRIM(city) as city,
    
            -- Maintains data consistency in state
            CASE WHEN TRIM(state) = 'AZ' THEN 'Arizona'                               
                 WHEN TRIM(state) = 'FL' THEN 'Florida'
                 WHEN TRIM(state) = 'NY' THEN 'New York'
                 WHEN TRIM(state) = 'MD' THEN 'Maryland'
                 ELSE TRIM(state)
            END state,
    
            -- Ensures data consistency in zipcode. Permits only five-digit zipcodes.
            CASE WHEN LEN(TRIM(zipcode)) = 5 THEN TRIM(zipcode)                        
                 ELSE 'N/A'
            END zipcode,
    
            -- Data Standardization by expanding abbreviations in region
            CASE WHEN TRIM(region) = 'C' THEN 'Central'                 
                 WHEN TRIM(region) = 'S' THEN 'South'
                 WHEN TRIM(region) = 'E' THEN 'East'
                 WHEN TRIM(region) = 'W' THEN 'West'
                 ELSE 'N/A'
            END region, date
        FROM
            -- For every CID, RANKS entries by the most recent date
            (SELECT *, ROW_NUMBER() OVER (PARTITION BY CID ORDER BY date DESC) as most_recent
            FROM bronze.ct_typ_add) t
            WHERE
                -- REMOVES duplicates and CHOOSES the most recent entry
                most_recent = 1 AND

                -- REMOVES NULLs
                CID IS NOT NULL AND
                segment IS NOT NULL AND
                country IS NOT NULL AND

                -- REMOVES BLANKs
                CID != '' AND
                country != '';

        SET @end_time = GETDATE();

		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';



        PRINT '**********************************************************************';
		PRINT 'LOADING silver.prod';
		PRINT '**********************************************************************';

		SET @start_time = GETDATE();

		-- Empties the table silver.prod
		PRINT '>> TRUNCATING Table: silver.prod';
		TRUNCATE TABLE SuperStoreDataWarehouse.silver.prod

        /* Data Cleaning operations in the table silver.prod */
        INSERT INTO silver.prod(
            prod_id, prod_name, prod_crt_date
        )
        SELECT 
            -- REMOVES trailing spaces
            TRIM(prod_id) as prod_id, TRIM(prod_name) as prod_name, prod_crt_date
        FROM
            -- For every prod_id, RANKS entries by the most recent prod_crt_date
            (SELECT *, ROW_NUMBER() OVER (PARTITION BY prod_id ORDER BY prod_crt_date DESC) as most_recent
            FROM bronze.prod) t
            WHERE
                -- REMOVES duplicates and CHOOSES the most recent entry
                most_recent = 1 AND

                -- REMOVES NULLs
                prod_id IS NOT NULL AND

                -- REMOVES BLANKs
                prod_id != '';

        SET @end_time = GETDATE();

		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';



        PRINT '**********************************************************************';
		PRINT 'LOADING silver.pr_cat';
		PRINT '**********************************************************************';

		SET @start_time = GETDATE();

		-- Empties the table silver.pr_cat
		PRINT '>> TRUNCATING Table: silver.pr_cat';
		TRUNCATE TABLE SuperStoreDataWarehouse.silver.pr_cat

        /* DATA CLEANING operations in table silver.pr_cat */
        INSERT INTO silver.pr_cat(
            PID, category, subcategory, date
        )
        SELECT 
            -- ADDs '-' between category and subcategory as well as subcategory and subsequent numbers. REMOVES trailing spaces
            CONCAT(SUBSTRING(TRIM(PID), 1, 3), '-', SUBSTRING(TRIM(PID), 5, 2), '-', SUBSTRING(TRIM(PID),7, LEN(PID))) as PID,

            TRIM(category) as category,
    
            -- Maintains data consistency in subcategory. NULLs or BLANKs are labeled as 'N/A'
            CASE WHEN subcategory IS NULL OR subcategory = '' THEN 'N/A'
                 ELSE TRIM(subcategory)
            END subcategory,
    
            date
        FROM
            -- For every PID, RANKS entries by the most recent date
            (SELECT *, ROW_NUMBER() OVER (PARTITION BY PID ORDER BY date DESC) as most_recent
            FROM bronze.pr_cat) t
            WHERE
                -- REMOVES duplicates and CHOOSES the most recent entry
                most_recent = 1 AND
        
                -- REMOVES NULLs
                PID IS NOT NULL AND
                category IS NOT NULL AND
        
                -- REMOVES BLANKs
                PID != '' AND
                category != '';

        SET @end_time = GETDATE();

		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';



        PRINT '**********************************************************************';
		PRINT 'LOADING silver.ord';
		PRINT '**********************************************************************';

		SET @start_time = GETDATE();

		PRINT '>> TRUNCATING Table: silver.ord';
		-- Empties the table silver.ord
		TRUNCATE TABLE SuperStoreDataWarehouse.silver.ord;

        /* DATA CLEANING operations in table silver.ord */
        INSERT INTO silver.ord(
            ord_id, cust_id, ord_date, ord_shipdate
        )
        SELECT
            -- REMOVES trailing spaces
            TRIM(ord_id) as ord_id, TRIM(cust_id) as cust_id,

            -- KEEPS data consistency in ord_date. ord_date is either before or the same day as ord_shipdate
            CASE WHEN ord_date <= ord_shipdate THEN ord_date
                 ELSE ord_shipdate
            END ord_date,
    
            -- ENSURES data consistency in ord_shipdate. ord_shipdate is either after or the same day as ord_date
            CASE WHEN ord_date <= ord_shipdate THEN ord_shipdate
                 ELSE ord_date
            END ord_shipdate
        FROM
            -- For every ord_id, RANKS entries by most recent ord_date
            (SELECT *, ROW_NUMBER() OVER (PARTITION BY ord_id ORDER BY ord_date DESC) as most_recent
            FROM bronze.ord) t
            WHERE
                -- REMOVES duplicates and CHOOSES the most recent entry
                most_recent = 1 AND
        
                -- REMOVES NULLs AND
                ord_id IS NOT NULL AND
        
                -- REMOVES BLANKs
                ord_id != '';

        SET @end_time = GETDATE();

		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';



        PRINT '**********************************************************************';
		PRINT 'LOADING silver.ord_mode';
		PRINT '**********************************************************************';

		SET @start_time = GETDATE();

		PRINT '>> TRUNCATING Table: silver.ord_mode';
		-- Empties the table silver.ord
		TRUNCATE TABLE SuperStoreDataWarehouse.silver.ord_mode;

        /* DATA CLEANING operations in table silver.ord_mode */
        INSERT INTO silver.ord_mode(
            OID, shipmode, date
        )
        SELECT
            -- REMOVES trailing spaces
            TRIM(OID) as OID,

            -- ENSURES Data Standardization in shipmode. shipmode must either be
            -- First Class, Second Class, Same Day, or Standard Class
            CASE WHEN shipmode = 'FC' THEN 'First Class'
                 WHEN shipmode = 'SC' THEN 'Second Class'
                 WHEN shipmode = '1 Day' THEN 'Same Day'
                 WHEN shipmode = 'Standard' THEN 'Standard Class'
            END as shipmode,
    
            date
        FROM
            -- For every OID, RANKS the entries by the most recent date
            (SELECT *, ROW_NUMBER() OVER (PARTITION BY OID ORDER BY date DESC) as most_recent
            FROM bronze.ord_mode) t
            WHERE
                -- REMOVES duplicates and CHOOSES the most recent entry
                most_recent = 1 AND
        
                -- REMOVES NULLs
                OID IS NOT NULL;

        SET @end_time = GETDATE();

		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';



        PRINT '**********************************************************************';
		PRINT 'LOADING silver.sales';
		PRINT '**********************************************************************';
		
		-- Empties the table silver.sales
		PRINT '>> TRUNCATING Table: silver.sales';
		TRUNCATE TABLE SuperStoreDataWarehouse.silver.sales;

        /* DATA CLEANING operations in table silver.sales */
        INSERT INTO silver.sales(
            ord_id, prod_id, sales_revenue, sales_price, sales_quantity, sales_discount, sales_cost, sales_profit,
            sales_crt_date
        )
        SELECT
            -- REMOVES trailing spaces
            TRIM(ord_id) as ord_id, TRIM(prod_id) as prod_id,

            sales_revenue,
    
            -- CREATES new column for price of each item
            sales_revenue / sales_quantity as sales_price,
    
            sales_quantity,

            -- DATA STANDARDIZATION by converting NULLs to 0
            CASE WHEN sales_discount IS NULL THEN 0
                 ELSE sales_discount
            END sales_discount,

            -- CREATES new column for total cost of each sale
            ABS(sales_revenue - sales_profit) as sales_cost,
    
            sales_profit, sales_crt_date
        FROM
            -- For every combo of ord_id and prod_id, RANKS entries by the most recent sales_crt_date
            (SELECT *, ROW_NUMBER() OVER (PARTITION BY ord_id, prod_id ORDER BY sales_crt_date) as most_recent
            FROM bronze.sales) t
            WHERE
                -- REMOVES duplicates and CHOOSES the most recent entry
                most_recent = 1 AND

                -- REMOVES sales_revenue that are either NULL or a non-positive number
                sales_revenue IS NOT NULL AND
                sales_revenue > 0 AND

                -- REMOVES sales_quantity that are either NULL or a non-positive number
                sales_quantity IS NOT NULL AND
                sales_quantity > 0 AND

                -- REMOVES sales_discount that are negative or above 1 (100%)
                (sales_discount >= 0 AND sales_discount <= 1) AND

                -- REMOVES sales_profit that are NULL 
                sales_profit IS NOT NULL

        SET @end_time = GETDATE();

		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';

        SET @batch_end_time = GETDATE();
		PRINT '**********************************************************************';
		PRINT 'LOADING Silver Layer COMPLETED';
		PRINT '		TOTAL DURATION: ' + CAST (DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '**********************************************************************';
	END TRY

    BEGIN CATCH
		PRINT '**********************************************************************';
		PRINT 'ERROR occurred in the Silver Layer';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE(); 
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);
	END CATCH
END