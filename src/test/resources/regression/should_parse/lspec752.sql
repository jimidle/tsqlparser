USE AdventureWorks;
GO
IF OBJECT_ID ('dbo.T1', 'U') IS NOT NULL
	    DROP TABLE dbo.T1;
	GO
	IF OBJECT_ID ('dbo.V1', 'V') IS NOT NULL
		    DROP VIEW dbo.V1;
		GO
		CREATE TABLE T1 ( column_1 int, column_2 varchar(30));
		GO
		CREATE VIEW V1 AS 
		SELECT column_2, column_1 
		FROM T1;
		GO
		INSERT INTO V1 
		    VALUES ('Row 1',1);
		GO
		SELECT column_1, column_2 
		FROM T1;
		GO
		SELECT column_1, column_2
		FROM V1;
		GO


