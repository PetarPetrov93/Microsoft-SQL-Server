CREATE DATABASE Boardgames
GO
USE Boardgames
GO

--Problem 1
CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	StreetName VARCHAR(50) NOT NULL,
	StreetNumber INT NOT NULL,
	Town VARCHAR(30) NOT NULL,
	Country VARCHAR(50) NOT NULL,
	ZIP INT NOT NULL
)

CREATE TABLE Publishers
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) UNIQUE NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL,
	Website VARCHAR(40),
	Phone VARCHAR(20),
)

CREATE TABLE PlayersRanges
(
	Id INT PRIMARY KEY IDENTITY,
	PlayersMin INT NOT NULL,
	PlayersMax INT NOT NULL
)

CREATE TABLE Boardgames
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL,
	YearPublished INT NOT NULL,
	Rating DECIMAL(8,2) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	PublisherId INT FOREIGN KEY REFERENCES Publishers(Id) NOT NULL,
	PlayersRangeId INT FOREIGN KEY REFERENCES PlayersRanges(Id) NOT NULL,
)

CREATE TABLE Creators
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Email NVARCHAR(30) NOT NULL,
)

CREATE TABLE CreatorsBoardgames
(
	CreatorId INT FOREIGN KEY REFERENCES Creators(Id),
	BoardgameId INT FOREIGN KEY REFERENCES Boardgames(Id),
	PRIMARY KEY(CreatorId, BoardgameId)
)

--Problem 2
INSERT INTO Boardgames([Name], YearPublished, Rating, CategoryId, PublisherId, PlayersRangeId)
	VALUES
		('Deep Blue', 2019, 5.67, 1, 15, 7),
		('Paris', 2016, 9.78, 7, 1, 5),
		('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
		('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
		('One Small Step', 2019, 5.75, 5, 9, 2)

INSERT INTO Publishers([Name], AddressId, Website, Phone)
	VALUES
		('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
		('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
		('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')

--Problem 3
UPDATE PlayersRanges
SET PlayersMax = PlayersMax + 1
WHERE PlayersMax = 2 AND PlayersMin = 2

UPDATE Boardgames
SET [Name] = CONCAT([Name], 'V2')
WHERE YearPublished >= 2020

--Problem 4
DELETE FROM CreatorsBoardgames
WHERE BoardgameId IN (SELECT Id
					  FROM Boardgames
					  WHERE PublisherId IN (SELECT Id
										    FROM Publishers
										    WHERE AddressId IN (SELECT Id
																FROM Addresses
																WHERE Town LIKE 'L%')))

DELETE FROM Boardgames
WHERE PublisherId IN (SELECT Id
					  FROM Publishers
					  WHERE AddressId IN (SELECT Id
										 FROM Addresses
										 WHERE Town LIKE 'L%'))

DELETE FROM Publishers
WHERE AddressId IN (SELECT Id
					FROM Addresses
					WHERE Town LIKE 'L%')

DELETE FROM Addresses
WHERE Town LIKE 'L%'

--Problem 5
SELECT [Name], Rating
FROM Boardgames
ORDER BY YearPublished, [Name] DESC

--Problem 6
SELECT b.Id, b.[Name], b.YearPublished, c.[Name]
FROM Boardgames AS b
JOIN Categories AS c
ON b.CategoryId = c.Id
WHERE c.[Name] = 'Strategy Games' OR c.[Name] = 'Wargames'
ORDER BY YearPublished DESC

--Problem 7
SELECT c.Id, CONCAT_WS(' ', c.FirstName, c.LastName) AS CreatorName, c.Email
FROM Creators AS c
LEFT JOIN CreatorsBoardgames AS cb
ON c.Id = cb.CreatorId
WHERE cb.CreatorId IS NULL
ORDER BY CreatorName

--Problem 8
SELECT TOP(5) b.[Name], b.Rating, c.[Name]
FROM Boardgames AS b
JOIN PlayersRanges AS p
ON b.PlayersRangeId = p.Id
JOIN Categories AS c
ON b.CategoryId = c.Id
WHERE (b.Rating > 7.00 AND b.[Name] LIKE '%a%') OR (b.Rating > 7.50 AND p.PlayersMax - p.PlayersMin IN (2, 5))
ORDER BY b.[Name], b.Rating DESC

--Problem 9
SELECT CONCAT_WS(' ', c.FirstName, c.LastName) AS FullName, c.Email, MAX(b.Rating) AS Rating
FROM Creators AS c
JOIN CreatorsBoardgames AS cb
ON c.Id = cb.CreatorId
JOIN Boardgames AS b
ON cb.BoardgameId = b.Id
WHERE Email LIKE '%.com'
GROUP BY c.FirstName, c.LastName, c.Email
ORDER BY FullName

--Problem 10
SELECT c.LastName, CEILING(AVG(b.Rating)) AS AverageRating, p.[Name] AS PublisherName
FROM Creators AS c
JOIN CreatorsBoardgames AS cb
ON c.Id = cb.CreatorId
JOIN Boardgames AS b
ON cb.BoardgameId = b.Id
JOIN Publishers AS p
ON b.PublisherId = p.Id
WHERE p.[Name] = 'Stonemaier Games'
GROUP BY c.LastName, p.[Name]
ORDER BY AVG(b.Rating) DESC

--Problem 11
GO

CREATE FUNCTION udf_CreatorWithBoardgames(@name NVARCHAR(30))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(c.Id)
			FROM Creators AS c
			JOIN CreatorsBoardgames AS cb
			ON c.Id = cb.CreatorId
			WHERE c.FirstName = @name)
END

--Problem 12
GO

CREATE PROCEDURE usp_SearchByCategory(@category VARCHAR(50))
AS
BEGIN
	SELECT b.[Name], b.YearPublished, b.Rating, c.[Name], p.[Name], CONCAT_WS(' ', pr.PlayersMin, 'people') AS MinPlayers, CONCAT_WS(' ', pr.PlayersMax, 'people') AS MaxPlayers
	FROM Categories AS c
	JOIN Boardgames AS b
	ON c.Id = b.CategoryId
	JOIN Publishers AS p
	ON b.PublisherId = p.Id
	JOIN PlayersRanges AS pr
	ON b.PlayersRangeId = pr.Id
	WHERE c.[Name] = @category
	ORDER BY p.[Name], b.YearPublished DESC
END