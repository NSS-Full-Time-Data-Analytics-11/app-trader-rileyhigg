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
   OR name ILIKE '%monster%'
   OR name ILIKE '%zombie%')
   AND price::money::numeric = 0
   AND rating >= (SELECT AVG (rating)
				 FROM play_store_apps)
   AND review_count > (SELECT AVG (review_count)
					  FROM play_store_apps)
   ORDER BY rating DESC, review_count DESC;
   
SELECT *
FROM app_store_apps 
WHERE (name ILIKE '%halloween%'
   OR name ILIKE '%ghost%' 
   OR name ILIKE '%costume%' 
   OR name ILIKE 'witch%' 
   OR name ILIKE '%dead%'
   OR name ILIKE '%creepy%'
   OR name ILIKE '%scary%'
   OR name ILIKE '%monster%'
   OR name ILIKE '%zombie%')
   AND price = 0
   AND rating >= (SELECT AVG(rating)
				 FROM app_store_apps)
   AND review_count::numeric > (SELECT AVG (review_count::numeric)
					  FROM app_store_apps)
   ORDER BY rating DESC, review_count DESC;
   
--a. Develop some general recommendations about the price range,
---genre, content rating, or any other app characteristics that the company should target. 
   
SELECT name, a.price, (a.review_count::numeric + p.review_count) AS total_review_count, a.rating, p.rating, a.content_rating, primary_genre, install_count 
FROM app_store_apps AS a INNER JOIN play_store_apps AS p USING (name)
WHERE a.review_count::numeric > (SELECT AVG (a.review_count::numeric)
					    FROM app_store_apps AS a)
  AND p.review_count::numeric > (SELECT AVG (p.review_count::numeric)
					    FROM play_store_apps AS p);
						
WITH top_apps AS (SELECT *
				FROM app_store_apps
				WHERE review_count::numeric > (SELECT AVG (review_count::numeric) +100000
							   FROM app_store_apps)
				 AND rating > (SELECT AVG (rating) + 0.5
				  			   FROM app_store_apps)
				 AND price = 0)
				 
SELECT primary_genre, AVG(rating)
FROM top_apps
GROUP BY primary_genre
ORDER BY avg DESC
						
		
						

 

