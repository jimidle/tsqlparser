SELECT "Result" =
    CASE WHEN salary > 1000 THEN     "> 1000"
         WHEN salary = 2000 THEN     "= 2000"
         WHEN salary < 8000 THEN     "< 8000"
    END
       FROM Employee
       WHERE Id <> @ID
         AND Start_Date <> @StartDate