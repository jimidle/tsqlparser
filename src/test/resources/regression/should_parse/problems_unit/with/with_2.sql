 WITH EmployeeData AS
 (
 SELECT region, AVG(Salary) 'AvgSalary' FROM Employee GROUP BY Region
 )
 SELECT e.ID, e.Name FROM Employee e
 JOIN EmployeeData edata
 ON e.Region = eData.Region
 WHERE e.Salary > edata.AvgSalary