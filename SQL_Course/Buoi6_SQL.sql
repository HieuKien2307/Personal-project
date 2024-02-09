use AdventureWorks2019;

A

--Question 1 : The Sales.SalesOrderHeader table contains foreign keys to the Sales.CurrencyRate and Purchasing.ShipMethod tables. Write a query joining all three tables, and make sure it contains all rows from Sales.SalesOrderHeader. Include the CurrencyRateID, AverageRate, SalesOrderID, and ShipBase columns.
SELECT CR.CurrencyRateID, CR.AverageRate, SOH.SalesOrderID , SM.ShipBase
FROM Sales.SalesOrderHeader SOH
LEFT OUTER JOIN Sales.CurrencyRate CR
ON SOH.CurrencyRateID = CR.CurrencyRateID
	LEFT OUTER JOIN Purchasing.ShipMethod AS SM
	ON SOH.ShipMethodID = SM.ShipMethodID;

SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.CurrencyRate
SELECT * FROM Purchasing.ShipMethod

--Question 2 : Using a derived table, join the Sales.SalesOrderHeader table to the Sales.SalesOrderDetail table. Display the SalesOrderID, OrderDate, and ProductID columns in the results. The Sales. SalesOrderDetail table should be inside the derived table query
SELECT SOH.SalesOrderID, SOH.OrderDate, ProductID 
FROM Sales.SalesOrderHeader AS SOH 
INNER JOIN ( 
SELECT SalesOrderID, ProductID 
FROM Sales.SalesOrderDetail) AS SOD 
ON SOH.SalesOrderID = SOD.SalesOrderID; 
--Question 3 : ? 
--Question 4 : Write a query joining the Person.Person, Sales.Customer, and Sales.SalesOrderHeader tables to return a list of the customer names along with a count of the orders placed           
SELECT COUNT(*) AS CountOfOrders, FirstName, 
MiddleName, LastName 
FROM Person.Person AS P 
INNER JOIN Sales.Customer AS C ON P.BusinessEntityID = C.PersonID 
INNER JOIN Sales.SalesOrderHeader 
AS SOH ON C.CustomerID = SOH.CustomerID 
GROUP BY FirstName, MiddleName, LastName; 

--Question 5 : Write a query using the Sales.SalesOrderHeader, Sales. SalesOrderDetail, and Production.Product tables to display the total sum of products by Name and OrderDate
SELECT SUM(OrderQty) SumOfOrderQty, P.Name, SOH.OrderDate
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product AS P ON SOD.ProductID = P.ProductID
GROUP BY P.Name, SOH.OrderDate;

B
DROP TABLE IF EXISTS Production.ProductColor;
CREATE table Production.ProductColor
 (Color nvarchar(15) NOT NULL PRIMARY KEY);
GO
--Insert most of the existing colors
INSERT INTO Production.ProductColor
SELECT DISTINCT Color
FROM Production.Product
WHERE Color IS NOT NULL and Color <> 'Silver';
--Insert some additional colors
INSERT INTO Production.ProductColor
VALUES ('Green'),('Orange'),('Purple')
SELECT * FROM Production.ProductColor
--Question 1 : Using a subquery that includes the Sales.SalesOrderDetail table, display the product names and product ID numbers from the Production.Product table that have been ordered
SELECT ProductID, Name 
FROM Production.Product 
WHERE ProductID IN 
(SELECT ProductID FROM Sales.SalesOrderDetail);
--Question 2 : Change the query written in Question 1 to display the products that have not been ordered.
SELECT ProductID, Name 
FROM Production.Product 
WHERE ProductID NOT IN ( 
SELECT ProductID FROM Sales.SalesOrderDetail 
WHERE ProductID IS NOT NULL);
--2.1 
SELECT ProductID, Name 
FROM Production.Product 
EXCEPT 
SELECT SalesOrderDetail.ProductID, Production.Product.Name 
FROM Production.Product 
JOIN Sales.SalesOrderDetail ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID 
WHERE Sales.SalesOrderDetail.ProductID IS NOT NULL;
--Question 3 : Write a query using a subquery that returns the rows from the Production.ProductColor table that are not being used in the Production.Product table.
SELECT DISTINCT Color 
FROM Production.ProductColor AS PC
WHERE NOT EXISTS (
    SELECT * 
    FROM Production.Product AS P
    WHERE P.Color = PC.Color
);
--3.1 
SELECT DISTINCT Color 
FROM Production.ProductColor
EXCEPT 
SELECT DISTINCT P.Color 
FROM Production.Product AS P
JOIN Production.ProductColor AS PC ON P.Color = PC.Color;
--Test
SELECT DISTINCT Color FROM Production.ProductColor
SELECT DISTINCT Color FROM Production.Product

--4.Write a query that combines the ModifiedDate from Person.Person and the HireDate from HumanResources.Employee with no duplicates in the results.
SELECT ModifiedDate 
FROM Person.Person 
UNION 
SELECT HireDate 
FROM HumanResources.Employee;
--5.Get all BusinessEntityID which exist in both table HumanResources.Employee, Person.Person
SELECT BusinessEntityID
FROM HumanResources.Employee
INTERSECT
SELECT BusinessEntityID
FROM Person.Person;
--6.Get all BusinessEntityID which exist in table HumanResources.Employee or Person.Person;
SELECT BusinessEntityID
FROM HumanResources.Employee
UNION
SELECT BusinessEntityID
FROM Person.Person;
--7.Get all First name of Employee and Customer without duplicate (hint: Using Employee, Customer and Person tables)
SELECT DISTINCT 
	Person.FirstName
FROM 
    HumanResources.Employee AS Employee
FULL OUTER JOIN 
    Person.Person AS Person ON Employee.BusinessEntityID = Person.BusinessEntityID
FULL OUTER JOIN 
    Sales.Customer AS Customer ON Employee.BusinessEntityID = Customer.PersonID;

C
 
--1. Using a derived table, join the Sales.SalesOrderHeader table to the Sales.SalesOrderDetail table. Display the SalesOrderID, OrderDate, and ProductID columns in the results. The Sales.SalesOrderDetail table should be inside the derived table query.. The results of using a CTE to solve a tricky query 
SELECT SOH.SalesOrderID, SOH.OrderDate, ProductID 
FROM Sales.SalesOrderHeader AS SOH 
INNER JOIN ( 
SELECT SalesOrderID, ProductID 
FROM Sales.SalesOrderDetail) AS SOD 
ON SOH.SalesOrderID = SOD.SalesOrderID; 

--2. Rewrite the query in Question 1 with a common table expression. 
WITH SalesOrderDetailCTE AS (
    SELECT SalesOrderID, ProductID 
    FROM Sales.SalesOrderDetail
)
SELECT SOH.SalesOrderID, SOH.OrderDate, SOD.ProductID 
FROM Sales.SalesOrderHeader AS SOH 
INNER JOIN SalesOrderDetailCTE AS SOD 
ON SOH.SalesOrderID = SOD.SalesOrderID;

--3. Write a query that displays all customers along with the orders placed in 2011. Use a common table expression to write the query and include the CustomerID, SalesOrderID, and OrderDate columns in the results.
WITH SOH AS (
SELECT SalesOrderID, OrderDate, CustomerID 
FROM Sales.SalesOrderHeader 
WHERE OrderDate BETWEEN '2011-01-01' AND '2011-12-31' ) 
SELECT C.CustomerID, SalesOrderID, OrderDate 
FROM Sales.Customer AS C 
LEFT OUTER JOIN SOH ON C.CustomerID = SOH.CustomerID;