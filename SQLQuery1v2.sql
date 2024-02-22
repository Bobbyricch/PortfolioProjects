select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4


--Select Data that we are going to be using

select Location, date, total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2



--Looking at Total Cases VS Total Deaths
--Shows likelihood of dying if you contract Covid in your country

select Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2



--Looking at Total Cases VS Total Deaths
--Shows likelihood of dying if you contract Covid in Nigeria

select Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like  '%Nigeria%'
and continent is not null
order by 1,2


--Looking at Total Cases VS Population
--Shows what percentage of population got Covid

select Location, date,population, total_cases,(total_cases/population)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like  '%Nigeria%'
where continent is not null
order by 1,2



--Looking at Countries with Highest Infection Rate compared to Population


select Location,population, max(total_cases) as HihgestInfectionCount,max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like  '%Nigeria%'
where continent is not null
Group by Location,population
order by PercentPopulationInfected desc


--Showing the Countreis with Highest Death Count per Population


select Location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like  '%Nigeria%'
where continent is not null
Group by Location
order by TotalDeathCount desc


--Breaking Down by Continent


--Showing the Continent with the Highest Death Count per Population

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like  '%Nigeria%'
where continent is not null
Group by Location
order by TotalDeathCount desc


--GLOBAL NUMBERS


select sum(new_cases)as Total_Cases,sum(cast(new_deaths as int)) as Total_Deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like  '%Nigeria%'
where continent is not null
--Group by date
order by 1,2



	 --Looking at Total Population VS Vaccinations

	 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date =vac.date
	 where dea.continent is not null
	 order by 2,3


	 --USE CTE

	 with popvsvac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
	 as
	 ( 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date =vac.date
	 where dea.continent is not null
	-- order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from popvsvac


--TEMP TABLE
Drop Table if Exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date =vac.date
	-- where dea.continent is not null
	-- order by 2,3
select *,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


--Creating Views to Store Data for Later Visualizations

create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date =vac.date
	 where dea.continent is not null
	-- order by 2,3

	select*
	from #PercentPopulationVaccinated