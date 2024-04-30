GO
USE [Diablo]
GO

--PROBLEM 14
SELECT TOP(50) [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
FROM [Games]
WHERE YEAR([Start]) IN (2011, 2012)
ORDER BY [Start], [Name]

--PROBLEM 15
---- SOLUTION 1 WITH LEFT
SELECT [Username],
	RIGHT([Email], LEN([Email]) - CHARINDEX('@', [Email]))
	AS [Email Provider]
FROM [Users]
ORDER BY [Email Provider], [Username]

---- SOLUTION 2 WITH SUBSTRING
SELECT [Username],
	SUBSTRING([Email], CHARINDEX('@', [Email])+1, LEN([Email]) - CHARINDEX('@', [Email]))
	AS [Email Provider]
FROM [Users]
ORDER BY [Email Provider], [Username]

--PROBLEM 16
SELECT [Username], [IpAddress]
FROM [Users]
WHERE [IpAddress] LIKE '___.1_%._%.___'
ORDER BY [Username]

--PROBLEM 17 EXAMPLE OF A CASE CLAUSE
SELECT [Name] AS [Game],
	CASE
		WHEN DATEPART(hour, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
		WHEN DATEPART(hour, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
		WHEN DATEPART(hour, [Start]) BETWEEN 18 AND 23 THEN 'Evening'
	END  AS [Part of the Day],
	CASE
		WHEN [Duration] <= 3 THEN 'Extra Short'
		WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
		WHEN [Duration] > 6 THEN 'Long'
		ELSE 'Extra Long'
	END AS [Duration]
FROM [Games]
ORDER BY [Name], [Duration], [Part of the Day]