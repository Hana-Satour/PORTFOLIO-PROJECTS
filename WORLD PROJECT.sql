--DATA EXPLORATION

--Explore data distribution

SELECT *
FROM country
LIMIT 40;

--The total rows number in the city table

SELECT COUNT(*) AS TOTAL_ROWS
FROM city;

--Checking the region column for any null values

SELECT COUNT(*) AS REGION_NULLS
FROM country
WHERE Region IS NULL;

--Population column_level summary

SELECT MIN(population) AS Min_Population,AVG(population) Avg_Population,MAX(population) AS Max_Population
FROM city;

--Counting cities in each continent

SELECT continent,COUNT(name)
FROM country
GROUP BY continent
ORDER BY COUNT(name) DESC;

--Finding outliers cities with population values 

SELECT Name,population
FROM city
WHERE population>5000000
ORDER BY population DESC;

--Checking for duplicate city name entries

SELECT Name,COUNT(*)
FROM city
GROUP BY Name
HAVING COUNT(*)>1;

--Language distribution analysis

SELECT language,COUNT(CountryCode) AS Country_Count
FROM countrylanguage
GROUP BY language
ORDER BY COUNT(CountryCode) DESC;

--Analyizing population by country

SELECT CountryCode,SUM(Population) AS POPULATION
FROM city
GROUP BY CountryCode;

--Top 5 cities with highest population

SELECT Name AS City_Name,SUM(Population) AS POPULATION
FROM city
GROUP BY Name
ORDER BY SUM(Population) DESC
LIMIT 5;

--Population distribution grouped by districts

SELECT District,ROUND(AVG(Population),2) AS Average_Population
FROM city
GROUP BY District
ORDER BY AVG(Population);

--Country_specific ANALYSIS 

SELECT Name AS City_Name,Population 
FROM city
WHERE Population>1000000 AND CountryCode LIKE 'EGY' 
ORDER BY Population DESC;

--Identifing missung data

SELECT Name AS Country_Name
FROM country
WHERE IndepYear IS NULL; 

--Regional Analysis

SELECT Name AS Country_name,Population
FROM Country
WHERE region LIKE 'Middle East'
ORDER BY population DESC;

--joining city and country tables 

SELECT *
FROM country AS c
JOIN city AS ci ON c.code=ci.countrycode;

--Continential populational insights

SELECT continent,SUM(population) AS population
FROM country 
GROUP BY continent
ORDER BY SUM(population) DESC;

--Top countries by population

SELECT c.name  AS Country_Name,SUM(ci.population) AS population
FROM country AS c
JOIN city AS ci ON c.code=ci.countrycode
GROUP BY c.name
ORDER BY SUM(ci.population) DESC;

--GROWTH potential

SELECT c.name AS Country_Name,ci.name AS City_Name,ci.population
FROM country AS c
JOIN city AS ci ON c.code=ci.countrycode
WHERE ci.population<500000 
ORDER BY population DESC;

--Larget city’s population ratio in it’s country population

SELECT ci.name AS City_Name,SUM(ci.population) AS City_Population,c.name AS Country_Name,
SUM(c.population) AS Country_Population,(SUM(ci.population)/SUM(c.population))*100 AS Percentage
FROM country AS c
JOIN city AS ci ON c.code=ci.countrycode
GROUP BY ci.name,c.name
ORDER BY SUM(ci.population) DESC
LIMIT 1;

--Checking the quality of the city table

SELECT name,countrycode,COUNT(*) AS Count
FROM city 
GROUP BY name,countrycode
HAVING COUNT(*)>1;

--Dominant languages by country

WITH countrymaxpercentage AS (SELECT countrycode,MAX(percentage) AS MAX_Percentage
FROM countrylanguage
GROUP BY countrycode)
SELECT cl.countrycode,cl.language,cl.percentage AS MAX_Percentage
FROM countrylanguage AS cl
JOIN countrymaxpercentage AS cmp ON cl.countrycode=cmp.countrycode AND cmp.MAX_Percentage=cl.percentage;

--Countries with higher language count than double the average

WITH Languagespercountry AS (SELECT countrycode,COUNT(language) AS language
FROM countrylanguage
GROUP BY countrycode),
Totalaverage AS (SELECT AVG(language) AS Total_Average
FROM languagespercountry)
SELECT lpc.countrycode,lpc.language
FROM Languagespercountry AS lpc
CROSS JOIN Totalaverage AS ta
WHERE lpc.language> 2*ta.Total_average
ORDER BY lpc.language DESC;