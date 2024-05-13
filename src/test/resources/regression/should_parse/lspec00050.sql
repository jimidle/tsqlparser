USE AdventureWorks ;
GO
-- Create Gloves table.
SELECT ProductModelID, Name
INTO dbo.Gloves
FROM Production.ProductModel
WHERE ProductModelID IN (3, 4) ;
GO

USE AdventureWorks ;
GO
SELECT ProductModelID, Name
INTO ProductResults
FROM Production.ProductModel
WHERE ProductModelID NOT IN (3, 4)
UNION
SELECT ProductModelID, Name
FROM dbo.Gloves ;
GO

SELECT * 
FROM dbo.ProductResults ;

