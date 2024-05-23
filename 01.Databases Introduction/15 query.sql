CREATE DATABASE Hotel

USE [Hotel]

CREATE TABLE [Employees](
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(40) NOT NULL,
	[LastName] NVARCHAR(40) NOT NULL,
	[Title] NVARCHAR(10),
	[Notes] NVARCHAR(300)
)

CREATE TABLE [Customers](
	[AccountNumber] VARCHAR(20) PRIMARY KEY,
	[FirstName] NVARCHAR(40) NOT NULL,
	[LastName] NVARCHAR(40) NOT NULL,
	[PhoneNumber] VARCHAR(15),
	[EmergencyName] NVARCHAR(40),
	[EmergencyNumber] VARCHAR(15),
	[Notes] NVARCHAR(300)
)

CREATE TABLE [RoomStatus](
	[RoomStatus] NVARCHAR(20) PRIMARY KEY,
	[Notes] NVARCHAR(300)
)

CREATE TABLE [RoomTypes](
	[RoomType] NVARCHAR(20) PRIMARY KEY,
	[Notes] NVARCHAR(300)
)

CREATE TABLE [BedTypes](
	[BedType] NVARCHAR(20) PRIMARY KEY,
	[Notes] NVARCHAR(300)
)

CREATE TABLE [Rooms](
	[RoomNumber] INT PRIMARY KEY,
	[RoomType] NVARCHAR(20) FOREIGN KEY REFERENCES [RoomTypes]([RoomType]) NOT NULL,
	[BedType] NVARCHAR(20) FOREIGN KEY REFERENCES [BedTypes]([BedType]) NOT NULL,
	[Rate] DECIMAL(4,1),
	[RoomStatus] NVARCHAR(20) FOREIGN KEY REFERENCES [RoomStatus]([RoomStatus]) NOT NULL,
	[Notes] NVARCHAR(300)
)

CREATE TABLE [Payments](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees]([Id]) NOT NULL,
	[PaymentDate] DATE NOT NULL,
	[AccountNumber] VARCHAR(20) FOREIGN KEY REFERENCES [Customers]([AccountNumber]) NOT NULL,
	[FirstDateOccupied] DATE NOT NULL,
	[LasttDateOccupied] DATE NOT NULL,
	[TotalDays] AS DATEDIFF(DAY, [FirstDateOccupied], [LasttDateOccupied]),
	[AmountCharged] DECIMAL(4,1) NOT NULL,
	[TaxRate] DECIMAL(2,2) NOT NULL,
	[TaxAmount] AS [AmountCharged] * [TaxRate],
	[PaymentTotal] AS [AmountCharged] + [AmountCharged] * [TaxRate],
	[Notes] NVARCHAR(300)
)

CREATE TABLE [Occupancies](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees]([Id]) NOT NULL,
	[DateOccupied] DATE NOT NULL,
	[AccountNumber] VARCHAR(20) FOREIGN KEY REFERENCES [Customers]([AccountNumber]) NOT NULL,
	[RoomNumber] INT FOREIGN KEY REFERENCES [Rooms]([RoomNumber]) NOT NULL,
	[RateApplied] DECIMAL(4,1),
	[PhoneCharge] DECIMAL(3,1),
	[Notes] NVARCHAR(300)
)

INSERT INTO [Employees]([FirstName],[LastName],[Title],[Notes])
	VALUES
	('Petar','Perov','Mr','THE BEST'),
	('GEORGI','GEORGIEV',NULL,'THE BEST AS WELL'),
	('DESISLAVA','GEORGIEVA','MRS',NULL)

INSERT INTO [Customers]([AccountNumber],[FirstName],[LastName],[PhoneNumber],[EmergencyName],[EmergencyNumber],[Notes])
	VALUES
	('BG3333NESHTOSI17', 'Pesho', 'Petrov', '0888888888', NULL, NULL, 'I SAM VOINUT E VOIN'),
	('BG3333NESHTOSI42', 'Stamo', 'Stamov', '0877777777', 'SOMEBODY', '0899999999', NULL),
	('BG3333NESHTOSI19', 'Kris', 'Georgiev', NULL, 'NOBODY', '0877777799', 'OK')

INSERT INTO [RoomStatus]([RoomStatus],[Notes])
	VALUES
	('FREE', 'AVAILABLE'),
	('TAKEN', 'SHORT TERM'),
	('RENTED', 'UNDER LONG TERM CONTRACT')

INSERT INTO [RoomTypes]([RoomType],[Notes])
	VALUES
	('SINGLE ROOM', 'FOR ONE PERSON'),
	('DOUBLE ROOM', 'FOR TWO PEOPLE'),
	('APPARTMENT', 'FOR FOUR PEOPLE')

INSERT INTO [BedTypes]([BedType],[Notes])
	VALUES
	('SINGLE BED', 'FOR ONE PERSON'),
	('DOUBLE BED', 'FOR TWO PEOPLE'),
	('KINGSIZE BED', 'BIGGER BED')

INSERT INTO [Rooms]([RoomNumber],[RoomType],[BedType],[Rate],[RoomStatus],[Notes])
	VALUES
	(101, 'APPARTMENT', 'KINGSIZE BED', 110.8, 'RENTED', 'FOR LONG TERM USE'),
	(201, 'SINGLE ROOM', 'SINGLE BED', 40.2, 'TAKEN', NULL),
	(301, 'DOUBLE ROOM', 'DOUBLE BED', 70.5, 'FREE', 'NOT CURRENTLY RENTED')

INSERT INTO [Payments]([EmployeeId], [PaymentDate], [AccountNumber], [FirstDateOccupied], [LasttDateOccupied], [AmountCharged], [TaxRate], [Notes])
	VALUES
	(1, '2024-03-21', 'BG3333NESHTOSI17', '2024-03-18', '2024-03-21', 210.5, 0.15, 'SOME NOTES'),
	(3, '2024-03-20', 'BG3333NESHTOSI42', '2024-03-17', '2024-03-20', 165.5, 0.17,  NULL),
	(2, '2024-03-18', 'BG3333NESHTOSI19', '2024-03-14', '2024-03-18', 182.5, 0.21, 'SOME MORE NOTES')

INSERT INTO [Occupancies]([EmployeeId], [DateOccupied], [AccountNumber], [RoomNumber], [RateApplied], [PhoneCharge])
	VALUES
	(2, '2024-03-19', 'BG3333NESHTOSI19', 201, 93.5, 12.3),
	(1, '2024-03-21', 'BG3333NESHTOSI17', 301, 42.5, 1.3),
	(3, '2024-03-20', 'BG3333NESHTOSI42', 101, 68.5, 5.3)