-- 1
select m.Name "Stolica ", m.Population "Populacja w stolicy", p.Name "Panstwo", p.Population "Populacja panstwa"
from city m,
     country p
where m.ID = p.Capital
  and p.Continent = 'Europe';

-- 2

select city.Name
from city,
     country
where CountryCode = Code
  and Continent = 'Europe'
order by city.Population desc
limit 1;

-- 3

select Continent, city.Name
from country,
     city
where city.CountryCode=country.Code
group by Continent, city.Name
order by city.Population desc
limit 12;
