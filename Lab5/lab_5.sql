 -- czasami istnieje potrzeba wy�wietlania wynik�w "w pionie" a nie "w poziomie"
 -- opowiadaj� za to operatory UNION i UNION ALL
 --
 -- ZADANIE: wypiszemy imiona i typy telefon�w (z osoby i telefony):
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
| kom�rka     |
| stacjonarny |
+-------------+
10 rows in set (0.03 sec)

 -- w tabeli telefon�w jest wiele telefon�w typu kom�rka, operator UNION wypisuje
 -- ka�dy wynik tylko po jednym razie, je�li chcemy mie� wszystkie wyniki, to:
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
| kom�rka     |
| kom�rka     |
| stacjonarny |
| kom�rka     |
| kom�rka     |
| kom�rka     |
| kom�rka     |
+-------------+
16 rows in set (0.00 sec)

 -- oczywi�cie liczba kolumn mo�e by� wi�ksza, wtedy
 -- dla UNION unikatowa ma by� para (n-ka) kolumn
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
| era    | kom�rka     |
| tp     | kom�rka     |
| tp     | stacjonarny |
| orange | kom�rka     |
| heyah  | kom�rka     |
+--------+-------------+
14 rows in set (0.00 sec)

 -- je�li wszystkie wyniki, to:
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
| era    | kom�rka     |
| tp     | kom�rka     |
| tp     | stacjonarny |
| orange | kom�rka     |
| orange | kom�rka     |
| heyah  | kom�rka     |
| heyah  | kom�rka     |
+--------+-------------+
16 rows in set (0.00 sec)

 -- przy r�nej liczbie kolumn zapytanie ko�czy si� b��dem:
 --
 select imie, nazwisko from osoby
     union -- albo union all
     select operator, typ, numer from telefony;
ERROR 1222 (21000): The used SELECT statements have a different number of columns
 --
 -- przyk�ad zastosowania: mamy tabel�, w kt�rej mamy osoby z podzia�em na p�e� (kobieta - k
 -- m�czyzna - m) i ze wzgl�du na stan cywilni (zaj�ci - z i wolni w); chcemy wypisa� po ile
 -- jest os�b danego typu (wolne panie, zaj�te panie, wolni faceci, zaj�ci faceci)
 --
 -- musimy wczeniej pozna� funkcj� licz�c�, jest to funkcja COUNT
 --
 -- sprawd�my, najpierw brutalnie, ile jest os�b z Gliwic:
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
|    8 | Ela   | Nowak    |   17 | Nowa S�l |
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

 -- okazuje si�, �e zamiast miasto w count mo�e by� cokolwiek:

 select count("Wypisz prosz�, ilu mam znajomych z Gliwic.") ile
     from osoby where
     miasto = "GLIwiCE";
+-----+
| ile |
+-----+
|   6 |
+-----+
1 row in set (0.00 sec)

-- mo�e tam by� cokolwiek, najcz�ciej kolumna lub * (r�nic� poka�emy p�niej)


 select count(*) ile
     from osoby where
     miasto = "GLIwiCE";
+-----+
| ile |
+-----+
|   6 |
+-----+
1 row in set (0.00 sec)

 -- teraz utworzymy pomocnicz� tabel� t o kolumnach p�e� i stan
 -- i wype�nimi j�: 1 kobiet� woln� (1kw), 2kz, 3mw i 4mz
 --
 create table test(
     p enum("k","m"),
     s enum("w","z"));
Query OK, 0 rows affected (0.30 sec)

 insert test value ("k", "w"), ("k", "z"), ("k", "z"), ("m", "w"), ("m", "w"),
     ("m", "w"), ("m", "z"), ("m", "z"), ("m", "z"), ("m", "z");
Query OK, 10 rows affected (0.17 sec)
Records: 10  Duplicates: 0  Warnings: 0

 -- policzmy liczb� typ�w os�b
 select "k-w" AS "p�e�-stan", count(*) AS ilosc
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
| p�e�-stan | ilosc |
+-----------+-------+
| k-w       |     1 |
| k-z       |     2 |
| m-w       |     3 |
| m-z       |     4 |
+-----------+-------+
4 rows in set (0.00 sec)

 -- nie usuwamy jeszcze tabeli test, powt�rzymy to zapytanie p�niej, du�o pro�ciej
 --
 --
 -- ZADANIE: kontynenty w bazie �wiat podzielone s� na regiony (kolumna region)
 -- sprawd�, ile jest region�w w Europie
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

 -- wydaje si�, �e jest ich 46, ale �atwo mo�na zauwa�y�, �e regiony te si� powtarzaj�
 -- w takim razie - czym jest liczba 46?
 -- Poniewa� przebiegli�my tabel� pa�stw, wybieraj�c tylko te z Europy (przy okazji
 -- wypisuj�c region), wi�c liczba ta oznacza liczb� pa�stw europejskich.
 --
 -- poprawiamy zapytanie wykorzystuj�c polecenie DISTINCT, kt�re eliminuje duplikaty
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

 -- okazuje si�, �e region�w w Europie jest 6
 --
 -- oczywi�cie mo�na to samo zrobi� bez wypisywania tych region�w, znamy funkcj� COUNT
 --
 select count(distinct region) ile -- pomy�l, a potem sprawd�, co b�dzie je�li w zapytaniu
     from country						 -- zamienimy na DISTINCT COUNT(region)
     where continent = "europe";
+-----+
| ile |
+-----+
|   6 |
+-----+
1 row in set (0.01 sec)

 --
 -- funkcja COUNT jest jedn� z funkcji agreguj�cych, pozosta�e (podstawowe)
 -- funkcje agreguj�ce to (na przyk�adzie zapytania):
 --
 select MAX(population) najwi�ksze, MIN(population) najmniejsze,
     AVG(population) rednio, SUM(population) suma, COUNT(population) ile
     from city;
+------------+-------------+-------------+------------+------+
| najwi�ksze | najmniejsze | �rednio     | suma       | ile  |
+------------+-------------+-------------+------------+------+
|   10500000 |          42 | 350468.2236 | 1429559884 | 4079 |
+------------+-------------+-------------+------------+------+
1 row in set (0.00 sec)

 -- ZADANIE: wypisz liczb� miast powy�ej 5 milion�w mieszka�c�w
 --
 select count(*) ile from city
     where population > 5*pow(10,6);
+-----+
| ile |
+-----+
|  24 |
+-----+
1 row in set (0.34 sec)

 -- ZADANIE: jak sprawdzi� poprawno�� powy�szego wyniku?
 --
 select name miasto, population ilu_ludzi
     from city
     order by 2 desc -- sortujemy po mieszka�cach malej�co
     limit 25; -- wypisujemy o jedno miasto wi�cej, �eby mie� pewno� poprawno�ci powy�szego
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
| Ciudad de M�xico  |   8591309 |
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
| Santaf� de Bogot� |   6260862 |
| Rio de Janeiro    |   5598953 |
| Tianjin           |   5286800 |
| Kinshasa          |   5064000 |
| Lahore            |   5063499 |
| Santiago de Chile |   4703954 |
+-------------------+-----------+
25 rows in set (0.00 sec)

 -- w zapytaniu o regiony europejskie (6) i poprzedzaj�ce go (46) nasuwa si�
 -- pytanie: po ile jest pa�stw europejskich w ka�dym z region�w
 --
 -- do tego rodzaju zapyta� s�u�y wa�na opcja GROUP BY, kt�ra potrafi
 -- grupowa� wyniki po zadanej kategorii
 --
 -- ZADANIE: wypisz nazw� regionu europejskiego i liczb� pa�stw tego regionu
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

 -- ZADANIE: wypisz kod (na liter� P) pa�stwa, ilo�� miast w tym pa�stwie
 -- i sum� mieszka�c�w tych miast sotrtuj�c po ilo�ci miast, potem po mieszka�cach
 select countrycode kod, count(*) "ile miast",
     sum(population) "ilu mieszczuch�w" from city
     where countrycode like "p%"
     group by kod -- mo�na grupowa� po aliasie albo po numerze (podobnie jak w sortowaniu)
     order by 2, 3;
+-----+-----------+------------------+
| kod | ile miast | ilu mieszczuch�w |
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

 -- poka�emy teraz r�nic� pomi�dzy COUNT("napis"), count(*), count(kolumna)
 --
 -- poprzednio zajmowalimy si� zmienn� typu NULL,
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


 select count(gnpold) kolumna, count(*) og�lnie -- r�nica: po kolumnie
     from country -- zlicza wartoci inne ni� NULL, * - zlicza wszystko
     where name like "P%"; -- (chyba, �e byby wiesz samych NULL-i)
+---------+---------+
| kolumna | og�lnie |
+---------+---------+
|       9 |      12 |
+---------+---------+
1 row in set (0.00 sec)

 -- ZADANIE: wypisz sum� mieszka�c�w miast z pa�stw, ale tylko tych,
 -- gdzie liczba ta jest wi�ksza od 10 000 000

 select countrycode kod, sum(population) ilu_w_miescie
     from city
     where
     Population > 1e7 -- zapis "kalkulatorowy": xey oznacza x*pow(10,y)
     group by 1;
ERROR 1111 (HY000): Invalid use of group function
 --
 -- zapytanie ko�czy si� b��dem, jest on spowodowany tym, �e je�li wyznaczamy
 -- warto�� funkcji agreguj�cej (COUNT, MAX, SUM, ...) i chcemy przefiltrowa�
 -- wyniki po jej wartoci (funkcji agreguj�cej), to trzeba u�y� klauzuli HAVING:
 --
 select countrycode kod, sum(population) ilu_w_miescie
     from city
     group by 1 -- mo�na sortowa� po numerze wypisywanej kolumny (jak w ORDER BY)
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

 -- je�li jest potrzeba u�ycia r�wnie� warunku WHERE, to oczywi�cie mo�na
 -- nale�y tylko zachowa� odpowiedni porz�dek sk�adni
 --
 -- ZADANIE: uzupe�nij powy�sze zapytanie, tak �eby wypisywa� tylko kraje,
	   -- kt�rych kod zaczyna si� liter� "P"
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
 -- grupowanie (GROUP BY) mo�na, podobnie jak sortowanie (ORDER BY) zagnie�d�a�
 --
 -- ZADANIE: wypisz nazwy kontynent�w i liczb� pa�stw na nich le��cych,
 -- kt�rych nazwy zaczynaj� si� jedn� z liter "H", "P" lub "U"
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
 -- ZADANIE: zweryfikuj powy�sze zapytanie na przyk�adzie Azji i Europy, wypisuj�c te kraje
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
 -- ZADANIE: wr�� do tabeli test (w bazie znajomi) i wykorzystuj�c grupowanie
 -- napisz zapytanie dotycz�ce p�ci i stanu
 --

 use znajomi
Database changed

 select p p�e�, s stan, count(*) ile
     from test
     group by p, s;
+------+------+-----+
| p�e� | stan | ile |
+------+------+-----+
| k    | w    |   1 |
| k    | z    |   2 |
| m    | w    |   3 |
| m    | z    |   4 |
+------+------+-----+
4 rows in set (0.00 sec)


 -- jeli bardzo chcielibymy, �eby by�a tylko jedna kolumna na p�e�-stan (jak poprzednio),
 -- to mo�na u�y� poznanych wcze�niej funkcji:
 --
 select concat(if(p="m","panowie ","panie "), if(s="w","stanu wolnego","brak wolno�ci"))
     "p�e� - stan", count(*) ile
     from test
     group by p, s
     order by p, s;
+------------------------+-----+
| p�e� - stan            | ile |
+------------------------+-----+
| panie stanu wolnego    |   1 |
| panie brak wolno�ci    |   2 |
| panowie stanu wolnego  |   3 |
| panowie brak wolno�ci  |   4 |
+------------------------+-----+
4 rows in set (0.00 sec)

 --
 -- tabeli test dzi�kujemy za wsp�prac�
 --
 drop table test; -- i wracamy do �wiata na podsumowuj�ce zapytanie
Query OK, 0 rows affected (0.40 sec)

 use swiat
Database changed
 --
 -- ZADANIE: wypisz g�ow� pa�stwa i liczb� kraj�w, kt�rymi ta g�owa rz�dzi
 -- interesuj� nas tylko rz�dz�cy nie zaczynaj�cy si� na samog�osk�
 -- wypisz tylko te wyniki, gdzie liczba podporz�dkowanych kraj�w
 -- jest wi�ksza od 2 i niepodzielna przez 5, wyniki posortuj po liczbie kraj�w
 -- a wewn�trz po rz�dz�cym (w odwrotnej kolejno�ci)
 -- pomi� w wypisywaniu pierwszy wynik, wypisz 4 kolejne
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

 -- ZADANIE: zweryfikuj powy�szy wynik wypisuj�c rz�dz�cych i liczb� pa�stw
 -- sortowanie po liczbie pa�stw w odwrotnym porz�dku,
 -- 9 pocz�tkowych wynik�w

 select headofstate g�owa, count(*) ile_krajow
     from country
     group by 1
     order by 2 desc
     limit 9;
+----------------+------------+
| g�owa          | ile_krajow |
+----------------+------------+
| Elisabeth II   |         35 |
| Jacques Chirac |         11 |
| George W. Bush |          7 |
| Beatrix        |          3 |
| Jiang Zemin    |          3 |
| Harald V       |          3 |
| Margrethe II   |          3 |
|                |          2 |
| Heyd�r �liyev  |          1 |
+----------------+------------+
9 rows in set (0.00 sec)

 \q
