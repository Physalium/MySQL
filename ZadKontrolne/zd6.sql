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

select Continent, MAX(city.Population)
from country,
     city
where CountryCode = Code
group by 1;

-- 4

select Continent, count(*) "Ilosc miast"
from country,
     city c
where c.CountryCode = Code
group by Continent;

-- 5
select city.Name "Miasto", country.Name "Panstwo"
from city,
     country
where city.Name = country.Name
  and city.CountryCode = Code;

-- 6
select Name, language
from country,
     countrylanguage
where CountryCode = Code
  and (Language = Name or Language = null);

-- 7
select m.Name, j.Language
from country k,
     city m,
     countrylanguage j
where m.CountryCode = k.Code
  and j.Language = "Polish"
  and k.Code = j.CountryCode;

-- 8

select j.Language, count(j.Language) ile
from country k,
     countrylanguage j
where j.CountryCode = k.Code
group by 1
having ile > 5
order by 2 desc;

