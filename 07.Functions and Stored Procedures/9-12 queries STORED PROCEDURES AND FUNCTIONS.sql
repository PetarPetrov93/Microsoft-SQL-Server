GO
USE [Bank]
GO

--PROBLEM 9
CREATE PROCEDURE [usp_GetHoldersFullName]
AS
BEGIN
	SELECT CONCAT([FirstName], ' ', [LastName]) AS [Full Name]
	FROM [AccountHolders]
END

GO
--PROBLEM 10
CREATE PROCEDURE [usp_GetHoldersWithBalanceHigherThan] @inputNum MONEY
AS
BEGIN
	SELECT ah.[FirstName], ah.[LastName]
	FROM [AccountHolders] AS ah
	JOIN [Accounts] AS ac
	ON ah.[Id] = ac.[AccountHolderId]
	GROUP BY ah.[FirstName], ah.[LastName]
	HAVING SUM(ac.[Balance]) > @inputNum
	ORDER BY ah.[FirstName], ah.[LastName]
END
--CALLING THE PROCEDURE
EXEC dbo.[usp_GetHoldersWithBalanceHigherThan] 50000

GO
--PROBLEM 11
CREATE OR ALTER FUNCTION [ufn_CalculateFutureValue] (@initialSum MONEY, @yearlyInterest FLOAT, @numberOfYears INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @result MONEY
		SET @result = @initialSum * (POWER((1 + @yearlyInterest), @numberOfYears))
	RETURN @result
END

GO
-- THIS IS HOW YOU CAN CALL THE FUNCTION WITHOUT SELECT QUERY BY DECLARING A VARIEABLE OF THE RETURN TYPE OF THE FUNCTION AND THEN USE THE FUNCTION LIKE SHOWN:
DECLARE @calculatedResult MONEY
SET @calculatedResult = dbo.[ufn_CalculateFutureValue](4.5, 0.4, 10)

GO
--PROBLEM 12 EXAMPLE OF A STORED PROCEDURE WHICH INCLUDES A FUNCTION IN THE SELECT
CREATE OR ALTER PROCEDURE [usp_CalculateFutureValueForAccount] @accIDinput INT, @interestYrate FLOAT
AS
BEGIN
	SELECT ah.[Id] AS [Account Id],
		   ah.[FirstName] AS [First Name],
		   ah.[LastName] AS [Last Name],
		   ac.[Balance] AS [Current Balance],
		   dbo.[ufn_CalculateFutureValue](ac.[Balance], @interestYrate, 5) AS [Balance in 5 years]
	FROM [AccountHolders] AS ah
	JOIN [Accounts] AS ac
	ON ah.[Id] = ac.[AccountHolderId]
	WHERE ac.[Id] = @accIDinput
END

