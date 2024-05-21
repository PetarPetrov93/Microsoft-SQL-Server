--[DirectorId] INT FOREIGN KEY REFERENCES [Directors]([Id]) NOT NULL,

CREATE DATABASE [CarRental]

USE [CarRental]

CREATE TABLE [Categories](
	[Id] INT PRIMARY KEY IDENTITY,
	[CategoryName] NVARCHAR(40) NOT NULL,
	[DailyRate] DECIMAL(4,1),
	[WeeklyRate] DECIMAL(4,1),
	[MonthlyRate] DECIMAL(4,1),
	[WeekendRate] DECIMAL(4,1)
)

CREATE TABLE [Cars](
	[Id] INT PRIMARY KEY IDENTITY,
	[PlateNumber] VARCHAR(10) NOT NULL,
	[Manufacturer] NVARCHAR(40) NOT NULL,
	[Model] NVARCHAR(80) NOT NULL,
	[CarYear] INT CHECK(LEN([CarYear]) = 4),
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]) NOT NULL,
	[Doors] INT,
	[Picture] VARBINARY(MAX) CHECK (DATALENGTH([Picture]) <= 5000000),
	[Condition] NVARCHAR(20),
	[Available] BIT NOT NULL
)

CREATE TABLE [Employees](
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(40) NOT NULL,
	[LastName] NVARCHAR(40) NOT NULL,
	[Title] NVARCHAR(10),
	[Notes] NVARCHAR(300), 
)

CREATE TABLE [Customers](
	[Id] INT PRIMARY KEY IDENTITY,
	[DriverLicenceNumber] INT NOT NULL,
	[FullName] NVARCHAR(120) NOT NULL,
	[Address] NVARCHAR(200),
	[City] NVARCHAR(80),
	[ZIPCode] NVARCHAR(10),
	[Notes] NVARCHAR(300), 
)

CREATE TABLE [RentalOrders](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees]([Id]) NOT NULL,
	[CustomerId] INT FOREIGN KEY REFERENCES [Customers]([Id]) NOT NULL,
	[CarId] INT FOREIGN KEY REFERENCES [Cars]([Id]) NOT NULL,
	[TankLevel] INT,
	[KilometrageStart] INT NOT NULL,
	[KilometrageEnd] INT NOT NULL,
	[TotalKilometrage] INT,
	[StartDate] DATE,
	[EndDate] DATE,
	[TotalDays] INT,
	[RateApplied] DECIMAL(4,1),
	[TaxRate] DECIMAL(4,1),
	[OrderStatus] NVARCHAR(10),
	[Notes] NVARCHAR(300),
)

INSERT INTO [Categories]([CategoryName],[DailyRate],[WeeklyRate],[MonthlyRate],[WeekendRate])
	VALUES
	('Car', 14.5, 80.9, 310, 17.2),
	('Bus', 16.5, 90.9, 410, 19.6),
	('Van', 15.6, 84.3, 360.5, 18)

INSERT INTO [Cars]([PlateNumber],[Manufacturer],[Model],[CarYear],[CategoryId],[Doors],[Condition],[Available])
	VALUES
	('BT 1718 BT', 'MERCEDES', 'E220', 2014, 1, 4, 'EXCELLENT', 0),
	('BT 4447 BT', 'PEUGEOT', 'PARTNER', 2018, 2, NULL, 'VERY GOOD', 1),
	('BT 6600 BT', 'IVECO', 'SOMETHING', 2004, 3,2, NULL, 1)

INSERT INTO [Employees]([FirstName],[LastName],[Title],[Notes])
	VALUES
	('Steven', 'Segal', 'Mr', 'TUFF GUY'),
	('Omar', 'Epps', NULL, 'Dr.'),
	('Mila', 'Kunis', 'Mrs', NULL)

INSERT INTO [Customers]([DriverLicenceNumber],[FullName],[Address],[City],[ZIPCode],[Notes])
	VALUES
	(1919191919, 'Ricardo Quaresma', 'St. Patrick, 24', 'Lisbon', 'L1S42', 'FORMER FOOTBALLER'),
	(1515151515, 'MARIA LIUSA', NULL, 'PARIS', 'L1S42', NULL),
	(1212121212, 'STEVEN SAVIC', 'FAIRLIGHT ROAD 44', 'LONDON', 'SW170JS', 'DOME GUY')

INSERT INTO [RentalOrders]([EmployeeId],[CustomerId],[CarId],[TankLevel],[KilometrageStart],[KilometrageEnd],[TotalKilometrage],[StartDate],[EndDate],[TotalDays],[RateApplied],[TaxRate],[OrderStatus],[Notes])
	VALUES
	(2, 3, 1, 60, 50000, 55000, 5000, '2024-03-15', '2024-03-20', 5, 310.5, 42.8, 'Finished', 'ok'),
	(1, 2, 3, 70, 150000, 155500, 5500, '2024-03-10', '2024-03-20', 10, 610.5, 72.8, 'dont know', NULL),
	(3, 1, 2, 50, 4000, 4500, 500, '2024-03-18', '2024-03-20', 2, 70.5, 21.8, 'no clue', 'I hope dughe accepts it cause I had no idea half of the time what was I doing')