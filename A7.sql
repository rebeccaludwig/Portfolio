--REBECCA LUDWIG
--A7

--103
SELECT Movie_Title, Movie_Year, Movie_Genre
FROM MOVIE

--104
SELECT Movie_Year, Movie_Title, Movie_Cost
FROM MOVIE
ORDER BY Movie_Year DESC

--105
SELECT Movie_Title, Movie_Year, Movie_Genre
FROM MOVIE
ORDER BY Movie_Genre ASC, Movie_Year DESC

--106
SELECT Movie_Num, Movie_Title, Price_Code
FROM MOVIE
WHERE Movie_Title LIKE 'R%'

--107
SELECT Movie_Title, Movie_Year,Movie_Cost
FROM MOVIE
WHERE Movie_Title LIKE '%HOPE%'
ORDER BY Movie_Title ASC

--108
SELECT Movie_Title, Movie_Year, Movie_Genre
FROM MOVIE
WHERE Movie_Genre = 'ACTION'

--109
SELECT Movie_Num, Movie_Title,Movie_Cost
FROM MOVIE
WHERE Movie_Cost > 40

--110
SELECT Movie_Num, Movie_Title, Movie_Cost, Movie_Genre
FROM MOVIE
WHERE Movie_Genre IN ('ACTION','COMEDY') AND Movie_Cost < 50
ORDER BY Movie_Genre ASC

--111
SELECT Mem_Num, Mem_FName, Mem_LName, Mem_Street, Mem_State, Mem_Balance
FROM MEMBERSHIP
WHERE Mem_State = 'TN' AND Mem_Balance < 5 AND Mem_Street LIKE '%AVENUE'

--112
SELECT Movie_Genre, COUNT(*) AS [Number of Movies]
FROM MOVIE
GROUP BY Movie_Genre

--113
SELECT AVG(Movie_Cost) AS [Average Movie Cost]
FROM MOVIE

--114
SELECT Movie_Genre, AVG(Movie_Cost) AS [Average Cost]
FROM MOVIE
GROUP BY Movie_Genre

--115
SELECT M.Movie_Title, M.Movie_Genre, P.Price_Description, P.Price_RentFee
FROM MOVIE M INNER JOIN PRICE P
ON M.Price_Code = P.Price_Code

--116
SELECT M.Movie_Genre, AVG(P.Price_RentFee) AS [Average Rental Fee]
FROM MOVIE M INNER JOIN PRICE P
ON M.Price_Code = P.Price_Code
GROUP BY M.Movie_Genre

--117
SELECT M.Movie_Title, M.Movie_Cost/P.Price_RentFee AS [Breakeven Rentals]
FROM MOVIE M INNER JOIN PRICE P
ON M.Price_Code = P.Price_Code

--118
SELECT M.Movie_Title, M.Movie_Year
FROM MOVIE M INNER JOIN PRICE P
ON M.Price_Code = P.Price_Code

--119
SELECT Movie_Title, Movie_Genre, Movie_Cost
FROM MOVIE 
WHERE Movie_Cost BETWEEN 44.99 AND 49.99

--120
SELECT M.Movie_Title, P.Price_Description, P.Price_RentFee, M.Movie_Genre
FROM MOVIE M INNER JOIN PRICE P
ON M.Price_Code = P.Price_Code
WHERE M.Movie_Genre IN ('FAMILY', 'COMEDY', 'DRAMA')

--121
SELECT N.Mem_Num, N.Mem_FName, N.Mem_LName, N.Mem_Balance
FROM MEMBERSHIP N INNER JOIN RENTAL R
ON N.Mem_Num = R.Mem_Num

--122
SELECT MIN(N.Mem_Balance) AS [Minimum Balance], MAX(N.Mem_Balance) AS [Maximum Balance], AVG(N.Mem_Balance) AS [Average Balance]
FROM MEMBERSHIP N INNER JOIN RENTAL R
ON N.Mem_Num = R.Mem_Num