# SuperStore Data Warehouse Project

## **OVERVIEW**
The project involves the creation of a data warehouse for business-ready analytics and reporting.
It follows the industry practice of constructing from raw data in the CRM and ERP using the 
Medallion Architecture (Bronze, Silver, and Gold). Within each layer, ETL pipelines are created
and the data model follows the star schema with fact and dimension tables.


## **Bronze Layer**
- **Source:** CRM and ERP Excel datasets
- **Object Type:** Tables 
- **Load:**
DDL scripts outlined the batch processing of raw data from the Excel data sets into MS SQL Server.
A full load was done, including potentially erroneous data. Each table was truncated first and
then a bulk insert was conducted.
- **Data Transformations:** None


## **Silver Layer**
- **Source:** Bronze Layer
- **Object Type:** Tables
- **Load:**
A full load was done, cleaning erroneous data from the Bronze Layer. Each table was truncated
first and then a standard insert was conducted.
- **Data Transformations:**
DDL scripts outlined data transformations from the bronze layer by data cleaning, data
standardization, data normalization, deriving columns, and enriching data.


## **Gold Layer**
- **Source:** Silver Layer
- **Object Type:** Views
- **Load:** None
- **Data Transformations:**
Referenced data in the Silver Layer to create views that represented the star schema
with sales as a fact and orders, customers, and products as dimensions.
