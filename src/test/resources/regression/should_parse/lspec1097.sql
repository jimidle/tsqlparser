-- Create a FILESTREAM-enabled database.
-- The c:\data directory must exist.
CREATE DATABASE PathNameDB
ON
PRIMARY ( NAME = ArchX1,
FILENAME = 'c:\data\archdatP1.mdf'),
FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM( NAME = ArchX3,
FILENAME = 'c:\data\filestreamP1')
LOG ON  ( NAME = ArchlogX1,
FILENAME = 'c:\data\archlogP1.ldf');
GO

USE PathNameDB;
GO

-- Create a table, add some records, and
-- create the associated FILESTREAM
-- BLOB files.

CREATE TABLE TABLE1
(
ID int,
RowGuidColumn UNIQUEIDENTIFIER
NOT NULL UNIQUE ROWGUIDCOL,
FILESTREAMColumn varbinary(MAX) FILESTREAM
);
GO

INSERT INTO TABLE1 VALUES(1, NEWID(), 0x00);
INSERT INTO TABLE1 VALUES(2, NEWID(), 0x00);
INSERT INTO TABLE1 VALUES(3, NEWID(), 0x00);
GO

SELECT FILESTREAMColumn.PathName() AS 'PathName' FROM TABLE1;

--Results
--PathName
------------------------------------------------------------------------------------------------------------
--\\SERVER\MSSQLSERVER\v1\PathNameExampleDB\dbo\TABLE1\FILESTREAMColumn\DD67C792-916E-4A76-8C8A-4A85DC5DB908
--\\SERVER\MSSQLSERVER\v1\PathNameExampleDB\dbo\TABLE1\FILESTREAMColumn\2907122B-2560-4CB9-86DC-FBE7ABA1843B
--\\SERVER\MSSQLSERVER\v1\PathNameExampleDB\dbo\TABLE1\FILESTREAMColumn\922BE0E0-CAB9-4403-90BF-945BD258E4BC
--
--(3 row(s) affected)
GO

--Drop the database to clean up.
USE MASTER
GO
DROP DATABASE PathNameDB

