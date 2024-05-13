USE AdventureWorks;
GO
DECLARE @SamplesPath nvarchar(1024)
-- You may have to modify the value of the this variable if you have
--installed the sample some location other than the default location.
SELECT @SamplesPath = REPLACE(physical_name, 'Microsoft SQL Server\MSSQL.1\MSSQL\DATA\master.mdf', 'Microsoft SQL Server\90\Samples\Engine\Programmability\CLR\') 
     FROM master.sys.database_files 
     WHERE name = 'master';
CREATE ASSEMBLY StringUtilities FROM @SamplesPath + 'StringUtilities\CS\StringUtilities\bin\debug\StringUtilities.dll'
WITH PERMISSION_SET=SAFE;
GO

CREATE AGGREGATE Concatenate(@input nvarchar(4000))
RETURNS nvarchar(4000)
EXTERNAL NAME [StringUtilities].[Microsoft.Samples.SqlServer.Concatenate];
GO
