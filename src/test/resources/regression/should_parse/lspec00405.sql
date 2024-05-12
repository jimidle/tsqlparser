CREATE FUNCTION MyFunction ()
RETURNS @Tbl TABLE
(
StudentID VARCHAR(255),
SAS_StudentInstancesID INT,
Label VARCHAR(255),
Value MONEY,
CMN_PersonsID INT
)
AS
BEGIN

INSERT @Tbl
(
StudentID ,
SAS_StudentInstancesID ,
Label ,
Value ,
CMN_PersonsID
)
SELECT
StudentID ,
SAS_StudentInstancesID ,
Label ,
Value ,
CMN_PersonsID
FROM MyView -- where MyView selects (with joins) the same columns from large table(s)

RETURN

END
