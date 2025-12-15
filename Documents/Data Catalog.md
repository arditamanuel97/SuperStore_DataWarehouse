
# DATA CATALOG

## OBJECTIVE
The following presents a data catalog for the Gold Layer, containing business-ready **analytics and reporting**.
It follows the star schema with **fact:** sales and **dimensions:** orders, customers, and products

### 1. **gold.dim_orders**
- **DESCRIPTION:** Contains order details such as date, ship date and ship mode
- **COLUMNS:**

| Column Name     | Data Type     | Description                                                                                       |
| order_key       | INT           | Primary Key                                                                                       |
| order_id        | NVARCHAR(100) | Unique identifier for each order                                                                  |
| customer_id     | NVARCHAR(100) | Unique identifier for the customer who made the order                                             |
| order_date      | DATE          | Date representing when the order was created                                                      |
| order_ship_date | DATE          | Date representing when the order was shipped                                                      |
| ship_mode       | NVARCHAR(100) | Description of how the order was shipped: First Class, Second Class, Same Day, and Standard Class |

### 2. **gold.dim_customers**
- **DESCRIPTION:** Stores customer information such as name, segment of customer, and address
- **COLUMNS:**

| Column Name     | Data Type     | Description                                                                     |
| customer_key    | NVARCHAR(100) | Primary Key                                                                     |
| first_name      | NVARCHAR(250) | A customer's first name                                                         |
| last_name       | NVARCHAR(250) | A customer's last name                                                          |    
| segment         | NVARCHAR(100) | A customer belongs in one of the segments: Corporate, Home Office, Consumer     |
| country         | NVARCHAR(100) | A customer's country                                                            |
| city            | NVARCHAR(100) | A customer's city                                                               |
| state           | NVARCHAR(100) | A customer's state                                                              |
| zipcode         | NVARCHAR(100) | A customer's zipcode                                                            |
| region          | NVARCHAR(100) | A customer belongs in one of the regions: Central, East, South, West            |
| create_date     | NVARCHAR(100) | Date when the customer information was inputted                                 |

### 3. **gold.dim_products**
- **DESCRIPTION:** Describes product information such as name, category, and subcategory
- **COLUMNS:**

| Column Name  | Data Type     | Description                                                                                            |
| product_key  | INT           | Primary Key                                                                                            |
| product_id   | NVARCHAR(100) | Unique identifier for each product                                                                     |
| product_name | NVARCHAR(MAX) | A product's name                                                                                       |
| category     | NVARCHAR(100) | A product belongs to one of the categories: Office Supplies, Furniture, Technology                     |
| subcategory  | NVARCHAR(100) | A product belongs to one of the subcategories: Supplies, Storage, Phones, Fasteners, Copiers, <br>     |
                                 Chairs, Bookcases, Machines, Art, Envelopes, Binders, Labels, Furnishings, Accessories,<br>            |
                                 Appliances, Paper, Tables                                                                              |
| create_date  | DATE          | Date when the product information was inputted                                                         |

### 4. **gold.fact_sales**
- **DESCRIPTION:** Documents each sale's information such as revenue, price, quantity, discount, cost, and profit. Utilized for analytics and reporting.
- **COLUMNS:**

| Column Name | Data Type     | Description                                     |
| order_key   | INT           | Foreign Key of Orders                           |
| product_key | INT           | Foreign Key of Products                         |
| revenue     | DECIMAL(18,2) | The total amount of money that the sale sold    |
| price       | DECIMAL(18,2) | The amount of money for each item               |
| quantity    | INT           | The number of items sold                        |
| discount    | DECIMAL(18,2) | The percentage taken out of the revenue         |
| cost        | DECIMAL(18,2) | The amount of costs needed to conduct the sale  |
| profit      | DECIMAL(18,2) | The difference of revenue - cost                |