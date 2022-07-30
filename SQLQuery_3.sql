-- Use Northwind database. All questions are based on assumptions described by the Database Diagram sent to you yesterday. When inserting, make up info if necessary. Write query for each step. Do not use IDE. BE CAREFUL WHEN DELETING DATA OR DROPPING TABLE.

Use Northwind

GO

-- 1. Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
CREATE VIEW view_product_order_Peng AS
SELECT p.ProductID, p.ProductName, sum(o.Quantity) AS Quantity FROM dbo.Products p JOIN dbo.[Order Details] o ON o.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName

GO

SELECT *
FROM view_product_order_Peng

-- 2. Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
GO

CREATE PROC sp_product_order_quantity_Peng 
@ProductID int,
@Quantity int OUT
AS
BEGIN
    SELECT @Quantity = sum(o.Quantity) FROM Products p JOIN dbo.[Order Details] o ON o.ProductID = p.ProductID WHERE p.ProductID = @ProductID
END

-- DROP PROC sp_product_order_quantity_Peng

GO

BEGIN
DECLARE @Quantity int
EXEC sp_product_order_quantity_Peng 2, @Quantity out
PRINT @Quantity
END

GO

-- 3. Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.

DROP PROC sp_product_order_city_Peng

GO

CREATE PROC sp_product_order_city_Peng 
@ProductName nvarchar(40)
-- @City nvarchar(15) OUT,
-- @Quantity int OUT
AS
BEGIN
    SELECT TOP 5 c.City, sum(o.Quantity) AS Quantity
    FROM dbo.Products p 
    JOIN [Order Details] o ON p.ProductID = o.ProductID
    JOIN Orders o1 ON o1.OrderID = o.OrderID
    JOIN Customers c ON c.CustomerID = o1.CustomerID
    WHERE p.ProductName = @ProductName
    GROUP BY c.City
    ORDER BY Quantity DESC
END

GO

EXEC sp_product_order_city_Peng [Chai]

GO

-- 4. Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: 
-- {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. 
-- Remove city of Seattle. 
-- If there was anyone from Seattle, put them into a new city “Madison”. 
-- Create a view “Packers_your_name” lists all people from Green Bay. 
-- If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
CREATE TABLE people_peng
(
    Id int,
    Name nvarchar(50),
    City int
)
INSERT INTO people_peng VALUES(1, 'Aaron Rodgers', 2)
INSERT INTO people_peng VALUES(2, 'Russell Wilson', 1)
INSERT INTO people_peng VALUES(3, 'Jody Nelson', 2)

SELECT * FROM people_peng

GO

CREATE TABLE city_peng
(
    Id int,
    City nvarchar(50),
)
INSERT INTO city_peng VALUES(1, 'Seattle')
INSERT INTO city_peng VALUES(2, 'Green Bay')

SELECT * FROM city_peng

GO 

-- 5. Create a stored procedure “sp_birthday_employees_[you_last_name]” that 
-- creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. 
-- (Make a screen shot) drop the table. Employee table should not be affected.



-- 6. How do you make sure two tables have the same data?