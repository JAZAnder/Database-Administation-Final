UPDATE dbo.Games
SET UserCount = ( SELECT COUNT(UserGame.GameId)
					FROM UserGame
					WHERE UserGame.GameId = Games.Id
	)
WHERE (Id = Games.Id)