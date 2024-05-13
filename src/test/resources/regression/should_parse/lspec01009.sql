USE AdventureWorks;
GO
SELECT o.name AS obj_name, c.name AS col_name,
       TYPE_NAME(c.user_type_id) AS type_name
FROM sys.objects AS o 
JOIN sys.columns AS c  ON o.object_id = c.object_id
WHERE o.name = 'Vendor'
ORDER BY col_name;
GO
