USE master
EXEC sp_detach_db Archive
GO
CREATE DATABASE Archive ON
PRIMARY ( NAME = Arch1,
FILENAME = 'c:\moved_location\archdat1.mdf'),
FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM( NAME = Arch3,
FILENAME = 'c:\moved_location\filestream1')
LOG ON  ( NAME = Archlog1,
FILENAME = 'c:\moved_location\archlog1.ldf')
FOR ATTACH
GO

