SELECT        Games.GameTitle AS Title, Games.Description, Developer.Name AS Devoloper, Games.UserCount AS Players, Games.AverageStars AS Rating
FROM            Games INNER JOIN
                         GameDevs ON Games.Id = GameDevs.GameId INNER JOIN
                         Developer ON GameDevs.DevId = Developer.Id
WHERE        (Games.Id IN( 
				SELECT        GameCatagories.GameId
				FROM            GameCatagories INNER JOIN
                         Catagory ON GameCatagories.CatagoryId = Catagory.Id
				WHERE        (Catagory.CatagoryType LIKE N'%Action%')
				)
)