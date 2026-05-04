select * from Superstore_2023

-- Total Sales & Profit  -- 
SELECT 
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM Superstore_2023;

-- Sales by Category
SELECT category, SUM(sales) AS total_sales
FROM Superstore_2023
GROUP BY category
ORDER BY total_sales DESC;

-- Top 10 Products by Sales
SELECT TOP 10 
    product_name,
    SUM(sales) AS total_sales
FROM Superstore_2023
GROUP BY product_name
ORDER BY total_sales DESC;


-- Profit by Region
SELECT region, SUM(profit) AS total_profit
FROM Superstore_2023
GROUP BY region;

-- Loss-making Products
SELECT product_name, SUM(profit) AS total_profit
FROM Superstore_2023
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit;

--LEVEL 2 — Intermediate (GROUP BY + Aggregation)
--Total sales by region
--Total profit by category
--Total quantity sold by sub-category
--Average discount by segment
--Top 5 customers by sales
--City with highest sales
--State-wise total profit
--Region-wise number of orders
--Category-wise average profit
--Find loss-making orders (profit < 0)
select * from Superstore_2023
select region, count(sales) from Superstore_2023 group by Region
select Category, count(Profit) from Superstore_2023 group by Category
select Sub_Category, count(Sales) from Superstore_2023 group by Sub_Category
select Category, avg(Discount) from Superstore_2023 group by Category
SELECT TOP 5 * FROM Superstore_2023 ORDER BY Sales DESC
Select top 100* from Superstore_2023 where Profit < 0 


--Rank category by sales
SELECT *
FROM (
    SELECT Category,
           Product_Name,
           SUM(Sales) AS total_sales,
           RANK() OVER (PARTITION BY Category ORDER BY SUM(Sales) DESC) AS rnk
    FROM Superstore_2023
    GROUP BY Category, Product_Name
) t
WHERE rnk = 1;

--Rank Region by sales

SELECT *
FROM (
    SELECT Region,
           Product_Name,
           SUM(Sales) AS total_sales,
           ROW_NUMBER() OVER (PARTITION BY Region ORDER BY SUM(Sales) DESC) AS rn
    FROM Superstore_2023
    GROUP BY Region, Product_Name
) t
WHERE rn < 2;

--5. Top 2 customers per region
select *
from (select customer_name, region, sum(sales) as cust_invest,
ROW_NUMBER() over (partition by region order by sum(sales) desc) as rn 
from Superstore_2023
group by customer_name, Region ) t
where rn <= 2

--6. Most profitable products per sub-category
select *
from(select Product_name, sub_category, sum(profit) as profitable,
ROW_NUMBER() over(partition by sub_category order by sum(profit) desc) as rn
from Superstore_2023 group by Product_Name, Sub_Category) t
where rn <5

--7. Highest profit order per state
select * from (select state, category, sum(profit) as pro, ROW_NUMBER() over(partition by category order by sum(profit) desc) as rn
from Superstore_2023 group by state, category) t
where rn =1

-- case function
--Profit > 200 → 'High Profit'--50–200 → 'Medium Profit'--< 50 → 'Low Profit'
select *,
case
    when profit > 201 then 'High Profit'
    when profit between 200 and 500 then 'Medium Profit'
    else 'no profit'
    end as p_V
from Superstore_2023

--Count how many orders are:  *Profitable  *Loss
SELECT 
    COUNT(CASE WHEN profit > 0 THEN 1 END) AS profitable_orders,
    COUNT(CASE WHEN profit <= 0 THEN 1 END) AS loss_orders
FROM Superstore_2023;

Calculate:

--Total profit--Total loss separately

SELECT 
    SUM(CASE WHEN profit > 0 THEN profit ELSE 0 END) AS total_profit,
    SUM(CASE WHEN profit < 0 THEN profit ELSE 0 END) AS total_loss
FROM Superstore_2023;

--Discount Category (Real Business Use)
--Categorize discount:
--0 → No Discount
--0–0.2 → Low
--0.2 → High

SELECT 
    discount,
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.2 THEN 'Low Discount'
        ELSE 'High Discount'
    END AS discount_category
FROM Superstore_2023;

--Find total sales by discount category
SELECT 
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.2 THEN 'Low Discount'
        ELSE 'High Discount'
    END AS discount_category,
    SUM(sales) AS total_sales
FROM Superstore_2023
GROUP BY 
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.2 THEN 'Low Discount'
        ELSE 'High Discount'
    END;

--Show high profit products first
SELECT 
    product_name,
    profit
FROM Superstore_2023
ORDER BY 
    CASE 
        WHEN profit > 500 THEN 1
        WHEN profit > 100 THEN 2
        ELSE 3
    END;

