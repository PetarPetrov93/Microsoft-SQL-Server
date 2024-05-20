CREATE TABLE [Users](
	[Id] INT PRIMARY KEY IDENTITY,
	[Username] VARCHAR(30) NOT NULL UNIQUE,
	[Password] VARCHAR(26) NOT NULL,
	[ProfilePicture] VARBINARY(MAX) CHECK(DATALENGTH([ProfilePicture]) <= 900000),
	[LastLoginTime] DATETIME2,
	[IsDeleted] BIT DEFAULT(0)
)

INSERT INTO [Users]([Username], [Password])
	VALUES
	('User1', 'PASSUSER1'),
	('User2', 'PASSUSER2'),
	('User3', 'PASSUSER3'),
	('User4', 'PASSUSER4'),
	('User5', 'PASSUSER5')