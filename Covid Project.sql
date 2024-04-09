SELECT *
FROM CovidDeaths
Order by 3,4

SELECT *
FROM CovidVaccinations




-- SELECT data we're going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths



-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract COVID in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases * 100) as DeathPercentage
FROM CovidDeaths
WHERE location LIKE '%states%'


-- Looking at the Total Cases vs Population
-- Shows what percentage of Population has contracted COVID
SELECT location, date, population,total_cases, (total_cases/population * 100) as InfectionRate
FROM CovidDeaths
WHERE location LIKE '%states%'

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT location, population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population * 100)) as InfectionRate
FROM CovidDeaths
GROUP BY location , population 
Order By InfectionRate DESC 

-- Showing countries with the Highest Death Count per Population

SELECT location,MAX(total_deaths) as totalDeathCount
FROM CovidDeaths
WHERE continent <> ''
Group By location
Order BY TotalDeathCount DESC 

-- Showing Total Death Count by Continent

SELECT continent,MAX(total_deaths) as totalDeathCount
FROM CovidDeaths
WHERE continent <> ''
Group By continent
Order BY TotalDeathCount DESC 



-- Global numbers

SELECT date, SUM(new_cases) as total_cases , SUM(new_deaths) as total_deaths, SUM(new_deaths)/
SUM(new_cases) *100 as DeathPercentage
FROM CovidDeaths
WHERE continent <> '' AND new_cases <> 0 AND total_deaths < total_cases 
GROUP BY date
ORDER BY 1

-- Looking at Total Population vs Vaccination

SELECT cd.continent , cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.date) AS RollingPeopleVaccinated
FROM CovidDeaths cd 
JOIN CovidVaccinations cv  
ON cd.date = cv.date 
and cd.location = cv.location
WHERE cd.continent <> '' AND cv.new_vaccinations <> ''
ORDER by 2,3




-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (Location, Continent, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT cd.continent , cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.date) AS RollingPeopleVaccinated
FROM CovidDeaths cd 
JOIN CovidVaccinations cv  
ON cd.date = cv.date 
and cd.location = cv.location
WHERE cd.continent <> '' AND cv.new_vaccinations <> ''
)

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac


