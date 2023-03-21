						--ANALYSIS SUMMARY--
-- 1) Getting the Top 5 selling products
SELECT od.ProductID ,p.ProductName ,
SUM(od.Quantity) AS Quantity
FROM "Order Details" od
JOIN Products p ON p.ProductID = od.ProductID
GROUP BY od.ProductID  
ORDER BY SUM(od.Quantity) DESC
Limit 5;

-- 2) Looking at the total amount of sales the company made for the 3 years: 2016,2017 and 2018,
		-- as well as checking whether sales did rise or fall.
SELECT
strftime('%Y', o.OrderDate) AS "Year",
ROUND(SUM(od.UnitPrice * od.Quantity ),2) AS Sales_Amount
FROM "Order Details" od
JOIN Orders o ON o.OrderID =od.OrderID
GROUP BY strftime('%Y', o.OrderDate)  ;

-- 3) Looking at the number of territories for each employee.
SELECT  et.EmployeeID ,  e.FirstName ,e.LastName,
COUNT (et.TerritoryID) AS number_of_territories
FROM EmployeeTerritories et 
JOIN Employees e ON e.EmployeeID = et.EmployeeID 
GROUP BY et.EmployeeID;

-- 4) Employees performance based on sales quantity.
SELECT o.EmployeeID, e.FirstName, e.LastName ,
SUM(od.Quantity) AS number_of_sales
FROM Orders o 
JOIN "Order Details" od ON od.OrderID = o.OrderID 
JOIN Employees e ON e.EmployeeID = o.EmployeeID 
GROUP BY o.EmployeeID 
ORDER BY number_of_sales DESC;

-- 4) Jouned solution
WITH total_sales AS(
SELECT o.EmployeeID ,
SUM(od.Quantity) AS total_quantity
FROM "Order Details" od 
JOIN Orders o ON o.OrderID =od.OrderID
GROUP BY o.EmployeeID)
SELECT o.EmployeeID ,e.FirstName ,
ts.total_quantity AS quantity_sold,
COUNT(DISTINCT et.TerritoryID) AS Number_of_territories 
FROM "Order Details" od 
JOIN Orders o ON o.OrderID =od.OrderID
JOIN Employees e ON e.EmployeeID =o.EmployeeID 
JOIN EmployeeTerritories et ON et.EmployeeID  =e.EmployeeID 
JOIN Territories t ON t.TerritoryID =et.TerritoryID 
JOIN total_sales ts on ts.EmployeeID = o.EmployeeID 
GROUP BY o.EmployeeID
ORDER BY ts.total_quantity DESC;

-- 5)  Top 5 countries with the least number of ordered items
SELECT c.Country, SUM(od.Quantity) AS Num_of_Ordered_Items
FROM "Order Details" od 
JOIN Orders o ON o.OrderID = od.OrderID 
JOIN Customers c ON c.CustomerID = o.CustomerID 
GROUP BY c.Country 
ORDER BY SUM(od.Quantity) 
LIMIT 5;

-- 6) Most Prevalent Categories in the Top 5 countries with the least number of ordered items
SELECT c.CategoryName, COUNT(od.ProductID) AS Number_of_Products
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
JOIN 'Order Details' od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE o.ShipCountry IN ('Norway', 'Poland', 'Portugal', 'Argentina', 'Spain')
GROUP BY c.CategoryName
ORDER BY Number_of_Products DESC;

--7a) Top 10-15 products of every country and their discount status
SELECT * 
FROM (
SELECT c.Country, p.ProductName AS Product,SUM(od.Quantity) As OrdNo,
RANK() OVER (PARTITION BY Country ORDER BY SUM(od.Quantity) DESC) AS Ranking,
SUM (CASE WHEN od.Discount > 0 THEN 1 END) as Discount_Count
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN 'Order Details' od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.Country, p.ProductName
)
WHERE Ranking <= 10 ;

--7b) Countries and the number of discounted products ordered from there
SELECT o.ShipCountry, COUNT(od.Discount > 0) AS Discount_Count
FROM "Order Details" od 
JOIN Orders o ON o.OrderID = od.OrderID 
GROUP BY o.ShipCountry 
ORDER BY Discount_Count DESC;

--8) Countries and their number of delayed orders
SELECT 
ShipCountry as Country,
SUM(CASE WHEN julianday(RequiredDate) - julianday(ShippedDate) < 0 THEN 1 ELSE 0 END) as Delayed_Orders,
SUM(CASE WHEN julianday(RequiredDate) - julianday(ShippedDate) >= 0 THEN 1 ELSE 0 END) as On_Time_Orders
FROM Orders
GROUP BY Country
ORDER BY Delayed_Orders DESC;

--9) Propsals to improve Sales
	--1. Territorial Expansion
SELECT t.TerritoryDescription AS Territory_Name, SUM(od.Quantity) AS Product_Sales
FROM Regions r 
LEFT JOIN Territories t ON t.RegionID = r.RegionID 
LEFT JOIN EmployeeTerritories et ON et.TerritoryID = t.TerritoryID 
LEFT JOIN Employees e ON e.EmployeeID = et.EmployeeID 
LEFT JOIN Orders o ON o.EmployeeID = e.EmployeeID 
LEFT JOIN "Order Details" od ON od.OrderID = o.OrderID 
WHERE r.RegionID = 4 
GROUP BY t.TerritoryID 
ORDER BY Product_Sales DESC
	--2. Re-Introduction of Discontinued Products
SELECT p.ProductName AS Discontinued_Products, sum(od.Quantity)AS Quantity_Sold
FROM Products p
JOIN "Order Details" od ON od.ProductID = p.ProductID 
WHERE p.Discontinued = 1 
GROUP BY Discontinued_Products
ORDER BY Quantity_Sold DESC

SELECT p.ProductName AS All_Products, sum(od.Quantity)AS Quantity_Sold
FROM Products p
JOIN "Order Details" od ON od.ProductID = p.ProductID 
GROUP BY All_Products
ORDER BY Quantity_Sold DESC
	--3. Targeted Advertisement
SELECT c.ContactTitle  ,SUM(i.UnitPrice*i.Quantity) AS Revenue_Made
from Invoices i 
JOIN Customers c ON i.CustomerID = c.CustomerID 
GROUP BY c.ContactTitle 
ORDER BY Revenue_Made DESC ;









