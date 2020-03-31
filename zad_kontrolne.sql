use swiat;
-- 1
select name, SurfaceArea
from country
where Continent like 'Asia'
order by SurfaceArea asc
limit 1;

-- 2
select name, SurfaceArea from country order by SurfaceArea desc limit 5;

-- 3
select name, SurfaceArea from country order by SurfaceArea asc limit 10;

-- 4
select name, SurfaceArea from country order by SurfaceArea asc limit 10;

-- 5
select name "Państwo", SurfaceArea "Pole powierzchni" from country where Continent='Europe' and SurfaceArea between 40000 and 100000;

