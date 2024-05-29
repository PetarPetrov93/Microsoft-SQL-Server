CREATE DATABASE NationalTouristSitesOfBulgaria
GO
USE NationalTouristSitesOfBulgaria
GO

--Problem 1
CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Locations
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	Municipality VARCHAR(50),
	Province VARCHAR(50)
)

CREATE TABLE Sites
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL,
	LocationId INT FOREIGN KEY REFERENCES Locations(Id) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Establishment VARCHAR(15)
)

CREATE TABLE Tourists
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	Age INT CHECK(Age BETWEEN 0 AND 120) NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL,
	Nationality VARCHAR(30) NOT NULL,
	Reward VARCHAR(20)
)

CREATE TABLE SitesTourists
(
	TouristId INT FOREIGN KEY REFERENCES Tourists(Id),
	SiteId INT FOREIGN KEY REFERENCES Sites(Id),
	PRIMARY KEY(TouristId, SiteId)
)

CREATE TABLE BonusPrizes
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE TouristsBonusPrizes
(
	TouristId INT FOREIGN KEY REFERENCES Tourists(Id),
	BonusPrizeId INT FOREIGN KEY REFERENCES BonusPrizes(Id),
	PRIMARY KEY(TouristId, BonusPrizeId)
)

--Problem 2
INSERT INTO Tourists([Name], Age, PhoneNumber, Nationality, Reward)
	VALUES
		('Borislava Kazakova', 52, '+359896354244', 'Bulgaria', NULL),
		('Peter Bosh', 48, '+447911844141', 'UK', NULL),
		('Martin Smith', 29, '+353863818592', 'Ireland', 'Bronze badge'),
		('Svilen Dobrev', 49, '+359986584786', 'Bulgaria', 'Silver badge'),
		('Kremena Popova', 38, '+359893298604', 'Bulgaria', NULL)

INSERT INTO Sites([Name], LocationId, CategoryId, Establishment)
	VALUES
		('Ustra fortress', 90, 7, 'X'),
		('Karlanovo Pyramids', 65, 7, NULL),
		('The Tomb of Tsar Sevt', 63, 8, 'V BC'),
		('Sinite Kamani Natural Park', 17, 1, NULL),
		('St. Petka of Bulgaria – Rupite', 92, 6, '1994')

--Problem 3
UPDATE Sites
SET Establishment = '(not defined)'
WHERE Establishment IS NULL

--Problem 4
DELETE FROM TouristsBonusPrizes
WHERE BonusPrizeId = (SELECT Id
		FROM BonusPrizes
		WHERE [Name] = 'Sleeping bag')

DELETE FROM BonusPrizes
WHERE [Name] = 'Sleeping bag'

--Problem 5
SELECT [Name], Age, PhoneNumber, Nationality
FROM Tourists
ORDER BY Nationality, Age DESC, [Name]

--Problem 6
SELECT s.[Name], l.[Name], s.Establishment, c.[Name]
FROM Sites AS s
JOIN Locations AS l
ON s.LocationId = l.Id
JOIN Categories AS c
ON s.CategoryId = c.Id
ORDER BY c.[Name] DESC, l.[Name], s.[Name]

--Problem 7
SELECT l.Province, l.Municipality, l.[Name], COUNT(l.[Name]) AS CountOfSites
FROM Locations AS l
JOIN Sites AS s
ON l.Id = s.LocationId
WHERE l.Province = 'Sofia'
GROUP BY l.[Name], l.Province, l.Municipality
ORDER BY CountOfSites DESC, l.[Name]

--Problem 8
SELECT s.[Name], l.[Name], l.Municipality, l.Province, s.Establishment
FROM Sites AS s
JOIN Locations AS l
ON s.LocationId = l.Id
WHERE (s.[Name] NOT LIKE 'B%' AND s.[Name] NOT LIKE 'M%' AND s.[Name] NOT LIKE 'D%') AND Establishment LIKE '%BC%'
ORDER BY s.[Name]

--Problem 9
SELECT t.[Name], Age, PhoneNumber, Nationality,
CASE
	WHEN tb.BonusPrizeId IS NULL THEN '(no bonus prize)'
	ELSE b.Name
END
AS Reward
FROM Tourists AS t
LEFT JOIN TouristsBonusPrizes AS tb
ON t.Id = tb.TouristId
LEFT JOIN BonusPrizes AS b
ON tb.BonusPrizeId = b.Id
ORDER BY t.[Name]

--Problem 10
SELECT SUBSTRING(t.[Name], CHARINDEX(' ', t.[Name]) + 1, LEN(t.[Name]) - CHARINDEX(' ', t.[Name])) AS LastName, t.Nationality, t.Age, t.PhoneNumber
FROM Tourists AS t
JOIN SitesTourists AS st
ON t.Id = st.TouristId
JOIN Sites AS s
ON st.SiteId = s.Id
JOIN Categories AS c
ON s.CategoryId = c.Id
WHERE c.[Name] = 'History and archaeology'
GROUP BY t.[Name], t.Nationality, t.Age, t.PhoneNumber
ORDER BY LastName

--Problem 11
GO

CREATE FUNCTION udf_GetTouristsCountOnATouristSite (@Site VARCHAR(100))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(t.Id)
			FROM Sites AS s
			JOIN SitesTourists AS st
			ON s.Id = st.SiteId
			JOIN Tourists AS t
			ON st.TouristId = t.Id
			WHERE s.[Name] = @Site)
END

--Problem 12
GO

CREATE PROCEDURE usp_AnnualRewardLottery(@TouristName VARCHAR(50))
AS
BEGIN
	  SELECT t.[Name],
	  CASE
		WHEN COUNT(t.Id) >= 100 THEN 'Gold badge'
		WHEN COUNT(t.Id) >= 50 THEN 'Silver badge'
		WHEN COUNT(t.Id) >= 25 THEN 'Bronze badge'
		ELSE NULL
	  END AS Reward
	  FROM Tourists AS t
	  JOIN SitesTourists AS st
	  ON t.Id = st.TouristId
  	  WHERE t.[Name] = @TouristName
	  GROUP BY t.[Name]
END

GO

