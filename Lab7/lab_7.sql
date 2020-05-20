mysql> -- PODZAPYTANIA I
mysql> --
mysql> -- Podzapytania to zapytania, kt�rych wynik jest wykorzystywany
mysql> -- w innym (zewn�trznym) zapytaniu, ca�o�� jest jednym zapytaniem
mysql> --
mysql> -- Prostsz� wersj� podzapyta� s� tzw. podzapytania proste -
mysql> -- w nich zapytanie wewn�trzne raz zwraca wynik, do kt�rego
mysql> -- odnosi� si� b�dzie zapytanie zewn�trzne
mysql> --
mysql> --
mysql> -- ZADANIE: wypisz dane pa�stwa, o najwi�kszej ludno�ci
mysql> --
mysql> select name kraj, continent kontynent, headofstate g�owa, population ludno��
    -> from country
    -> order by 4 desc
    -> limit 1;
+-------+-----------+-------------+------------+
| kraj  | kontynent | g�owa       | ludno��    |
+-------+-----------+-------------+------------+
| China | Asia      | Jiang Zemin | 1277558000 |
+-------+-----------+-------------+------------+
1 row in set (0.01 sec)

mysql> --
mysql> -- niby jest ok, ale sk�d wiemy, �e taki kraj jest tylko jeden ...
mysql> -- a je�li takich pa�stw jest wi�cej (o tej, maksymalnej, liczbie
mysql> -- ludno�ci), a je�li mia�oby to by� pa�stwo o ludno�ci jak
mysql> -- najbardziej zbli�onej do �redniej ...
mysql> --
mysql> -- do tego typu zada� stosujemy w�a�nie podzapytania
mysql> -- podzapytanie wewn�trzne zwr�ci najwi�ksz� liczb� spo�r�d
mysql> -- wszystkich populacji pa�stw, a zewn�trzne b�dzie szuka�o
mysql> -- kraj�w, kt�re maj� tak� liczb� mieszka�c�w i je�li znajd�, to
mysql> -- wypisze je (teraz mo�e ich by� wi�cej i wszystkie b�d� wypisane)
mysql> --
mysql> select name kraj, continent kontynent, headofstate g�owa, population ludno��
    -> from country
    -> where
    -> population = (select max(population) from country);
+-------+-----------+-------------+------------+
| kraj  | kontynent | g�owa       | ludno��    |
+-------+-----------+-------------+------------+
| China | Asia      | Jiang Zemin | 1277558000 |
+-------+-----------+-------------+------------+
1 row in set (0.00 sec)

mysql> --
mysql> -- ZADANIE: wypisz dane kraju, kt�ry ma �redni� liczb� mieszka�c�w
mysql> -- tzn. jego populacja jest r�wna �redniej dla ca�ego �wiata
mysql> --
mysql> select name kraj, continent kontynent, headofstate g�owa, population ludno��
    -> from country
    -> where
    -> population = (select avg(population) from country);
Empty set (0.00 sec)

mysql> --
mysql> -- mo�na si� by�o spodziewa� takiego wyniku - prawie na pewno �rednia
mysql> -- nie jest liczb� naturaln� ...
mysql> --
mysql> -- ZADANIE: wypisz dane kraju, kt�ry ma populacj� tak� jak �rednia
mysql> -- plus-minus 2 miliony mieszka�c�w
mysql> --
mysql> select name kraj, continent kontynent, population ludno��
    -> from country
    -> where population between
    -> (select avg(population) - 2e6 from country)
    -> and
    -> (select avg(population)  from country) + 2e6
    -> order by 3;
+-------------+---------------+-----------+
| kraj        | kontynent     | ludno��   |
+-------------+---------------+-----------+
| Nepal       | Asia          |  23930000 |
| North Korea | Asia          |  24039000 |
| Venezuela   | South America |  24170000 |
| Uzbekistan  | Asia          |  24318000 |
| Peru        | South America |  25662000 |
+-------------+---------------+-----------+
5 rows in set (0.01 sec)

mysql> -- je�li kto� pami�ta co� o warto�ci bezwzgl�dnej, to ...
mysql> --
mysql> select name kraj, continent kontynent, population ludno��
    -> from country
    -> where
    -> abs(population - (select avg(population) from country)) < 2e6
    -> order by 3;
+-------------+---------------+-----------+
| kraj        | kontynent     | ludno��   |
+-------------+---------------+-----------+
| Nepal       | Asia          |  23930000 |
| North Korea | Asia          |  24039000 |
| Venezuela   | South America |  24170000 |
| Uzbekistan  | Asia          |  24318000 |
| Peru        | South America |  25662000 |
+-------------+---------------+-----------+
5 rows in set (0.00 sec)

mysql> -- podzapytania mo�na oczywi�cie ��czy� ze z��czeniami
mysql> --
mysql> -- ZADANIE: do�o�y� do powy�szego stolice
mysql> --
m
mysql> select p.name kraj, m.name stolica, continent kontynent, p.population ludno��
    -> from country p, city m
    -> where
    -> capital = id
    -> and
    -> abs(p.population - (select avg(population) from country)) < 2e6
    -> order by 3;
+-------------+-----------+---------------+-----------+
| kraj        | stolica   | kontynent     | ludno��   |
+-------------+-----------+---------------+-----------+
| North Korea | Pyongyang | Asia          |  24039000 |
| Nepal       | Kathmandu | Asia          |  23930000 |
| Uzbekistan  | Toskent   | Asia          |  24318000 |
| Peru        | Lima      | South America |  25662000 |
| Venezuela   | Caracas   | South America |  24170000 |
+-------------+-----------+---------------+-----------+
5 rows in set (0.00 sec)

mysql> -- ZADANIE: wypisz dane pa�stwa o najwi�kszej ludno�ci w Europie
mysql> -- z��czenie robimy za pomoc� RIGHT JOINA
mysql> --
select p.name kraj, m.name stolica, continent kontynent, p.population ludno��
    from country p , city m
    where
     capital = id
     and
     continent = "europe"
    and
    p.population =
    (select max(population) from country-- poniewa� kontynenty s� "enum", mo�na poda�
    where continent = 2);  -- jego nr. (tu "Europa"), kt�ry oczywi�cie trzeba zna�
+--------------------+---------+-----------+-----------+
| kraj               | stolica | kontynent | ludno��   |
+--------------------+---------+-----------+-----------+
| Russian Federation | Moscow  | Europe    | 146934000 |
+--------------------+---------+-----------+-----------+
1 row in set (0.00 sec)

mysql> -- czy obydwa warunki WHERE s� potrzebne?
mysql> --
mysql> -- robi�c test mog�oby si� okaza�, �e nie ... ale
mysql> -- wewn�trzny jest potrzebny, bo nusi wybra� najliczniejszy
mysql> -- kraj w Europie, a zewn�trzny te�, bo gdyby np. w Afryce by� kraj,
mysql> -- kt�ry ma tylu mieszka�c�w, ile na najludniejszy kraj w Europie,
mysql> -- to te� zosta�by wypisany, wi�c obydwa s� potrzenbne
mysql> --
mysql> --
mysql> -- podzapytania najcz�ciej s� wykonywane po warunku WHERE ale mog� by�
mysql> -- r�wnie� w SELECT albo we FROM, np.
mysql> --
mysql> -- ZADANIE: wypisz kraje na liter� "P", ich kontynent, ich powierzchni�
mysql> -- i r�nic� ich powierzchni i �redniej powierzchni pa�stw na "P"
mysql> --

mysql> select name kraj, continent kontynent, surfacearea powierzchnia,
    -> surfacearea - (select avg(surfacearea) from country
    -> where name like "p%") r�nica
    -> from country
    -> where name like "p%"
    -> order by 4;
+------------------+---------------+--------------+----------------+
| kraj             | kontynent     | powierzchnia | r�nica        |
+------------------+---------------+--------------+----------------+
| Pitcairn         | Oceania       |        49.00 | -313058.666667 |
| Palau            | Oceania       |       459.00 | -312648.666667 |
| Palestine        | Asia          |      6257.00 | -306850.666667 |
| Puerto Rico      | North America |      8875.00 | -304232.666667 |
| Panama           | North America |     75517.00 | -237590.666667 |
| Portugal         | Europe        |     91982.00 | -221125.666667 |
| Philippines      | Asia          |    300000.00 |  -13107.666667 |
| Poland           | Europe        |    323250.00 |   10142.333333 |
| Paraguay         | South America |    406752.00 |   93644.333333 |
| Papua New Guinea | Oceania       |    462840.00 |  149732.333333 |
| Pakistan         | Asia          |    796095.00 |  482987.333333 |
| Peru             | South America |   1285216.00 |  972108.333333 |
+------------------+---------------+--------------+----------------+
12 rows in set (0.00 sec)

mysql> --
mysql> -- ZADANIE: (dla podzapytania we FROM) wypisz j�zyki, kt�rych nazwa
mysql> -- rozpoczyna si� literami "po"
mysql> --
mysql> select language from
    -> (select distinct language from countrylanguage) tab_tymcz
    -> where
    -> language like "po%";
+----------------------+
| language             |
+----------------------+
| Portuguese           |
| Polish               |
| Pohnpei              |
| Polynesian Languages |
+----------------------+
4 rows in set (0.00 sec)

mysql> -- pozdapytanie to tworzy tymczasow� tabel�, kt�rej MUSIMY nada�
mysql> -- jaki� alias (tu tab_tymcz), zapytanie zewn�trzne odnosi si�
mysql> -- do tej tabeli, kt�ra znika po wykonaniu ca�ego zapytania
mysql> --
mysql> -- oczywi�cie mo�na by�o to samo zrobi� du�o pro�ciej, trzeba
mysql> -- jednak o czym� pami�ta�, bo je�li zapomnimy, to:
mysql> --
mysql> select language
    -> from
    -> countrylanguage
    -> where
    -> language like "po%";
+----------------------+
| language             |
+----------------------+
| Portuguese           |
| Polish               |
| Polish               |
| Portuguese           |
| Polish               |
| Portuguese           |
| Portuguese           |
| Polish               |
| Polish               |
| Portuguese           |
| Pohnpei              |
| Portuguese           |
| Polish               |
| Portuguese           |
| Polish               |
| Portuguese           |
| Polynesian Languages |
| Polish               |
| Portuguese           |
| Portuguese           |
| Polynesian Languages |
| Portuguese           |
| Polish               |
| Polish               |
| Portuguese           |
+----------------------+
25 rows in set (0.00 sec)

mysql> -- j�zyki na po wypisa�y si� tyle razy, ile razy wyst�puj�
mysql> -- w tabeli countrylanguage, nale�y u�y� znanego nam ju� DISTINCT:
mysql> --
mysql> select distinct language
    -> from
    -> countrylanguage
    -> where
    -> language like "po%";
+----------------------+
| language             |
+----------------------+
| Portuguese           |
| Polish               |
| Pohnpei              |
| Polynesian Languages |
+----------------------+
4 rows in set (0.00 sec)

mysql> -- ZADANIE: wypisz nazwy, kontynenty, powierzchnie dla pa�stw, kt�rych
mysql> -- powierzchnia jest najwi�ksz� na danym kontynencie
mysql> --

mysql> -- tutaj nie zadzia�a podzapytanie proste, bo dla ka�dego kontynentu
mysql> -- musimy znale�� najwi�ksz� powierzchni� na nim, tu zadzia�a
mysql> -- podzapytanie skorelowane

mysql> select name kraj, surfacearea powierzchnia, continent kontynent
    -> from country p
    -> where surfacearea =
    -> (select max(surfacearea)
    -> from country k
    -> where
    -> p.continent = k.continent)
    -> order by 2;
+--------------------+--------------+---------------+
| kraj               | powierzchnia | kontynent     |
+--------------------+--------------+---------------+
| Sudan              |   2505813.00 | Africa        |
| Australia          |   7741220.00 | Oceania       |
| Brazil             |   8547403.00 | South America |
| China              |   9572900.00 | Asia          |
| Canada             |   9970610.00 | North America |
| Antarctica         |  13120000.00 | Antarctica    |
| Russian Federation |  17075400.00 | Europe        |
+--------------------+--------------+---------------+
7 rows in set (0.11 sec)

mysql> --
mysql> -- podzapytanie wewn�trzne wybiera najwi�ksz� powierzchni� dla
mysql> -- kontynentu, ale kontynent musi by� taki, jak ten w analizowanym
mysql> -- kraju (zapytanie zewn�trzne), w zwi�zku z tym kontynenty
mysql> -- (wewn�trzny i zawn�trzny) musz� by� rozr�nialne, st�d aliasy p i k
mysql> --
mysql> -- Czy kt�ry� z alias�w m�g�by by� pomini�ty?
mysql> --
mysql> -- na pewno nie obydwa, bo warunek by�by continent = continent ...
mysql> --
mysql> -- mo�na pomin�� wewn�trzny alias:
mysql> --

mysql> select name kraj, surfacearea powierzchnia, continent kontynent
    -> from country p
    -> where surfacearea =
    -> (select max(surfacearea)
    -> from country
    -> where
    -> p.continent = continent)
    -> order by 2;
+--------------------+--------------+---------------+
| kraj               | powierzchnia | kontynent     |
+--------------------+--------------+---------------+
| Sudan              |   2505813.00 | Africa        |
| Australia          |   7741220.00 | Oceania       |
| Brazil             |   8547403.00 | South America |
| China              |   9572900.00 | Asia          |
| Canada             |   9970610.00 | North America |
| Antarctica         |  13120000.00 | Antarctica    |
| Russian Federation |  17075400.00 | Europe        |
+--------------------+--------------+---------------+
7 rows in set (0.12 sec)

mysql> -- ZADANIE: wypisz pa�stwa, formy rz�d�w, i d�ugo�� �ycia pa�stw, kt�rych
mysql> -- d�ugo�� �ycia jest najwi�ksza na �wiecie dla danych form rz�d�w
mysql>
mysql> select name kraj, governmentform rz�dy, lifeexpectancy �ycie
    -> from country p
    -> where lifeexpectancy =
    -> (select max(lifeexpectancy)
    -> from country k
    -> where p.governmentform = k.governmentform)
    -> order by 3;
+---------------------------+----------------------------------------------+--------+
| kraj                      | rz�dy                                        | �ycie  |
+---------------------------+----------------------------------------------+--------+
| Afghanistan               | Islamic Emirate                              |   45.9 |
| East Timor                | Administrated by the UN                      |   46.0 |
| Western Sahara            | Occupied by Marocco                          |   49.8 |
| Samoa                     | Parlementary Monarchy                        |   69.2 |
| Iran                      | Islamic Republic                             |   69.7 |
| Cook Islands              | Nonmetropolitan Territory of New Zealand     |   71.1 |
| China                     | People'sRepublic'                            |   71.4 |
| Palestine                 | Autonomous Area                              |   71.4 |
| Qatar                     | Monarchy                                     |   72.4 |
| Bahrain                   | Monarchy (Emirate)                           |   73.0 |
| Brunei                    | Monarchy (Sultanate)                         |   73.6 |
| United Arab Emirates      | Emirate Federation                           |   74.1 |
| French Polynesia          | Nonmetropolitan Territory of France          |   74.8 |
| Libyan Arab Jamahiriya    | Socialistic State                            |   75.5 |
| Puerto Rico               | Commonwealth of the US                       |   75.6 |
| Kuwait                    | Constitutional Monarchy (Emirate)            |   76.1 |
| Cuba                      | Socialistic Republic                         |   76.2 |
| Saint Pierre and Miquelon | Territorial Collectivity of France           |   77.6 |
| Austria                   | Federal Republic                             |   77.7 |
| Virgin Islands, U.S.      | US Territory                                 |   78.1 |
| Martinique                | Overseas Department of France                |   78.3 |
| Aruba                     | Nonmetropolitan Territory of The Netherlands |   78.4 |
| Faroe Islands             | Part of Denmark                              |   78.4 |
| Gibraltar                 | Dependent Territory of the UK                |   79.0 |
| Switzerland               | Federation                                   |   79.6 |
| Australia                 | Constitutional Monarchy, Federation          |   79.8 |
| Japan                     | Constitutional Monarchy                      |   80.7 |
| San Marino                | Republic                                     |   81.1 |
| Macao                     | Special Administrative Region of China       |   81.6 |
| Andorra                   | Parliamentary Coprincipality                 |   83.5 |
+---------------------------+----------------------------------------------+--------+
30 rows in set (0.11 sec)

mysql> -- ZADANIE: wypisz kraj, stolic�, powierzchni�, populacj� i rok uzyskania niepodleg�o�ci
mysql> -- powierzchnia jest wi�ksza od po�owy �redniej powierzchni na kontynencie danego kraju
mysql> -- populacja jest wi�ksza od �redniej populacji pa�stw na dan� liter�
mysql> -- parzysto�� roku uzyskania niepodleg�o�ci jest taka jak najm�odszego kraju �wiata
mysql>
mysql> select k.name kraj, m.name stolica, surfacearea pow,
    -> k.population ludno��, indepyear rok
    -> from country k, city m
    -> where
    -> capital = id
    -> and
    -> surfacearea > 0.5*
    -> (select avg(surfacearea) from country p
    -> where k.continent = p.continent)
    -> and
    -> k.population >
    -> (select avg(population) from country p
    -> where left(k.name,1) = left(p.name,1))
    -> and
    -> mod(indepyear,2) =
    -> (select mod(max(indepyear),2) from country)
    -> order by 5;
+---------------+-------------------+------------+-----------+-------+
| kraj          | stolica           | pow        | ludno��   | rok   |
+---------------+-------------------+------------+-----------+-------+
| Ethiopia      | Addis Abeba       | 1104300.00 |  62565000 | -1000 |
| Japan         | Tokyo             |  377829.00 | 126714000 |  -660 |
| Thailand      | Bangkok           |  513115.00 |  61399000 |  1350 |
| Spain         | Madrid            |  505992.00 |  39441700 |  1492 |
| United States | Washington        | 9363520.00 | 278357000 |  1776 |
| Mexico        | Ciudad de M�xico  | 1958201.00 |  98881000 |  1810 |
| Argentina     | Buenos Aires      | 2780400.00 |  37032000 |  1816 |
| Brazil        | Bras�lia          | 8547403.00 | 170115000 |  1822 |
| South Africa  | Pretoria          | 1221037.00 |  40377000 |  1910 |
| Yemen         | Sanaa             |  527968.00 |  18112000 |  1918 |
| Poland        | Warszawa          |  323250.00 |  38653600 |  1918 |
| Egypt         | Cairo             | 1001449.00 |  68470000 |  1922 |
| Saudi Arabia  | Riyadh            | 2149690.00 |  21607000 |  1932 |
| Myanmar       | Rangoon (Yangon)  |  676578.00 |  45611000 |  1948 |
| Morocco       | Rabat             |  446550.00 |  28351000 |  1956 |
| Sudan         | Khartum           | 2505813.00 |  29490000 |  1956 |
| Madagascar    | Antananarivo      |  587041.00 |  15942000 |  1960 |
| Nigeria       | Abuja             |  923768.00 | 111506000 |  1960 |
| Somalia       | Mogadishu         |  637657.00 |  10097000 |  1960 |
| Algeria       | Alger             | 2381741.00 |  31471000 |  1962 |
| Zimbabwe      | Harare            |  390757.00 |  11669000 |  1980 |
+---------------+-------------------+------------+-----------+-------+
21 rows in set (0.16 sec)

mysql> -- ZADANIE: wypisz populacje i nazwy miast pa�stwa, kt�rych populacja
mysql> -- jest najwi�ksza w ka�dym z pa�stw
mysql>
mysql> select p.name pa�stwo, m.name miasto, m.population "ludno�� miasta"
    -> from city m, country p
    -> where
	-> m.population =
    -> (select max(population)
    -> from city mm
    -> where
	-> m.countrycode = mm.countrycode)
    -> and
	-> code = countrycode
    -> order by 3;

+---------------------------------------+------------------------------------+------------------+
| pa�stwo                               | miasto                             | ludno�� miasta   |
+---------------------------------------+------------------------------------+------------------+
| Pitcairn                              | Adamstown                          |               42 |
| Tokelau                               | Fakaofo                            |              300 |
| Holy See (Vatican City State)         | Citt? del Vaticano                 |              455 |
| Cocos (Keeling) Islands               | Bantam                             |              503 |
| Niue                                  | Alofi                              |              682 |
| Christmas Island                      | Flying Fish Cove                   |              700 |
| Norfolk Island                        | Kingston                           |              800 |
| Anguilla                              | South Hill                         |              961 |
| Wallis and Futuna                     | Mata-Utu                           |             1137 |
| Svalbard and Jan Mayen                | Longyearbyen                       |             1438 |
| Saint Helena                          | Jamestown                          |             1500 |
| Falkland Islands                      | Stanley                            |             1636 |
| Bermuda                               | Saint George                       |             1800 |
| Montserrat                            | Plymouth                           |             2000 |
| Saint Lucia                           | Castries                           |             2301 |
| Netherlands Antilles                  | Willemstad                         |             2345 |
| Nauru                                 | Yangor                             |             4050 |
| Tuvalu                                | Funafuti                           |             4600 |
| Grenada                               | Saint George�s                     |             4621 |
| Turks and Caicos Islands              | Cockburn Town                      |             4800 |
| San Marino                            | Serravalle                         |             4802 |
| Kiribati                              | Bikenibeu                          |             5055 |
| American Samoa                        | Tafuna                             |             5200 |
| Liechtenstein                         | Schaan                             |             5346 |
| Saint Pierre and Miquelon             | Saint-Pierre                       |             5808 |
| Barbados                              | Bridgetown                         |             6070 |
| Virgin Islands, British               | Road Town                          |             8000 |
| Northern Mariana Islands              | Garapan                            |             9200 |
| Guam                                  | Tamuning                           |             9500 |
| Saint Kitts and Nevis                 | Basseterre                         |            11600 |
| Cook Islands                          | Avarua                             |            11900 |
| Mayotte                               | Mamoutzou                          |            12000 |
| Palau                                 | Koror                              |            12000 |
| Virgin Islands, U.S.                  | Charlotte Amalie                   |            13000 |
| Monaco                                | Monte-Carlo                        |            13154 |
| Greenland                             | Nuuk                               |            13445 |
| Faroe Islands                         | T�rshavn                           |            14542 |
| Dominica                              | Roseau                             |            16243 |
| Saint Vincent and the Grenadines      | Kingstown                          |            17100 |
| Cayman Islands                        | George Town                        |            19600 |
| Andorra                               | Andorra la Vella                   |            21189 |
| Malta                                 | Birkirkara                         |            21445 |
| Brunei                                | Bandar Seri Begawan                |            21484 |
| Bhutan                                | Thimphu                            |            22000 |
| Micronesia, Federated States of       | Weno                               |            22000 |
| Tonga                                 | Nuku�alofa                         |            22400 |
| Antigua and Barbuda                   | Saint John�s                       |            24000 |
| French Polynesia                      | Faaa                               |            25888 |
| Gibraltar                             | Gibraltar                          |            27025 |
| Marshall Islands                      | Dalap-Uliga-Darrit                 |            28000 |
| Aruba                                 | Oranjestad                         |            29034 |
| Vanuatu                               | Port-Vila                          |            33700 |
| Samoa                                 | Apia                               |            35900 |
| Comoros                               | Moroni                             |            36000 |
| Equatorial Guinea                     | Malabo                             |            40000 |
| Seychelles                            | Victoria                           |            41000 |
| East Timor                            | Dili                               |            47900 |
| Sao Tome and Principe                 | S?o Tom�                           |            49541 |
| Solomon Islands                       | Honiara                            |            50100 |
| French Guiana                         | Cayenne                            |            50699 |
| Belize                                | Belize City                        |            55810 |
| Trinidad and Tobago                   | Chaguanas                          |            56601 |
| Swaziland                             | Mbabane                            |            61000 |
| Guadeloupe                            | Les Abymes                         |            62947 |
| Maldives                              | Male                               |            71000 |
| New Caledonia                         | Noum�a                             |            76293 |
| Fiji Islands                          | Suva                               |            77366 |
| Luxembourg                            | Luxembourg [Luxemburg/L�tzebuerg]  |            80700 |
| Martinique                            | Fort-de-France                     |            94050 |
| Cape Verde                            | Praia                              |            94800 |
| Gambia                                | Serekunda                          |           102600 |
| Iceland                               | Reykjav�k                          |           109184 |
| Jamaica                               | Spanish Town                       |           110379 |
| Suriname                              | Paramaribo                         |           112000 |
| Kuwait                                | al-Salimiya                        |           130215 |
| R�union                               | Saint-Denis                        |           131480 |
| Mauritius                             | Port-Louis                         |           138200 |
| Bahrain                               | al-Manama                          |           148000 |
| Oman                                  | al-Sib                             |           155000 |
| Western Sahara                        | El-Aai�n                           |           169000 |
| Namibia                               | Windhoek                           |           169000 |
| Bahamas                               | Nassau                             |           172000 |
| Cyprus                                | Nicosia                            |           195000 |
| Botswana                              | Gaborone                           |           213017 |
| Guinea-Bissau                         | Bissau                             |           241000 |
| Papua New Guinea                      | Port Moresby                       |           247000 |
| Guyana                                | Georgetown                         |           254000 |
| Albania                               | Tirana                             |           270000 |
| Slovenia                              | Ljubljana                          |           270986 |
| Rwanda                                | Kigali                             |           286000 |
| Lesotho                               | Maseru                             |           297000 |
| Burundi                               | Bujumbura                          |           300000 |
| Switzerland                           | Z�rich                             |           336800 |
| Costa Rica                            | San Jos�                           |           339131 |
| Palestine                             | Gaza                               |           353632 |
| Qatar                                 | Doha                               |           355000 |
| Bosnia and Herzegovina                | Sarajevo                           |           360000 |
| Togo                                  | Lom�                               |           375000 |
| New Zealand                           | Auckland                           |           381800 |
| Djibouti                              | Djibouti                           |           383000 |
| Estonia                               | Tallinn                            |           403981 |
| El Salvador                           | San Salvador                       |           415346 |
| Gabon                                 | Libreville                         |           419000 |
| Niger                                 | Niamey                             |           420000 |
| Eritrea                               | Asmara                             |           431000 |
| Puerto Rico                           | San Juan                           |           434374 |
| Macao                                 | Macao                              |           437500 |
| Macedonia                             | Skopje                             |           444299 |
| Belgium                               | Antwerpen                          |           446525 |
| Slovakia                              | Bratislava                         |           448292 |
| Panama                                | Ciudad de Panam�                   |           471373 |
| Malawi                                | Blantyre                           |           478155 |
| Ireland                               | Dublin                             |           481854 |
| Denmark                               | K?benhavn                          |           495699 |
| Yemen                                 | Sanaa                              |           503600 |
| Norway                                | Oslo                               |           508726 |
| Central African Republic              | Bangui                             |           524000 |
| Tajikistan                            | Dushanbe                           |           524000 |
| Chad                                  | N�Djam�na                          |           530965 |
| Laos                                  | Vientiane                          |           531800 |
| Benin                                 | Cotonou                            |           536827 |
| Turkmenistan                          | Ashgabat                           |           540600 |
| Finland                               | Helsinki [Helsingfors]             |           555474 |
| Paraguay                              | Asunci�n                           |           557776 |
| Portugal                              | Lisboa                             |           563210 |
| Cambodia                              | Phnom Penh                         |           570155 |
| Lithuania                             | Vilnius                            |           577969 |
| Kyrgyzstan                            | Bishkek                            |           589400 |
| Nepal                                 | Kathmandu                          |           591835 |
| Israel                                | Jerusalem                          |           633700 |
| Sri Lanka                             | Colombo                            |           645000 |
| Mauritania                            | Nouakchott                         |           667300 |
| United Arab Emirates                  | Dubai                              |           669181 |
| Madagascar                            | Antananarivo                       |           675669 |
| Tunisia                               | Tunis                              |           690600 |
| Croatia                               | Zagreb                             |           706770 |
| Moldova                               | Chisinau                           |           719900 |
| Netherlands                           | Amsterdam                          |           731200 |
| Sweden                                | Stockholm                          |           750348 |
| Latvia                                | Riga                               |           764328 |
| Greece                                | Athenai                            |           772072 |
| Mongolia                              | Ulan Bator                         |           773700 |
| Mali                                  | Bamako                             |           809552 |
| Honduras                              | Tegucigalpa                        |           813900 |
| Guatemala                             | Ciudad de Guatemala                |           823301 |
| Burkina Faso                          | Ouagadougou                        |           824000 |
| Liberia                               | Monrovia                           |           850000 |
| Sierra Leone                          | Freetown                           |           850000 |
| Senegal                               | Pikine                             |           855287 |
| Haiti                                 | Port-au-Prince                     |           884472 |
| Uganda                                | Kampala                            |           890800 |
| Bolivia                               | Santa Cruz de la Sierra            |           935361 |
| Congo                                 | Brazzaville                        |           950000 |
| Nicaragua                             | Managua                            |           959000 |
| Somalia                               | Mogadishu                          |           997000 |
| Jordan                                | Amman                              |          1000000 |
| Canada                                | Montr�al                           |          1016376 |
| Mozambique                            | Maputo                             |          1018938 |
| Ghana                                 | Accra                              |          1070000 |
| Guinea                                | Conakry                            |          1090610 |
| Lebanon                               | Beirut                             |          1100000 |
| Bulgaria                              | Sofija                             |          1122302 |
| Kazakstan                             | Almaty                             |          1129400 |
| Czech Republic                        | Praha                              |          1181126 |
| Yugoslavia                            | Beograd                            |          1204000 |
| Georgia                               | Tbilisi                            |          1235200 |
| Uruguay                               | Montevideo                         |          1236000 |
| Armenia                               | Yerevan                            |          1248700 |
| Sudan                                 | Omdurman                           |          1271403 |
| Malaysia                              | Kuala Lumpur                       |          1297526 |
| Zambia                                | Lusaka                             |          1317000 |
| Syria                                 | Damascus                           |          1347000 |
| Zimbabwe                              | Harare                             |          1410000 |
| Cameroon                              | Douala                             |          1448300 |
| Nigeria                               | Lagos                              |          1518000 |
| Austria                               | Wien                               |          1608144 |
| Dominican Republic                    | Santo Domingo de Guzm�n            |          1609966 |
| Poland                                | Warszawa                           |          1615369 |
| Belarus                               | Minsk                              |          1674000 |
| Libyan Arab Jamahiriya                | Tripoli                            |          1682000 |
| Tanzania                              | Dar es Salaam                      |          1747000 |
| Afghanistan                           | Kabul                              |          1780000 |
| Azerbaijan                            | Baku                               |          1787800 |
| Hungary                               | Budapest                           |          1811552 |
| Venezuela                             | Caracas                            |          1975294 |
| Hong Kong                             | Kowloon and New Kowloon            |          1987996 |
| Romania                               | Bucuresti                          |          2016131 |
| Angola                                | Luanda                             |          2022000 |
| Ecuador                               | Guayaquil                          |          2070040 |
| Uzbekistan                            | Toskent                            |          2117500 |
| France                                | Paris                              |          2125246 |
| Algeria                               | Alger                              |          2168000 |
| Philippines                           | Quezon                             |          2173831 |
| Cuba                                  | La Habana                          |          2256000 |
| Kenya                                 | Nairobi                            |          2290000 |
| South Africa                          | Cape Town                          |          2352121 |
| North Korea                           | Pyongyang                          |          2484000 |
| Ethiopia                              | Addis Abeba                        |          2495000 |
| C�te d�Ivoire                         | Abidjan                            |          2500000 |
| Ukraine                               | Kyiv                               |          2624000 |
| Taiwan                                | Taipei                             |          2641312 |
| Italy                                 | Roma                               |          2643581 |
| Spain                                 | Madrid                             |          2879052 |
| Morocco                               | Casablanca                         |          2940623 |
| Argentina                             | Buenos Aires                       |          2982146 |
| Australia                             | Sydney                             |          3276207 |
| Saudi Arabia                          | Riyadh                             |          3324000 |
| Myanmar                               | Rangoon (Yangon)                   |          3361700 |
| Germany                               | Berlin                             |          3386667 |
| Bangladesh                            | Dhaka                              |          3612850 |
| Vietnam                               | Ho Chi Minh City                   |          3980000 |
| Singapore                             | Singapore                          |          4017733 |
| Iraq                                  | Baghdad                            |          4336000 |
| Chile                                 | Santiago de Chile                  |          4703954 |
| Congo, The Democratic Republic of the | Kinshasa                           |          5064000 |
| Colombia                              | Santaf� de Bogot�                  |          6260862 |
| Thailand                              | Bangkok                            |          6320174 |
| Peru                                  | Lima                               |          6464693 |
| Iran                                  | Teheran                            |          6758845 |
| Egypt                                 | Cairo                              |          6789479 |
| United Kingdom                        | London                             |          7285000 |
| Japan                                 | Tokyo                              |          7980230 |
| United States                         | New York                           |          8008278 |
| Russian Federation                    | Moscow                             |          8389200 |
| Mexico                                | Ciudad de M�xico                   |          8591309 |
| Turkey                                | Istanbul                           |          8787958 |
| Pakistan                              | Karachi                            |          9269265 |
| Indonesia                             | Jakarta                            |          9604900 |
| China                                 | Shanghai                           |          9696300 |
| Brazil                                | S?o Paulo                          |          9968485 |
| South Korea                           | Seoul                              |          9981619 |
| India                                 | Mumbai (Bombay)                    |         10500000 |
+---------------------------------------+------------------------------------+------------------+
232 rows in set (32.77 sec)

mysql> -- jak wida�, podzapytania (szczeg�lnie skorelowane) bywaj� mniej wydajne od
mysql> -- z��cze�, dlatego, o ile to mo�liwe, lepiej (najcz�ciej) korzysta� ze z��cze�
mysql> --


mysql> select k.name kraj, m.name miasto, max(m.population) "ludno�� miasta"
    -> from country k, city m
    -> where
    -> code = countrycode
    -> group by 1
    -> order by 3;
+---------------------------------------+------------------------------------+------------------+
| kraj                                  | miasto                             | ludno�� miasta   |
+---------------------------------------+------------------------------------+------------------+
| Pitcairn                              | Adamstown                          |               42 |
| Tokelau                               | Fakaofo                            |              300 |
| Holy See (Vatican City State)         | Citt? del Vaticano                 |              455 |
| Cocos (Keeling) Islands               | Bantam                             |              503 |
| Niue                                  | Alofi                              |              682 |
| Christmas Island                      | Flying Fish Cove                   |              700 |
| Norfolk Island                        | Kingston                           |              800 |
| Anguilla                              | South Hill                         |              961 |
| Wallis and Futuna                     | Mata-Utu                           |             1137 |
| Svalbard and Jan Mayen                | Longyearbyen                       |             1438 |
| Saint Helena                          | Jamestown                          |             1500 |
| Falkland Islands                      | Stanley                            |             1636 |
| Bermuda                               | Saint George                       |             1800 |
| Montserrat                            | Plymouth                           |             2000 |
| Saint Lucia                           | Castries                           |             2301 |
| Netherlands Antilles                  | Willemstad                         |             2345 |
| Nauru                                 | Yangor                             |             4050 |
| Tuvalu                                | Funafuti                           |             4600 |
| Grenada                               | Saint George�s                     |             4621 |
| Turks and Caicos Islands              | Cockburn Town                      |             4800 |
| San Marino                            | Serravalle                         |             4802 |
| Kiribati                              | Bikenibeu                          |             5055 |
| American Samoa                        | Tafuna                             |             5200 |
| Liechtenstein                         | Schaan                             |             5346 |
| Saint Pierre and Miquelon             | Saint-Pierre                       |             5808 |
| Barbados                              | Bridgetown                         |             6070 |
| Virgin Islands, British               | Road Town                          |             8000 |
| Northern Mariana Islands              | Garapan                            |             9200 |
| Guam                                  | Tamuning                           |             9500 |
| Saint Kitts and Nevis                 | Basseterre                         |            11600 |
| Cook Islands                          | Avarua                             |            11900 |
| Mayotte                               | Mamoutzou                          |            12000 |
| Palau                                 | Koror                              |            12000 |
| Virgin Islands, U.S.                  | Charlotte Amalie                   |            13000 |
| Monaco                                | Monte-Carlo                        |            13154 |
| Greenland                             | Nuuk                               |            13445 |
| Faroe Islands                         | T�rshavn                           |            14542 |
| Dominica                              | Roseau                             |            16243 |
| Saint Vincent and the Grenadines      | Kingstown                          |            17100 |
| Cayman Islands                        | George Town                        |            19600 |
| Andorra                               | Andorra la Vella                   |            21189 |
| Malta                                 | Birkirkara                         |            21445 |
| Brunei                                | Bandar Seri Begawan                |            21484 |
| Bhutan                                | Thimphu                            |            22000 |
| Micronesia, Federated States of       | Weno                               |            22000 |
| Tonga                                 | Nuku�alofa                         |            22400 |
| Antigua and Barbuda                   | Saint John�s                       |            24000 |
| French Polynesia                      | Faaa                               |            25888 |
| Gibraltar                             | Gibraltar                          |            27025 |
| Marshall Islands                      | Dalap-Uliga-Darrit                 |            28000 |
| Aruba                                 | Oranjestad                         |            29034 |
| Vanuatu                               | Port-Vila                          |            33700 |
| Samoa                                 | Apia                               |            35900 |
| Comoros                               | Moroni                             |            36000 |
| Equatorial Guinea                     | Malabo                             |            40000 |
| Seychelles                            | Victoria                           |            41000 |
| East Timor                            | Dili                               |            47900 |
| Sao Tome and Principe                 | S?o Tom�                           |            49541 |
| Solomon Islands                       | Honiara                            |            50100 |
| French Guiana                         | Cayenne                            |            50699 |
| Belize                                | Belize City                        |            55810 |
| Trinidad and Tobago                   | Chaguanas                          |            56601 |
| Swaziland                             | Mbabane                            |            61000 |
| Guadeloupe                            | Les Abymes                         |            62947 |
| Maldives                              | Male                               |            71000 |
| New Caledonia                         | Noum�a                             |            76293 |
| Fiji Islands                          | Suva                               |            77366 |
| Luxembourg                            | Luxembourg [Luxemburg/L�tzebuerg]  |            80700 |
| Martinique                            | Fort-de-France                     |            94050 |
| Cape Verde                            | Praia                              |            94800 |
| Gambia                                | Serekunda                          |           102600 |
| Iceland                               | Reykjav�k                          |           109184 |
| Jamaica                               | Spanish Town                       |           110379 |
| Suriname                              | Paramaribo                         |           112000 |
| Kuwait                                | al-Salimiya                        |           130215 |
| R�union                               | Saint-Denis                        |           131480 |
| Mauritius                             | Port-Louis                         |           138200 |
| Bahrain                               | al-Manama                          |           148000 |
| Oman                                  | al-Sib                             |           155000 |
| Western Sahara                        | El-Aai�n                           |           169000 |
| Namibia                               | Windhoek                           |           169000 |
| Bahamas                               | Nassau                             |           172000 |
| Cyprus                                | Nicosia                            |           195000 |
| Botswana                              | Gaborone                           |           213017 |
| Guinea-Bissau                         | Bissau                             |           241000 |
| Papua New Guinea                      | Port Moresby                       |           247000 |
| Guyana                                | Georgetown                         |           254000 |
| Albania                               | Tirana                             |           270000 |
| Slovenia                              | Ljubljana                          |           270986 |
| Rwanda                                | Kigali                             |           286000 |
| Lesotho                               | Maseru                             |           297000 |
| Burundi                               | Bujumbura                          |           300000 |
| Switzerland                           | Z�rich                             |           336800 |
| Costa Rica                            | San Jos�                           |           339131 |
| Palestine                             | Gaza                               |           353632 |
| Qatar                                 | Doha                               |           355000 |
| Bosnia and Herzegovina                | Sarajevo                           |           360000 |
| Togo                                  | Lom�                               |           375000 |
| New Zealand                           | Auckland                           |           381800 |
| Djibouti                              | Djibouti                           |           383000 |
| Estonia                               | Tallinn                            |           403981 |
| El Salvador                           | San Salvador                       |           415346 |
| Gabon                                 | Libreville                         |           419000 |
| Niger                                 | Niamey                             |           420000 |
| Eritrea                               | Asmara                             |           431000 |
| Puerto Rico                           | San Juan                           |           434374 |
| Macao                                 | Macao                              |           437500 |
| Macedonia                             | Skopje                             |           444299 |
| Belgium                               | Antwerpen                          |           446525 |
| Slovakia                              | Bratislava                         |           448292 |
| Panama                                | Ciudad de Panam�                   |           471373 |
| Malawi                                | Blantyre                           |           478155 |
| Ireland                               | Dublin                             |           481854 |
| Denmark                               | K?benhavn                          |           495699 |
| Yemen                                 | Sanaa                              |           503600 |
| Norway                                | Oslo                               |           508726 |
| Central African Republic              | Bangui                             |           524000 |
| Tajikistan                            | Dushanbe                           |           524000 |
| Chad                                  | N�Djam�na                          |           530965 |
| Laos                                  | Vientiane                          |           531800 |
| Benin                                 | Cotonou                            |           536827 |
| Turkmenistan                          | Ashgabat                           |           540600 |
| Finland                               | Helsinki [Helsingfors]             |           555474 |
| Paraguay                              | Asunci�n                           |           557776 |
| Portugal                              | Lisboa                             |           563210 |
| Cambodia                              | Phnom Penh                         |           570155 |
| Lithuania                             | Vilnius                            |           577969 |
| Kyrgyzstan                            | Bishkek                            |           589400 |
| Nepal                                 | Kathmandu                          |           591835 |
| Israel                                | Jerusalem                          |           633700 |
| Sri Lanka                             | Colombo                            |           645000 |
| Mauritania                            | Nouakchott                         |           667300 |
| United Arab Emirates                  | Dubai                              |           669181 |
| Madagascar                            | Antananarivo                       |           675669 |
| Tunisia                               | Tunis                              |           690600 |
| Croatia                               | Zagreb                             |           706770 |
| Moldova                               | Chisinau                           |           719900 |
| Netherlands                           | Amsterdam                          |           731200 |
| Sweden                                | Stockholm                          |           750348 |
| Latvia                                | Riga                               |           764328 |
| Greece                                | Athenai                            |           772072 |
| Mongolia                              | Ulan Bator                         |           773700 |
| Mali                                  | Bamako                             |           809552 |
| Honduras                              | Tegucigalpa                        |           813900 |
| Guatemala                             | Ciudad de Guatemala                |           823301 |
| Burkina Faso                          | Ouagadougou                        |           824000 |
| Liberia                               | Monrovia                           |           850000 |
| Sierra Leone                          | Freetown                           |           850000 |
| Senegal                               | Pikine                             |           855287 |
| Haiti                                 | Port-au-Prince                     |           884472 |
| Uganda                                | Kampala                            |           890800 |
| Bolivia                               | Santa Cruz de la Sierra            |           935361 |
| Congo                                 | Brazzaville                        |           950000 |
| Nicaragua                             | Managua                            |           959000 |
| Somalia                               | Mogadishu                          |           997000 |
| Jordan                                | Amman                              |          1000000 |
| Canada                                | Montr�al                           |          1016376 |
| Mozambique                            | Maputo                             |          1018938 |
| Ghana                                 | Accra                              |          1070000 |
| Guinea                                | Conakry                            |          1090610 |
| Lebanon                               | Beirut                             |          1100000 |
| Bulgaria                              | Sofija                             |          1122302 |
| Kazakstan                             | Almaty                             |          1129400 |
| Czech Republic                        | Praha                              |          1181126 |
| Yugoslavia                            | Beograd                            |          1204000 |
| Georgia                               | Tbilisi                            |          1235200 |
| Uruguay                               | Montevideo                         |          1236000 |
| Armenia                               | Yerevan                            |          1248700 |
| Sudan                                 | Omdurman                           |          1271403 |
| Malaysia                              | Kuala Lumpur                       |          1297526 |
| Zambia                                | Lusaka                             |          1317000 |
| Syria                                 | Damascus                           |          1347000 |
| Zimbabwe                              | Harare                             |          1410000 |
| Cameroon                              | Douala                             |          1448300 |
| Nigeria                               | Lagos                              |          1518000 |
| Austria                               | Wien                               |          1608144 |
| Dominican Republic                    | Santo Domingo de Guzm�n            |          1609966 |
| Poland                                | Warszawa                           |          1615369 |
| Belarus                               | Minsk                              |          1674000 |
| Libyan Arab Jamahiriya                | Tripoli                            |          1682000 |
| Tanzania                              | Dar es Salaam                      |          1747000 |
| Afghanistan                           | Kabul                              |          1780000 |
| Azerbaijan                            | Baku                               |          1787800 |
| Hungary                               | Budapest                           |          1811552 |
| Venezuela                             | Caracas                            |          1975294 |
| Hong Kong                             | Kowloon and New Kowloon            |          1987996 |
| Romania                               | Bucuresti                          |          2016131 |
| Angola                                | Luanda                             |          2022000 |
| Ecuador                               | Guayaquil                          |          2070040 |
| Uzbekistan                            | Toskent                            |          2117500 |
| France                                | Paris                              |          2125246 |
| Algeria                               | Alger                              |          2168000 |
| Philippines                           | Quezon                             |          2173831 |
| Cuba                                  | La Habana                          |          2256000 |
| Kenya                                 | Nairobi                            |          2290000 |
| South Africa                          | Cape Town                          |          2352121 |
| North Korea                           | Pyongyang                          |          2484000 |
| Ethiopia                              | Addis Abeba                        |          2495000 |
| C�te d�Ivoire                         | Abidjan                            |          2500000 |
| Ukraine                               | Kyiv                               |          2624000 |
| Taiwan                                | Taipei                             |          2641312 |
| Italy                                 | Roma                               |          2643581 |
| Spain                                 | Madrid                             |          2879052 |
| Morocco                               | Casablanca                         |          2940623 |
| Argentina                             | Buenos Aires                       |          2982146 |
| Australia                             | Sydney                             |          3276207 |
| Saudi Arabia                          | Riyadh                             |          3324000 |
| Myanmar                               | Rangoon (Yangon)                   |          3361700 |
| Germany                               | Berlin                             |          3386667 |
| Bangladesh                            | Dhaka                              |          3612850 |
| Vietnam                               | Ho Chi Minh City                   |          3980000 |
| Singapore                             | Singapore                          |          4017733 |
| Iraq                                  | Baghdad                            |          4336000 |
| Chile                                 | Santiago de Chile                  |          4703954 |
| Congo, The Democratic Republic of the | Kinshasa                           |          5064000 |
| Colombia                              | Santaf� de Bogot�                  |          6260862 |
| Thailand                              | Bangkok                            |          6320174 |
| Peru                                  | Lima                               |          6464693 |
| Iran                                  | Teheran                            |          6758845 |
| Egypt                                 | Cairo                              |          6789479 |
| United Kingdom                        | London                             |          7285000 |
| Japan                                 | Tokyo                              |          7980230 |
| United States                         | New York                           |          8008278 |
| Russian Federation                    | Moscow                             |          8389200 |
| Mexico                                | Ciudad de M�xico                   |          8591309 |
| Turkey                                | Istanbul                           |          8787958 |
| Pakistan                              | Karachi                            |          9269265 |
| Indonesia                             | Jakarta                            |          9604900 |
| China                                 | Shanghai                           |          9696300 |
| Brazil                                | S?o Paulo                          |          9968485 |
| South Korea                           | Seoul                              |          9981619 |
| India                                 | Mumbai (Bombay)                    |         10500000 |
+---------------------------------------+------------------------------------+------------------+
232 rows in set (0.02 sec)

mysql> --
mysql> -- wynik ten sam, a otrzymany ok. 1500 razy szybciej!
mysql> --mysql> Terminal close -- exit!