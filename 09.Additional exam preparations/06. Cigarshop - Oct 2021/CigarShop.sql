CREATE DATABASE CigarShop
GO
USE CigarShop
GO

--Problem 1
CREATE TABLE Sizes
(
	Id INT PRIMARY KEY IDENTITY,
	[Length] INT CHECK([Length] BETWEEN 10 AND 25) NOT NULL,
	RingRange DECIMAL(18, 2) CHECK(RingRange BETWEEN 1.5 AND 7.5) NOT NULL
)

CREATE TABLE Tastes
(
	Id INT PRIMARY KEY IDENTITY,
	TasteType VARCHAR(20) NOT NULL,
	TasteStrength VARCHAR(15) NOT NULL,
	ImageURL NVARCHAR(100) NOT NULL,
)

CREATE TABLE Brands
(
	Id INT PRIMARY KEY IDENTITY,
	BrandName VARCHAR(20) UNIQUE NOT NULL,
	BrandDescription VARCHAR(MAX),
)

CREATE TABLE Cigars
(
	Id INT PRIMARY KEY IDENTITY,
	CigarName VARCHAR(80) NOT NULL,
	BrandId INT FOREIGN KEY REFERENCES Brands(Id) NOT NULL,
	TastId INT FOREIGN KEY REFERENCES Tastes(Id) NOT NULL, --WRONG NAME OF THE COLUMN - HAS TO BE TasteId BUT LEAVING IT FOR JUDGE!
	SizeId INT FOREIGN KEY REFERENCES Sizes(Id) NOT NULL,
	PriceForSingleCigar DECIMAL(18,2) NOT NULL,
	ImageURL NVARCHAR(100) NOT NULL,
)

CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	Town VARCHAR(30) NOT NULL,
	Country VARCHAR(30) NOT NULL,
	Streat VARCHAR(100) NOT NULL,
	ZIP VARCHAR(20) NOT NULL,
)

CREATE TABLE Clients
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Email NVARCHAR(50) NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL,
)

CREATE TABLE ClientsCigars
(
	ClientId INT FOREIGN KEY REFERENCES Clients(Id),
	CigarId INT FOREIGN KEY REFERENCES Cigars(Id)
	PRIMARY KEY (ClientId, CigarId)
)

--Problem 2
INSERT INTO Cigars (CigarName, BrandId, TastId, SizeId, PriceForSingleCigar, ImageURL)
	VALUES
		('COHIBA ROBUSTO', 9, 1, 5, 15.50, 'cohiba-robusto-stick_18.jpg'),
		('COHIBA SIGLO I', 9, 1, 10, 410.00, 'cohiba-siglo-i-stick_12.jpg'),
		('HOYO DE MONTERREY LE HOYO DU MAIRE', 14, 5, 11, 7.50, 'hoyo-du-maire-stick_17.jpg'),
		('HOYO DE MONTERREY LE HOYO DE SAN JUAN', 14, 4, 15, 32.00, 'hoyo-de-san-juan-stick_20.jpg'),
		('TRINIDAD COLONIALES', 2, 3, 8, 85.21, 'trinidad-coloniales-stick_30.jpg')

INSERT INTO Addresses (Town, Country, Streat, ZIP)
	VALUES
		('Sofia', 'Bulgaria', '18 Bul. Vasil levski', '1000'),
		('Athens', 'Greece', '4342 McDonald Avenue', '10435'),
		('Zagreb', 'Croatia', '4333 Lauren Drive', '10000')

--Problem 3
UPDATE Cigars
SET PriceForSingleCigar = PriceForSingleCigar + (PriceForSingleCigar * 0.2) -- OR PriceForSingleCigar * 1.2
WHERE TastId IN 
			  (SELECT Id
			   FROM Tastes
			   WHERE TasteType = 'Spicy')

UPDATE Brands
SET BrandDescription = 'New description'
WHERE BrandDescription IS NULL

--Problem 4
DELETE FROM Clients
WHERE AddressId IN 
				  (SELECT Id
				   FROM Addresses
				   WHERE Country LIKE 'C%')

DELETE FROM Addresses
WHERE Country LIKE 'C%'

--Problem 5
SELECT CigarName, PriceForSingleCigar, ImageURL
FROM Cigars
ORDER BY PriceForSingleCigar, CigarName DESC

--Problem 6
SELECT c.Id, c.CigarName, c.PriceForSingleCigar, t.TasteType, t.TasteStrength
FROM Cigars AS c
JOIN Tastes AS t
ON c.TastId = t.Id
WHERE t.TasteType IN ('Earthy', 'Woody')
ORDER BY c.PriceForSingleCigar DESC

--Problem 7
SELECT cl.Id, CONCAT_WS(' ', cl.FirstName, cl.LastName) AS ClientName, cl.Email
FROM Clients AS cl
LEFT JOIN ClientsCigars AS cc
ON cl.Id = cc.ClientId
WHERE cc.CigarId IS NULL
ORDER BY ClientName

--Problem 8
SELECT TOP(5) c.CigarName, c.PriceForSingleCigar, c.ImageURL
FROM Cigars AS c
JOIN Sizes AS s
ON c.SizeId = s.Id
WHERE s.[Length] >= 12 AND (c.CigarName LIKE '%ci%' OR c.PriceForSingleCigar > 50.0) AND s.RingRange > 2.55
ORDER BY c.CigarName, c.PriceForSingleCigar DESC

--Problem 9
SELECT CONCAT_WS(' ', c.FirstName, c.LastName) AS FullName, a.Country, a.ZIP, CONCAT('$',MAX(cg.PriceForSingleCigar)) AS CigarPrice
FROM Clients AS c
JOIN Addresses AS a
ON c.AddressId = a.Id
JOIN ClientsCigars AS cc
ON c.Id = cc.ClientId
JOIN Cigars AS cg
ON cc.CigarId = cg.Id
WHERE PATINDEX('%[^0-9]%', a.ZIP) = 0
GROUP BY c.Id, c.FirstName, c.LastName, a.Country, a.ZIP
ORDER BY FullName

--Problem 10
SELECT c.LastName, AVG(s.[Length]) AS CiagrLength, CEILING(AVG(s.RingRange)) AS CiagrRingRange
FROM Clients AS c
JOIN ClientsCigars AS cc
ON c.Id = cc.ClientId
JOIN Cigars AS cg
ON cc.CigarId = cg.Id
JOIN Sizes AS s
ON cg.SizeId = s.Id
GROUP BY c.LastName
ORDER BY CiagrLength DESC


--Problem 11
GO

CREATE FUNCTION udf_ClientWithCigars(@name NVARCHAR(30))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(cc.CigarId)
			FROM Clients AS c
			JOIN ClientsCigars AS cc
			ON c.Id = cc.ClientId
			WHERE c.FirstName = @name)
END

--Problem 12
GO

CREATE PROCEDURE usp_SearchByTaste(@taste VARCHAR(20))
AS
BEGIN
	SELECT c.CigarName,
		   CONCAT('$', c.PriceForSingleCigar) AS Price, 
		   t.TasteType, b.BrandName, CONCAT(s.[Length], ' cm') AS CigarLength, 
		   CONCAT(s.RingRange, ' cm') AS CigarRingRange
	FROM Tastes AS t
	JOIN Cigars AS c
	ON t.Id = c.TastId
	JOIN Brands AS b
	ON c.BrandId = b.Id
	JOIN Sizes AS s
	ON c.SizeId = s.Id
	WHERE t.TasteType = @taste
	ORDER BY CigarLength, CigarRingRange DESC
END

GO