USE AdventureWorks;
GO
SELECT count(*) AS Count
FROM Production.ProductInventory
WHERE Quantity < 300;
GO
SET ROWCOUNT 4;
UPDATE Production.ProductInventory
SET Quantity = 400
WHERE Quantity < 300;
GO

