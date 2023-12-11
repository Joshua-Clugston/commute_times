SELECT *
FROM age;

SELECT county, state,
	   SUM(workers) AS workers, SUM(drove_alone) AS drove_alone,
	   SUM(carpooled) AS carpooled, SUM(pub_transit) AS pub_transit
FROM age
WHERE year = 2016
GROUP BY county, state
ORDER BY workers DESC;