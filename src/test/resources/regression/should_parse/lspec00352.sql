USE AdventureWorks;
GO
SELECT Name
FROM Production.Product
WHERE CONTAINS(Name, ' "Mountain" OR "Road" ')
GO
