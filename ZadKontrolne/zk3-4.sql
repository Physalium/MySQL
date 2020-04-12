use swiat;
-- 1
select name, SurfaceArea
from country
where Continent like 'Asia'
order by SurfaceArea
limit 1;

-- 2
select name, SurfaceArea
from country
order by SurfaceArea desc
limit 5;

-- 3
select name, SurfaceArea
from country
order by SurfaceArea
limit 10;

-- 4
select name, SurfaceArea
from country
order by SurfaceArea asc
limit 10;

-- 5
select name "Państwo", SurfaceArea "Pole powierzchni"
from country
where Continent = 'Europe'
  and SurfaceArea between 40000 and 100000;

-- 6

select name
from city
where name like "Z%k";

-- 7

select name, Population
from city
where name like "W%"
  and Population > 1000000;

-- 8

select name, Population
from city
where Population not between 500 and 9000000;

-- 9

select Name, Continent, SurfaceArea
from country
order by Continent, SurfaceArea desc;

-- 10

select Name, Population / SurfaceArea "Zaludnienie"
from country
order by 2 desc
limit 10;

-- 11
select Name, Population / SurfaceArea "Zaludnienie"
from country
where SurfaceArea > 10000
order by 2 desc
limit 10;

-- 12
select Name, Population / SurfaceArea "Zaludnienie"
from country
order by 2 asc
limit 4;

-- 13
select Name, Population / SurfaceArea "Zaludnienie"
from country
where Population != 0
order by 2
limit 10;

-- 14
select name, IndepYear
from country
where IndepYear is null;

-- 15
select name
from country
where IndepYear
order by SurfaceArea desc
limit 1;

-- 16
select name, Population, Continent
from country
where Continent = 'Asia'
  and IndepYear < 0
order by Population desc;

-- 17
select name, Population, IndepYear
from country
where Population > 5000000
  and (IndepYear is null or IndepYear < 0);

-- 18
select name, CountryCode, Population
from city
where CountryCode like "pol"
order by Population asc
limit 1;