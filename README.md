
# Northwind Database 
### Aim of the project
This work is about doing an analysis on a free open source database callled Northwind created by microsoft and containing data from a fictional company. And for this project sql queries will be written in Dbeaver and to draw more insight from the data we will also be using excell especially for different graphs. Also a schematic presenting all different tables interconnections are presented in the image below\
![database](https://github.com/JulienAganze/Northwind_database_Project/blob/master/Graphs/Northwind_ERD.png)\
The goal of this project is to test our ability to gather information from a real-world database and use our knowledge of statistical analysis  to generate analytical insights that can be of value to the company.\
The methodology used in this project is to perform exploring some some about data contained in the database and noting our observations. And finally at th end of our study we will be presenting some ways or paths that could be taken to improve company revenues or sales. It is also necessary to note that for each and every insight we will be showing and explaining the sql query used to get it as well as a screenshot from DBeaver ilustrating our findings.

## introduction to data
The data we are going to work with is a database made of 11 tables, and each table is of a specific number of columns containing necessary information
Note that compared to the above picture we have 13 interconnected tables, but here we are not going to describe 2 of them as they appear to be empty.
* **Categories:** Contains all the information related to different product categories being sold by the company. It includes details like Category ID, category name and its description.\
![Categories](https://github.com/JulienAganze/Northwind_database_Project/blob/master/Graphs/Categories.png)
* **Customers:** provides details related to every customer and has information related to his name, regiion address and more.\
![customers](https://github.com/JulienAganze/Northwind_database_Project/blob/master/Graphs/Customers.png)
* **Employees:** contains information for each employee, like name. date of birth, Hiredate, phone number and much more.\
![Employees](https://github.com/JulienAganze/Northwind_database_Project/blob/master/Graphs/Employees.png)
* **EmployeesTerritories:** Just has information about Territories being coverage by employees by linking every employee ID to a territory ID.\
![EmployeesTerritories](https://github.com/JulienAganze/Northwind_database_Project/blob/master/Graphs/EmployeesTerritories.png)
* **Orders Details:** has information related to each specific order, offering details like unit price, quantity as well as discount.\
![Orders Details](https://github.com/JulienAganze/Northwind_database_Project/blob/master/Graphs/Order_details.png)
* **Orders:** Contains information related to shipmen, like shipment date, shipment country, shipment address, country, region , city and many more.\
![Orders](https://github.com/JulienAganze/Northwind_database_Project/blob/master/Graphs/Orders.png)
* **Products:** has information basically related  to properties of different products, like product name, number of ordered units, unit price and much more.\
![Products](https://github.com/JulienAganze/Northwind_database_Project/blob/master/Graphs/Products.png)
* **Regions:**  Just lists all the regions covered by the business.\
![Regions](https://github.com/JulienAganze/Northwind_database_Project/blob/master/Graphs/Regions.png)
* **Shippers:** Just gives of different shipping company by giving company names as well as their phone contact.\
![Shippers](https://github.com/JulienAganze/Northwind_database_Project/blob/master/Graphs/Shippers.png)
* **Suppliers:** provides information related to each specific supplier with details like the supplier name, his address, country and many more.\
![Suppliers](https://github.com/JulienAganze/Northwind_database_Project/blob/master/Graphs/Suppliers.png)
* **Territories:** gives information related to every territory, basically the territory name as well the region it belongs to.\
![Territories](https://github.com/JulienAganze/Northwind_database_Project/blob/master/Graphs/Territories.png)


## General Project Overview
Let us now go straight too the different analysis carried out in our study

### 1) Total Amount of Sales for the Years 2016, 2017 and 2018
    SELECT
    strftime('%Y', o.OrderDate) AS "Year",
    ROUND(SUM(od.UnitPrice * od.Quantity ),2) AS Sales_Amount
    FROM "Order Details" od
    JOIN Orders o ON o.OrderID =od.OrderID
    GROUP BY strftime('%Y', o.OrderDate)  ;
Using the STRFTIME function, all orders were group into years(2016-2018).
Yearly sales was determined  by multiplying the unit price by the total quantity purchased for a particular year.\
![image](https://user-images.githubusercontent.com/120035660/226740645-c0b7ccaf-86f0-4ec7-90b3-7c11c67390ab.png).\
From the above figure we may notice that sales incresed from 2016 to 2017 then slightly decreased in 2018. For now we don't really have an explanation for this

### 2) Top 5 Selling Products by Number
    SELECT od.ProductID ,p.ProductName ,
    SUM(od.Quantity) AS Quantity
    FROM "Order Details" od
    JOIN Products p ON p.ProductID = od.ProductID
    GROUP BY od.ProductID  
    ORDER BY SUM(od.Quantity) DESC
    Limit 5;
All products sold were group using their unique Product ID.\
The sold quantities were obtained by adding the purchased quantities of each product together.\
The result was ordered in a descending order, displaying only the first 5 products.\
![image](https://user-images.githubusercontent.com/120035660/226740543-0b11d49e-8100-46df-9da1-54fa6a6f694a.png)
The top five selling products appear all to be having the number of sold product greater than 1100 products

### 3) Employee Territories
    SELECT  et.EmployeeID ,  e.FirstName ,e.LastName,
    COUNT (et.TerritoryID) AS number_of_territories
    FROM EmployeeTerritories et 
    JOIN Employees e ON e.EmployeeID = et.EmployeeID 
    GROUP BY et.EmployeeID;
To find the number of territories for each employee, unique territory IDs assigned to each employee(ID) was counted.\
From the table below, the territory distribution is not even for  employees.\
![image](https://user-images.githubusercontent.com/120035660/226740341-58268c36-a81e-4d10-8742-d1bf163ae4d6.png)

### 4) Employee Sales Quantity
    SELECT o.EmployeeID, e.FirstName, e.LastName ,
    SUM(od.Quantity) AS number_of_sales
    FROM Orders o 
    JOIN "Order Details" od ON od.OrderID = o.OrderID 
    JOIN Employees e ON e.EmployeeID = o.EmployeeID 
    GROUP BY o.EmployeeID 
    ORDER BY number_of_sales DESC;
his data consist of the sum of all products sold by each employee grouped using the unique employee ID and.
The data is ordered  from highest to lowest using the number of sales.\
From the table below, Margaret, Janet and Nancy appear to be topping the quantity of sales.\
![image](https://user-images.githubusercontent.com/120035660/226740270-495f6cf1-4309-4eca-8088-d307772e0a61.png)


### 5) Employee Sales and Territory Analysis
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
A comparison between the  the number of sales and number of territories for each employee, it can be deduced that;The number of sales per employee is independent of the number of territories assigned.\
![image](https://user-images.githubusercontent.com/120035660/226740099-2d716481-fbf8-4cf4-bcb8-9a44016a3015.png)


### 6) Low Ordering Countries
#### 6a) Top 5 Countries with Least Ordered Items
    SELECT c.Country, SUM(od.Quantity) AS Num_of_Ordered_Items
    FROM "Order Details" od 
    JOIN Orders o ON o.OrderID = od.OrderID 
    JOIN Customers c ON c.CustomerID = o.CustomerID 
    GROUP BY c.Country 
    ORDER BY SUM(od.Quantity) 
    LIMIT 5;
This was obtained by using the SUM function to add all products purchased by a customer and grouped by the customer’s country.
It was then ordered using the number of ordered items in an ascending order with only the top 5 displaying.\
From the table below, Norway,Poland,Argentina,Portugal and Spain appear to be the countries with the least ordered items.
![image](https://user-images.githubusercontent.com/120035660/226739822-a1cd0080-81bf-4151-b7c2-04bf3ea88786.png)


#### 6b) Number of Products per Category
    SELECT c.CategoryName, COUNT(od.ProductID) AS Number_of_Products
    FROM Categories c
    JOIN Products p ON c.CategoryID = p.CategoryID
    JOIN 'Order Details' od ON p.ProductID = od.ProductID
    JOIN Orders o ON od.OrderID = o.OrderID
    WHERE o.ShipCountry IN ('Norway', 'Poland', 'Portugal', 'Argentina', 'Spain')
    GROUP BY c.CategoryName
    ORDER BY Number_of_Products DESC;
This was obtained by using the count function to count all unique product IDs for each of the categories
The result was filtered such that the products were shipped to one of the least 5 countries.\
Categories like beverages, confections and condiments appear to be topping the list here as they have the greatest number of product available under them.\
![image](https://user-images.githubusercontent.com/120035660/226739696-6aa98aa3-b7c8-4dd3-89c2-f013e08d763b.png)


### 7) Top 10 products of every country and their discount status
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
For each country, all products ordered were ranked based on the number of the product ordered.
Products with higher order numbers were ranked the highest while those with lower order numbers ranked lower.
The number of each product ordered at a discount is also added.
The result was filtered to display the top 10 products for each country.\
![image](https://user-images.githubusercontent.com/120035660/226739600-271e09c7-03aa-4089-a12a-218b4a30e13d.png)


### 8) Number of Discounted Products Ordered per Country
    SELECT o.ShipCountry, COUNT(od.Discount > 0) AS Discount_Count
    FROM "Order Details" od 
    JOIN Orders o ON o.OrderID = od.OrderID 
    GROUP BY o.ShipCountry 
    ORDER BY Discount_Count DESC;
For each country, the total number of products ordered under discount is counted using the COUNT function for the condition that discount is greater than zero(0)
The result is ordered in descending order based on the number of products ordered under discount.\
Countries like USA, Germany and Brasil are having the hihest number of discounted products as we can see from the figure below.\
![image](https://user-images.githubusercontent.com/120035660/226739493-600cec85-f70b-4d64-86bd-38332bbdab3b.png)


### 9) Delayed Orders per Country
    SELECT 
    ShipCountry as Country,
    SUM(CASE WHEN julianday(RequiredDate) - julianday(ShippedDate) < 0 THEN 1 ELSE 0 END) as Delayed_Orders,
    SUM(CASE WHEN julianday(RequiredDate) - julianday(ShippedDate) >= 0 THEN 1 ELSE 0 END) as On_Time_Orders
    FROM Orders
    GROUP BY Country
    ORDER BY Delayed_Orders DESC;
Using the CASE and JULIANDAY functions, the difference between the shipped date and required date was determined in days.
All orders with a difference as greater or equal to one were designated as on time orders while those with negative differences were designated as delayed orders. \
For each country, both delayed orders and on time orders were counted and the result ordered in a descending order based on the number of delayed orders .
From the table, only Poland and Norway, from the 5 countries with the least ordered items had either all or almost all their orders delayed.\
![image](https://user-images.githubusercontent.com/120035660/226739314-62bddf34-b0df-4679-bb4b-66703d97d4c6.png)

### 10) Proposals to Improve Sales
#### 10a) Territorial Expansion
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
In the Southern region with region ID 4, only 4 of the 8 territories were found to be assigned to employees. \
The unassigned regions produced no sales, meaning the services of the company does not  reach there.\
To increase sales, it is recommended that the company extends its services to these 4 territories to take advantage of the market there.\
![image](https://user-images.githubusercontent.com/120035660/226739122-3c733cd0-8efe-490f-8430-9a3a86de0c4c.png)


#### 10b) Re-Introduction of Discontinued Products
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
The company since inception has sold a total of 77 products, out of which 8 have been discontinued.\
6 out of the 8 products have pretty decent  demand based on the total quantity sold, with the 6th product occupying the 40th position out of 77 products.\
It is recommended that; these six products be reintroduced into the market to improve sales for the company\
![image](https://user-images.githubusercontent.com/120035660/226738843-7ed17a8a-8a0e-4fc1-8c7f-90dc0cfa9ea6.png)

#### 10c) Targeted Advertisement
    SELECT c.ContactTitle  ,SUM(i.UnitPrice*i.Quantity) AS Revenue_Made
    from Invoices i 
    JOIN Customers c ON i.CustomerID = c.CustomerID 
    GROUP BY c.ContactTitle 
    ORDER BY Revenue_Made DESC ;
Analyzing the revenue made, it can be realized that revenue made is higher when our contact person in a buyer company holds a specific title or position, while other positions produce lower revenue for the company.\
It is recommended that the company’s marketing and advertisement campaigns be primarily directed towards individuals who hold positions corresponding to high revenue as per the data\
![image](https://user-images.githubusercontent.com/120035660/226738448-6b84d950-705b-45a3-aa6b-597f8c54382e.png)

### Conclusion and recommendations
From the aove made observations in order to improve revenues or sales it is recommended that
* the company extends its services to these 4 discovered territories where the company is not yet present to take advantage of the market there\
* as according to the data, the company's marketing and advertising initiatives are predominantly targeted at people who occupy jobs that are associated with significant revenue. \
* the discovered six product that are discontinued should be reintroduced as from the made analysis they are clearly presenting a good demand base

