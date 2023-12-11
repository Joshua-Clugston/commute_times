SELECT *
FROM age;

SELECT county, state,
	   SUM(workers) AS workers, SUM(drove_alone) AS drove_alone,
	   SUM(carpooled) AS carpooled, SUM(pub_transit) AS pub_transit
FROM comm
WHERE year = 2016
GROUP BY county, state
ORDER BY workers DESC;

SELECT *
FROM comm INNER JOIN age USING(county, workers, drove_alone, carpooled, pub_transit, state, year)
WHERE county = 'Montgomery County, Maryland';