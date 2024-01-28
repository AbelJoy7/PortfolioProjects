 SELECT *
FROM abel..CovidDeaths$
ORDER BY 3,4


--SELECT *
--FROM abel..CovidVaccinations$
--ORDER BY 3,4

--select data that we are going to be using

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM abel..CovidDeaths$
ORDER BY 1,2

--looking total cases vs total deaths

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS 'precentage of deaths'
FROM abel..CovidDeaths$
ORDER BY 1,2

--looking percentage of total deaths in india

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS "deaths/cases"
FROM abel..CovidDeaths$
WHERE location = 'india'
ORDER BY 1,2

--shows what percentage of population got covid

SELECT location,date,population,total_cases,(total_cases/population)*100 AS 'population percentage'
FROM abel..CovidDeaths$
ORDER BY 1,2

--SELECT SUM(total_deaths) AS 'total deaths',location
--FROM abel..CovidDeaths$
--GROUP BY location

--looking at countries with highest infection rate to population

SELECT location,population,MAX(total_cases) AS highesttotal_case,MAX((total_cases/population)*100) AS populationinfected_percentage
FROM abel..CovidDeaths$
GROUP BY location,population
ORDER BY populationinfected_percentage DESC

--looking countries with highest death count per population

SELECT location,population,MAX(CAST(total_deaths AS INT)) AS total_deathcount,MAX(CAST(total_deaths AS INT))/population*100 as deathratetopopulation
FROM abel..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY deathratetopopulation DESC

--break thinks down by continents

--showing continents with the highest deaths per population

SELECT continent,MAX(CAST(total_deaths AS INT)) AS total_deathcount
FROM abel..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_deathcount DESC


--global numbers

SELECT SUM(new_cases) AS total_cases,SUM(CAST(total_deaths AS INT))AS total_deaths,SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS deathpercasespercentage
FROM abel..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 1,2

SELECT *
FROM abel..CovidDeaths$ deaths
JOIN abel..CovidVaccinations$ vaccin
  ON deaths.location = vaccin.location
  AND deaths.date = vaccin.date

--looking at total population vs vaccination

SELECT deaths.continent,deaths.location,deaths.date,deaths.population,vaccin.new_vaccinations,SUM(CAST(vaccin.new_vaccinations AS INT)) OVER (PARTITION BY deaths.location ORDER BY deaths.location,deaths.date) AS rollingpeoplevaccinated

FROM abel..CovidDeaths$ deaths
JOIN abel..CovidVaccinations$ vaccin
  ON deaths.location = vaccin.location
  AND deaths.date = vaccin.date
WHERE deaths.continent IS NOT NULL
ORDER BY 2,3

--USE CTE

WITH popvsvac(continent,location,date,population,rollingpeoplevaccinated,new_vaccinations)
AS
(
SELECT deaths.continent,deaths.location,deaths.date,deaths.population,vaccin.new_vaccinations,SUM(CAST(vaccin.new_vaccinations AS INT)) OVER (PARTITION BY deaths.location ORDER BY deaths.location,deaths.date) AS rollingpeoplevaccinated

FROM abel..CovidDeaths$ deaths
JOIN abel..CovidVaccinations$ vaccin
  ON deaths.location = vaccin.location
  AND deaths.date = vaccin.date
WHERE deaths.continent IS NOT NULL
)
SELECT *,(rollingpeoplevaccinated/population)*100 as rollingvacperpopulationpercentage
FROM popvsvac



--TEMP TABLE
DROP TABLE IF EXISTS #percentpopulationvaccinated
CREATE TABLE #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

INSERT INTO #percentpopulationvaccinated
SELECT deaths.continent,deaths.location,
deaths.date,deaths.population,vaccin.new_vaccinations,
SUM(CONVERT(INT,vaccin.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location,deaths.date)
AS rollingpeoplevaccinated

FROM abel..CovidDeaths$ deaths
JOIN abel..CovidVaccinations$ vaccin
  ON deaths.location = vaccin.location
  AND deaths.date = vaccin.date
--WHERE deaths.continent IS NOT NULL

SELECT *,(rollingpeoplevaccinated/population)*100
FROM #percentpopulationvaccinated


--create view to store data for later visualizations

CREATE VIEW percentpopulationvaccinated AS
SELECT deaths.continent,deaths.location,
deaths.date,deaths.population,vaccin.new_vaccinations,
SUM(CONVERT(INT,vaccin.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location,deaths.date)
AS rollingpeoplevaccinated

FROM abel..CovidDeaths$ deaths
JOIN abel..CovidVaccinations$ vaccin
  ON deaths.location = vaccin.location
  AND deaths.date = vaccin.date
WHERE deaths.continent IS NOT NULL

SELECT *
FROM percentpopulationvaccinated