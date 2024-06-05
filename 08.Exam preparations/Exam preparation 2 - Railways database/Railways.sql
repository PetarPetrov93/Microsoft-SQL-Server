CREATE DATABASE RailwaysDb
GO
USE RailwaysDb
GO

--Problem 1
CREATE TABLE Passengers
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(80) NOT NULL
)


CREATE TABLE Towns
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL
)


CREATE TABLE RailwayStations
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	TownId INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL
)

CREATE TABLE Trains
(
	Id INT PRIMARY KEY IDENTITY,
	HourOfDeparture VARCHAR(5) NOT NULL,
	HourOfArrival VARCHAR(5) NOT NULL,
	DepartureTownId INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL,
	ArrivalTownId INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL
)

CREATE TABLE TrainsRailwayStations
(
	TrainId INT FOREIGN KEY REFERENCES Trains(Id),
	RailwayStationId INT FOREIGN KEY REFERENCES RailwayStations(Id),
	PRIMARY KEY(TrainId, RailwayStationId)
)

CREATE TABLE MaintenanceRecords
(
	Id INT PRIMARY KEY IDENTITY,
	DateOfMaintenance DATE NOT NULL,
	Details VARCHAR(2000) NOT NULL,
	TrainId INT FOREIGN KEY REFERENCES Trains(Id) NOT NULL
)

CREATE TABLE Tickets
(
	Id INT PRIMARY KEY IDENTITY,
	Price DECIMAL(5,2) NOT NULL,
	DateOfDeparture DATE NOT NULL,
	DateOfArrival DATE NOT NULL,
	TrainId INT FOREIGN KEY REFERENCES Trains(Id) NOT NULL,
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL
)

--Problem 2
INSERT INTO Trains(HourOfDeparture, HourOfArrival, DepartureTownId, ArrivalTownId)
	VALUES
		('07:00', '19:00', 1, 3),
		('08:30', '20:30', 5, 6),
		('09:00', '21:00', 4, 8),
		('06:45', '03:55', 27, 7),
		('10:15', '12:15', 15, 5)

INSERT INTO TrainsRailwayStations(TrainID, RailwayStationId)
	VALUES
		(36, 1), (37, 60), (39, 3),
		(36, 4), (37, 16), (39, 31),
		(36, 31), (38, 10), (39, 19),
		(36, 57), (38, 50), (40, 41),
		(36, 7), (38, 52), (40, 7),
		(37, 13), (38, 22), (40, 52),
		(37, 54), (39, 68), (40, 13)

INSERT INTO Tickets(Price, DateOfDeparture, DateOfArrival, TrainId, PassengerId)
	VALUES
		('90.00', '2023-12-01', '2023-12-01', 36, 1),
		('115.00', '2023-08-02', '2023-08-02', 37, 2),
		('160.00', '2023-08-03', '2023-08-03', 38, 3),
		('255.00', '2023-09-01', '2023-09-02', 39, 21),
		('95.00', '2023-09-02', '2023-09-03', 40, 22)

--Problem 3
UPDATE Tickets
SET DateOfDeparture = DATEADD(DAY, 7, DateOfDeparture),
	DateOfArrival = DATEADD(DAY, 7, DateOfArrival)
WHERE MONTH(DateOfDeparture) > 10

--Problem 4
DELETE FROM TrainsRailwayStations
WHERE TrainID = 
	   (SELECT tr.Id
		FROM Trains AS tr
		JOIN Towns AS tn
		ON tr.DepartureTownId = tn.Id
		WHERE tn.Name = 'Berlin')

DELETE FROM MaintenanceRecords
WHERE TrainID = 
	   (SELECT tr.Id
		FROM Trains AS tr
		JOIN Towns AS tn
		ON tr.DepartureTownId = tn.Id
		WHERE tn.Name = 'Berlin')

DELETE FROM Tickets
WHERE TrainID = 
	   (SELECT tr.Id
		FROM Trains AS tr
		JOIN Towns AS tn
		ON tr.DepartureTownId = tn.Id
		WHERE tn.Name = 'Berlin')

DELETE FROM Trains
WHERE Id = 
	   (SELECT tr.Id
		FROM Trains AS tr
		JOIN Towns AS tn
		ON tr.DepartureTownId = tn.Id
		WHERE tn.Name = 'Berlin')

--Problem 5
SELECT DateOfDeparture, Price AS TicketPrice
FROM Tickets
ORDER BY Price, DateOfDeparture DESC

--Problem 6
SELECT p.Name, t.Price, t.DateOfDeparture, t.TrainId
FROM Tickets AS t
JOIN Passengers AS p
ON t.PassengerId = p.Id
ORDER BY t.Price DESC, p.Name

--Problem 7
SELECT t.Name, r.Name
FROM RailwayStations AS r
LEFT JOIN TrainsRailwayStations AS trs
ON r.Id = trs.RailwayStationId
JOIN Towns AS t
ON r.TownId = t.Id
WHERE trs.RailwayStationId IS NULL
ORDER BY t.Name, r.Name

--Problem 8
SELECT TOP(3) tk.TrainId, t.HourOfDeparture, tk.Price AS TicketPrice, tn.Name AS Destination
FROM Trains AS t
JOIN Towns AS tn
ON t.ArrivalTownId = tn.Id
JOIN Tickets AS tk
ON tk.TrainId = t.Id
WHERE (CONVERT(TIME, t.HourOfDeparture) >= CONVERT(TIME, '08:00') AND CONVERT(TIME, t.HourOfDeparture) < CONVERT(TIME, '08:59')) AND tk.Price > 50
ORDER BY tk.Price

--Problem 9
SELECT tn.Name, COUNT(p.Id) AS PassengersCount
FROM Passengers AS p
JOIN Tickets AS tk
ON p.Id = tk.PassengerId
JOIN Trains AS tr
ON tk.TrainId = tr.Id
JOIN Towns AS tn
ON tr.ArrivalTownId = tn.Id
WHERE tk.Price > 76.99
GROUP BY tn.Name
ORDER BY tn.Name

--Problem 10
SELECT m.TrainId, tn.Name, m.Details
FROM Trains AS tr
JOIN MaintenanceRecords AS m
ON m.TrainId = tr.Id
JOIN Towns AS tn
ON tr.DepartureTownId = tn.Id
WHERE m.Details LIKE '%inspection%'
ORDER BY TrainId

--Problem 11
GO

CREATE FUNCTION udf_TownsWithTrains(@name VARCHAR(30))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(tr.Id)
			FROM Trains AS tr
			JOIN Towns AS tna
			ON tna.Id = tr.ArrivalTownId
			JOIN Towns AS tnd
			ON tnd.Id = tr.DepartureTownId
			WHERE tna.Name = @name OR tnd.Name = @name)
END

--Problem 12
GO

CREATE PROCEDURE usp_SearchByTown(@townName VARCHAR(30))
AS
BEGIN
	SELECT p.Name, tk.DateOfDeparture, tr.HourOfDeparture
	FROM Towns AS tn
	JOIN Trains AS tr
	ON tn.Id = tr.ArrivalTownId
	JOIN Tickets AS tk
	ON tr.Id = tk.TrainId
	JOIN Passengers AS p
	ON p.Id = tk.PassengerId
	WHERE tn.Name = @townName
	ORDER BY tk.DateOfDeparture DESC, p.Name
END

GO
