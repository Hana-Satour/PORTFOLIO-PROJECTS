1
SELECT *
FROM country
LIMIT 40;

2
SELECT COUNT(*) AS TOTAL_ROWS
FROM city;

3
SELECT COUNT(*) AS REGION_NULLS
FROM country
WHERE Region IS NULL;

4
SELECT CountryCode,SUM(Population) AS POPULATION
FROM city
GROUP BY CountryCode;

5
SELECT Name AS City_Name,SUM(Population) AS POPULATION
FROM city
GROUP BY Name
ORDER BY SUM(Population) DESC
LIMIT 5;

6
SELECT District,ROUND(AVG(Population),2) AS Average_Population
FROM city
GROUP BY District
ORDER BY AVG(Population);
7
SELECT Name AS City_Name,Population 
FROM city
WHERE Population>1000000
ORDER BY Population DESC;

8
SELECT name AS Country_Name
FROM country
WHERE GovernmentForm IS NULL; 

9
SELECT Name AS Country_name, Population
FROM Country
WHERE region LIKE 'Middle East'
ORDER BY population DESC;

10

