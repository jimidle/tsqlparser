DECLARE Employee_Cursor CURSOR FOR
SELECT LastName, FirstName
FROM AdventureWorks.HumanResources.vEmployee
WHERE LastName like 'B%';

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor;
WHILE @@FETCH_STATUS = 0
	BEGIN
		    FETCH NEXT FROM Employee_Cursor
	END;

	CLOSE Employee_Cursor;
	DEALLOCATE Employee_Cursor;

