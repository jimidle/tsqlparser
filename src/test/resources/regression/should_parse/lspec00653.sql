USE AdventureWorks
GO
-- Declare the variables to store the values returned by FETCH.
DECLARE @LastName varchar(50), @FirstName varchar(50)

DECLARE contact_cursor CURSOR FOR
SELECT LastName, FirstName FROM Person.Contact
WHERE LastName LIKE 'B%'
ORDER BY LastName, FirstName

OPEN contact_cursor

-- Perform the first fetch and store the values in variables.
-- Note: The variables are in the same order as the columns
-- in the SELECT statement. 

FETCH NEXT FROM contact_cursor
INTO @LastName, @FirstName

-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
WHILE @@FETCH_STATUS = 0
	BEGIN

		   -- Concatenate and display the current values in the variables.
   PRINT 'Contact Name: ' + @FirstName + ' ' +  @LastName

   -- This is executed as long as the previous fetch succeeds.
   FETCH NEXT FROM contact_cursor
   INTO @LastName, @FirstName
END

CLOSE contact_cursor
DEALLOCATE contact_cursor
GO

