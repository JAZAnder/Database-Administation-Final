SELECT Users.GamerTag AS Gamertag, Titles.Name AS Title
FROM     Users INNER JOIN
                  Titles ON Users.Id = Titles.Id