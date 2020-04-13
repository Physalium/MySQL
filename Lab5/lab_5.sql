 -- czasami istnieje potrzeba wyświetlania wyników "w pionie" a nie "w poziomie"
 -- opowiadają za to operatory UNION i UNION ALL
 --
 -- ZADANIE: wypiszemy imiona i typy telefonów (z osoby i telefony):
 --
 use znajomi
 select imie from osoby
     UNION
     select typ from telefony;
+-------------+
| imie        |
+-------------+
| Jan         |
| Ola         |
| Ela         |
| Ala         |
| Iza         |
| Marek       |
| imie        |
| www         |
| komórka     |
| stacjonarny |
+-------------+
10 rows in set (0.03 sec)

 -- w tabeli telefonów jest wiele telefonów typu komórka, operator UNION wypisuje
 -- każdy wynik tylko po jednym razie, jeśli chcemy mieć wszystkie wyniki, to:
 --
 select imie from osoby
     UNION ALL
     select typ from telefony;
+-------------+
| imie        |
+-------------+
| Jan         |
| Ola         |
| Ela         |
| Ala         |
| Iza         |
| Marek       |
| imie        |
| Ela         |
| www         |
| komórka     |
| komórka     |
| stacjonarny |
| komórka     |
| komórka     |
| komórka     |
| komórka     |
+-------------+
16 rows in set (0.00 sec)

 -- oczywiście liczba kolumn może być większa, wtedy
 -- dla UNION unikatowa ma być para (n-ka) kolumn
 --
 select imie, nazwisko from osoby
     union
     select operator, typ from telefony;
+--------+-------------+
| imie   | nazwisko    |
+--------+-------------+
| Jan    | Lis         |
| Ola    | Nowak       |
| Ela    | Maj         |
| Ala    | Guz         |
| Iza    | Kot         |
| Marek  | Reks        |
| imie   | nazwisko    |
| Ela    | Nowak       |
| www    | onet        |
| era    | komórka     |
| tp     | komórka     |
| tp     | stacjonarny |
| orange | komórka     |
| heyah  | komórka     |
+--------+-------------+
14 rows in set (0.00 sec)

 -- jeśli wszystkie wyniki, to:
 --
 select imie, nazwisko from osoby
     union all
     select operator, typ from telefony;
+--------+-------------+
| imie   | nazwisko    |
+--------+-------------+
| Jan    | Lis         |
| Ola    | Nowak       |
| Ela    | Maj         |
| Ala    | Guz         |
| Iza    | Kot         |
| Marek  | Reks        |
| imie   | nazwisko    |
| Ela    | Nowak       |
| www    | onet        |
| era    | komórka     |
| tp     | komórka     |
| tp     | stacjonarny |
| orange | komórka     |
| orange | komórka     |
| heyah  | komórka     |
| heyah  | komórka     |
+--------+-------------+
16 rows in set (0.00 sec)

 -- przy różnej liczbie kolumn zapytanie kończy się błędem:
 --
 select imie, nazwisko from osoby
     union -- albo union all
     select operator, typ, numer from telefony;
ERROR 1222 (21000): The used SELECT statements have a different number of columns
 --
 -- przykład zastosowania: mamy tabelę, w której mamy osoby z podziałem na płeć (kobieta - k
 -- mężczyzna - m) i ze względu na stan cywilni (zajęci - z i wolni w); chcemy wypisać po ile
 -- jest osób danego typu (wolne panie, zajęte panie, wolni faceci, zajęci faceci)
 --
 -- musimy wczeniej poznać funkcję liczącą, jest to funkcja COUNT
 --
 -- sprawdźmy, najpierw brutalnie, ile jest osób z Gliwic:
 --
 select * from osoby;
+------+-------+----------+------+----------+
| id_o | imie  | nazwisko | wiek | miasto   |
+------+-------+----------+------+----------+
|    1 | Jan   | Lis      |    0 | gliwice  |
|    2 | Ola   | Nowak    |   56 | gliwice  |
|    3 | Ela   | Maj      |   21 | gliwice  |
|    4 | Ala   | Guz      |   87 | gliwice  |
|    5 | Iza   | Kot      |   38 | gliwice  |
|    6 | Marek | Reks     |   30 | Zabrze   |
|    7 | imie  | nazwisko |   25 | zabrze   |
|    8 | Ela   | Nowak    |   17 | Nowa Sól |
|    9 | www   | onet     |   90 | gliwice  |
+------+-------+----------+------+----------+
9 rows in set (0.00 sec)

 -- jest ich 6, a teraz subtelniej:
 --
 select count(miasto) ile
     from osoby
     where miasto = "gliwice";
+-----+
| ile |
+-----+
|   6 |
+-----+
1 row in set (0.34 sec)

 -- okazuje się, że zamiast miasto w count może być cokolwiek:

 select count("Wypisz proszę, ilu mam znajomych z Gliwic.") ile
     from osoby where
     miasto = "GLIwiCE";
+-----+
| ile |
+-----+
|   6 |
+-----+
1 row in set (0.00 sec)

-- może tam być cokolwiek, najczęściej kolumna lub * (różnicę pokażemy później)


 select count(*) ile
     from osoby where
     miasto = "GLIwiCE";
+-----+
| ile |
+-----+
|   6 |
+-----+
1 row in set (0.00 sec)

 -- teraz utworzymy pomocniczą tabelę t o kolumnach płeć i stan
 -- i wypełnimi ją: 1 kobietą wolną (1kw), 2kz, 3mw i 4mz
 --
 create table test(
     p enum("k","m"),
     s enum("w","z"));
Query OK, 0 rows affected (0.30 sec)

 insert test value ("k", "w"), ("k", "z"), ("k", "z"), ("m", "w"), ("m", "w"),
     ("m", "w"), ("m", "z"), ("m", "z"), ("m", "z"), ("m", "z");
Query OK, 10 rows affected (0.17 sec)
Records: 10  Duplicates: 0  Warnings: 0

 -- policzmy liczbę typów osób
 select "k-w" AS "płeć-stan", count(*) AS ilosc
     from test
     where
     p = "k" and s = "w"
     union
     select "k-z", count(*)
     from test
     where
     p = "k" and s = "z"
     union
     select "m-w", count(*)
     from test
     where
     p = "m" and s = "w"
     union
     select "m-z", count(*)
     from test
     where
     p = "m" and s = "z";
+-----------+-------+
| płeć-stan | ilosc |
+-----------+-------+
| k-w       |     1 |
| k-z       |     2 |
| m-w       |     3 |
| m-z       |     4 |
+-----------+-------+
4 rows in set (0.00 sec)

 -- nie usuwamy jeszcze tabeli test, powtórzymy to zapytanie później, dużo prościej
 --
 --
 -- ZADANIE: kontynenty w bazie świat podzielone są na regiony (kolumna region)
 -- sprawdź, ile jest regionów w Europie
 --
 use swiat;
Database changed
 select region from country
     where continent = "europe";
+------------------+
| region           |
+------------------+
| Western Europe   |
| Southern Europe  |
| Southern Europe  |
| Western Europe   |
| Southern Europe  |
| British Islands  |
| Eastern Europe   |
| Southern Europe  |
| Nordic Countries |
| Southern Europe  |
| Nordic Countries |
| British Islands  |
| Nordic Countries |
| Southern Europe  |
| Western Europe   |
| Southern Europe  |
| Southern Europe  |
| Southern Europe  |
| Baltic Countries |
| Western Europe   |
| Baltic Countries |
| Western Europe   |
| Southern Europe  |
| Southern Europe  |
| Eastern Europe   |
| Western Europe   |
| Nordic Countries |
| Southern Europe  |
| Eastern Europe   |
| Western Europe   |
| Eastern Europe   |
| Nordic Countries |
| Western Europe   |
| Southern Europe  |
| Eastern Europe   |
| Southern Europe  |
| Nordic Countries |
| Western Europe   |
| Nordic Countries |
| Eastern Europe   |
| Eastern Europe   |
| Eastern Europe   |
| Eastern Europe   |
| Southern Europe  |
| Eastern Europe   |
| Baltic Countries |
+------------------+
46 rows in set (0.18 sec)

 -- wydaje się, że jest ich 46, ale łatwo można zauważyć, że regiony te się powtarzają
 -- w takim razie - czym jest liczba 46?
 -- Ponieważ przebiegliśmy tabelę państw, wybierając tylko te z Europy (przy okazji
 -- wypisując region), więc liczba ta oznacza liczbę państw europejskich.
 --
 -- poprawiamy zapytanie wykorzystując polecenie DISTINCT, które eliminuje duplikaty
 --
 select DISTINCT region from country
     where continent = "europe";
+------------------+
| region           |
+------------------+
| Western Europe   |
| Southern Europe  |
| British Islands  |
| Eastern Europe   |
| Nordic Countries |
| Baltic Countries |
+------------------+
6 rows in set (0.00 sec)

 -- okazuje się, że regionów w Europie jest 6
 --
 -- oczywiście można to samo zrobić bez wypisywania tych regionów, znamy funkcję COUNT
 --
 select count(distinct region) ile -- pomyśl, a potem sprawdź, co będzie jeśli w zapytaniu
     from country						 -- zamienimy na DISTINCT COUNT(region)
     where continent = "europe";
+-----+
| ile |
+-----+
|   6 |
+-----+
1 row in set (0.01 sec)

 --
 -- funkcja COUNT jest jedną z funkcji agregujących, pozostałe (podstawowe)
 -- funkcje agregujące to (na przykładzie zapytania):
 --
 select MAX(population) największe, MIN(population) najmniejsze,
     AVG(population) rednio, SUM(population) suma, COUNT(population) ile
     from city;
+------------+-------------+-------------+------------+------+
| największe | najmniejsze | średnio     | suma       | ile  |
+------------+-------------+-------------+------------+------+
|   10500000 |          42 | 350468.2236 | 1429559884 | 4079 |
+------------+-------------+-------------+------------+------+
1 row in set (0.00 sec)

 -- ZADANIE: wypisz liczbę miast powyżej 5 milionów mieszkańców
 --
 select count(*) ile from city
     where population > 5*pow(10,6);
+-----+
| ile |
+-----+
|  24 |
+-----+
1 row in set (0.34 sec)

 -- ZADANIE: jak sprawdzić poprawność powyższego wyniku?
 --
 select name miasto, population ilu_ludzi
     from city
     order by 2 desc -- sortujemy po mieszkańcach malejąco
     limit 25; -- wypisujemy o jedno miasto więcej, żeby mieć pewnoć poprawności powyższego
+-------------------+-----------+
| miasto            | ilu_ludzi |
+-------------------+-----------+
| Mumbai (Bombay)   |  10500000 |
| Seoul             |   9981619 |
| S?o Paulo         |   9968485 |
| Shanghai          |   9696300 |
| Jakarta           |   9604900 |
| Karachi           |   9269265 |
| Istanbul          |   8787958 |
| Ciudad de M‚xico  |   8591309 |
| Moscow            |   8389200 |
| New York          |   8008278 |
| Tokyo             |   7980230 |
| Peking            |   7472000 |
| London            |   7285000 |
| Delhi             |   7206704 |
| Cairo             |   6789479 |
| Teheran           |   6758845 |
| Lima              |   6464693 |
| Chongqing         |   6351600 |
| Bangkok           |   6320174 |
| Santaf‚ de Bogot  |   6260862 |
| Rio de Janeiro    |   5598953 |
| Tianjin           |   5286800 |
| Kinshasa          |   5064000 |
| Lahore            |   5063499 |
| Santiago de Chile |   4703954 |
+-------------------+-----------+
25 rows in set (0.00 sec)

 -- w zapytaniu o regiony europejskie (6) i poprzedzające go (46) nasuwa się
 -- pytanie: po ile jest państw europejskich w każdym z regionów
 --
 -- do tego rodzaju zapytań służy ważna opcja GROUP BY, która potrafi
 -- grupować wyniki po zadanej kategorii
 --
 -- ZADANIE: wypisz nazwę regionu europejskiego i liczbę państw tego regionu
 --
 select region, count(*) ile
     from country
     where continent = "europe"
     GROUP BY region
     order by 2;
+------------------+-----+
| region           | ile |
+------------------+-----+
| British Islands  |   2 |
| Baltic Countries |   3 |
| Nordic Countries |   7 |
| Western Europe   |   9 |
| Eastern Europe   |  10 |
| Southern Europe  |  15 |
+------------------+-----+
6 rows in set (0.00 sec)

 -- ZADANIE: wypisz kod (na literę P) państwa, ilość miast w tym państwie
 -- i sumę mieszkańców tych miast sotrtując po ilości miast, potem po mieszkańcach
 select countrycode kod, count(*) "ile miast",
     sum(population) "ilu mieszczuchów" from city
     where countrycode like "p%"
     group by kod -- można grupować po aliasie albo po numerze (podobnie jak w sortowaniu)
     order by 2, 3;
+-----+-----------+------------------+
| kod | ile miast | ilu mieszczuchów |
+-----+-----------+------------------+
| PCN |         1 |               42 |
| PLW |         1 |            12000 |
| PNG |         1 |           247000 |
| PYF |         2 |            51441 |
| PAN |         2 |           786755 |
| PRY |         5 |          1020020 |
| PRT |         5 |          1145011 |
| PSE |         6 |           902360 |
| PRI |         9 |          1564174 |
| PRK |        13 |          6476751 |
| PER |        22 |         12147242 |
| POL |        44 |         11687431 |
| PAK |        59 |         31546745 |
| PHL |       136 |         30934791 |
+-----+-----------+------------------+
14 rows in set (0.38 sec)

 -- pokażemy teraz różnicę pomiędzy COUNT("napis"), count(*), count(kolumna)
 --
 -- poprzednio zajmowalimy się zmienną typu NULL,
 -- bya ona m.in. w kolumnie gnpold
 --
 select name, gnpold from country
     where name like "P%";
+------------------+-----------+
| name             | gnpold    |
+------------------+-----------+
| Philippines      |  82239.00 |
| Pakistan         |  58549.00 |
| Palau            |      NULL |
| Panama           |   8700.00 |
| Papua New Guinea |   6328.00 |
| Paraguay         |   9555.00 |
| Peru             |  65186.00 |
| Pitcairn         |      NULL |
| Portugal         | 102133.00 |
| Puerto Rico      |  32100.00 |
| Poland           | 135636.00 |
| Palestine        |      NULL |
+------------------+-----------+
12 rows in set (0.02 sec)


 select count(gnpold) kolumna, count(*) ogólnie -- różnica: po kolumnie
     from country -- zlicza wartoci inne niż NULL, * - zlicza wszystko
     where name like "P%"; -- (chyba, że byby wiesz samych NULL-i)
+---------+---------+
| kolumna | ogólnie |
+---------+---------+
|       9 |      12 |
+---------+---------+
1 row in set (0.00 sec)

 -- ZADANIE: wypisz sumę mieszkańców miast z państw, ale tylko tych,
 -- gdzie liczba ta jest większa od 10 000 000

 select countrycode kod, sum(population) ilu_w_miescie
     from city
     where
     Population > 1e7 -- zapis "kalkulatorowy": xey oznacza x*pow(10,y)
     group by 1;
ERROR 1111 (HY000): Invalid use of group function
 --
 -- zapytanie kończy się błędem, jest on spowodowany tym, że jeśli wyznaczamy
 -- wartość funkcji agregującej (COUNT, MAX, SUM, ...) i chcemy przefiltrować
 -- wyniki po jej wartoci (funkcji agregującej), to trzeba użyć klauzuli HAVING:
 --
 select countrycode kod, sum(population) ilu_w_miescie
     from city
     group by 1 -- można sortować po numerze wypisywanej kolumny (jak w ORDER BY)
     having
     sum(population) > 1e7
     order by 2;
+-----+---------------+
| kod | ilu_w_miescie |
+-----+---------------+
| SAU |      10636700 |
| AUS |      11313666 |
| POL |      11687431 |
| PER |      12147242 |
| VEN |      12251091 |
| CAN |      12673840 |
| TWN |      13569336 |
| ITA |      15087019 |
| ZAF |      15196370 |
| ESP |      16669189 |
| NGA |      17366900 |
| ARG |      19996563 |
| UKR |      20074000 |
| EGY |      20083079 |
| COL |      20250990 |
| GBR |      22436673 |
| IRN |      26032990 |
| DEU |      26245483 |
| TUR |      28327028 |
| PHL |      30934791 |
| PAK |      31546745 |
| IDN |      37485695 |
| KOR |      38999893 |
| MEX |      59752521 |
| RUS |      69150700 |
| JPN |      77965107 |
| USA |      78625774 |
| BRA |      85876862 |
| IND |     123298526 |
| CHN |     175953614 |
+-----+---------------+
30 rows in set (0.01 sec)

 -- jeśli jest potrzeba użycia również warunku WHERE, to oczywiście można
 -- należy tylko zachować odpowiedni porządek składni
 --
 -- ZADANIE: uzupełnij powyższe zapytanie, tak żeby wypisywać tylko kraje,
	   -- których kod zaczyna się literą "P"
 --
 select countrycode kod, sum(population) ilu_w_miescie
     from city
     where
     countrycode like "p%"
     group by 1
     having
     sum(population) > 1e7
     order by 2;
+-----+---------------+
| kod | ilu_w_miescie |
+-----+---------------+
| POL |      11687431 |
| PER |      12147242 |
| PHL |      30934791 |
| PAK |      31546745 |
+-----+---------------+
4 rows in set (0.00 sec)
 -- grupowanie (GROUP BY) można, podobnie jak sortowanie (ORDER BY) zagnieżdżać
 --
 -- ZADANIE: wypisz nazwy kontynentów i liczbę państw na nich leżących,
 -- których nazwy zaczynają się jedną z liter "H", "P" lub "U"
 select continent kontynent, left(name, 1) znak, count(*) ile
     from country
     where
     name like "P%" or name like "h%" or name like "u%"
     group by 1, 2;
+---------------+------+-----+
| kontynent     | znak | ile |
+---------------+------+-----+
| Asia          | H    |   1 |
| Asia          | P    |   3 |
| Asia          | U    |   2 |
| Europe        | H    |   2 |
| Europe        | P    |   2 |
| Europe        | U    |   2 |
| North America | H    |   2 |
| North America | P    |   2 |
| North America | U    |   1 |
| Africa        | U    |   1 |
| Oceania       | P    |   3 |
| Oceania       | U    |   1 |
| Antarctica    | H    |   1 |
| South America | P    |   2 |
| South America | U    |   1 |
+---------------+------+-----+
15 rows in set (0.00 sec)

 --
 -- ZADANIE: zweryfikuj powyższe zapytanie na przykładzie Azji i Europy, wypisując te kraje
 --
 select continent kontynent, name kraj
     from country
     where
     continent in ("asia", "europe")
     and
     (name like "P%" or name like "h%" or name like "u%")
     order by 1, 2;
+-----------+-------------------------------+
| kontynent | kraj                          |
+-----------+-------------------------------+
| Asia      | Hong Kong                     |
| Asia      | Pakistan                      |
| Asia      | Palestine                     |
| Asia      | Philippines                   |
| Asia      | United Arab Emirates          |
| Asia      | Uzbekistan                    |
| Europe    | Holy See (Vatican City State) |
| Europe    | Hungary                       |
| Europe    | Poland                        |
| Europe    | Portugal                      |
| Europe    | Ukraine                       |
| Europe    | United Kingdom                |
+-----------+-------------------------------+
12 rows in set (0.00 sec)

 --
 -- ZADANIE: wróć do tabeli test (w bazie znajomi) i wykorzystując grupowanie
 -- napisz zapytanie dotyczące płci i stanu
 --

 use znajomi
Database changed

 select p płeć, s stan, count(*) ile
     from test
     group by p, s;
+------+------+-----+
| płeć | stan | ile |
+------+------+-----+
| k    | w    |   1 |
| k    | z    |   2 |
| m    | w    |   3 |
| m    | z    |   4 |
+------+------+-----+
4 rows in set (0.00 sec)


 -- jeli bardzo chcielibymy, żeby była tylko jedna kolumna na płeć-stan (jak poprzednio),
 -- to można użyć poznanych wcześniej funkcji:
 --
 select concat(if(p="m","panowie ","panie "), if(s="w","stanu wolnego","brak wolności"))
     "płeć - stan", count(*) ile
     from test
     group by p, s
     order by p, s;
+------------------------+-----+
| płeć - stan            | ile |
+------------------------+-----+
| panie stanu wolnego    |   1 |
| panie brak wolności    |   2 |
| panowie stanu wolnego  |   3 |
| panowie brak wolności  |   4 |
+------------------------+-----+
4 rows in set (0.00 sec)

 --
 -- tabeli test dziękujemy za współpracę
 --
 drop table test; -- i wracamy do świata na podsumowujące zapytanie
Query OK, 0 rows affected (0.40 sec)

 use swiat
Database changed
 --
 -- ZADANIE: wypisz głowę państwa i liczbę krajów, którymi ta głowa rządzi
 -- interesują nas tylko rządzący nie zaczynający się na samogłoskę
 -- wypisz tylko te wyniki, gdzie liczba podporządkowanych krajów
 -- jest większa od 2 i niepodzielna przez 5, wyniki posortuj po liczbie krajów
 -- a wewnątrz po rządzącym (w odwrotnej kolejności)
 -- pomiń w wypisywaniu pierwszy wynik, wypisz 4 kolejne
 --
 select headofstate glowa, count(*) ile_krajow
     from country
     where
     headofstate not like "a%" or
     headofstate not like "e%" or
     headofstate not like "u%" or
     headofstate not like "o%" or
     headofstate not like "y%" or
     headofstate not like "i%"
     group by 1
     having ile_krajow > 2 and mod(ile_krajow,5) <> 0
     order by 2, 1 desc
     limit 1, 4;
+----------------+------------+
| glowa          | ile_krajow |
+----------------+------------+
| Jiang Zemin    |          3 |
| Harald V       |          3 |
| Beatrix        |          3 |
| George W. Bush |          7 |
+----------------+------------+
4 rows in set (0.00 sec)

 -- ZADANIE: zweryfikuj powyższy wynik wypisując rządzących i liczbę państw
 -- sortowanie po liczbie państw w odwrotnym porządku,
 -- 9 początkowych wyników

 select headofstate głowa, count(*) ile_krajow
     from country
     group by 1
     order by 2 desc
     limit 9;
+----------------+------------+
| głowa          | ile_krajow |
+----------------+------------+
| Elisabeth II   |         35 |
| Jacques Chirac |         11 |
| George W. Bush |          7 |
| Beatrix        |          3 |
| Jiang Zemin    |          3 |
| Harald V       |          3 |
| Margrethe II   |          3 |
|                |          2 |
| Heydär Äliyev  |          1 |
+----------------+------------+
9 rows in set (0.00 sec)

 \q
