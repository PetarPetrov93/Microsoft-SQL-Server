CREATE DATABASE [Movies]

USE [Movies]

CREATE TABLE [Directors](
	[Id] INT PRIMARY KEY  IDENTITY,
	[DirectorName] NVARCHAR(80) NOT NULL,
	[Notes] NVARCHAR(MAX)
)

CREATE TABLE [Genres](
	[Id] INT PRIMARY KEY IDENTITY,
	[GenreName] NVARCHAR(50) NOT NULL,
	[Notes] NVARCHAR(MAX)
)

CREATE TABLE [Categories](
	[Id] INT PRIMARY KEY IDENTITY,
	[CategoryName] NVARCHAR(50) NOT NULL,
	[Notes] NVARCHAR(MAX)
)

CREATE TABLE [Movies](
	[Id] INT PRIMARY KEY IDENTITY,
	[Title] NVARCHAR(150) NOT NULL,
	[DirectorId] INT FOREIGN KEY REFERENCES [Directors]([Id]) NOT NULL,
	[CopyrightYear] INT CHECK (LEN([CopyrightYear]) = 4),
	[Length] INT,
	[GenreId] INT FOREIGN KEY REFERENCES [Genres]([Id]) NOT NULL,
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories](Id) NOT NULL,
	[Rating] DECIMAL(3,1),
	[Notes] NVARCHAR(MAX)	
)

INSERT INTO [Directors]([DirectorName],[Notes])
	VALUES
	('Director1', 'Some notes'),
	('Director2', 'Other notes'),
	('Director3', 'nO notes'),
	('Director4', NULL),
	('Director5', 'Some more notes')

INSERT INTO [Genres]([GenreName],[Notes])
	VALUES
	('Comedy', 'Some notes'),
	('Horror', 'Other notes'),
	('Thriller', NULL),
	('Adventure', NULL),
	('Romantic', 'Some more notes')

INSERT INTO [Categories]([CategoryName],[Notes])
	VALUES
	('AllAges', 'Some notes'),
	('Over12', 'Other notes'),
	('Over14', 'And more notes'),
	('Over16', 'Something else'),
	('Over18', 'Some more notes')

INSERT INTO [Movies]([Title],[DirectorId],[CopyrightYear],[Length],[GenreId],[CategoryId],[Rating],[Notes])
	VALUES
	('Movie1', 3, 2024, 90, 2, 5, 7.5, 'NEW MOVIE'),
	('Movie2', 1, 2017, 110, 3, 2, NULL, 'OLD MOVIE'),
	('Movie3', 4, NULL, 80, 4, 3, 9.9, 'INTERESTING MOVIE'),
	('Movie4', 2, 2021, NULL, 5, 4, 10.0, NULL),
	('Movie5', 5, 2020, 92, 1, 1, 9.9, 'FUN MOVIE')