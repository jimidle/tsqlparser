USE tempdb;
GO
DECLARE @Num1 int;
SET @Num1 = -5;
SELECT +@Num1, ABS(@Num1);
GO
