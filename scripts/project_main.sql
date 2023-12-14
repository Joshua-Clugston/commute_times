-- EDA time!

SELECT *
FROM age;

SELECT *
FROM comm;

SELECT county, state,
	   SUM(workers) AS workers, SUM(drove_alone) AS drove_alone,
	   SUM(carpooled) AS carpooled, SUM(pub_transit) AS pub_transit
FROM comm
WHERE year = 2016
GROUP BY county, state
ORDER BY workers DESC;

SELECT state, AVG(workers)::int as avg_workers,
	   ROUND( AVG(mean_min)::decimal,2 ) AS avg_mean_min, ROUND( AVG(drove_alone_mean_min)::decimal,2 ) AS avg_alone_mean_min,
	   ROUND( AVG(carpooled_mean_min)::decimal, 2) AS avg_carpool_mean_min, ROUND( AVG(pub_transit_mean_min)::decimal,2 ) AS avg_pub_mean_min,
	   ROUND( AVG(median_age)::decimal,2 ) AS avg_age, ROUND( AVG(drove_alone_median_age)::decimal,2 ) AS avg_alone_age,
	   ROUND( AVG(carpooled_median_age)::decimal, 2) AS avg_carpool_age, ROUND( AVG(pub_transit_median_age)::decimal,2 ) AS avg_pub_age
FROM comm FULL JOIN age USING(county, workers, drove_alone, carpooled, pub_transit, state, year)
GROUP BY state
ORDER BY state;

-- Which city has worse traffic: DC or Nashville?
-- Nashville is in Davidson County, so let's use that as a metric

SELECT state, county, AVG(workers)::int as avg_workers,
	   ROUND( AVG(mean_min)::decimal,2 ) AS avg_mean_min, ROUND( AVG(drove_alone_mean_min)::decimal,2 ) AS avg_alone_mean_min,
	   ROUND( AVG(carpooled_mean_min)::decimal, 2) AS avg_carpool_mean_min, ROUND( AVG(pub_transit_mean_min)::decimal,2 ) AS avg_pub_mean_min,
	   ROUND( AVG(median_age)::decimal,2 ) AS avg_age, ROUND( AVG(drove_alone_median_age)::decimal,2 ) AS avg_alone_age,
	   ROUND( AVG(carpooled_median_age)::decimal, 2) AS avg_carpool_age, ROUND( AVG(pub_transit_median_age)::decimal,2 ) AS avg_pub_age
FROM comm FULL JOIN age USING(county, workers, drove_alone, carpooled, pub_transit, state, year)
WHERE state = 'District of Columbia' OR county = 'Davidson County, Tennessee'
GROUP BY state, county
ORDER BY state;

-- Looks like DC has longer commute times across the board! Although, it's not far behind in terms of public transit, so maybe that's 
-- something Nashville can look into!


-- Let's explore the relation between mode of transportation and commute time.

WITH county_times AS (
	SELECT county, ROUND( AVG(workers)::decimal, 2) AS avg_workers, ROUND( AVG(mean_min)::decimal, 2) AS avg_travel_time,
		   ROUND( AVG(drove_alone_mean_min)::decimal, 2) AS avg_drive_time,
		   ROUND( AVG(carpooled_mean_min)::decimal, 2) AS avg_carpool_time,
		   ROUND( AVG(pub_transit_mean_min)::decimal, 2) AS avg_transit_time
		   /*
		   ROUND( AVG(drove_alone_10_min)::decimal, 2 ) AS avg_10, ROUND( AVG(drove_alone_10_14_min)::decimal,2 ) AS avg_10_14, 
		   ROUND( AVG(drove_alone_15_19_min)::decimal,2 ) AS avg_10_19, ROUND( AVG(drove_alone_20_24_min)::decimal,2 ) AS avg_20_24, 
		   ROUND( AVG(drove_alone_25_29_min)::decimal,2 ) AS avg_25_29, ROUND( AVG(drove_alone_30_34_min)::decimal,2 ) AS avg_20_34, 
		   ROUND( AVG(drove_alone_35_44_min)::decimal,2 ) AS avg_35_44, ROUND( AVG(drove_alone_45_59_min)::decimal,2 ) AS avg_45_59, 
		   ROUND( AVG(drove_alone_60_min)::decimal,   2 ) AS avg_60
		   */
	FROM comm
	GROUP BY county
	ORDER BY avg_travel_time DESC NULLS LAST)

SELECT *
FROM county_times
WHERE avg_transit_time < avg_travel_time
ORDER BY avg_transit_time;

SELECT *
FROM comm
WHERE county = 'Lapeer County, Michigan';

