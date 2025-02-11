SET SQL_SAFE_UPDATES = 0;
-- For coviddeathfixed: Remove unnecessary characters (like '0') and extra spaces in the location names
UPDATE ProjectPortfolio.coviddeathfixed
SET continent = REPLACE(continent, '0', ' '),
    location = REPLACE(location, '0', ' ')
WHERE continent LIKE '%0%' OR location LIKE '%0%';


-- For covidvaccinationscleaned: Remove unnecessary characters (like '0') and extra spaces in the location names
UPDATE ProjectPortfolio.covidvaccinationscleaned
SET continent = REPLACE(continent, '0', ' '),
    location = REPLACE(location, '0', ' ')
WHERE continent LIKE '%0%' OR location LIKE '%0%';

-- For coviddeathfixed: Assign location to continent where continent is NULL
UPDATE ProjectPortfolio.coviddeathfixed
SET continent = location
WHERE continent IS NULL;

-- For covidvaccinationscleaned: Assign location to continent where continent is NULL
UPDATE ProjectPortfolio.covidvaccinationscleaned
SET continent = location
WHERE continent IS NULL;

-- For coviddeathfixed: Clean up locations that have extra spaces or unwanted formatting
UPDATE ProjectPortfolio.coviddeathfixed
SET location = TRIM(location)
WHERE location IS NOT NULL;

-- For covidvaccinationscleaned: Clean up locations that have extra spaces or unwanted formatting
UPDATE ProjectPortfolio.covidvaccinationscleaned
SET location = TRIM(location)
WHERE location IS NOT NULL;






Select location, date, total_cases, new_cases, total_deaths, population
From ProjectPortfolio.coviddeathfixed
 Order by 1,2; 

-- Total Cases vs Total Deaths – Death likelihood for COVID cases in your country
SELECT location, 
       date, 
       total_cases_per_million, 
       total_deaths_per_million, 
       CASE 
           WHEN total_cases_per_million = 0 THEN 0
           ELSE (total_deaths_per_million / total_cases_per_million) * 100
       END AS DeathPercentage
FROM ProjectPortfolio.coviddeathfixed
WHERE Location LIKE "%states%";



-- Looking at total cases per million vs population
SELECT location, date, total_cases_per_million, population, (total_cases_per_million / 10000) AS PercentPopulationInfected
FROM ProjectPortfolio.coviddeathfixed
WHERE Location LIKE "%states%";

-- Countries with Highest Infection Rate compared to Population
SELECT Location, Population, MAX(total_cases_per_million) AS HighestInfectionCount, MAX(total_cases_per_million) / 10000 AS PercentPopulationInfected
FROM ProjectPortfolio.coviddeathfixed
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- Having continents with highest Death counts per Population


SELECT TRIM(location) AS CleanedLocation, MAX(total_deaths) AS TotalDeathCount
FROM ProjectPortfolio.coviddeathfixed 
WHERE continent IS NULL
GROUP BY CleanedLocation
ORDER BY TotalDeathCount DESC;

-- Global Numbers
 SELECT  date, SUM(new_cases) AS total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths) / SUM(new_cases)*100 AS DeathPercentage
 FROM ProjectPortfolio.coviddeathfixed 
 WHERE Continent is not null
 GROUP BY Date 
 ORDER BY 1,2;
 
 -- Looking at Total population VS Vaccinations
SELECT dea.continent,
       dea.location,
       dea.date,
       dea.population,
       COALESCE(vac.new_vaccinations, 0) AS new_vaccinations,
       SUM(COALESCE(vac.new_vaccinations, 0)) OVER (PARTITION BY dea.location ORDER BY dea.date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RollingPeopleVaccinated
FROM ProjectPortfolio.coviddeathfixed dea
LEFT JOIN ProjectPortfolio.covidvaccinationscleaned vac
  ON TRIM(LOWER(dea.location)) = TRIM(LOWER(vac.location))
  AND STR_TO_DATE(dea.date, '%Y-%m-%d') = STR_TO_DATE(vac.date, '%Y-%m-%d')
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;



-- USE CTE 
WITH PopvsVac ( Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS 
(
SELECT dea.continent,
       dea.location,
       dea.date,
       dea.population,
       COALESCE(vac.new_vaccinations, 0) AS new_vaccinations,
       SUM(COALESCE(vac.new_vaccinations, 0)) OVER (PARTITION BY dea.location ORDER BY dea.date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RollingPeopleVaccinated
FROM ProjectPortfolio.coviddeathfixed dea
LEFT JOIN ProjectPortfolio.covidvaccinationscleaned vac
  ON TRIM(LOWER(dea.location)) = TRIM(LOWER(vac.location))
  AND STR_TO_DATE(dea.date, '%Y-%m-%d') = STR_TO_DATE(vac.date, '%Y-%m-%d')
WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3
)
SELECT *,(RollingPeopleVaccinated/Population)*100 AS Percentage
 FROM PopvsVac;


-- Temp TABLE

-- Drop the temporary table if it exists
-- Step 1: Clean the continent and location fields (fix 'North0America' and handle NULL or empty continents)
UPDATE ProjectPortfolio.coviddeathfixed
SET continent = TRIM(REPLACE(continent, '0', ' '))
WHERE continent LIKE '%0%';

UPDATE ProjectPortfolio.coviddeathfixed
SET continent = location
WHERE continent IS NULL OR continent = '';

UPDATE ProjectPortfolio.covidvaccinationscleaned
SET continent = TRIM(REPLACE(continent, '0', ' '))
WHERE continent LIKE '%0%';

UPDATE ProjectPortfolio.covidvaccinationscleaned
SET continent = location
WHERE continent IS NULL OR continent = '';

-- Step 2: Create the temporary table to store the results
DROP TEMPORARY TABLE IF EXISTS PercentPopulationVaccinated;

CREATE TEMPORARY TABLE PercentPopulationVaccinated (
    Continent VARCHAR(255),
    Location VARCHAR(255),
    Date DATE,
    Population BIGINT,
    New_vaccinations BIGINT,
    RollingPeopleVaccinated BIGINT
);

-- Step 3: Insert data into the temporary table, ensuring we handle NULL values correctly for `new_vaccinations`
INSERT INTO PercentPopulationVaccinated (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    COALESCE(vac.new_vaccinations, 0) AS new_vaccinations,
    SUM(COALESCE(vac.new_vaccinations, 0)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM ProjectPortfolio.coviddeathfixed dea
LEFT JOIN ProjectPortfolio.covidvaccinationscleaned vac
    ON dea.location = vac.location
    AND dea.date = vac.date;

-- Step 4: Retrieve data and calculate the percentage of the population vaccinated
SELECT *, 
       (RollingPeopleVaccinated / Population) * 100 AS Percentage_Vaccinated
FROM PercentPopulationVaccinated;



-- Create View to store the data for later visualizations
-- Creating View to store data for later visualizations
DROP VIEW IF EXISTS PercentPopulationVaccinated;
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, 
       dea.location, 
       dea.date, 
       dea.population, 
       vac.new_vaccinations,
       SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM ProjectPortfolio.coviddeathfixed dea
JOIN ProjectPortfolio.covidvaccinationscleaned vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;









