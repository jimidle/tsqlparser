CREATE PROCEDURE dbo.usp_myproc 
  WITH EXECUTE AS CALLER
AS 
    SELECT SUSER_NAME(), USER_NAME();
    EXECUTE AS USER = 'guest';
    SELECT SUSER_NAME(), USER_NAME();
    REVERT;
    SELECT SUSER_NAME(), USER_NAME();
GO

