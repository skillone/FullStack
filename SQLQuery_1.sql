-- 1. Write a query that retrieves the columns ProductID, Name, Color and ListPrice 
-- from the Production.Product table, with no filter. 

SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product 


-- 2. Write a query that retrieves the
-- columns ProductID, Name, Color and ListPrice from the Production.Product table,
-- excluding the rows that ListPrice is 0.

SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product 
WHERE ListPrice != 0


-- 3. Write a query that retrieves the columns ProductID, Name, Color and ListPrice 
-- from the Production.Product table, the rows that are not NULL for the Color column.
SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product
WHERE Color IS NOT NULL


-- 4. Write a query that retrieves the columns ProductID, Name, Color and ListPrice 
-- from the Production.Product table, the rows that are not NULL for the column Color, 
-- and the column ListPrice has a value greater than zero.

SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product
WHERE Color IS NOT NULL
AND ListPrice >= 0


-- 5. Write a query that concatenates the columns Name and Color
-- from the Production.Product table by excluding the rows that are null for color.
SELECT Name, Color
FROM Production.Product
WHERE Color IS NOT NULL


-- 6. Write a query that generates the following result set from Production.Product:
-- NAME: LL Crankarm  --  COLOR: Black
SELECT *
FROM Production.Product
WHERE Name = 'LL' + ' ' + 'Crankarm'
AND Color = 'Black'

--NAME: ML Crankarm  --  COLOR: Black
SELECT *
FROM Production.Product
WHERE Name = 'ML' + ' ' + 'Crankarm'
AND Color = 'Black'

-- NAME: HL Crankarm  --  COLOR: Black
SELECT *
FROM Production.Product
WHERE Name = 'HL' + ' ' + 'Crankarm'
AND Color = 'Black'

-- NAME: Chainring Bolts  --  COLOR: Silver
SELECT *
FROM Production.Product
WHERE Name = 'Chainring' + ' ' + 'Bolts'
AND Color = 'Silver'

-- NAME: Chainring Nut  --  COLOR: Silver
SELECT *
FROM Production.Product
WHERE Name = 'Chainring' + ' ' + 'Nut'
AND Color = 'Silver'

-- NAME: Chainring  --  COLOR: Black
SELECT *
FROM Production.Product
WHERE Name = 'Chainring'
AND Color = 'Black'


-- 7. Write a query to retrieve the to the columns ProductID and Name 
-- from the Production.Product table filtered by ProductID from 400 to 500 using between
SELECT ProductID, Name 
FROM Production.Product
WHERE ProductID BETWEEN 400 AND 500

-- 8. Write a query to retrieve the to the columns  ProductID,
-- Name and color from the Production.Product table restricted to the colors black and blue
SELECT ProductID, Name, Color
FROM Production.Product
WHERE Color in ('Black', 'Blue')

-- 9. Write a query to get a result set on products that begins
-- with the letter S. 
SELECT *
FROM Production.Product
WHERE Name like 'S%'

-- 10. Write a query that retrieves the columns Name and ListPrice
-- from the Production.Product table. Your result set should look something like the following. Order the result set
-- by the Name column. The products name should start with either 'A' or 'S'
-- Name                                            ListPrice
-- Adjustable Race                                   0,00
-- All-Purpose Bike Stand                          159,00
-- AWC Logo Cap                                      8,99
-- Seat Lug                                          0,00
-- Seat Post                                         0,00
SELECT Name, ListPrice
FROM Production.Product
WHERE Name like '[AS]%'
ORDER BY Name



-- 11. Write a query so you retrieve rows that have a Name that begins with the letters SPO,
-- but is then not followed by the letter K. After this zero or more letters can exists. Order the result set by the Name column.
SELECT Name, ListPrice
FROM Production.Product
WHERE Name like 'SPO[^K]%'
ORDER BY Name

-- 12. Write a query that retrieves the unique combination of columns ProductSubcategoryID 
-- and Color from the Production.Product table. We do not want any rows that are NULL.in any of the two columns in the result. (Hint: Use IsNull)
SELECT DISTINCT ISNULL(p1.ProductSubcategoryID, 0) AS 'ProductSubcategoryID', ISNULL(p2.Color, 'NULL') AS 'Color'
FROM Production.Product p1
JOIN Production.Product p2
ON p1.ProductID = p2.ProductID
WHERE p1.ProductSubcategoryID != 0
AND p2.Color != 'NULL'