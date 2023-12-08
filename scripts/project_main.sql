SELECT *
FROM comm_2010;

SELECT county, pub_transit
FROM comm_2010
ORDER BY pub_transit DESC;

SELECT state, pub_transit
FROM (SELECT state, SUM(pub_transit) AS pub_transit FROM comm_2010 GROUP BY state) AS states
ORDER BY pub_transit DESC;

SELECT *
FROM age_2010;

SELECT state, age_16_19
FROM (SELECT state, SUM(age_16_19) AS age_16_19 FROM age_2010 GROUP BY state) AS states
ORDER BY age_16_19 DESC;