/* Creating Portfolio Project`27`*/

create database PortfolioProject;

use PortfolioProject;
select * from covidvaccinations;
select * from coviddeaths;


-- Count of rows of two different tables 

SELECT  (
        SELECT COUNT(*)
        FROM   covidvaccinations
        ) AS count1,
        (
        SELECT COUNT(*)
        FROM   coviddeaths
        ) AS count2
FROM    dual;


-- select data which we are going to use


select location,date,total_cases,new_cases,total_deaths,population
from coviddeaths
order by 1,2;

-- Country wise total covid cases

select location, sum(total_cases) TCovidCases
from coviddeaths
group by location;


-- Total cases versus total deaths

select location, year(date) Year,sum(total_cases) TotalCovidCases,
	   Concat(((sum(total_deaths))/sum(total_cases))*100,'%') DeathsPercnt, 
       sum(total_cases-total_deaths) RecoveredCases,
       concat(((sum(total_cases-total_deaths)/sum(total_cases))*100),'%') RecoveredPercnt
from coviddeaths
group by location,year(date)
order by 4;


-- Total cases vs population
select location, year(date) Year,avg(population),Max(total_cases) HighestInfectionCount, (Max(total_cases)/avg(population)) *100 HighestInfectnPercnt,
       (avg(population)-max(total_cases)) UnEffectedPepl,
       concat(((avg(population)-max(total_cases))/avg(population)*100),'%') UnEfectdPercent
from coviddeaths
group by location,year(date)
order by 5 desc;

-- Lets break down by continent

select continent,sum(population),sum(total_cases) CovidCases, sum(population-total_cases) UnEffectedPepl
from coviddeaths
group by continent
order by 1;

select count(distinct(location)) from coviddeaths;

-- Showing continents with highest death count per population

select continent,location,Max(total_deaths)
from coviddeaths
group by continent,location
order by 1;

-- Global Covidcases and death%
select sum(new_deaths) from coviddeaths where year(date)=2023;

select year(date),sum(new_cases) TotalCovidCases,sum(new_deaths) TotalDeaths
from coviddeaths
group by year(date)
order by 1;

-- 
select date,continent,location,new_deaths, 
sum(new_deaths) over (partition by location order by date) cummulative_new_deaths
from
coviddeaths;



-- joins

Select count(*) from coviddeaths CovD 
inner join 
covidvaccinations CovV
on 
CovD.location=CovV.location;


Select * from covidvaccinations CovD 
inner join 
 coviddeaths CovV
on 
CovD.location=CovV.location;


select * from coviddeaths;
select * from covidvaccinations;

Select year(CovD.date),month(CovD.date), CovV.location,sum(population) Country_Wise_Population,
       sum(people_fully_vaccinated) Country_Wise_Vaccinated from covidvaccinations CovD
inner join 
coviddeaths CovV
on 
CovD.location=CovV.location
and CovD.date=CovV.date
group by month(CovD.date),year(CovD.date),CovD.location
order by 1;

-- Total Vaccinations vs Population location wise

Select A.*, sum((A.Country_Wise_Population-A.Country_Wise_Vaccinated) *100/A.Country_Wise_Population) '%_Vacc_P'
from
(Select CovV.location,sum(population) Country_Wise_Population,
       sum(people_fully_vaccinated) Country_Wise_Vaccinated from covidvaccinations CovD
       -- ((sum(population))-(sum(people_fully_vaccinated)))*100)
	inner join 
 coviddeaths CovV
on 
CovD.location=CovV.location

group by CovV.location) A

group by A.location;


-- use CTE

WITH Per_Vac_Pepl (loc,Country_Wise_Population,Country_Wise_Vaccinated)

AS

(
Select CovV.location loc,sum(population) Country_Wise_Population,
       sum(people_fully_vaccinated) Country_Wise_Vaccinated 
from 

covidvaccinations CovD

inner join 

coviddeaths CovV

on 

CovD.location=CovV.location

group by CovV.location
)

Select * ,sum((Country_Wise_Population-Country_Wise_Vaccinated) *100/Country_Wise_Population) '%_Vacc_P'
from
Per_Vac_Pepl
group by loc

-- CTE for cummulative percentages of vaccinations


-- Create views

