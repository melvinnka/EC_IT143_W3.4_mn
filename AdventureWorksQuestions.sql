/* NAME:    EC_IT143_W3.4_mn.sql */
/* PURPOSE: Answers to eight AdventureWorks2022 questions using SQL queries, joins, aggregate functions,
         filtering, sorting and INFORMATION_SCHEMA metadata views */

/* Q1: Which employee has been with us the longest? */

SELECT TOP 1
    p.FirstName,
    p.LastName,
    e.HireDate
FROM HumanResources.Employee e
INNER JOIN Person.Person p
    ON e.BusinessEntityID = p.BusinessEntityID
ORDER BY e.HireDate ASC;

/* Answer: Guy Gilbert */

/* Q2: Which three products currently have the highest inventory levels? */

SELECT TOP 3
    p.Name AS ProductName,
    SUM(pi.Quantity) AS TotalInventory
FROM Production.Product p
INNER JOIN Production.ProductInventory pi
    ON p.ProductID = pi.ProductID
GROUP BY p.Name
ORDER BY TotalInventory DESC;

/* Answer:Hex Nut 7, Hex Nut 23 and Thin-Jam Hex Nut 3 */

/* Q3: Which three product categories currently contain the highest total inventory quantity across all locations? */

SELECT TOP 3
    pc.Name AS CategoryName,
    SUM(pi.Quantity) AS TotalInventory
FROM Production.ProductCategory pc
INNER JOIN Production.ProductSubcategory ps
    ON pc.ProductCategoryID = ps.ProductCategoryID
INNER JOIN Production.Product p
    ON ps.ProductSubcategoryID = p.ProductSubcategoryID
INNER JOIN Production.ProductInventory pi
    ON p.ProductID = pi.ProductID
GROUP BY pc.Name
ORDER BY TotalInventory DESC;

/* Answer: Components, Bikes and Accessories */

/* Q4: Which clients have the highest total purchasing value? */

SELECT TOP 10
    c.CustomerID,
    SUM(soh.TotalDue) AS TotalPurchases
FROM Sales.Customer c
INNER JOIN Sales.SalesOrderHeader soh
    ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalPurchases DESC;

/* Answer: CustomerID, 29818, 29715, 29722, 30117, 29614, 29639, 29701, 29617, 29994, 29646 */

/* Q5: Product with highest inventory but lowest sales volume */

SELECT TOP 2
    p.ProductID,
    p.Name,
    SUM(pi.Quantity) AS InventoryQuantity,
    ISNULL(SUM(sod.OrderQty),0) AS TotalUnitsSold
FROM Production.Product p
INNER JOIN Production.ProductInventory pi
    ON p.ProductID = pi.ProductID
LEFT JOIN Sales.SalesOrderDetail sod
    ON p.ProductID = sod.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY InventoryQuantity DESC, TotalUnitsSold ASC;

/* Answer: ProductID 921, Name_ Mountain Tire Tube  */

/* Q6: Among the five most expensive products, which has the fewest units in inventory? */

WITH TopExpensiveProducts AS
(
    SELECT TOP 5
        ProductID,
        Name,
        ListPrice
    FROM Production.Product
    WHERE ListPrice > 0
    ORDER BY ListPrice DESC
)

SELECT TOP 1
    tep.Name,
    tep.ListPrice,
    SUM(pi.Quantity) AS InventoryQuantity
FROM TopExpensiveProducts tep
LEFT JOIN Production.ProductInventory pi
    ON tep.ProductID = pi.ProductID
GROUP BY tep.Name, tep.ListPrice
ORDER BY InventoryQuantity ASC;

/* Answer: Road-150 Red, 52 */

/* Q7: Which table contains the greatest number of columns ending with 'Date'? */

SELECT TOP 1
    TABLE_SCHEMA,
    TABLE_NAME,
    COUNT(*) AS DateColumnCount
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%Date'
GROUP BY TABLE_SCHEMA, TABLE_NAME
ORDER BY DateColumnCount DESC;

/* Answer: WorkOrderRouting */

/* Q8: What are the column names and data types in the Sales Order table? */

SELECT TOP 3
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Sales'
    AND TABLE_NAME = 'SalesOrderHeader'
ORDER BY ORDINAL_POSITION;

/* Answer: Column Name and Data Type: SalesOrderID _ int RevisionNumber, _ tinyint, OrderDate datetime */

/* NOTE: This project demonstrated how SQL can be used to answer real business questions using the AdventureWorks 
database. Through joins, aggregate functions, sorting, grouping, Common Table Expression and information schema views, 
I was able to extract meaningful information to support business decision making. */

