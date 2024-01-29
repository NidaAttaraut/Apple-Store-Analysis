CREATE TABLE appleStore_description_combined AS

SELECT*FROM appleStore_description1

UNION ALL

SELECT*FROM appleStore_description2

UNION ALL

SELECT*FROM appleStore_description3

UNION ALL

SELECT*FROM appleStore_description4


** EXPLORATORY DATA ANALYSES
-- Check the number of unique apps in both tables AppleStoreAppleStore

SELECT COUNT(DISTINCT id) AS UNIQUEAPPIDS
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UNIQUEAPPID
FROM appleStore_description_combined

-- Check for any missing values in key fields

SELECT COUNT(*) AS MISSINGVALUES
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre ISNULL

SELECT COUNT(*) AS MISSINGVALUES
FROM appleStore_description_combined
WHERE app_desc IS NULL 

-- find out the number of apps per genre

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NUMAPPS DESC

-- Get an overview of the apps ratingsAppleStore
SELECT MIN(user_rating) AS MinRating,
	   MAX(user_rating) AS MaxRating,
       AVG(user_rating) AS AvgRating
FROM AppleStore


** DATA ANALYSIS**

-- Determine whether paid apps have higher ratings than free appsAppleStore

SELECT CASE
			WHEN price>0 THEN 'Paid'
            ELSE 'Free'
       end as App_Type,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY App_Type

-- Check if apps with more supported languages have higher ratingsAppleStore

SELECT CASE
			WHEN lang_num<10 THEN '<10 Languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 Languages'
            ELSE '>30 Languages'
         END AS language_bucket,
         avg(user_rating) as avg_rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY Avg_Rating DESC
          
-- Check genres with low ratings

SELECT prime_genre, AVG(user_rating) as avg_rating
FROM AppleStore
GROUP BY prime_genre
Order by Avg_Rating ASC
LIMIT 10

SELECT CASE
			WHEN LENGTH(B.app_desc)<500 THEN 'Short'
            WHEN LENGTH(B.app_desc) BETWEEN 500 AND 1000 THEN 'MEDIUM'
 			ELSE 'LONG'
       END AS DESCRIPTION_LENGTH_BUCKET,
       AVG(A.user_rating) AS AVERAGE_RATING
FROM AppleStore AS A
JOIN appleStore_description_combined AS B
ON A.ID = B.id
GROUP BY DESCRIPTION_LENGTH_BUCKET
ORDER BY AVERAGE_RATING DESC

--- Check the top-rated apps for each genreAppleStore

SELECT
	prime_genre,
    track_name,
    user_rating
FROM(
      SELECT
	  prime_genre,
	  track_name,
	  user_rating,
	  RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) as rank
  	  FROM
      AppleStore) as A
WHERE a.rank = 1