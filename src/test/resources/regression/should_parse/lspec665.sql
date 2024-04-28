USE AdventureWorks;
GO
SELECT objtype, objname, name, value
FROM fn_listextendedproperty(default, default, default, default, default, default, default);
GO

USE AdventureWorks;
GO
SELECT objtype, objname, name, value
FROM fn_listextendedproperty (NULL, 'schema', 'Production', 'table', 'ScrapReason', 'column', default);
GO

USE AdventureWorks;
GO
SELECT objtype, objname, name, value
FROM fn_listextendedproperty (NULL, 'schema', 'Sales', 'table', default, NULL, NULL);
GO

