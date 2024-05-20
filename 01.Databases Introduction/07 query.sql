CREATE TABLE [People](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(200) NOT NULL,
	[Picture] VARBINARY(MAX) CHECK (DATALENGTH([Picture]) <= 2000000),
	[Height] DECIMAL(3, 2),
	[Weight] DECIMAL(5, 2),
	[Gender] CHAR(1) NOT NULL CHECK([Gender] = 'm' OR [Gender] = 'f'),
	[Birthdate] DATE NOT NULL,
	[Biography] NVARCHAR(MAX)
)

INSERT INTO [People]([Name],[Height],[Weight],[Gender],[Birthdate],[Biography])
	VALUES
	('Petar', 1.68, 63.2, 'm', '1993-12-06', 'About me..'),
	('Georgi', 1.65, 79.1, 'm', '1963-09-19', 'About him..'),
	('Desislava', 1.63, 48.6, 'f', '1972-06-29', 'About her..'),
	('Kristina', 1.59, 50.2, 'f', '1993-02-13', NULL),
	('Aleks', NULL, 80.2, 'm', '1996-05-28', NULL)