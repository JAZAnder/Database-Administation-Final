SELECT        Users.Id, Users.GamerTag, Users.ReviewsLeft, Titles.Name
FROM            Users INNER JOIN
                         UserTitle ON Users.Id = UserTitle.UserId INNER JOIN
                         Titles ON UserTitle.TitleID = Titles.Id