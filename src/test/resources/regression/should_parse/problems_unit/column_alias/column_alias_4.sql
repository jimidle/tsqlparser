SELECT City AS "City Name", MIN(Salary) Minimum, MAX(Salary) Maximum
FROM Employee
WHERE ID BETWEEN 1 AND 10
GROUP BY City