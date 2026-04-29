use superstore_sales;

-- View the table
-- Customers table
SELECT *
FROM customers;

-- Orders table
SELECT *
FROM orders;


-- Products table
SELECT *
FROM products;

-- Fact table
SELECT *
FROM order_details;

-- Total revenue
SELECT sum(Sales) AS revenue, 
        avg(Sales) as avg_sales
FROM order_details;

-- Order year
SELECT YEAR(Order_Date) AS Year
FROM orders 
GROUP BY Year;

-- Order Month
  SELECT MONTH(Order_Date) AS Month, 
         monthname(Order_Date) AS Month_name
FROM orders
GROUP BY Month, Month_name
ORDER BY Month ASC;

-- Order Day of week
  SELECT dayofweek(Order_Date) AS Day_of_weeek, 
            dayname(Order_Date) As Day_name
FROM orders
GROUP BY Day_of_weeek, Day_name
ORDER BY Day_of_weeek ASC;

-- Which products category, sub-category highest unit_sold.
SELECT p.Category, p.Sub_Category,
       COUNT(o.Quantity) AS Total_unitsold
FROM products p 
   INNER JOIN order_details o
   ON p.Product_ID = o.Product_ID
   GROUP BY p.Category, p.Sub_Category
   ORDER BY  Total_unitsold desc;
   
-- -- Which products  sub-category highest profit.
SELECT p.Sub_Category,
	   ROUND(SUM(o.Profit), 2) AS Total_profit
FROM products p 
   INNER JOIN order_details o
   ON p.Product_ID = o.Product_ID
   GROUP BY p.Sub_Category
   ORDER BY  Total_profit desc;
   
-- Which cities has most products orders. 
SELECT  c.City,
       COUNT(o.Order_ID) AS Total_orders
FROM customers c
  JOIN orders o 
 ON c.Customer_ID = o.Customer_ID 
 GROUP BY c.City
 ORDER BY Total_orders DESC 
 LIMIT 10;
 
-- Average sales by category
SELECT p.Category, p.Sub_Category, 
       ROUND(AVG(od.sales), 2) AS avg_sales
FROM products p
  INNER JOIN order_details od
   ON p.Product_ID = od.Product_ID
   GROUP BY p.Category, p.Sub_Category
   ORDER BY avg_sales DESC;

-- Total revenue by category.
SELECT p.Category, ROUND(SUM(od.Sales), 2) AS Total_revenue
FROM products  p
INNER JOIN  order_details od
ON p.Product_ID = od.Product_ID
GROUP BY p.Category
ORDER BY Total_revenue DESC;

-- 