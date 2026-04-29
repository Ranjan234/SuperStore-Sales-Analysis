use superstore_sales;

-- View tables
-- Customers table
SELECT *
FROM customers;

SELECT  COUNT(Customer_ID)
FROM customers;

-- Orders Table
SELECT *
FROM orders;

SELECT  DISTINCT COUNT(Order_ID)
FROM orders;

-- Product Table
SELECT *
FROM products;

SELECT  DISTINCT COUNT(Product_ID)
FROM products;

-- Orders_details Table
SELECT *
FROM order_details;

SELECT  DISTINCT COUNT(Order_ID)
FROM order_details;



