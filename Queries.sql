/*
TEAM NAME:
TEAM MEMBERS' NAME:
Joshua Cantu
Jacob Dillon
Nicholas Tate

Instructions
- Descriptions must reflect a business operation's need
- One query for each item (Q..) is enough
- You must use the exact format
- Project a few attributes only unless otherwise said
- Do not change the order of the queries
*/

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ DDL QUERIES   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--QD1: CREATE TABLE ...
/*
Instructions:
- Must define PK
- Must define default value as needed
*/


CREATE TABLE dbo.Games
    (
    Id float(53) primary key NOT NULL,
    GameTitle varchar(50) NULL,
    UserCount float(53) NOT NULL,
    ReleaseDate date NOT NULL DEFAULT (getdate()),
    AverageStars float(53) NOT NULL DEFAULT 0,
    ReviewCount float(53) NOT NULL DEFAULT 0,
    Description varchar(MAX) NULL
    )
GO



--QD2: ALTER TABLE ...
ALTER TABLE dbo.[Developer]
ADD FAVColor varchar(20);

----Description: .....................
Alters the Devolper table to add favorite color column



--QD3: ADD "CHECK" CONSTRAINT:
ALTER TABLE Reviews
ADD CHECK (StarRating <= 5)

----Description: .....................
Prevents the User from leaving a reveiw with more then 5 stars



--QD4: ADD FK CONSTRAINT(S) TO THE TABLE
/*
Instructions:
- Must define action
- At least one of the FKs must utilize the default value
*/
ALTER TABLE dbo.GameDevs
    ADD Developer_id float NOT NULL
    CONSTRAINT DK_GameDevs_DevId DEFAULT (20)
    CONSTRAINT FK_GameDevs_DevId FOREIGN KEY (DevId)
    REFERENCES dbo.Developer
	(
	Id
	) ON UPDATE  NO ACTION
	 ON DELETE  NO ACTION

GO
----Description: .....................
/*Added Forein key and defult value*/



--QD5: ADD TRIGGER ...
Create TRIGGER [dbo].[tr_LastIncertReveiws]
   ON [dbo].[Reviews]
   AFTER INSERT, UPDATE
AS
BEGIN

	SET NOCOUNT ON;

	Declare @Game INT
	Set @Game = (SELECT GameId From inserted)

	DECLARE @newValue INT
	SET @newValue = (SELECT ReviewCount FROM Games WHERE Games.Id = @Game)


	UPDATE Games

	SET ReviewCount = @newValue+1
	WHERE Games.Id = @Game;

END
----Description: .....................
/* Updates Review Count on game when Reveiw is left */


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ DML QUERIES   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


--QM1.1: A TEST QUERY FOR THE TRIGGER CREATED in QA5:
INSERT INTO dbo.Reviews
                  (Id, GameId, [User ID], Heading, StarRating, Body)
VALUES     (73, 1, 1, N'good job', 3, N'words')

----Description: .....................
/* when user makes a review, it INCREMENTs ReviewCount */




--QM1.2: A TEST QUERY FOR THE "CHECK" CONSTRAINT DEFINED in QA3:
INSERT INTO Reviews
                         (Id, GameId, [User ID], Heading, Body, StarRating)
VALUES        (79, 5, 17, N'This Game is AWESOME', N'bEsT GaME eVER', 77)

----Description: .....................
Trys to add a review with a star rating of 77

--QM1.3: A TEST QUERY FOR THE FK CONSTRAINT DEFINED in QA4:
INSERT INTO dbo.GameDevs
                  (Id,  GameId)
VALUES     (2,  2)

----Description: .....................
Adds a GamesDev which links the Game "Counter Strike Global Defense" to a placeholder Developer



--QM2: INSERT DATA:
INSERT INTO dbo.Games
                  (Id, GameTitle, UserCount, AverageStars, ReviewCount, Description)
VALUES (24, 'Mario', 17, 4.4, 0, 'Not that bad ig')

----Description: .....................
/* Adds a New Game to GameTable */



--QM3: UPDATE DATA:
UPDATE dbo.Users
SET          Title = 13
WHERE  (Id = 2)

----Description: .....................
/* Updates the Title of the User with the User Id 2 to 13 */



--QM4: DELETE DATA:
DELETE FROM dbo.Reviews
WHERE  (Id = 1)

----Description: .....................
/* Deletes Review with the Id of 1 */



--QM5: QUERY DATA WITH WHERE CLAUSE:
SELECT        Games.GameTitle AS Title, Games.Description, Developer.Name AS Developer, Games.UserCount AS Players, Games.ReleaseDate, Games.AverageStars AS Rating, Games.ReviewCount
FROM            Games INNER JOIN
                         GameDevs ON Games.Id = GameDevs.GameId INNER JOIN
                         Developer ON GameDevs.DevId = Developer.Id
WHERE        (Games.Description LIKE '%battle%')
				OR ((Games.Description LIKE '%hero%')
				AND (Games.Description LIKE '%adventure%'))
----Description: .....................
/*
Finds any game that either has the Word "battle"
in the Description OR has both of the words
"hero" and "adventure" then Returns the Title oof the Game, the Description, the Developer, How many Players the Game has, Realse Date, the Rating, and how many revies were left.
*/



--QM6.1: QUERY DATA WITH SUB-QUERY IN WHERE CLAUSE:
SELECT        Games.GameTitle AS Title, Games.Description, Developer.Name AS Devoloper, Games.UserCount AS Players, Games.AverageStars AS Rating
FROM            Games INNER JOIN
                         GameDevs ON Games.Id = GameDevs.GameId INNER JOIN
                         Developer ON GameDevs.DevId = Developer.Id
WHERE        (Games.Id IN(
				SELECT        GameCatagories2.GameId
				FROM            GameCatagories2 INNER JOIN
                         Catagory ON GameCatagories2.CatagoryId = Catagory.Id
				WHERE        (Catagory.CatagoryType LIKE N'%Action%')
				)
)

----Description: .....................
/* Returns all Games of a category using key words */




--QM6.2: QUERY DATA WITH SUB-QUERY IN FROM CLAUSE:
SELECT *
FROM (SELECT ReviewsLeft as leftReviews, Id as UserId FROM Users WHERE ReviewsLeft > 0) as MostReviews

 WHERE   MostReviews.leftReviews > 0

----Description: .....................
/* List all the USers That have left more then 1 review */



--QM6.3: QUERY DATA WITH SUB-QUERY IN SELECT CLAUSE:
SELECT Games.GameTitle, (
							SELECT AVG(Reviews.StarRating)
							FROM Reviews
							WHERE Reviews.GameId = Games.Id
							)
							AS Average_Reviews
FROM Games

----Description: .....................
/* Gets all the games and there Average Star rating based on the reviews*/



--QM7: QUERY DATA WITH EXCEPT:
SELECT        Id, GameTitle, Description
FROM            Games
WHERE Games.Id IN (
	SELECT        Id
	FROM            Games
	EXCEPT
		SELECT        GameId
		FROM            GameCatagories2
		WHERE        (CatagoryId = 30)
)

----Description: .....................
/* Returns all games that are not in the mature catagory */



--QM8: QUERY DATA WITH ANY/SOME/ALL:
SELECT dbo.Titles.Id AS Title_ID, dbo.Titles.Name AS Title_Name, dbo.Requirments.Title, dbo.Requirments.Requirment
FROM dbo.Requirments INNER JOIN
                         dbo.Titles ON dbo.Requirments.Title = dbo.Titles.Id
WHERE dbo.Titles.Id = ANY
  (SELECT dbo.Requirments.Title
  FROM Requirments
  WHERE dbo.Requirments.Title = dbo.Titles.Id );

----Description: .....................
List all the Possible Titles, as well as the Requirements that must be met in order to achieve the Titles



--QM8: QUERY DATA WITH ANY/SOME/ALL:
Select GamerTag, ReviewsLeft
From Users
Where Users.ReviewsLeft = All( Select Users.ReviewsLeft From Users
					Where ReviewsLeft = 1)

----Description: .....................
Select GamerTag and ReviewsLeft where there has only been one review left.



--QM9.1: INNER-JOIN-QUERY WITH WHERE CLAUSE:
SELECT        Games.GameTitle, Reviews.Heading, Reviews.StarRating, Reviews.Body
FROM            Reviews INNER JOIN
                         Games ON Reviews.Id = Games.Id INNER JOIN
                         Users ON Reviews.[User ID] = Users.Id
WHERE        (Users.GamerTag = 'GDoc')

----Description: .....................
/*Returns all reveiws left by the User with the Gamertag GDoc. Returns Game Name, and all review info */



--QM9.2: LEFT-OUTER-JOIN-QUERY WITH WHERE CLAUSE:
----Instruction: The query must return NULL due to the outer join:
SELECT Name, GamerTag
FROM Users AS E LEFT OUTER JOIN Titles AS S
                              ON E.GamerTag = S.Name



----Description: .....................
/* Returns null for all the names given back. */

--QM9.3: RIGHT-OUTER-JOIN-QUERY WITH WHERE CLAUSE:
----Instruction: The query must return NULL due to the outer join:
SELECT Name, GamerTag
FROM Users AS E Right OUTER JOIN Titles AS S
	on E.GamerTag = s.Name
	Where Name like ('ALLNighter')

----Description: .....................
/*the right joined table is null. */

--QM9.4: FULL-OUTER-JOIN-QUERY WITH WHERE CLAUSE:
----Instruction: The query must return NULL from LEFT and RIGHT tables due to the outer join:
SELECT        Developer.Name, Games.GameTitle, Catagory.CatagoryType
FROM            GameCatagories2 FULL OUTER JOIN
                         Games ON GameCatagories2.GameId = Games.Id FULL OUTER JOIN
                         GameDevs ON Games.Id = GameDevs.GameId FULL OUTER JOIN
                         Catagory ON GameCatagories2.CatagoryId = Catagory.Id FULL OUTER JOIN
                         Developer ON GameDevs.DevId = Developer.Id
WHERE        (Games.AverageStars <= 2)

----Description: .....................
LEFT and RIGHT tables due to the outer join:
----Description: .....................
/*
Finds all Games with a Rating Below 2 Stars, and returns Developer and Category
*/

--QM10.1: AGGREGATION-JOIN-QUERY WITH GROUP BY & HAVING:
Select GameTitle, Games.UserCount, AverageStars
From Games Left outer join Catagory as C on Games.Id = C.CatagoryType
WHERE Games.AverageStars > 4
GROUP BY GameTitle, UserCount, AverageStars
Having AverageStars > 2

----Description: .....................
/* query returns all games with AverageStars rating greater than 4 using values assigned in the Games Table*/

--QM10.2: AGGREGATION-JOIN-QUERY WITH SUB-QUERY:
Select Games.UserCount, GameTitle, (

							SELECT AVG(Reviews.StarRating)
							FROM Reviews
							WHERE Reviews.GameId = Games.Id
							) as AverageStars

From Games inner join Reviews as R on Games.Id = R.GameId
WHERE AverageStars > 3
GROUP BY UserCount,GameTitle,AverageStars, GameId, Games.Id
Having AverageStars > 4 

----Description: .....................
/*query returns all games, with AverageStars
 rating greater than 4. Using value assigned
 by taking the average of StarRatings
 from Reviews Table as AverageStars. */


--QM11: WITH-QUERY:
WITH tempDistanceFromAverage AS (
SELECT Games.Id,
	ROUND(
		(Games.AverageStars -
			(SELECT AVG(Reviews.StarRating)
			FROM Reviews
			)
		),
	2) AS Distance
FROM Games
)

SELECT        Games.GameTitle, tempDistanceFromAverage.Distance AS "Deviation from Average"
FROM            Games INNER JOIN
                         tempDistanceFromAverage ON tempDistanceFromAverage.Id = Games.Id
----Description: .....................
/*
Calculates the Deviation of each games Average Rating, from the Average of all Reveiws left.
*/



