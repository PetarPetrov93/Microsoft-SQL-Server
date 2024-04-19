GO
USE SoftUni
GO

--PROBLEM 13
SELECT [DepartmentID], SUM([Salary]) AS [TotalSalary]
FROM [Employees]
GROUP BY [DepartmentID]
ORDER BY [DepartmentID]

--PROBLEM 14
SELECT [DepartmentID], MIN([Salary]) AS [MinSalary]
FROM [Employees]
WHERE [HireDate] > '1-1-2000' AND DepartmentID IN (2, 5, 7)
GROUP BY [DepartmentID]

--PROBLEM 15
SELECT *
INTO [EmployeesWithSalaryOver30000]
FROM [Employees]
WHERE [Salary] > 30000

DELETE FROM [EmployeesWithSalaryOver30000]
WHERE ManagerID = 42

UPDATE [EmployeesWithSalaryOver30000]
	SET Salary += 5000
WHERE DepartmentID = 1

SELECT [DepartmentID],
	AVG([Salary]) AS [AverageSalary]
FROM [EmployeesWithSalaryOver30000]
GROUP BY [DepartmentID]

--PROBLEM 16
SELECT [DepartmentID],
	MAX([Salary]) AS [MaxSalary]
FROM [Employees]
GROUP BY [DepartmentID]
HAVING MAX([Salary]) NOT BETWEEN 30000 AND 70000

--PROBLEM 17
SELECT COUNT([Salary])
FROM [Employees]
WHERE [ManagerID] IS NULL

--PROBLEM 18
SELECT DISTINCT [DepartmentID], [Salary] AS [ThirdHighestSalary]
FROM(
		SELECT [DepartmentID], [Salary], 
				DENSE_RANK() OVER (PARTITION  BY [DepartmentID] ORDER BY [Salary] DESC) AS [RankedSalaries]
		FROM [Employees]
	) AS [SubqueryRes]
WHERE [RankedSalaries] = 3


--PROBLEM 19
SELECT TOP(10) [FirstName], [LastName], [DepartmentID]
FROM [Employees] AS [e]
WHERE [Salary] > (
					SELECT
							AVG([Salary])
					FROM [Employees] AS [eSub]
					WHERE [eSub].[DepartmentID] = [e].DepartmentID
					GROUP BY [DepartmentID]
				)
ORDER BY [DepartmentID]