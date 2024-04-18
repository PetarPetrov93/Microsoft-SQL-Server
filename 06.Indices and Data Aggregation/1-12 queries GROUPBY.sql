GO
USE [Gringotts]
GO

--PROBLEM 1
SELECT COUNT(*) AS [Count]
FROM [WizzardDeposits]

--PROBLEM 2
SELECT MAX([MagicWandSize]) AS [LongestMagicWand]
FROM [WizzardDeposits]

--PROBLEM 3
SELECT [DepositGroup],
	MAX([MagicWandSize]) AS [LongestMagicWand]
FROM [WizzardDeposits]
GROUP BY [DepositGroup]

--PROBLEM 4
SELECT TOP(2) [DepositGroup]
FROM [WizzardDeposits]
GROUP BY [DepositGroup]
ORDER BY AVG([MagicWandSize])

--PROBLEM 5
SELECT [DepositGroup],
	SUM([DepositAmount]) AS [TotalSum]
FROM [WizzardDeposits]
GROUP BY [DepositGroup]


--PROBLEM 6
SELECT [DepositGroup],
	SUM([DepositAmount]) AS [TotalSum]
FROM [WizzardDeposits]
GROUP BY [DepositGroup], [MagicWandCreator]
HAVING [MagicWandCreator] = 'Ollivander family'

--PROBLEM 7 WITH SUBQUERY EXAMPLE
---- SOLUTION 1 - WE USE SUBQUERY IN ORDER TO BE ABLE TO FILTER BY THE [TotalSum] PROPERTY
SELECT *
FROM(
		SELECT [DepositGroup],
			SUM([DepositAmount]) AS [TotalSum]
		FROM [WizzardDeposits]
		GROUP BY [DepositGroup], [MagicWandCreator]
		HAVING [MagicWandCreator] = 'Ollivander family'
	) AS [Subquery]
WHERE [TotalSum] < 150000
ORDER BY [TotalSum] DESC

--PROBLEM 7 WIHTOUT SUBQUERY
---- SOLUTION 2 - WE DONT NEED SUBQUERY BUT WE CANT USE THE [TotalSum] PROPERTY AS IT IS NOT YET CREATED, INSTEAD WE NEED TO USE SUM() AGAIN IN THE HAVING CLAUSE
SELECT [DepositGroup],
		SUM([DepositAmount]) AS [TotalSum]
FROM [WizzardDeposits]
GROUP BY [DepositGroup], [MagicWandCreator]
HAVING [MagicWandCreator] = 'Ollivander family' AND SUM([DepositAmount]) < 150000
ORDER BY [TotalSum] DESC

--PROBLEM 8 WITH SUBQUERY (SAME REASON AS IN Q7)
----SOLUTION 1
SELECT *
FROM(
		SELECT [DepositGroup], [MagicWandCreator],
			MIN([DepositCharge]) AS [MinDepositCharge]
		FROM [WizzardDeposits]
		GROUP BY [DepositGroup], [MagicWandCreator]
	) AS [Subquery]
WHERE [MinDepositCharge] >= 30.00
ORDER BY [MagicWandCreator], [DepositGroup]

--PROBLEM 8 WITHOUT SUBQUERY (SAME REASON AS IN Q7)
----SOLUTION 2
SELECT [DepositGroup], [MagicWandCreator],
	MIN([DepositCharge]) AS [MinDepositCharge]
FROM [WizzardDeposits]
GROUP BY [DepositGroup], [MagicWandCreator]
HAVING MIN(DepositCharge) >= 30.00
ORDER BY [MagicWandCreator], [DepositGroup]

--PROBLEM 9 -- CREATING A NEW COLUMN AND THEN GROUPING BY THAT NEWLY CRATED COLUMN
SELECT [AgeGroup],
	COUNT([AgeGroup])
FROM(
		SELECT 
			CASE
				WHEN [Age] BETWEEN 0 AND 10 THEN '[0-10]'
				WHEN [Age] BETWEEN 11 AND 20 THEN '[11-20]'
				WHEN [Age] BETWEEN 21 AND 30 THEN '[21-30]'
				WHEN [Age] BETWEEN 31 AND 40 THEN '[31-40]'
				WHEN [Age] BETWEEN 41 AND 50 THEN '[41-50]'
				WHEN [Age] BETWEEN 51 AND 60 THEN '[51-60]'
				ELSE '[61+]'
			END AS [AgeGroup]
		FROM [WizzardDeposits]
	) AS [Subquery]
GROUP BY [AgeGroup]

--PROBLEM 10 -- ANOTHER EXAMPLE FOR CREATING A NEW COLUMN AND USING IT TO GROUP
SELECT *
FROM(
		SELECT
			SUBSTRING([FirstName], 1, 1) AS [FirstLetter]
		FROM [WizzardDeposits]
	) AS [Subquery]
GROUP BY [FirstLetter]

--PROBLEM 11 -- WHERE CAN BE BEFORE GROUP BY IF WE NEED TO FILTER SOMETHING FIRST WHICH IS NOT RELATED TO THE COLUMNS WE WILL BE GROUPING BY
SELECT [DepositGroup], [IsDepositExpired],
		AVG([DepositInterest]) AS [AverageInterest]
FROM [WizzardDeposits]
WHERE [DepositStartDate] > '01-01-1985'
GROUP BY [DepositGroup], [IsDepositExpired]
ORDER BY [DepositGroup] DESC, [IsDepositExpired]

--PROBLEM 12
SELECT SUM(Diff) AS [SumDifference]
FROM(
		SELECT
		[DepositAmount] - LEAD([DepositAmount]) OVER (ORDER BY [Id]) AS [Diff]
		FROM [WizzardDeposits]
	) AS [Subquery]
