UPDATE dbo.Users
SET ReviewsLeft = ( SELECT COUNT(Reviews.[User ID])
					FROM Reviews
					WHERE Reviews.[User ID] = Users.Id)
WHERE (Id = Users.Id)