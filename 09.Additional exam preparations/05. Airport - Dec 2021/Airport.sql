CREATE DATABASE Airport
GO
USE Airport
GO

--Problem 1
CREATE TABLE Passengers
(
	Id INT PRIMARY KEY IDENTITY,
	FullName VARCHAR(100) UNIQUE NOT NULL,
	Email VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Pilots
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) UNIQUE NOT NULL,
	LastName VARCHAR(30) UNIQUE NOT NULL,
	Age TINYINT CHECK (Age BETWEEN 21 AND 62) NOT NULL,
	Rating FLOAT CHECK (Rating BETWEEN 0.0 AND 10.0)
)

CREATE TABLE AircraftTypes
(
	Id INT PRIMARY KEY IDENTITY,
	TypeName VARCHAR(30) UNIQUE NOT NULL
)

CREATE TABLE Aircraft
(
	Id INT PRIMARY KEY IDENTITY,
	Manufacturer VARCHAR(25) NOT NULL,
	Model VARCHAR(30) NOT NULL,
	[Year] INT NOT NULL,
	FlightHours INT,
	Condition CHAR NOT NULL,
	TypeId INT FOREIGN KEY REFERENCES AircraftTypes(Id) NOT NULL
)

CREATE TABLE PilotsAircraft
(
	AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id),
	PilotId INT FOREIGN KEY REFERENCES Pilots(Id),
	PRIMARY KEY(AircraftId, PilotId)
)

CREATE TABLE Airports
(
	Id INT PRIMARY KEY IDENTITY,
	AirportName VARCHAR(70) UNIQUE NOT NULL,
	Country VARCHAR(100) UNIQUE NOT NULL,
)

CREATE TABLE FlightDestinations
(
	Id INT PRIMARY KEY IDENTITY,
	AirportId INT FOREIGN KEY REFERENCES Airports(Id) NOT NULL,
	[Start] DATETIME NOT NULL,
	AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL,
	TicketPrice DECIMAL(18, 2) DEFAULT(15) NOT NULL
)

--Problem 2
INSERT INTO Passengers (FullName, Email)
SELECT CONCAT_WS(' ', FirstName, LastName) AS FullName,
	   CONCAT(FirstName, LastName, '@gmail.com') AS Email
FROM Pilots
WHERE Id BETWEEN 5 AND 15

--Problem 3
UPDATE Aircraft
SET Condition = 'A'
WHERE Condition IN ('C', 'B') AND (FlightHours IS NULL OR FlightHours <= 100) AND [Year] >= 2013

--Problem 4
DELETE FROM FlightDestinations
WHERE PassengerId IN 
					(SELECT Id
					 FROM Passengers
					 WHERE LEN(FullName) <= 10)

DELETE FROM Passengers
WHERE Id IN (SELECT Id
			FROM Passengers
			WHERE LEN(FullName) <= 10)

--Problem 5
SELECT Manufacturer, Model, FlightHours, Condition
FROM Aircraft
ORDER BY FlightHours DESC

--Problem 6
SELECT p.FirstName, p.LastName, a.Manufacturer, a.Model, a.FlightHours
FROM Pilots AS p
JOIN PilotsAircraft AS ap
ON p.Id = ap.PilotId
JOIN Aircraft AS a
ON ap.AircraftId = a.Id
WHERE a.FlightHours IS NOT NULL AND a.FlightHours < 304
ORDER BY a.FlightHours DESC, p.FirstName

--Problem 7
SELECT TOP(20) d.Id, d.[Start], p.FullName, a.AirportName, d.TicketPrice
FROM FlightDestinations AS d
JOIN Passengers AS p
ON d.PassengerId = p.Id
JOIN Airports AS a
ON d.AirportId = a.Id
WHERE DAY(d.[Start]) % 2 = 0
ORDER BY d.TicketPrice DESC, a.AirportName

--Problem 8
SELECT *
FROM (SELECT a.Id AS AircraftId, a.Manufacturer, a.FlightHours, COUNT(d.Id) AS FlightDestinationsCount, ROUND(AVG(d.TicketPrice), 2) AS AvgPrice
	  FROM Aircraft AS a
	  JOIN FlightDestinations AS d
	  ON a.Id = d.AircraftId
	  GROUP BY a.Id, a.Manufacturer, a.FlightHours) 
	  AS Subquery
WHERE FlightDestinationsCount >= 2
ORDER BY FlightDestinationsCount DESC, AircraftId

--Problem 9
SELECT *
FROM (SELECT p.FullName AS FullName, COUNT(d.AircraftId) AS CountOfAircraft, SUM(d.TicketPrice) AS TotalPayed
	  FROM Passengers AS p
	  JOIN FlightDestinations AS d
	  ON p.Id = d.PassengerId
	  JOIN Aircraft AS a
	  ON d.AircraftId = a.Id
	  GROUP BY p.FullName)
	  AS Subquery
WHERE CountOfAircraft >= 2 AND SUBSTRING(FullName,2,1) LIKE 'a'
ORDER BY FullName

--Problem 10
SELECT a.AirportName, d.[Start] AS DayTime, d.TicketPrice, p.FullName, ac.Manufacturer, ac.Model
FROM FlightDestinations AS d
JOIN Airports AS a
ON d.AirportId = a.Id
JOIN Passengers AS p
ON d.PassengerId = p.Id
JOIN Aircraft AS ac
ON d.AircraftId = ac.Id
WHERE (CONVERT(TIME, d.[Start]) BETWEEN '6:00' AND '20:00') AND (d.TicketPrice > 2500)
ORDER BY ac.Model

--Problem 11
GO

CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(d.Id)
		    FROM Passengers AS p
			JOIN FlightDestinations AS d
			ON p.Id = d.PassengerId
			WHERE p.Email = @email)
END

--Problem 12
GO

CREATE PROCEDURE usp_SearchByAirportName(@airportName VARCHAR(70))
AS
BEGIN
	SELECT a.AirportName, p.FullName,
	CASE 
		WHEN d.TicketPrice <= 400 THEN 'Low'
		WHEN d.TicketPrice > 400 AND D.TicketPrice <= 1500 THEN 'Medium'
		ELSE 'High' --WHEN d.TicketPrice > 1500 THEN 'High' - ALTERNATIVELY IT CAN ALSO BE DONE WITH ANOTHER WHEN
	END AS LevelOfTickerPrice,
	ac.Manufacturer, ac.Condition, t.TypeName
	FROM Airports AS a
	JOIN FlightDestinations AS d
	ON a.Id = d.AirportId
	JOIN Passengers AS p
	ON d.PassengerId = p.Id
	JOIN Aircraft AS ac
	ON d.AircraftId = ac.Id
	JOIN AircraftTypes AS t
	ON ac.TypeId = t.Id
	WHERE a.AirportName = @airportName
	ORDER BY ac.Manufacturer, p.FullName
END

GO