GO
USE [SoftUni]
GO

--PROBLEM 1
SELECT TOP(5) e.[EmployeeID], e.[JobTitle], a.[AddressID], a.[AddressText]
FROM [Employees] AS e
JOIN [Addresses] AS a
ON e.[AddressID] = a.[AddressID]
ORDER BY a.[AddressID]

--PROBLEM 2
SELECT TOP(50) e.[FirstName], e.[LastName], t.[Name], a.AddressText
FROM [Employees] AS e
JOIN [Addresses] AS a
ON e.AddressID = a.AddressID
JOIN [Towns] AS t
ON a.[TownID] = t.[TownID]
ORDER BY e.[FirstName], e.[LastName]

--PROBLEM 3
SELECT e.[EmployeeID], e.[FirstName], e.[LastName], d.[Name]
FROM [Employees] AS e
JOIN [Departments] AS d
ON e.[DepartmentID] = d.DepartmentID
WHERE d.[Name] = 'Sales'
ORDER BY e.[EmployeeID]

--PROBLEM 4
SELECT TOP(5) e.[EmployeeID], e.[FirstName], e.[Salary], d.[Name]
FROM [Employees] AS e
JOIN [Departments] AS d
ON e.[DepartmentID] = d.DepartmentID
WHERE e.[Salary] > 15000
ORDER BY d.[DepartmentID]


--PROBLEM 5 THE 2ND JOIN IS NOT NEEDED FOR THIS TASK AS WE CAN CHECK WHICH EMPLOYEE DOES NOT HAVE A PROJECT FROM THE TRANSITIONAL TABLE (ep.[EmployeeID] IS NULL)
SELECT TOP(3) e.[EmployeeID], e.[FirstName]
FROM [Employees] AS e
LEFT JOIN [EmployeesProjects] AS ep
ON e.[EmployeeID] = ep.[EmployeeID]
LEFT JOIN [Projects] AS p
ON p.[ProjectID] = ep.[ProjectID]
WHERE ep.[EmployeeID] IS NULL
ORDER BY e.[EmployeeID]

--PROBLEM 6
SELECT e.[FirstName], e.[LastName], e.[HireDate], d.[Name]
FROM [Employees] AS e
JOIN [Departments] AS d
ON e.[DepartmentID] = d.DepartmentID
WHERE e.[HireDate] > '01-01-1999' AND d.[Name] IN ('Sales', 'Finance')
ORDER BY e.[HireDate]

--PROBLEM 7
SELECT TOP(5) e.[EmployeeID], e.[FirstName], p.[Name]
FROM [Employees] AS e
JOIN [EmployeesProjects] AS ep
ON e.[EmployeeID] = ep.EmployeeID
JOIN [Projects] AS p
ON p.[ProjectID] = ep.[ProjectID]
WHERE p.[StartDate] > '08-13-2002' AND p.[EndDate] IS NULL
ORDER BY e.[EmployeeID]

--PROBLEM 8
SELECT TOP(5) e.[EmployeeID], e.[FirstName],
	CASE
		WHEN p.[StartDate] >= '2005' THEN NULL
		ELSE p.[Name]
	END AS [ProjectName]
FROM [Employees] AS e
JOIN [EmployeesProjects] AS ep
ON e.[EmployeeID] = ep.EmployeeID
JOIN [Projects] AS p
ON p.[ProjectID] = ep.[ProjectID]
WHERE e.[EmployeeID] = 24

--PROBLEM 9 -- SELF-REFERENCING TABLE EXAMPLE e.[ManagerID] CAN BE REPLACED WITH m.[EmployeeID]
SELECT e.[EmployeeID], e.[FirstName], e.[ManagerID], m.[FirstName] AS [ManagerName]
FROM [Employees] AS e
JOIN [Employees] AS m
ON e.[ManagerID] = m.[EmployeeID]
WHERE m.[EmployeeID] IN (3, 7)
ORDER BY e.[EmployeeID]

--PROBLEM 10 -- SELF REFERENCING TABLE WITH ANOTHER JOINT TO A DIFFERENT TABLE
SELECT TOP(50) e.[EmployeeID],
		CONCAT(e.[FirstName], ' ', e.[LastName]) AS [EmployeeName],
		CONCAT(m.[FirstName], ' ', m.LastName) AS [ManagerName],
		d.[Name] AS [DepartmentName]
FROM [Employees] AS e
JOIN [Employees] AS m
ON e.[ManagerID] = m.[EmployeeID]
JOIN [Departments] AS d
ON e.[DepartmentID] = d.DepartmentID
ORDER BY e.[EmployeeID]

--PROBLEM 11 SUBQUERY EXAMPLE AND GROUP BY - IN ORDER TO USE THE AverageSalary WE NEED AN OUTTER QUERY TO FURTHER FIND THE MIN SALARY OUT OF ALL THE DEPARTMENTS AVERAGE SALARIES
SELECT MIN([AverageSalary]) AS [MinAverageSalary]
FROM(
		SELECT AVG([Salary]) AS [AverageSalary]
		FROM [Employees]
		GROUP BY ([DepartmentID])
) AS [SubQUery]
