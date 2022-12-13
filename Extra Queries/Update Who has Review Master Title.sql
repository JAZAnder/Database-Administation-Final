INSERT INTO UserTitle (UserId, TitleID)
SELECT UserId, 21
FROM (SELECT ReviewsLeft as leftReviews, Id as UserId FROM Users WHERE ReviewsLeft > 0) as MostReviews

 WHERE   MostReviews.leftReviews > 0 