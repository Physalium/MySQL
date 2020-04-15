 -- czasami istnieje potrzeba wyœwietlania wyników "w pionie" a nie "w poziomie"
 -- opowiadaj¹ za to operatory UNION i UNION ALL
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
 -- ka¿dy wynik tylko po jednym razie, jeœli chcemy mieæ wszystkie wyniki, to:
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

 -- oczywiœcie liczba kolumn mo¿e byæ wiêksza, wtedy
 -- dla UNION unikatowa ma byæ para (n-ka) kolumn
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

 -- jeœli wszystkie wyniki, to:
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

 -- przy ró¿nej liczbie kolumn zapytanie koñczy siê b³êdem:
 --
 select imie, nazwisko from osoby
     union -- albo union all
     select operator, typ, numer from telefony;
ERROR 1222 (21000): The used SELECT statements have a different number of columns
 --
 -- przyk³ad zastosowania: mamy tabelê, w której mamy osoby z podzia³em na p³eæ (kobieta - k
 -- mê¿czyzna - m) i ze wzglêdu na stan cywilni (zajêci - z i wolni w); chcemy wypisaæ po ile
 -- jest osób danego typu (wolne panie, zajête panie, wolni faceci, zajêci faceci)
 --
 -- musimy wczeniej poznaæ funkcjê licz¹c¹, jest to funkcja COUNT
 --
 -- sprawdŸmy, najpierw brutalnie, ile jest osób z Gliwic:
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

 -- okazuje siê, ¿e zamiast miasto w count mo¿e byæ cokolwiek:

 select count("Wypisz proszê, ilu mam znajomych z Gliwic.") ile
     from osoby where
     miasto = "GLIwiCE";
+-----+
| ile |
+-----+
|   6 |
+-----+
1 row in set (0.00 sec)

-- mo¿e tam byæ cokolwiek, najczêœciej kolumna lub * (ró¿nicê poka¿emy póŸniej)


 select count(*) ile
     from osoby where
     miasto = "GLIwiCE";
+-----+
| ile |
+-----+
|   6 |
+-----+
1 row in set (0.00 sec)

 -- teraz utworzymy pomocnicz¹ tabelê t o kolumnach p³eæ i stan
 -- i wype³nimi j¹: 1 kobiet¹ woln¹ (1kw), 2kz, 3mw i 4mz
 --
 create table test(
     p enum("k","m"),
     s enum("w","z"));
Query OK, 0 rows affected (0.30 sec)

 insert test value ("k", "w"), ("k", "z"), ("k", "z"), ("m", "w"), ("m", "w"),
     ("m", "w"), ("m", "z"), ("m", "z"), ("m", "z"), ("m", "z");
Query OK, 10 rows affected (0.17 sec)
Records: 10  Duplicates: 0  Warnings: 0

 -- policzmy liczbê typów osób
 select "k-w" AS "p³eæ-stan", count(*) AS ilosc
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
| p³eæ-stan | ilosc |
+-----------+-------+
| k-w       |     1 |
| k-z       |     2 |
| m-w       |     3 |
| m-z       |     4 |
+-----------+-------+
4 rows in set (0.00 sec)

 -- nie usuwamy jeszcze tabeli test, powtórzymy to zapytanie póŸniej, du¿o proœciej
 --
 --
 -- ZADANIE: kontynenty w bazie œwiat podzielone s¹ na regiony (kolumna region)
 -- sprawdŸ, ile jest regionów w Europie
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

 -- wydaje siê, ¿e jest ich 46, ale ³atwo mo¿na zauwa¿yæ, ¿e regiony te siê powtarzaj¹
 -- w takim razie - czym jest liczba 46?
 -- Poniewa¿ przebiegliœmy tabelê pañstw, wybieraj¹c tylko te z Europy (przy okazji
 -- wypisuj¹c region), wiêc liczba ta oznacza liczbê pañstw europejskich.
 --
 -- poprawiamy zapytanie wykorzystuj¹c polecenie DISTINCT, które eliminuje duplikaty
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

 -- okazuje siê, ¿e regionów w Europie jest 6
 --
 -- oczywiœcie mo¿na to samo zrobiæ bez wypisywania tych regionów, znamy funkcjê COUNT
 --
 select count(distinct region) ile -- pomyœl, a potem sprawdŸ, co bêdzie jeœli w zapytaniu
     from country						 -- zamienimy na DISTINCT COUNT(region)
     where continent = "europe";
+-----+
| ile |
+-----+
|   6 |
+-----+
1 row in set (0.01 sec)

 --
 -- funkcja COUNT jest jedn¹ z funkcji agreguj¹cych, pozosta³e (podstawowe)
 -- funkcje agreguj¹ce to (na przyk³adzie zapytania):
 --
 select MAX(population) najwiêksze, MIN(population) najmniejsze,
     AVG(population) rednio, SUM(population) suma, COUNT(population) ile
     from city;
+------------+-------------+-------------+------------+------+
| najwiêksze | najmniejsze | œrednio     | suma       | ile  |
+------------+-------------+-------------+------------+------+
|   10500000 |          42 | 350468.2236 | 1429559884 | 4079 |
+------------+-------------+-------------+------------+------+
1 row in set (0.00 sec)

 -- ZADANIE: wypisz liczbê miast powy¿ej 5 milionów mieszkañców
 --
 select count(*) ile from city
     where population > 5*pow(10,6);
+-----+
| ile |
+-----+
|  24 |
+-----+
1 row in set (0.34 sec)

 -- ZADANIE: jak sprawdziæ poprawnoœæ powy¿szego wyniku?
 --
 select name miasto, population ilu_ludzi
     from city
     order by 2 desc -- sortujemy po mieszkañcach malej¹co
     limit 25; -- wypisujemy o jedno miasto wiêcej, ¿eby mieæ pewnoæ poprawnoœci powy¿szego
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

 -- w zapytaniu o regiony europejskie (6) i poprzedzaj¹ce go (46) nasuwa siê
 -- pytanie: po ile jest pañstw europejskich w ka¿dym z regionów
 --
 -- do tego rodzaju zapytañ s³u¿y wa¿na opcja GROUP BY, która potrafi
 -- grupowaæ wyniki po zadanej kategorii
 --
 -- ZADANIE: wypisz nazwê regionu europejskiego i liczbê pañstw tego regionu
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

 -- ZADANIE: wypisz kod (na literê P) pañstwa, iloœæ miast w tym pañstwie
 -- i sumê mieszkañców tych miast sotrtuj¹c po iloœci miast, potem po mieszkañcach
 select countrycode kod, count(*) "ile miast",
     sum(population) "ilu mieszczuchów" from city
     where countrycode like "p%"
     group by kod -- mo¿na grupowaæ po aliasie albo po numerze (podobnie jak w sortowaniu)
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

 -- poka¿emy teraz ró¿nicê pomiêdzy COUNT("napis"), count(*), count(kolumna)
 --
 -- poprzednio zajmowalimy siê zmienn¹ typu NULL,
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


 select count(gnpold) kolumna, count(*) ogólnie -- ró¿nica: po kolumnie
     from country -- zlicza wartoci inne ni¿ NULL, * - zlicza wszystko
     where name like "P%"; -- (chyba, ¿e byby wiesz samych NULL-i)
+---------+---------+
| kolumna | ogólnie |
+---------+---------+
|       9 |      12 |
+---------+---------+
1 row in set (0.00 sec)

 -- ZADANIE: wypisz sumê mieszkañców miast z pañstw, ale tylko tych,
 -- gdzie liczba ta jest wiêksza od 10 000 000

 select countrycode kod, sum(population) ilu_w_miescie
     from city
     where
     Population > 1e7 -- zapis "kalkulatorowy": xey oznacza x*pow(10,y)
     group by 1;
ERROR 1111 (HY000): Invalid use of group function
 --
 -- zapytanie koñczy siê b³êdem, jest on spowodowany tym, ¿e jeœli wyznaczamy
 -- wartoœæ funkcji agreguj¹cej (COUNT, MAX, SUM, ...) i chcemy przefiltrowaæ
 -- wyniki po jej wartoci (funkcji agreguj¹cej), to trzeba u¿yæ klauzuli HAVING:
 --
 select countrycode kod, sum(population) ilu_w_miescie
     from city
     group by 1 -- mo¿na sortowaæ po numerze wypisywanej kolumny (jak w ORDER BY)
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

 -- jeœli jest potrzeba u¿ycia równie¿ warunku WHERE, to oczywiœcie mo¿na
 -- nale¿y tylko zachowaæ odpowiedni porz¹dek sk³adni
 --
 -- ZADANIE: uzupe³nij powy¿sze zapytanie, tak ¿eby wypisywaæ tylko kraje,
	   -- których kod zaczyna siê liter¹ "P"
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
 -- grupowanie (GROUP BY) mo¿na, podobnie jak sortowanie (ORDER BY) zagnie¿d¿aæ
 --
 -- ZADANIE: wypisz nazwy kontynentów i liczbê pañstw na nich le¿¹cych,
 -- których nazwy zaczynaj¹ siê jedn¹ z liter "H", "P" lub "U"
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
 -- ZADANIE: zweryfikuj powy¿sze zapytanie na przyk³adzie Azji i Europy, wypisuj¹c te kraje
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
 -- ZADANIE: wróæ do tabeli test (w bazie znajomi) i wykorzystuj¹c grupowanie
 -- napisz zapytanie dotycz¹ce p³ci i stanu
 --

 use znajomi
Database changed

 select p p³eæ, s stan, count(*) ile
     from test
     group by p, s;
+------+------+-----+
| p³eæ | stan | ile |
+------+------+-----+
| k    | w    |   1 |
| k    | z    |   2 |
| m    | w    |   3 |
| m    | z    |   4 |
+------+------+-----+
4 rows in set (0.00 sec)


 -- jeli bardzo chcielibymy, ¿eby by³a tylko jedna kolumna na p³eæ-stan (jak poprzednio),
 -- to mo¿na u¿yæ poznanych wczeœniej funkcji:
 --
 select concat(if(p="m","panowie ","panie "), if(s="w","stanu wolnego","brak wolnoœci"))
     "p³eæ - stan", count(*) ile
     from test
     group by p, s
     order by p, s;
+------------------------+-----+
| p³eæ - stan            | ile |
+------------------------+-----+
| panie stanu wolnego    |   1 |
| panie brak wolnoœci    |   2 |
| panowie stanu wolnego  |   3 |
| panowie brak wolnoœci  |   4 |
+------------------------+-----+
4 rows in set (0.00 sec)

 --
 -- tabeli test dziêkujemy za wspó³pracê
 --
 drop table test; -- i wracamy do œwiata na podsumowuj¹ce zapytanie
Query OK, 0 rows affected (0.40 sec)

 use swiat
Database changed
 --
 -- ZADANIE: wypisz g³owê pañstwa i liczbê krajów, którymi ta g³owa rz¹dzi
 -- interesuj¹ nas tylko rz¹dz¹cy nie zaczynaj¹cy siê na samog³oskê
 -- wypisz tylko te wyniki, gdzie liczba podporz¹dkowanych krajów
 -- jest wiêksza od 2 i niepodzielna przez 5, wyniki posortuj po liczbie krajów
 -- a wewn¹trz po rz¹dz¹cym (w odwrotnej kolejnoœci)
 -- pomiñ w wypisywaniu pierwszy wynik, wypisz 4 kolejne
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

 -- ZADANIE: zweryfikuj powy¿szy wynik wypisuj¹c rz¹dz¹cych i liczbê pañstw
 -- sortowanie po liczbie pañstw w odwrotnym porz¹dku,
 -- 9 pocz¹tkowych wyników

 select headofstate g³owa, count(*) ile_krajow
     from country
     group by 1
     order by 2 desc
     limit 9;
+----------------+------------+
| g³owa          | ile_krajow |
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
