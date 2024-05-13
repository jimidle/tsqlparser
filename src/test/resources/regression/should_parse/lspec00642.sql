USE Sales;
GO
CREATE PROCEDURE dbo.usp_Demo
WITH EXECUTE AS 'CompanyDomain\SqlUser1'
AS
SELECT user_name();
GO
CREATE PROCEDURE dbo.usp_Demo
WITH EXECUTE AS 'SqlUser1'
AS
SELECT user_name(); -- Shows execution context is set to SqlUser1.
EXECUTE AS CALLER;
SELECT user_name(); -- Shows execution context is set to SqlUser2, the caller of the module.
REVERT;
SELECT user_name(); -- Shows execution context is set to SqlUser1.
GO

