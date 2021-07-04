use covid_schema;
SELECT 
    *
FROM
    covid_deaths
    WHERE continent = "";
    
    


-- Total cases vs Total deaths
-- likelihood of dying if you get infected
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    ROUND((total_deaths / total_cases)*100, 2) AS DeathPercentage
    FROM covid_deaths
    WHERE location like '%states%'
ORDER BY 1 , 2;

-- Total Cases vs Population
SELECT 
    location,
    date,
    population,
    total_cases,
    (total_cases / population) * 100
FROM
    covid_deaths
WHERE
    location LIKE '%states%'
ORDER BY 1 , 2;

-- Looking at countries with highest infection rate compared to population
SELECT 
    location,
    population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population) * 100) AS PercentPopulationInfected
FROM
    covid_deaths
GROUP BY location , population
ORDER BY PercentPopulationInfected DESC;

-- Looking at countries with highest death rate compared to population
SELECT 
    location,
    MAX(CAST(total_deaths AS SIGNED)) AS HighestDeathCount
FROM
    covid_deaths
WHERE
    continent != ''
GROUP BY location
ORDER BY HighestDeathCount DESC;

-- Looking at continents with highest death rate compared to population
SELECT 
    location,
    MAX(CAST(total_deaths AS SIGNED)) AS HighestDeathCount
FROM
    covid_deaths
WHERE
    continent = ''
GROUP BY location
ORDER BY HighestDeathCount DESC;


-- Global Numbers

SELECT 
-- date,
    SUM(new_cases),
    SUM(CAST(new_deaths AS signed)),
    SUM(CAST(new_deaths AS signed))/(SUM(new_cases))*100 AS DeathPercentage
    FROM covid_deaths
    WHERE continent != ""
-- WHERE location like '%states%'
-- GROUP BY date
ORDER BY 1 , 2;

-- Total population vs vaccinations
SELECT 
    d.continent, d.location, d.date, d.population, v.new_vaccinations, 
    SUM(CAST(v.new_vaccinations as signed)) OVER (partition by d.location order by d.location, d.date) as RollingPeopleVaccination
FROM
    covid_deaths d
        JOIN
    covid_vac v ON d.location = v.location
        AND d.date = v.date
        WHERE d.continent != ""
        ORDER BY 2,3;
        
        select * from covid_vac
        where continent != "";
        
-- USE CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccination)
AS (
SELECT 
    d.continent, d.location, d.date, d.population, v.new_vaccinations, 
    SUM(CAST(v.new_vaccinations as signed)) OVER (partition by d.location order by d.location, d.date) as RollingPeopleVaccination
FROM
    covid_deaths d
        JOIN
    covid_vac v ON d.location = v.location
        AND d.date = v.date
        WHERE d.continent != ""
        )
	select *, (RollingPeopleVaccination/population)*100 as perc from PopvsVac;
    
    -- temp table
    
CREATE TABLE PV
( continent nvarchar(255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric
)

INSERT INTO PV
SELECT 
    d.continent, d.location, d.date, d.population, v.new_vaccinations, 
    SUM(CAST(v.new_vaccinations as signed)) OVER (partition by d.location order by d.location, d.date) as RollingPeopleVaccination
FROM
    covid_deaths d
        JOIN
    covid_vac v ON d.location = v.location
        AND d.date = v.date
        WHERE d.continent != "";
        
SELECT * from PopvsVac;

-- Creating a view to store data for later visualisations

Create view PercPopVac as 
SELECT 
    d.continent, d.location, d.date, d.population, v.new_vaccinations, 
    SUM(CAST(v.new_vaccinations as signed)) OVER (partition by d.location order by d.location, d.date) as RollingPeopleVaccination
FROM
    covid_deaths d
        JOIN
    covid_vac v ON d.location = v.location
        AND d.date = v.date
        WHERE d.continent != "";

select location from percpopvac;



        
        
        


        
        
        















 





