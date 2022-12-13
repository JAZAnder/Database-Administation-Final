SELECT        GamesTables.GameTitle AS Title, GamesTables.Description, Developer.Name AS Developer, GamesTables.UserCount AS Players, GamesTables.ReleaseDate, GamesTables.AverageStars AS Rating, GamesTables.ReviewCount, 
                         Developer.FAVColor AS [Dev Color]
FROM            GamesTables INNER JOIN
                         GameDevs ON GamesTables.Id = GameDevs.GameId INNER JOIN
                         Developer ON GameDevs.DevId = Developer.Id
WHERE        (GamesTables.Description LIKE '%the%')