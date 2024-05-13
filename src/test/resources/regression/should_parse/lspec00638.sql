USE AdventureWorks;
GO
CREATE TABLE ddl_log (PostTime datetime, DB_User nvarchar(100), Event nvarchar(100), TSQL nvarchar(2000));
GO
CREATE TRIGGER log 
ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS 
AS
DECLARE @data XML
SET @data = EVENTDATA()
INSERT ddl_log 
   (PostTime, DB_User, Event, TSQL) 
   VALUES 
   (GETDATE(), 
	   CONVERT(nvarchar(100), CURRENT_USER), 
	   @data.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'), 
	   @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(2000)') ) ;
GO
--Test the trigger.
CREATE TABLE TestTable (a int)
DROP TABLE TestTable ;
GO
SELECT * FROM ddl_log ;
GO
--Drop the trigger.
DROP TRIGGER log
ON DATABASE
GO
--Drop table ddl_log.
DROP TABLE ddl_log
GO

