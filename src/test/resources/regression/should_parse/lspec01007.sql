USE tempdb;
GO
CREATE TYPE NewType FROM int;
GO
CREATE SCHEMA NewSchema;
GO
CREATE TYPE NewSchema.NewType FROM int;
GO
SELECT TYPE_ID('NewType') AS [1 Part Data Type ID],
       TYPE_ID('NewSchema.NewType') AS [2 Part Data Type ID];
GO
