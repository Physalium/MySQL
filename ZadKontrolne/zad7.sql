-- 1
use swiat;
select c.name,
       c.Population
from city c
where c.Population = (
    select max(population)
    from city mm
);
-- 2
select c.name
from city c,
     country k
where c.CountryCode = k.Code
  and k.Name like "Vietnam";
-- 3
select k.name,
       count(*)
from country k,
     city
where Continent = 'Europe'
  and city.CountryCode = k.Code
group by k.name;
-- 4
select k.name        kraj,
       count(m.Name) "ile miast"
from country k,
     city m
where m.CountryCode = k.code
  and k.Continent = 'Asia'
  and m.Population >= (
    select Population
    from city
    where city.ID = k.Capital
)
group by k.Name;

-- 5
select count(m.name) "ile miast"
from city m,
     country k
where k.Continent = 'Europe'
  and m.CountryCode = k.Code
  and m.Population >
      (select avg(city.Population)
       from country,
            city
       where city.ID = country.Capital
         and country.Continent = 'Europe');

-- 6
select k.Continent, m.name, m.Population
from country k,
     city m
where m.Population = (select max(q.Population)
                      from country p,
                           city q
                      where p.Continent = k.Continent
                        and q.CountryCode = p.Code)
  and k.Code = m.CountryCode
group by k.Continent;

-- 7
select k.Continent, m.name, m.Population
from country k,
     city m
where m.Population = (select max(q.Population)
                      from country p,
                           city q
                      where p.Continent = k.Continent
                        and q.ID = p.Capital
                        and q.CountryCode = p.Code)
  and k.Code = m.CountryCode
group by k.Continent;

-- 8
select k.Continent, k.name, m.Name
from country k,
     city m
where k.Population = (select max(p.Population)
                      from country p
                      where p.Continent = k.Continent
)
  and m.Population = (select max(q.Population)
                      from country p,
                           city q
                      where p.Name = k.Name
                        and q.CountryCode = p.Code)
  and k.Code = m.CountryCode
group by k.Continent;

-- 9
select k.Continent,
       j.Language,sum(k.Population*j.Percentage) ile
from country k,
     countrylanguage j
where j.CountryCode = k.Code
  and k.Population = (select sum(p.Population) from country p where p.Name=k.Name )
group by Continent;

select k.Continent,sum(Population) from country k,countrylanguage j where k.Code=j.CountryCode  group by Continent;
