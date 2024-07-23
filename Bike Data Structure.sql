USE Bike;
GO

-- Drop tables if they already exist
IF OBJECT_ID('dbo.stores_', 'U') IS NOT NULL
   DROP TABLE dbo.stores_;
IF OBJECT_ID('dbo.stocks_', 'U') IS NOT NULL
   DROP TABLE dbo.stocks_;
IF OBJECT_ID('dbo.staffs', 'U') IS NOT NULL
   DROP TABLE dbo.staffs;
IF OBJECT_ID('dbo.products', 'U') IS NOT NULL
   DROP TABLE dbo.products;
IF OBJECT_ID('dbo.orders', 'U') IS NOT NULL
   DROP TABLE dbo.orders;
IF OBJECT_ID('dbo.stores_', 'U') IS NOT NULL
   DROP TABLE dbo.stores_;
IF OBJECT_ID('dbo.stocks_', 'U') IS NOT NULL
   DROP TABLE dbo.stocks_;
IF OBJECT_ID('dbo.customers', 'U') IS NOT NULL
   DROP TABLE dbo.customers;
IF OBJECT_ID('dbo.categories', 'U') IS NOT NULL
   DROP TABLE dbo.categories;
IF OBJECT_ID('dbo.order_items', 'U') IS NOT NULL
   DROP TABLE dbo.order_items;
-- Create the stores table
CREATE TABLE dbo.stores_ (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    store_location VARCHAR(100)
);

-- Bulk insert into stores table
BEGIN TRY
    BULK INSERT dbo.stores_
    FROM 'C:\Users\avia1\Downloads\Bike Data\stores.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );
    PRINT 'Data inserted into dbo.stores_ table successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error inserting data into dbo.stores_ table:';
    PRINT ERROR_MESSAGE();
END CATCH;

-- Create the stocks table
CREATE TABLE dbo.stocks_ (
    stock_id INT PRIMARY KEY,
    store_id INT,
    product_id INT,
    quantity INT
);

-- Bulk insert into stocks table
BEGIN TRY
    BULK INSERT dbo.stocks_
    FROM 'C:\Users\avia1\Downloads\Bike Data\stocks.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );
    PRINT 'Data inserted into dbo.stocks_ table successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error inserting data into dbo.stocks_ table:';
    PRINT ERROR_MESSAGE();
END CATCH;

CREATE TABLE dbo.products (
	product_id INT PRIMARY KEY,
	product_name VARCHAR (100),
	brand_id INT,
	category_id INT,
	model_year INT,
	list_price FLOAT


    -- Add more columns as per your CSV file structure
);
BEGIN TRY
    BULK INSERT dbo.products
    FROM 'C:\Users\avia1\Downloads\Bike Data\products.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );
    PRINT 'Data inserted into dbo.products table successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error inserting data into dbo.products table:';
    PRINT ERROR_MESSAGE();
END CATCH;

CREATE TABLE dbo.staffs (
    staff_id INT PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	email VARCHAR(100),
	phone VARCHAR (100),
	active INT,
	store_id INT,
	manager_id INT

    -- Add more columns as per your CSV file structure
);
BEGIN TRY
    BULK INSERT dbo.staffs
    FROM 'C:\Users\avia1\Downloads\Bike Data\staffs.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );
    PRINT 'Data inserted into dbo.staffs table successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error inserting data into dbo.staffs table:';
    PRINT ERROR_MESSAGE();
END CATCH;

CREATE TABLE dbo.orders_staging (
    order_id INT,
    customer_id INT,
    order_status VARCHAR(100),
    order_date FLOAT,  -- Changed to FLOAT to accommodate Excel serial dates or similar formats
    required_date FLOAT,
    shipped_date FLOAT,
    store_id INT,
    staff_id INT
);

BULK INSERT dbo.orders_staging
FROM 'C:\Users\avia1\Downloads\Bike Data\orders.csv'
WITH (
    FIELDTERMINATOR = ',',  -- Adjust if your delimiter differs
    ROWTERMINATOR = '\n',   -- Adjust if your line endings differ
    FIRSTROW = 2            -- Adjust if your CSV contains a header row
);
CREATE TABLE dbo.orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_status VARCHAR(100),
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    store_id INT,
    staff_id INT
);

INSERT INTO dbo.orders (order_id, customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id)
SELECT
    order_id,
    customer_id,
    order_status,
    DATEADD(DAY, order_date - 2, '1899-12-31'),  -- Conversion formula
    DATEADD(DAY, required_date - 2, '1899-12-31'),
    DATEADD(DAY, shipped_date - 2, '1899-12-31'),
    store_id,
    staff_id
FROM dbo.orders_staging;








DROP TABLE dbo.orders_staging;
GO


-- Create the stores table
CREATE TABLE dbo.order_items (
    order_item_id INT PRIMARY KEY,
	order_id INT,
	item_id INT,
	product_id INT,
	quantity INT,
	list_price FLOAT,
	discount FLOAT

);

-- Bulk insert into stores table
BEGIN TRY
    BULK INSERT dbo.order_items
    FROM 'C:\Users\avia1\Downloads\Bike Data\order_items.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );
    PRINT 'Data inserted into dbo.order_items table successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error inserting data into dbo.order_items table:';
    PRINT ERROR_MESSAGE();
END CATCH;

-- Create the stores table
CREATE TABLE dbo.customers (
    customer_id INT PRIMARY KEY,
	first_name VARCHAR (100),
	last_name VARCHAR(100),
	phone VARCHAR (100),
	email VARCHAR(100),
	street VARCHAR(100),
	city VARCHAR(100),
	state VARCHAR (10),
	zip_code VARCHAR (100)


);

-- Bulk insert into stores table
BEGIN TRY
    BULK INSERT dbo.customers
    FROM 'C:\Users\avia1\Downloads\Bike Data\customers.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );
    PRINT 'Data inserted into dbo.customers table successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error inserting data into dbo.customers table:';
    PRINT ERROR_MESSAGE();
END CATCH;

-- Create the stores table
CREATE TABLE dbo.categories (
    category_id INT PRIMARY KEY,
	category_name VARCHAR (100)
);

-- Bulk insert into stores table
BEGIN TRY
    BULK INSERT dbo.categories
    FROM 'C:\Users\avia1\Downloads\Bike Data\categories.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );
    PRINT 'Data inserted into dbo.categories table successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error inserting data into dbo.categories table:';
    PRINT ERROR_MESSAGE();
END CATCH;

-- Create the stores table
CREATE TABLE dbo.brands (
    brand_id INT PRIMARY KEY,
	brand_name VARCHAR (100)
);

-- Bulk insert into stores table
BEGIN TRY
    BULK INSERT dbo.brands
    FROM 'C:\Users\avia1\Downloads\Bike Data\brands.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );
    PRINT 'Data inserted into dbo.brands table successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error inserting data into dbo.brands table:';
    PRINT ERROR_MESSAGE();
END CATCH;

--FOREIGN keys
ALTER TABLE dbo.orders
ADD CONSTRAINT FK_orders_customers
FOREIGN KEY (customer_id) REFERENCES dbo.customers(customer_id);
GO

ALTER TABLE dbo.orders
ADD CONSTRAINT FK_orders_stores
FOREIGN KEY (store_id) REFERENCES dbo.stores(store_id);
GO

ALTER TABLE dbo.orders
ADD CONSTRAINT FK_orders_staffs
FOREIGN KEY (staff_id) REFERENCES dbo.staffs(staff_id);
GO



ALTER TABLE dbo.stocks
ADD CONSTRAINT FK_stocks_stores
FOREIGN KEY (store_id) REFERENCES dbo.stores(store_id);
GO

-- Add foreign key from stocks to products
ALTER TABLE dbo.stocks_
ADD CONSTRAINT FK_stocks__products
FOREIGN KEY (product_id) REFERENCES dbo.products(product_id);
GO

ALTER TABLE dbo.products
ADD CONSTRAINT FK_products_categories
FOREIGN KEY (category_id) REFERENCES dbo.categories(category_id);
GO

ALTER TABLE dbo.products
ADD CONSTRAINT FK_products_brands
FOREIGN KEY (brand_id) REFERENCES dbo.brands(brand_id);
GO

ALTER TABLE dbo.staffs
ADD CONSTRAINT FK_staffs_stores
FOREIGN KEY (store_id) REFERENCES dbo.stores(store_id);
GO

ALTER TABLE dbo.order_items
ADD CONSTRAINT FK_order_items_orders
FOREIGN KEY (order_id) REFERENCES dbo.orders(order_id);
GO

ALTER TABLE dbo.order_items
DROP CONSTRAINT FK_order_items_orders;
GO





