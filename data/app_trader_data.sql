SELECT *, ROUND(((app_store_apps.rating + play_store_apps.rating)/2),1) AS avg_rating
FROM app_store_apps INNER JOIN play_store_apps USING (name);

SELECT *
FROM (SELECT *, ROUND(((app_store_apps.rating + play_store_apps.rating)/2),1) AS avg_rating
		FROM app_store_apps INNER JOIN play_store_apps USING (name)) AS rating
WHERE avg_rating >= 3.5;

SELECT *, ROUND(((a.rating + p.rating)/2)/25, 2)* 25 AS avg_rating,
		  (ROUND(((a.rating + p.rating)/2)/25, 2)* 25/.25) * 0.5 + 1 AS yrs_longevity
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING(name)
WHERE a.rating>(SELECT AVG(rating)
			   FROM app_store_apps)
	  AND p.rating > (SELECT AVG(rating)
					 FROM play_store_apps);
					 
WITH highest_rating AS (SELECT *, ROUND(((a.rating + p.rating)/2)/25, 2)* 25 AS avg_rating,
		  (ROUND(((a.rating + p.rating)/2)/25, 2)* 25/.25) * 0.5 + 1 AS yrs_longevity
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING(name)
WHERE a.rating>(SELECT AVG(rating)
			   FROM app_store_apps)
	  AND p.rating > (SELECT AVG(rating)
					 FROM play_store_apps))
					 
SELECT COUNT (primary_genre), primary_genre
FROM highest_rating
GROUP BY primary_genre
ORDER BY count DESC;

WITH highest_rating AS (SELECT *, ROUND(((a.rating + p.rating)/2)/25, 2)* 25 AS avg_rating,
		  (ROUND(((a.rating + p.rating)/2)/25, 2)* 25/.25) * 0.5 + 1 AS yrs_longevity
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING(name)
WHERE a.rating>(SELECT AVG(rating)
			   FROM app_store_apps)
	  AND p.rating > (SELECT AVG(rating)
					 FROM play_store_apps))
					 
SELECT COUNT (genres), genres
FROM highest_rating
GROUP BY genres
ORDER BY count DESC;

SELECT *
FROM play_store_apps
WHERE (name ILIKE '%halloween%'
   OR name ILIKE '%ghost%' 
   OR name ILIKE '%costume%' 
   OR name ILIKE 'witch%' 
   OR name ILIKE '%dead%'
   OR name ILIKE '%creepy%'
   OR name ILIKE '%scary%'
   OR name ILIKE '%monster%')
   AND price::money::numeric = 0
   AND rating >= (SELECT AVG (rating)
				 FROM play_store_apps)
   AND review_count > (SELECT AVG (review_count)
					  FROM play_store_apps)
   ORDER BY rating DESC;
   
SELECT *
FROM app_store_apps 
WHERE (name ILIKE '%halloween%'
   OR name ILIKE '%ghost%' 
   OR name ILIKE '%costume%' 
   OR name ILIKE 'witch%' 
   OR name ILIKE '%dead%'
   OR name ILIKE '%creepy%'
   OR name ILIKE '%scary%'
   OR name ILIKE '%monster%')
   AND price = 0
   AND rating >= (SELECT AVG(rating)
				 FROM app_store_apps)
   AND review_count::numeric > (SELECT AVG (review_count::numeric)
					  FROM app_store_apps)
   ORDER BY rating DESC;
   
   
   
   

 

