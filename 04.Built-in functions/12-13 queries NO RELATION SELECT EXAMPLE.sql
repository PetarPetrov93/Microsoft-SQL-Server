GO
USE [Geography]
GO

--PROBLEM 12
----SOLUTION 1
SELECT [CountryName] AS [Country Name],
		[IsoCode] AS [ISO Code]
FROM [Countries]
WHERE LOWER([CountryName]) LIKE '%a%a%a%'
ORDER BY [IsoCode] -- CAN ALSO USE THE ALIAS [ISOI Code] HERE IT IS THE SAME

----SOLUTION 2
SELECT [CountryName] AS [Country Name],
		[IsoCode] AS [ISO Code]
FROM [Countries]
WHERE LEN([CountryName]) - LEN(REPLACE(LOWER([CountryName]), 'a', '')) >= 3
ORDER BY [IsoCode]

--PROBLEM 13 MULTIPLE SELECT WITHOUT PK-FK RELATION
---- SOLUTION 1
SELECT p.[PeakName], r.[RiverName], LOWER(CONCAT(LEFT([PeakName], LEN([PeakName])-1), [RiverName])) AS [Mix]
FROM [Peaks] AS p, [Rivers] AS r
WHERE RIGHT([PeakName], 1) = LOWER(LEFT([RiverName], 1))
ORDER BY [Mix]

---- SOLUTION 2 SAME BUT INSTEAD OF LEFT USED RIGHT IN THE CONCAT FUNCTION
SELECT p.[PeakName], r.[RiverName], LOWER(CONCAT([PeakName], RIGHT([RiverName], LEN([RiverName]) - 1))) AS [Mix]
FROM [Peaks] AS p, [Rivers] AS r
WHERE RIGHT([PeakName], 1) = LOWER(LEFT([RiverName], 1))
ORDER BY [Mix]

---- SOLUTION 3 SAME BUT USING SUBSTRING INSTEAD OF LEFT OR RIGHT. CAN BE DONE FOR EITHER [PeakName] OR [RiverName]
SELECT p.[PeakName], r.[RiverName], LOWER(CONCAT([PeakName], SUBSTRING([RiverName], 2, LEN([RiverName])))) AS [Mix]
FROM [Peaks] AS p, [Rivers] AS r
WHERE RIGHT([PeakName], 1) = LOWER(LEFT([RiverName], 1))
ORDER BY [Mix]

