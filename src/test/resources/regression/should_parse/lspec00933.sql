SET CONTEXT_INFO 0x01010101
GO
SELECT context_info 
FROM sys.dm_exec_sessions
WHERE session_id = @@SPID;
GO
DECLARE @BinVar varbinary(128)
SET @BinVar = CAST(REPLICATE( 0x20, 128 ) AS varbinary(128) )
SET CONTEXT_INFO @BinVar

SELECT CONTEXT_INFO() AS MyContextInfo;
GO

