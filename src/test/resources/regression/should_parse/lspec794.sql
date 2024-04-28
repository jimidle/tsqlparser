USE AdventureWorks;
GO

SELECT ProductID, MakeFlag, FinishedGoodsFlag, 
   NULLIF(MakeFlag,FinishedGoodsFlag)AS 'Null if Equal'
FROM Production.Product
WHERE ProductID < 10;
GO

SELECT ProductID, MakeFlag, FinishedGoodsFlag,'Null if Equal' =
   CASE
	       WHEN MakeFlag = FinishedGoodsFlag THEN NULL
		       ELSE MakeFlag
			   END
			FROM Production.Product
			WHERE ProductID < 10;
			GO

