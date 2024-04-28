USE [SoftUni]

GO

-- PROBLEM 1
---- APPROACH 1
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE LOWER(SUBSTRING([FirstName], 1, 2)) = 'sa'

---- APPROACH 2
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE [FirstName] LIKE 'Sa%'

-- PROBLEM 2
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE LOWER([LastName]) LIKE '%ei%'

--PROBLEM 3
SELECT [FirstName]
FROM [Employees]
WHERE [DepartmentID] IN (3, 10) AND YEAR([HireDate]) BETWEEN 1995 AND 2005

--PROBLEM 4
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE LOWER([JobTitle]) NOT LIKE '%engineer%'

--PROBLEM 5
----APPROACH 1
SELECT [Name]
FROM [Towns]
WHERE LEN([Name]) = 5 OR LEN([Name]) = 6
ORDER BY [Name]

----APPROACH 2
SELECT [Name]
FROM [Towns]
WHERE LEN([Name]) IN (5, 6)
ORDER BY [Name]

--PROBLEM 6
SELECT *
FROM [Towns]
WHERE SUBSTRING([Name], 1, 1) IN ('M', 'K', 'B', 'E')
ORDER BY [Name]

--PROBLEM 7
SELECT *
FROM [Towns]
WHERE SUBSTRING([Name], 1, 1) NOT IN ('R', 'B', 'D')
ORDER BY [Name]

--PROBLEM 8
GO

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE YEAR([HireDate]) > 2000

GO

--PROBLEM 9
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE LEN([LastName]) = 5

--PROBLEM 10 DENSE RANK EXAMPLE
SELECT [EmployeeID], [FirstName], [LastName], [Salary],
		DENSE_RANK() 
		OVER(
		PARTITION BY [Salary]
		ORDER BY [EmployeeID]
		) AS [Rank]
FROM [Employees]
WHERE [Salary] BETWEEN 10000 AND 50000
ORDER BY [Salary] DESC

--PROBLEM 11 DENSE RANK IN A SUBQUERY IN ORDER TO GET [Rank] IN THE WHERE CLAUSE
SELECT *
FROM(
		SELECT [EmployeeID], [FirstName], [LastName], [Salary],
				DENSE_RANK() 
				OVER(
				PARTITION BY [Salary]
				ORDER BY [EmployeeID]
				) AS [Rank]
		FROM [Employees]
		WHERE [Salary] BETWEEN 10000 AND 50000
) AS [RankingSubquery]
WHERE [Rank] = 2
ORDER BY [Salary] DESC
