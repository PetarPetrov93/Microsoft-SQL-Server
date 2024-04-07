GO
USE [Diablo]
GO

--PROBLEM 13
CREATE OR ALTER FUNCTION [ufn_CashInUsersGames] (@gameName VARCHAR(50))
RETURNS TABLE
AS
RETURN
		(
			SELECT SUM([Cash]) AS [SumCash]
			FROM(
					SELECT g.[Name], ug.[Cash],
					ROW_NUMBER() OVER (ORDER BY ug.[Cash] DESC) AS [rowNumber]
					FROM [UsersGames] AS ug
					JOIN [Games] AS g
					ON ug.[GameId] = g.[Id]
					WHERE [Name] = @gameName
				) AS [Subquery]
			 WHERE [rowNumber] % 2 <> 0
		)