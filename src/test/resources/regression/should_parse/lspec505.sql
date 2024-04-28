IF EXISTS (SELECT * FROM sys.server_triggers
    WHERE name = 'ddl_trig_database')
DROP TRIGGER ddl_trig_database
ON ALL SERVER
GO
CREATE TRIGGER ddl_trig_database 
ON ALL SERVER 
FOR CREATE_DATABASE 
AS 
    PRINT 'Database Created.'
    SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)')
GO
DROP TRIGGER ddl_trig_database
ON ALL SERVER
GO

