--  iranدرصد مرگ مبتلایان
select i.location, i.date, i.total_cases, i.total_deaths, (total_deaths/total_cases)*100 as death_precent
from iran as i
order by death_precent DESC

-- iranامار مبتلایان
select i.location, i.date, i.total_cases, 
i.total_deaths, (total_cases/population)*100 
as patients_precent
from iran as i
order by patients_precent DESC


select c.location, c.date, c.total_cases, c.total_deaths, (total_deaths/total_cases)*100 as death_precent
from corona as c
order by death_precent DESC

select i.location, i.date, max(total_cases), max(total_deaths), 
max(total_cases/population)*100 
as patients_precent
from iran as i
order by patients_precent DESC

-- showing countries with highest death count per population
select i.location, i.date, max(total_cases), max(total_deaths), 
max(total_deaths/population)*100 
as deaths_precent
from iran as i
order by deaths_precent DESC
  
  
  
-- showing highest counries death
select location, max(total_deaths) as highest
from corona
where location != 'Africa'
group by location 
order by highest desc


-- lets try with continent
select continent, location, max(total_deaths) as highest
from corona
where continent != 'Africa'
group by continent 
order by highest desc


-- global numbers
select location, date, (sum(new_deaths)/sum(new_cases))*100 as sum 
from corona as c
where continent is not null
group by c.date
order by sum desc


-- lookong at total_population and total_vaccinations
select c.location, c.date, c.population,
sum(c2.new_vaccinations) over (partition by c.location order by c.location,
c.date) as vaccinatedpeople
-- (vaccinatedpeople/population)*100 as vaccinated_people
from corona as c
join corona2 as c2
on c.location = c2.location
and c.date = c2.date
where c.continent is not null
order by new_vaccinations desc


-- Use CTE (population vs vaccianation)
with pvv (location, date, population, vaccinatedpeople)
as
(
select c.location, c.date, c.population,
sum(c2.new_vaccinations) over (partition by c.location order by c.location,
c.date) as vaccinatedpeople
-- (vaccinatedpeople/population)*100 as vaccinated_people
from corona as c
join corona2 as c2
on c.location = c2.location
and c.date = c2.date
where c.continent is not null
-- order by new_vaccinations desc
)
select *, (vaccinatedpeople/population)*100 as vp
from pvv
order by vp desc







-- Use CTE (population vs vaccianation)
with pvv (location, date, population, vaccinatedpeople)
as
(
select c.location, c.date, c.population,
sum(c2.new_vaccinations) over (partition by c.location order by c.location,
c.date) as vaccinatedpeople
from corona as c
join corona2 as c2
on c.location = c2.location
and c.date = c2.date
-- where c.continent is not null
-- order by new_vaccinations desc
)
select *, (vaccinatedpeople/population)*100 as vp
from pvv







-- create new table for population and vaccination
drop table if exists percentvaccinated
create table percentvaccinated(
location nvarchar(255),
date text,
population numeric,
vaccinatedpeople numeric)
insert into percentvaccinated
select c.location, c.date, c.population,
sum(c2.new_vaccinations) over (partition by c.location order by c.location,
c.date) as vaccinatedpeople
from corona as c
join corona2 as c2
on c.location = c2.location
and c.date = c2.date
-- where c.continent is not null
-- order by new_vaccinations desc
select *, (vaccinatedpeople/population)*100 as vp
from percentvaccinated
order by vp desc


-- creating a view of data
create view percentvaccination as
select c.location, c.date, c.population,
sum(c2.new_vaccinations) over (partition by c.location order by c.location,
c.date) as vaccinatedpeople
from corona as c
join corona2 as c2
on c.location = c2.location
and c.date = c2.date
where c.continent is not null
order by vaccinatedpeople desc