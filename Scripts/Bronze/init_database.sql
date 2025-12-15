/*
************************************************************************************
Creates the SuperStoreDataWarehouse and Schemas: Bronze, Silver, Gold
************************************************************************************
DESCRIPTION:
	The following script creates a database called SuperStoreDataWarehouse.
	Firstly, any database named SuperStoreDataWarehouse will be dropped and
	recreated. Secondly, the script will create the following schemas: Bronze,
	Silver, and Gold, resembling the data warehouse layers.

NOTE:
	If SuperStoreDataWarehouse already exists, it will be dropped. Make sure
	there are backups prior to running the script.
*/

USE master;
GO

-- If the SuperStoreDataWarehouse EXISTS, it will be dropped and recreated
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'SuperStoreDataWarehouse')
BEGIN
	ALTER DATABASE SuperStoreDataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE SuperStoreDataWarehouse;
END;
GO

-- Creates the SuperStoreDataWarehouse
CREATE DATABASE SuperStoreDataWarehouse;
GO

USE SuperStoreDataWarehouse;
GO

-- Creates the Bronze, Silver, and Gold Layer Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO