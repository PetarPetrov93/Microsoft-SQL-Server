GO
USE [Orders]
GO

-- ROBLEM 18 ADDING DAYS AND MONTHS FUNCTION
SELECT [ProductName], [OrderDate],
	DATEADD(DAY, 3, [OrderDate]) AS [Pay Due],
	DATEADD(MONTH, 1, [OrderDate]) AS [Delibery Due]
FROM [Orders]

--PROBLEM 19
CREATE TABLE [People](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(40) NOT NULL,
	[Birthdate] DATETIME2 NOT NULL
)

INSERT INTO [People]
	VALUES
		('Victor', '2000-12-07 00:00:00.000'),
		('Steven', '1992-09-10 00:00:00.000'),
		('Stephen', '1910-09-19 00:00:00.000'),
		('John', '2010-01-06 00:00:00.000')

SELECT [Name],
	DATEDIFF(YEAR, [Birthdate], GETDATE()) AS [Age in Years,],
	DATEDIFF(MONTH, [Birthdate], GETDATE()) AS [Age in Months,],
	DATEDIFF(DAY, [Birthdate], GETDATE()) AS [Age in Days,],
	DATEDIFF(MINUTE, [Birthdate], GETDATE()) AS [Age in Minutes,]
FROM [People]