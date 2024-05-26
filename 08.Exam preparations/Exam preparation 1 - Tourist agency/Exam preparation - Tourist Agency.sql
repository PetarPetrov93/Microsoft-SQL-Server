GO
CREATE DATABASE TouristAgency
GO
USE TouristAgency
GO

--Problem 1
CREATE TABLE Countries
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50)
)

CREATE TABLE Destinations
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	CountryId INT FOREIGN KEY REFERENCES Countries(Id) NOT NULL
)

CREATE TABLE Rooms
(
	Id INT PRIMARY KEY IDENTITY,
	[Type] VARCHAR(40) NOT NULL,
	Price DECIMAL(18, 2) NOT NULL,
	BedCount INT CHECK(Bedcount > 0 AND BedCount <= 10) NOT NULL
)

CREATE TABLE Hotels
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	DestinationId INT FOREIGN KEY REFERENCES Destinations(Id) NOT NULL
)

CREATE TABLE Tourists
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(80) NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL,
	Email VARCHAR(80),
	CountryId INT FOREIGN KEY REFERENCES Countries(Id) NOT NULL
)

CREATE TABLE Bookings
(
	Id INT PRIMARY KEY IDENTITY,
	ArrivalDate DATETIME2 NOT NULL,
	DepartureDate DATETIME2 NOT NULL,
	AdultsCount INT CHECK(AdultsCount >= 1 AND AdultsCount <= 10) NOT NULL,
	ChildrenCount INT CHECK(ChildrenCount >= 0 AND ChildrenCount <= 9) NOT NULL,
	TouristId INT FOREIGN KEY REFERENCES Tourists(Id) NOT NULL,
	HotelId INT FOREIGN KEY REFERENCES Hotels(Id) NOT NULL,
	RoomId INT FOREIGN KEY REFERENCES Rooms(Id) NOT NULL,
)

CREATE TABLE HotelsRooms
(
	HotelId INT FOREIGN KEY REFERENCES Hotels(Id),
	RoomId INT FOREIGN KEY REFERENCES Rooms(Id),
	PRIMARY KEY(HotelId, RoomId)
)

--Problem 2
INSERT INTO Tourists([Name], PhoneNumber, Email, CountryId)
	VALUES
		('John Rivers', '653-551-1555', 'john.rivers@example.com', 6),
		('Adeline Aglaé', '122-654-8726', 'adeline.aglae@example.com', 2),
		('Sergio Ramirez', '233-465-2876', 's.ramirez@example.com', 3),
		('Johan Müller', '322-876-9826', 'j.muller@example.com', 7),
		('Eden Smith', '551-874-2234', 'eden.smith@example.com', 6)

INSERT INTO Bookings(ArrivalDate, DepartureDate, AdultsCount, ChildrenCount, TouristId, HotelId, RoomId)
	VALUES
		('2024-03-01', '2024-03-11', 1, 0, 21, 3, 5),
		('2023-12-28', '2024-01-06', 2, 1, 23, 13, 3),
		('2023-11-15', '2023-11-20', 1, 2, 23, 19, 7),
		('2023-12-05', '2023-12-09', 4, 0, 24, 6, 4),
		('2024-05-01', '2024-05-07', 6, 0, 25, 14, 6)

--Problem 3
UPDATE Bookings
SET DepartureDate = DATEADD(DAY, 1, DepartureDate)
WHERE MONTH(DepartureDate) = 12

UPDATE Tourists
SET Email = NULL
WHERE Email LIKE '%MA%'

--Problem 4
DELETE FROM Bookings
WHERE TouristId IN 
			(
				SELECT Id
				FROM Tourists
				WHERE [Name] LIKE '%Smith'
			)

DELETE FROM Tourists
WHERE [Name] LIKE '%Smith'

GO

--Problem 5
SELECT FORMAT(b.ArrivalDate, 'yyyy-MM-dd') AS ArrivalDate,
		b.AdultsCount, b.ChildrenCount
FROM Bookings AS b
JOIN Rooms AS r
ON b.RoomId = r.Id
ORDER BY r.Price DESC, ArrivalDate

--Problem 6
SELECT h.Id, h.Name
FROM Hotels AS h
JOIN HotelsRooms AS hr
ON h.Id = HR.HotelId
JOIN Rooms AS r
ON hr.RoomId = r.Id
JOIN Bookings AS b
ON h.Id = b.HotelId
WHERE r.Type = 'VIP Apartment'
GROUP BY h.Id, h.Name
ORDER BY COUNT(h.Id) DESC

--Problem 7
SELECT t.Id, t.Name, t.PhoneNumber
FROM Tourists AS t
LEFT JOIN Bookings AS b
ON t.Id = b.TouristId
WHERE b.TouristId IS NULL
ORDER BY t.Name

--Problem 8
SELECT TOP(10) h.Name, d.Name, c.Name
FROM Bookings AS b
JOIN Hotels AS h
ON b.HotelId = h.Id
JOIN Destinations AS d
ON h.DestinationId = d.Id
JOIN Countries AS c
ON d.CountryId = c.Id
WHERE b.ArrivalDate < '2023-12-31' AND h.Id % 2 = 1
ORDER BY c.Name, b.ArrivalDate

--Problem 9
SELECT h.Name, r.Price
FROM Tourists AS t
JOIN Bookings AS b
ON t.Id = b.TouristId
JOIN Hotels AS h
ON b.HotelId = h.Id
JOIN Rooms AS r
ON b.RoomId = r.Id
WHERE t.Name NOT LIKE '%EZ'
ORDER BY r.Price DESC

--Problem 10
SELECT h.Name,
	SUM(r.Price * DATEDIFF(DAY, b.ArrivalDate, b.DepartureDate)) AS HotelRevenue
FROM Hotels AS h
JOIN Bookings AS b
ON b.HotelId = h.Id
JOIN Rooms AS r
ON b.RoomId = r.Id
GROUP BY h.Name
ORDER BY HotelRevenue DESC

--Problem 11
GO

CREATE FUNCTION udf_RoomsWithTourists(@name VARCHAR(40))
RETURNS INT
AS
BEGIN
	DECLARE @total INT 
	SET @total = (SELECT SUM(b.AdultsCount + b.ChildrenCount)
			FROM Rooms AS r
			JOIN Bookings AS b
			ON r.Id = b.RoomId
			JOIN Tourists AS t
			ON b.TouristId = t.Id
			WHERE r.Type = @name)
	RETURN @total
END

--Problem 12
GO

CREATE PROCEDURE usp_SearchByCountry(@country NVARCHAR(50))
AS
BEGIN
	SELECT t.Name, t.PhoneNumber, t.Email, Count(b.Id) AS CountOfBookings
	FROM Tourists AS t
	JOIN Countries AS c
	ON t.CountryId = c.Id
	JOIN Bookings AS b
	ON b.TouristId = t.Id
	WHERE c.Name = @country
	GROUP BY b.TouristId, t.Name, t.PhoneNumber, t.Email
	ORDER BY t.Name, CountOfBookings
END

GO