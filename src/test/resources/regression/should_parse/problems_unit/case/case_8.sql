SELECT TOP 10 ID % 10 AS "ID",
   "ID?" = CASE
     WHEN (ID % 10) < 3 THEN 'Ends With Less Than Three'
     WHEN ID = 6 THEN 'ProductID is 6'
     WHEN ABS(ID % 10 - 2) <= 1 THEN 'Based on calculation'
     ELSE 'More Than One Apart'
   END
 FROM Employee