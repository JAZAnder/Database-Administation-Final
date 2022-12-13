UPDATE dbo.Games
SET AverageStars =(SELECT AVG(Reviews.StarRating)
							FROM Reviews
							WHERE Reviews.GameId = Games.Id),
	ReviewCount = ( SELECT COUNT(Reviews.GameId)
					FROM Reviews
					WHERE Reviews.GameId = Games.Id
	)
WHERE (Id = Games.Id)