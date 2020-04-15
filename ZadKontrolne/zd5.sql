-- 1
select Continent "Kontynent", count(*) "Ilość państw"
from country
group by Continent;
-- 2
select Continent "Kontynent", count(*) "Ilość państw"
from country
group by Continent
order by 2;
-- 3
select Continent,
       sum(SurfaceArea) "Pole Powierzchni",
       sum(Population)  "Populacja"
from country
group by Continent
order by 3 desc;
-- 4
select Continent        "Kontynent",
       count(*)         "Ilość państw",
       avg(SurfaceArea) "Sr pole pow",
       avg(Population)  "sr populacja"
from country
group by Continent;

-- 5
select GovernmentForm, count(GovernmentForm)
from country
where Continent = 'Europe'
  and Population > pow(10, 6)
group by GovernmentForm
order by 2 desc
limit 1;

-- 6
select CountryCode, count(*)
from city
group by CountryCode
order by 2 desc
limit 1;

-- 7
select Language, count(CountryCode)
from countrylanguage
group by Language
order by 2 desc
limit 10;

-- 8
select GovernmentForm
from country
group by GovernmentForm
having count(*) >= 10;

-- 9
select IndepYear, count(IndepYear)
from country
group by IndepYear
order by 2 desc;

-- 10

select IndepYear
from country
group by IndepYear
having count(IndepYear) >= 5;