USE AdventureWorks2019

-- 1. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the
-- following.
--  Country                        Province
SELECT c.Name as Country, s.Name as State
FROM Person.CountryRegion c
JOIN Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode


-- 2. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada.
-- Join them and produce a result set similar to the following.
--  Country                        Province
SELECT c.Name as Country, s.Name as State
FROM Person.CountryRegion c
JOIN Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name In ('Germany', 'Canada')
ORDER BY c.Name

GO

USE Northwind

-- 3. List all Products that has been sold at least once in last 25 years.
SELECT DISTINCT p.ProductName
FROM dbo.Products p
JOIN dbo.[Order Details] o
ON o.ProductID = p.ProductID
JOIN dbo.Orders o1
ON o1.OrderID = o.OrderID
WHERE DATEDIFF(YEAR, o1.OrderDate, GETDATE()) <= 25


-- 4. List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 o.ShipPostalCode AS [Zip Code], SUM(o1.Quantity) AS Quantity
FROM dbo.Orders o
LEFT JOIN dbo.[Order Details] o1
ON o.OrderID = o1.OrderID
GROUP BY o.ShipPostalCode
ORDER BY Quantity DESC


-- 5. List all city names and number of customers in that city.     
SELECT City AS City, count(CustomerID) as [Number of Customers]
FROM dbo.Customers
GROUP BY City
ORDER BY [Number of Customers] DESC


-- 6. List city names which have more than 2 customers, and number of customers in that city
SELECT City AS City, count(CustomerID) as [Number of Customers]
FROM dbo.Customers
GROUP BY City
HAVING count(CustomerID) > 2
ORDER BY [Number of Customers] DESC



-- 7. Display the names of all customers  along with the count of products they bought
SELECT c.ContactName, SUM(o1.Quantity) AS Quantity
FROM dbo.Customers c JOIN Orders o ON o.CustomerID = c.CustomerID
JOIN [Order Details] o1 ON o1.OrderID = o.OrderID
GROUP BY c.ContactName
ORDER BY Quantity DESC



-- 8. Display the customer ids who bought more than 100 Products with count of products.
SELECT c.ContactName, SUM(o1.Quantity) AS Quantity
FROM dbo.Customers c JOIN Orders o ON o.CustomerID = c.CustomerID
JOIN [Order Details] o1 ON o1.OrderID = o.OrderID
GROUP BY c.ContactName
HAVING SUM(o1.Quantity) > 100
ORDER BY Quantity DESC


-- 9. List all of the possible ways that suppliers can ship their products. Display the results as below
-- Supplier Company Name                Shipping Company Name
SELECT DISTINCT s1.CompanyName AS [Supplier Company Name], s2.CompanyName AS [Shipping Company Name]
FROM dbo.Suppliers s1 LEFT JOIN dbo.Products p ON s1.SupplierID = p.SupplierID 
JOIN [Order Details] o1 on o1.ProductID = p.ProductID
JOIN Orders o ON o.OrderID = o1.OrderID
RIGHT JOIN Shippers s2 ON s2.ShipperID = o.ShipVia
ORDER BY [Supplier Company Name]


-- 10. Display the products order each day. Show Order date and Product Name.
SELECT o.OrderDate as [Order Date], p.ProductName AS [Product Name]
FROM Orders o
JOIN [Order Details] o1 ON o.OrderID = o1.OrderID
JOIN Products p ON p.ProductID = o1.ProductID
ORDER BY [Order Date] DESC


-- 11. Displays pairs of employees who have the same job title.
SELECT DISTINCT e1.LastName + ' ' + e1.LastName AS Employee, 
e2.LastName + ' ' + e2.LastName AS [Employee with same title]
FROM dbo.Employees e1 JOIN dbo.Employees e2
ON e1.EmployeeID != e2.EmployeeID 
WHERE e1.Title = e2.Title
ORDER BY Employee



-- 12. Display all the Managers who have more than 2 employees reporting to them.
WITH empHierachyCte
AS
(
    SELECT EmployeeID, FirstName, LastName, ReportsTo, 1 lvl
    FROM Employees
    WHERE ReportsTo is null
    UNION ALL
    SELECT e.EmployeeID, e.FirstName, e.LastName, e.ReportsTo, cte.lvl + 1
    FROM Employees e INNER JOIN empHierachyCte cte ON e.ReportsTo = cte.EmployeeId
)
SELECT * FROM empHierachyCte
WHERE lvl > 2


-- 13. Display the customers and suppliers by city. The results should have the following columns
-- City-- Name-- Contact Name-- Type (Customer or Supplier)
SELECT City, ContactName, 'Supplier' Type
FROM Suppliers
Union
SELECT City, ContactName, 'Customer' Type
FROM Customers
ORDER BY City


-- All scenarios are based on Database NORTHWIND.

-- 14. List all cities that have both Employees and Customers.
SELECT DISTINCT City FROM Employees
WHERE City In (Select City FROM Customers)



-- 15. List all cities that have Customers but no Employee.

-- a.--  Use -- sub-query
SELECT DISTINCT City FROM Customers
WHERE City NOT IN (Select City FROM Employees)

-- b. --  Do-- not use sub-query
SELECT c.City, COUNT(e.EmployeeID) AS [Employee Count], COUNT(c.CustomerID) AS [Customer Count]
FROM Customers c
LEFT JOIN Employees e ON e.City = c.City
GROUP BY c.City
HAVING COUNT(e.EmployeeID) = 0 AND COUNT(c.CustomerID) > 0


-- 16. List all products and their total order quantities throughout all orders.
SELECT p.ProductName, SUM(o.Quantity) AS [Total Order Quantities]
FROM Products p join [Order Details] o on p.ProductID = o.ProductID
GROUP BY p.ProductName
ORDER BY [Total Order Quantities] DESC


-- 17. List all Customer Cities that have at least two customers.
-- a. --  Use -- union
select city, COUNT(CustomerID) AS [Cutomer Num]
FROM Customers 
where City not in
(
Select City
FROM Customers
GROUP BY CITY
HAVING COUNT(CustomerID) = 0
UNION
Select City
FROM Customers
GROUP BY CITY
HAVING COUNT(CustomerID) = 1
)
group by city
order by COUNT(CustomerID) DESC

-- b. --  Use-- no union
SELECT City, COUNT(CustomerID) AS [Cutomer Num]
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >= 2
ORDER BY [Cutomer Num] DESC


-- 18. List all Customer Cities that have ordered at least two different kinds of products.
SELECT DISTINCT c.City, COUNT(o1.ProductID) AS [Product Kinds]
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] o1 ON o.OrderID = o1.OrderID
GROUP BY c.City
HAVING COUNT(o1.ProductID) >= 2
ORDER BY [Product Kinds] DESC
 


-- 19. List 5 most popular products, their average price, and the customer city that ordered most quantity of it
SELECT TOP 5 dt.ProductName, dt.ProductID, dt.UnitPrice, dt.City, SUM(o.Quantity) AS [Total Quantity]--, ROW_NUMBER() OVER(ORDER BY SUM(dt.Quantity) DESC) RNK2
FROM
(SELECT p.ProductName, p.ProductID, p.UnitPrice, c.city, 
SUM(o1.Quantity) AS Quantity, ROW_NUMBER() OVER(PARTITION BY p.ProductName ORDER BY SUM(o1.Quantity) DESC) RNK1
FROM Products p JOIN [Order Details] o1 on o1.ProductID = p.ProductID
JOIN Orders o ON o.OrderID = o1.OrderID
JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY p.ProductName, p.ProductID, p.UnitPrice, c.city
) dt
JOIN [Order Details] o ON o.ProductID = dt.ProductID
where dt.RNK1 = 1
group by dt.ProductName, dt.ProductID, dt.UnitPrice, dt.City
ORDER BY SUM(o.Quantity) DESC

GO

-- 20. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered
-- from. (tip: join  sub-query)

WIth cte AS
(SELECT Top 1 e.City, count(o.OrderID) AS NumOfOrders
FROM dbo.Employees e JOIN dbo.Orders o ON o.EmployeeID = e.EmployeeID
GROUP BY e.City ORDER BY NumOfOrders DESC) 
SELECT TOP 1 dt1.City, dt1.Quantity
FROM (
SELECT TOP 1 c.City, count(o1.Quantity) AS Quantity
FROM Customers c
JOIN dbo.Orders o on c.CustomerID = o.CustomerID
join [Order Details] o1 on o1.orderID = o.OrderID
GROUP BY c.City
ORDER BY Quantity DESC
) dt1
join cte on cte.City = dt1.City


-- 21. How do you remove the duplicates record of a table?

-- We can use the table to union itself to remove all the duplicated.





