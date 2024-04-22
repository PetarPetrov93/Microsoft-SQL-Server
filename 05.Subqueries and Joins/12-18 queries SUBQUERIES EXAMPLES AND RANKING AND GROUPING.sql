GO
USE [Geography]
GO

--PROBLEM 12
SELECT mc.[CountryCode], m.[MountainRange], p.[PeakName], p.[Elevation]
FROM [MountainsCountries] AS mc
JOIN [Mountains] AS m
ON mc.[MountainId] = m.[Id]
JOIN [Peaks] AS p
ON p.[MountainId] = m.[Id]
WHERE mc.[CountryCode] = 'BG' AND p.[Elevation] > 2835
ORDER BY p.[Elevation] DESC

--PROBLEM 13
SELECT [CountryCode], COUNT (MountainId) AS [MountainRanges]
FROM [MountainsCountries]
WHERE [CountryCode] IN ('BG', 'RU', 'US')
GROUP BY ([CountryCode])

--PROBLEM 14
SELECT TOP(5) c.[CountryName], r.[RiverName]
FROM [Countries] AS c
LEFT JOIN [CountriesRivers] AS cr
ON c.[CountryCode] = cr.[CountryCode]
LEFT JOIN [Rivers] AS r
ON r.[Id] = cr.[RiverId]
LEFT JOIN [Continents] AS co
ON co.[ContinentCode] = c.[ContinentCode]
WHERE co.ContinentName = 'Africa'
ORDER BY c.[CountryName]

--PROBLEM 15
SELECT [ContinentCode], [CurrencyCode], [CurrencyUsage]
FROM(
		SELECT *, DENSE_RANK() OVER(PARTITION BY [ContinentCode] ORDER BY [CurrencyUsage] DESC) AS [CurrencyRank]
		FROM(
				SELECT [ContinentCode], [CurrencyCode], COUNT(*) AS [CurrencyUsage]
				FROM [Countries]
				GROUP BY [ContinentCode], [CurrencyCode]
				HAVING COUNT(*) > 1
			) AS [CurrUsageSubquery]
	) AS [CurrancyRankingSubquery]
WHERE [CurrencyRank] = 1

--PROBLEM 16
SELECT COUNT(c.[CountryCode]) AS [Count]
FROM [Countries] AS c
LEFT JOIN [MountainsCountries] AS mc
ON c.[Countrycode] = mc.CountryCode
WHERE mc.[MountainId] IS NULL

--PROBLEM 17
SELECT TOP(5) c.[CountryName], MAX(p.[Elevation]) AS [HighestPeakElevation], MAX(r.[Length]) AS [LongestRiverLength]
FROM [Countries] AS c
LEFT JOIN [MountainsCountries] AS mc
ON c.[CountryCode] = mc.[CountryCode]
LEFT JOIN [Mountains] AS m
ON m.[Id] = mc.[MountainId]
LEFT JOIN [Peaks] AS p
ON p.[MountainId] = m.[Id]
LEFT JOIN [CountriesRivers] AS cr
ON c.[CountryCode] = cr.[CountryCode]
LEFT JOIN [Rivers] AS r
ON r.[Id] = cr.[RiverId]
GROUP BY c.[CountryName]
ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, c.[CountryName]

--PROBLEM 18
SELECT TOP(5) [CountryName] AS [Country],
		ISNULL([PeakName], '(no highest peak)') AS [Highest Peak Name],
		ISNULL([Elevation], 0) AS [Highest Peak Elevation],
		ISNULL([MountainRange], '(no mountain)') AS [Mountain]
FROM(
		SELECT c.[CountryName], 
				DENSE_RANK() OVER(PARTITION BY c.[CountryName] ORDER BY p.[Elevation]) AS [PeakRank],
				p.[PeakName], p.[Elevation], m.[MountainRange]
		FROM [Countries] AS c
		LEFT JOIN [MountainsCountries] AS mc
		ON c.[CountryCode] = mc.[CountryCode]
		LEFT JOIN [Mountains] AS m
		ON m.[Id] = mc.[MountainId]
		LEFT JOIN [Peaks] AS p
		ON p.[MountainId] = m.[Id]
	) AS [RankingSubquery]
WHERE [PeakRank] = 1
ORDER BY [Country], [PeakName]
