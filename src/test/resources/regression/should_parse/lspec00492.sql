CREATE PROCEDURE Test2
AS
CREATE TABLE #t(x INT PRIMARY KEY)
INSERT INTO #t VALUES (2)
SELECT Test2Col = x FROM #t;
GO
CREATE PROCEDURE Test1
AS
CREATE TABLE #t(x INT PRIMARY KEY)
INSERT INTO #t VALUES (1)
SELECT Test1Col = x FROM #t;
EXEC Test2;
GO
CREATE TABLE #t(x INT PRIMARY KEY)
INSERT INTO #t VALUES (99);
GO
EXEC Test1;
GO

