use superstore_sales;

-- View the tables
SELECT *
FROM customers;

SELECT *
FROM orders;

SELECT *
FROM products;

SELECT *
FROM order_details;

-- QUESTION 1 : Total Sales and Profit by Customer Segment.

SELECT c.Segment, 
       COUNT(DISTINCT o.Order_ID) AS Total_Orders,
       SUM(od.Sales) AS Total_Sales,
       SUM(od.Profit) AS Total_Profit,
       ROUND(SUM(od.Profit) / SUM(od.Sales) * 100, 2) AS Profit_margin
FROM customers c
    INNER JOIN orders o ON c.Customer_ID = o.Customer_ID
    INNER JOIN order_details od ON o.Order_ID = od.Order_ID
GROUP BY c.Segment
ORDER BY Total_Sales DESC;

--  QUESTION 2 : Revenue by Region with subquery.

SELECT c.Region,
      SUM(od.Sales) AS Region_Sales
FROM customers c
INNER JOIN orders o ON c.Customer_ID = o.Customer_ID
INNER JOIN order_details od On o.Order_ID = od.Order_ID
GROUP BY  c.Region
HAVING SUM(od.Sales) > (
     SELECT AVG(region_sales)
     FROM ( SELECT c2.Region,
           SUM(od2.Sales) AS region_sales
         FROM customers c2
		 INNER JOIN orders o2 ON c2.Customer_ID = o2.Customer_ID
		  INNER JOIN order_details od2 On o2.Order_ID = od2.Order_ID
		 GROUP BY  c2.Region
        ) subquery
	)
    ORDER BY Region_Sales DESC;
    
    --   QUESTION 3 : Top 10 Customers by Revenue. (CWith CTE, group by)

 WITH customer_revenue AS (
	 SELECT c.Customer_ID, c.Customer_Name, c.Segment,
           COUNT(DISTINCT o.Order_ID) AS Order_count,
           SUM(od.Sales) AS Total_Revenue,
		   SUM(od.Profit) AS Total_Profit
       FROM customers c 
     INNER JOIN orders o ON c.Customer_ID = o.Customer_ID
     INNER JOIN order_details od On o.Order_ID = od.Order_ID
     GROUP BY  c.Customer_ID, c.Customer_Name, c.Segment
)
SELECT 
   ROW_NUMBER() OVER (ORDER BY  Total_Revenue DESC) AS Order_no,
   Customer_name,
   Segment,
   Order_count,
   ROUND(Total_Revenue , 2) AS Total_revenue,
   ROUND(Total_Profit, 2) AS Total_profit
FROM customer_revenue 
LIMIT  10 ;
    
--  QUESTION 4 : Sales by category and Profit (Group by and CASE statement).
-- Show sales breakdown by category and whether items were profitable or loss-making.

SELECT p.Category,
       CASE 
           WHEN od.Profit > 0 THEN 'Profitable'
           WHEN od.Profit < 0 THEN 'Loss'
           ELSE 'Break Even'
           END AS Profit_Status,
           COUNT(*) AS Item_Count,
           SUM(od.Sales) AS Total_Sales,
           SUM(od.Profit) AS Total_profit,
           ROUND(AVG(od.Profit_Margin),2) AS Avg_profit_margin
FROM order_details od
INNER JOIN products p 
ON od.Product_ID = p.Product_ID
GROUP BY p.Category, Profit_Status
ORDER BY p.Category, Profit_Status DESC;

-- QUESTION 5: Customer Purchase Patterns by Region (CTE +JOIN)
-- Show average order value and frequency for each region.

   WITH regional_stats AS (
               SELECT c.Region, c.Segment, o.Order_ID, 
			        ROUND(SUM(od.Sales),2) AS Order_value
               FROM customers c
                   INNER JOIN orders o ON c.Customer_ID = o.Customer_ID 
                   INNER JOIN order_details od ON o.Order_ID = od.Order_ID
                   GROUP BY c.Region, c.Segment, o.Order_ID
	 )
        SELECT Region, Segment,
              COUNT(*) AS total_orders,
              ROUND(AVG(Order_value),2) AS avg_order_value,
              ROUND(MAX(Order_value),2) AS max_order_value,
              ROUND(MIN(Order_value),2) AS min_order_value
        FROM regional_stats
        GROUP BY Region, Segment
        ORDER BY Region, total_orders DESC;
        
-- QUESTION 6 : Monthly Sales Trend with CTE 
-- Calculate monthly sales trend showing month-over-month growth using CTE

 WITH monthly_sales AS (SELECT  monthname(o.Order_Date) AS Month,
      SUM(od.Sales) AS monthly_sales,
      SUM(od.Profit) AS monthly_profit,
      COUNT(DISTINCT o.Order_ID ) AS order_count
FROM orders o
    INNER JOIN order_details od ON o.Order_ID = od.Order_ID
    GROUP BY monthname(o.Order_Date)
)    
   SELECT Month,  monthly_sales, monthly_profit,
                 order_count
    FROM  monthly_sales
    ORDER BY Month DESC
    LIMIT 10;
    
    -- QUESTION 7: Products Not Sold (LEFT JOIN + Subquery)
-- Find products that have never been sold using a LEFT JOIN.
SELECT p.Product_ID, p.Product_Name , p.Category, 
       p.Sub_Category
FROM products p
  LEFT JOIN  order_details od ON p.Product_ID = od.Product_ID
WHERE od.Product_ID IS NULL
ORDER BY p.Product_Name;

-- QUESTION 8: Shipping Mode Analysis (GROUP BY + JOIN)

SELECT o.Ship_Mode, 
       COUNT(DISTINCT o.Order_ID) AS Total_orders,
       COUNT(*) AS total_items,
	   SUM(od.Sales) AS total_sales,
       ROUND(AVG(od.Sales), 2) AS Avg_sales_per_item,
       SUM(od.Profit) AS Total_profit,
       ROUND(AVG(o.Days_to_Ship),2) AS avg_Days_to_Ship
FROM orders o 
   INNER JOIN order_details od ON o.Order_ID = od.Order_ID
GROUP BY o.Ship_Mode
ORDER BY total_sales DESC;