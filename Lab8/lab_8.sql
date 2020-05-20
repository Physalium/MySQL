
mysql> tee d:\lab_8.sql
mysql> -- kontynuujemy temat podzapytań
mysql> -- zaczniemy od przypomnienia - jeśli zapytanie da się zrealizować przez złączenie,
mysql> -- to będzie ono szybsze (najczęściej) od zapytania przez pozdapytanie (o ile
mysql> -- jest to podzapytanie skorelowane i o ile jest to możliwe)
mysql> --
mysql> -- ZADANIE: wypisz kraje i ich liczbę miast, które mają liczbę miast równą 5
mysql> --
mysql> select p.name kraj, count(*) "ile miast"
    -> from country p, city m       -- pierwszy sposób, bez pozdzapytania
    -> where code = countrycode
    -> group by 1
    -> having count(*)  = 5
    -> order by 1;                  -- czas małoznaczący
+----------------------+-----------+
| kraj                 | ile miast |
+----------------------+-----------+
| Angola               |         5 |
| Côte d’Ivoire        |         5 |
| Denmark              |         5 |
| Georgia              |         5 |
| Ghana                |         5 |
| Jordan               |         5 |
| Lithuania            |         5 |
| Madagascar           |         5 |
| Nepal                |         5 |
| Norway               |         5 |
| Oman                 |         5 |
| Paraguay             |         5 |
| Portugal             |         5 |
| Switzerland          |         5 |
| United Arab Emirates |         5 |
+----------------------+-----------+
15 rows in set (0.03 sec)

mysql> select p.name kraj, count(*) "ile miast"
    -> from country p, city m				-- sposób z podzapytaniem, pierwszym z innych 
    -> where code = countrycode
    -> and									-- czas znaczący
    -> (select count(*) from city c
    -> where m.countrycode = c.countrycode) = 5 
    -> group by 1
    -> order by 1;
+----------------------+-----------+
| kraj                 | ile miast |
+----------------------+-----------+
| Angola               |         5 |
| Côte d’Ivoire        |         5 |
| Denmark              |         5 |
| Georgia              |         5 |
| Ghana                |         5 |
| Jordan               |         5 |
| Lithuania            |         5 |
| Madagascar           |         5 |
| Nepal                |         5 |
| Norway               |         5 |
| Oman                 |         5 |
| Paraguay             |         5 |
| Portugal             |         5 |
| Switzerland          |         5 |
| United Arab Emirates |         5 |
+----------------------+-----------+
15 rows in set (46.89 sec)


mysql> --
mysql> -- ZADANIE: wypisz miasta i ich populacje, które mają populację większą niż 70-cio
mysql> -- krotność ludności pewnego miasta, którego nazwa nie jest unikatowa w tabeli miasta
mysql> --
mysql> -- zaczniemy (pomocniczo) od 
mysql> -- wszystkie miasta, które nie są "jedynakami" w bazie
mysql> 
mysql> select name miasto, sum(population) ludność, sum(population)*70 krotność, count(*) ile
    -> from city
    -> group by name
    -> having count(*) > 1
    -> order by 3, 2;
+---------------+-----------+------------+-----+
| miasto        | ludność   | krotność   | ile |
+---------------+-----------+------------+-----+
| Kingston      |    104762 |    7333340 |   2 |
| Saint John´s  |    125936 |    8815520 |   2 |
| San Felipe    |    186245 |   13037150 |   2 |
| Zeleznogorsk  |    190900 |   13363000 |   2 |
| Halifax       |    204979 |   14348530 |   2 |
| Gloucester    |    214314 |   15001980 |   2 |
| Kaiyuan       |    216218 |   15135260 |   2 |
| Peoria        |    221300 |   15491000 |   2 |
| San Mateo     |    227402 |   15918140 |   2 |
| Manzanillo    |    233364 |   16335480 |   2 |
| Plymouth      |    255000 |   17850000 |   2 |
| York          |    259405 |   18158350 |   2 |
| Worcester     |    267648 |   18735360 |   2 |
| San Carlos    |    272523 |   19076610 |   2 |
| Pasadena      |    275610 |   19292700 |   2 |
| Cádiz         |    284403 |   19908210 |   2 |
| Portsmouth    |    290565 |   20339550 |   2 |
| Santa Clara   |    309711 |   21679770 |   2 |
| Cambridge     |    331541 |   23207870 |   3 |
| Concepción    |    332835 |   23298450 |   2 |
| Santa Rosa    |    333228 |   23325960 |   2 |
| Taiping       |    348785 |   24414950 |   2 |
| Santa Maria   |    382755 |   26792850 |   2 |
| Salamanca     |    385584 |   26990880 |   2 |
| Ede           |    408674 |   28607180 |   2 |
| Glendale      |    413785 |   28964950 |   2 |
| Springfield   |    415116 |   29058120 |   3 |
| Aurora        |    419383 |   29356810 |   2 |
| Jining        |    428800 |   30016000 |   2 |
| Brest         |    435634 |   30494380 |   2 |
| Richmond      |    440757 |   30852990 |   3 |
| Hamilton      |    453914 |   31773980 |   3 |
| Depok         |    472000 |   33040000 |   2 |
| San Fernando  |    476975 |   33388250 |   3 |
| Santa Ana     |    477366 |   33415620 |   2 |
| Newcastle     |    493317 |   34532190 |   2 |
| San Miguel    |    500220 |   35015400 |   3 |
| Salem         |    503636 |   35254520 |   2 |
| Arlington     |    507807 |   35546490 |   2 |
| Matamoros     |    508286 |   35580020 |   2 |
| Manchester    |    537006 |   37590420 |   2 |
| San Juan      |    553526 |   38746820 |   2 |
| Toledo        |    554180 |   38792600 |   3 |
| Kansas City   |    588411 |   41188770 |   2 |
| Vancouver     |    657568 |   46029760 |   2 |
| Jinzhou       |    665761 |   46603270 |   2 |
| Guadalupe     |    777661 |   54436270 |   2 |
| Colombo       |    822764 |   57593480 |   2 |
| Suzhou        |    861862 |   60330340 |   2 |
| Columbus      |    897761 |   62843270 |   2 |
| Mérida        |    928211 |   64974770 |   2 |
| Yichun        |    951585 |   66610950 |   2 |
| Cartagena     |    983466 |   68842620 |   2 |
| Anyang        |   1011438 |   70800660 |   2 |
| La Paz        |   1167894 |   81752580 |   3 |
| Birmingham    |   1255820 |   87907400 |   2 |
| León          |   1397250 |   97807500 |   3 |
| San José      |   1453337 |  101733590 |   4 |
| Victoria      |   1616323 |  113142610 |   3 |
| Córdoba       |   1646167 |  115231690 |   3 |
| Valencia      |   1681582 |  117710740 |   3 |
| Barcelona     |   1825718 |  127800260 |   2 |
| Tripoli       |   1922000 |  134540000 |   2 |
| Alexandria    |   3456479 |  241953530 |   2 |
| Los Angeles   |   3853035 |  269712450 |   2 |
| Hyderabad     |   4115912 |  288113840 |   2 |
| London        |   7624917 |  533744190 |   2 |
+---------------+-----------+------------+-----+
67 rows in set (0.04 sec)

mysql> -- pierwsza kolumna to miasta, których nazwa pojawię się na świecie więcej niż raz
mysql> -- druga kolumna to ich łączna populacja
mysql> -- trzecia to 70-cio krotność tej sumy (70*(kolumna 2))
mysql> -- czwarta to liczba wystąpień danego miasta
mysql> --
mysql> -- zadanie polega na tym, żeby znaleźć wszystkie miasta świata, które
mysql> -- mają populację większą niż 70-cio krotność obojętnie którego miasta
mysql> -- spośród wypisanych powyżej; oczywiście można by było
mysql> -- z tych krotności wybrać najmniejszą liczbę i odwołać się do niej,
mysql> --  ale my poznamy nowy sposób z podzapytaniem innym niż dotychczas
mysql> --
mysql> 
mysql> -- dotychczas podzapytanie zwracało tylko jeden wiersz (jeden wynik), zarówno w 
mysql> -- podzapytaniu prostym, jak i w skorelowanym (tam wiele razy zwracało jeden wiersz)
mysql> --
mysql> -- teraz dowiemy się jak współpracować z podzapytaniami, które zwracają wiele wierszy
mysql> --
mysql> -- pierwszym operatorem jest ANY - jest to odpowiednik kwantyfikatora ISTNIEJE,
mysql> -- tzn. jeśli w wierszach zwracanych przez podzapytnaie znajdzie się taki, który 
mysql> -- spełnia warunek, to zewnętrze zapytanie wypisze analizowany właśnie wiersz,
mysql> -- jeśli wszystkie nie będą spełniać warunku - wiersz nie zostanie wypisany,
mysql> --
mysql> -- wracamy więc do rozwiązania zadania:
mysql> --
mysql> select name miasto, population ludność
    -> from city
    -> where 
    -> population > ANY						
    -> (select 70*sum(population)
    -> from city
    -> group by name
    -> having 
    -> count(*) > 1)
    -> order by 2;	
+-------------------+-----------+
| miasto            | ludność   |
+-------------------+-----------+
| Peking            |   7472000 |
| Tokyo             |   7980230 |
| New York          |   8008278 |
| Moscow            |   8389200 |
| Ciudad de México  |   8591309 |
| Istanbul          |   8787958 |
| Karachi           |   9269265 |
| Jakarta           |   9604900 |
| Shanghai          |   9696300 |
| São Paulo         |   9968485 |
| Seoul             |   9981619 |
| Mumbai (Bombay)   |  10500000 |
+-------------------+-----------+
12 rows in set (0.05 sec)

mysql> -- najmniejsza liczba z krotności to 7333340, a Pekin ma 7472000 mieszkańców
mysql> -- więc raczej jest ok, bo reszta miasta jest większa od Pekinu
mysql> --
mysql> -- 
mysql> -- ZADANIE: wypisz kraje i ich liczbę miast, ale tylko tych, które mają liczbę miast 
mysql> -- nie mniejszą niż dowolny (każdy) kraj z Europy
mysql> 

mysql> -- teraz przydałby się odpowiednik kwantyfikatora DLA KAŻDEGO
mysql> -- jest nim operator ALL
mysql> -- działa on podobnie do ANY, jednak teraz wszystkie wiersze zwracane
mysql> -- przez podzapytanie muszą spełniać kryterium
mysql> --
mysql> -- znowu można by było znaleźć liczbę miast kraju z Europy, który ma 
mysql> -- tym razem najwięcej miast i odwołać się do tej liczby
mysql> --
mysql> -- użyjemy jednak operatora ALL: 
mysql> --
mysql> select p.name kraj, count(*) "ile miast"
    -> from country p, city m
    -> where
    -> code = countrycode
    -> group by 1
    -> having								
    -> count(*) > All						
    -> (select count(*)
    -> from country, city
    -> where
    -> code = countrycode				
    -> and								 
    -> continent = "europe"			    
    -> group by code)
    -> order by 2;
+---------------+-----------+
| kraj          | ile miast |
+---------------+-----------+
| Japan         |       248 |
| Brazil        |       250 |
| United States |       274 |
| India         |       341 |
| China         |       363 |
+---------------+-----------+
5 rows in set (0.05 sec)

mysql> --
mysql> -- wynik można sprawdzić, wypisując nazwy krajów
mysql> -- i liczbę ich miast posortowaną "desc" z opcją
mysql> -- limit 6 (bo jest z tego zapytania 5 wyników)
mysql> --
mysql> -- ZADANIE: dokonaj powyższej weryfikacji
mysql> --
mysql> --
mysql> -- ZADANIE: nie znając kodu Polski, wypisz wszystkie państwa i ich stolice, 
mysql> -- w których mówi się jakimkolwiek językiem występującym w Polsce
mysql> --
mysql> -- 
mysql> -- teraz wykorzystamy operator IN, działający tak, że analizowana wartość
mysql> -- w podzapytaniu zewnętrznym występuje wśród wierszy zwracanych przez
mysql> -- podzapytaniu wewnętrznym, to wartość ta (zewnętrzna) jest wypisywana
mysql> --
mysql> select p.name kraj, m.name stolica, language język
    -> from country p, city m, countrylanguage j
    -> where
    -> j.countrycode = code
    -> and
    -> capital = id
    -> and
    -> language IN						-- wykorzystanie operatora IN
    -> (select language 
    -> from countrylanguage cl			
    -> where cl.countrycode = 			-- nie znamy kodu Polski
    -> (select code from country
    -> where
    -> name = "Poland"))
    -> order by 3, 1;
+--------------------+------------------------------------+-------------+
| kraj               | stolica                            | język       |
+--------------------+------------------------------------+-------------+
| Belarus            | Minsk                              | Belorussian |
| Estonia            | Tallinn                            | Belorussian |
| Latvia             | Riga                               | Belorussian |
| Lithuania          | Vilnius                            | Belorussian |
| Poland             | Warszawa                           | Belorussian |
| Russian Federation | Moscow                             | Belorussian |
| Ukraine            | Kyiv                               | Belorussian |
| Australia          | Canberra                           | German      |
| Austria            | Wien                               | German      |
| Belgium            | Bruxelles [Brussel]                | German      |
| Brazil             | Brasília                           | German      |
| Canada             | Ottawa                             | German      |
| Czech Republic     | Praha                              | German      |
| Denmark            | København                          | German      |
| Germany            | Berlin                             | German      |
| Hungary            | Budapest                           | German      |
| Italy              | Roma                               | German      |
| Kazakstan          | Astana                             | German      |
| Liechtenstein      | Vaduz                              | German      |
| Luxembourg         | Luxembourg [Luxemburg/Lëtzebuerg]  | German      |
| Namibia            | Windhoek                           | German      |
| Paraguay           | Asunción                           | German      |
| Poland             | Warszawa                           | German      |
| Romania            | Bucuresti                          | German      |
| Switzerland        | Bern                               | German      |
| United States      | Washington                         | German      |
| Austria            | Wien                               | Polish      |
| Belarus            | Minsk                              | Polish      |
| Canada             | Ottawa                             | Polish      |
| Czech Republic     | Praha                              | Polish      |
| Germany            | Berlin                             | Polish      |
| Latvia             | Riga                               | Polish      |
| Lithuania          | Vilnius                            | Polish      |
| Poland             | Warszawa                           | Polish      |
| Ukraine            | Kyiv                               | Polish      |
| United States      | Washington                         | Polish      |
| Belarus            | Minsk                              | Ukrainian   |
| Canada             | Ottawa                             | Ukrainian   |
| Estonia            | Tallinn                            | Ukrainian   |
| Kazakstan          | Astana                             | Ukrainian   |
| Kyrgyzstan         | Bishkek                            | Ukrainian   |
| Latvia             | Riga                               | Ukrainian   |
| Lithuania          | Vilnius                            | Ukrainian   |
| Moldova            | Chisinau                           | Ukrainian   |
| Poland             | Warszawa                           | Ukrainian   |
| Romania            | Bucuresti                          | Ukrainian   |
| Russian Federation | Moscow                             | Ukrainian   |
| Ukraine            | Kyiv                               | Ukrainian   |
+--------------------+------------------------------------+-------------+
48 rows in set (0.01 sec)
mysql> --
mysql> --
mysql> -- ZADANIE: sprawdź, czy istnieje również operator NOT IN
mysql> -- a jeśli tak, to wymyśl zadanie z nim związanie
mysql> -- i napisz odpowiednie zapytanie (najlepiej dot. podzapytań)
mysql> --
mysql> --
mysql> -- ZADANIE: wypisz po ile jest miast na daną literę
mysql> 
mysql> select left(name,1) litera, count(*) ile
    -> from city 
    -> group by 1
    -> order by 2;
+--------+-----+
| litera | ile |
+--------+-----+
| ´      |   1 |
| [      |   2 |
| Ö      |   2 |
| Š      |   5 |
| X      |  24 |
| Q      |  39 |
| U      |  49 |
| Z      |  59 |
| Y      |  63 |
| W      |  66 |
| E      |  72 |
| F      |  78 |
| V      |  85 |
| O      |  96 |
| J      | 104 |
| I      | 109 |
| R      | 110 |
| D      | 127 |
| G      | 140 |
| H      | 159 |
| L      | 172 |
| N      | 176 |
| P      | 236 |
| T      | 255 |
| A      | 259 |
| K      | 261 |
| C      | 281 |
| M      | 301 |
| B      | 317 |
| S      | 431 |
+--------+-----+
30 rows in set (0.04 sec)

mysql> 
mysql> 
mysql> -- ZADANIE: wypisz wszystkie państwa, w których są miasta na literę Z
mysql> 
mysql> select p.name kraj, m.name miasto
    -> from country p, city m			-- poprzez złączenie
    -> where							
    -> code = countrycode				 
    -> and
    -> m.name like "z%"				
    -> order by 1;					
+------------------------+-----------------+
| kraj                   | miasto          |
+------------------------+-----------------+
| Bosnia and Herzegovina | Zenica          |
| China                  | Zhangjiakou     |
| China                  | Zaoyang         |
| China                  | Zhangjiagang    |
| China                  | Zalantun        |
| China                  | Zhoushan        |
| China                  | Zhoukou         |
| China                  | Zhucheng        |
| China                  | Zixing          |
| China                  | Zhengzhou       |
| China                  | Zibo            |
| China                  | Zhumadian       |
| China                  | Zhuzhou         |
| China                  | Zhangjiang      |
| China                  | Zigong          |
| China                  | Zaozhuang       |
| China                  | Zhenjiang       |
| China                  | Zhongshan       |
| China                  | Zunyi           |
| China                  | Zhaoqing        |
| China                  | Zhangzhou       |
| China                  | Zhaodong        |
| China                  | Zhuhai          |
| Croatia                | Zagreb          |
| Egypt                  | Zagazig         |
| Germany                | Zwickau         |
| Iran                   | Zahedan         |
| Iran                   | Zanjan          |
| Iran                   | Zabol           |
| Japan                  | Zama            |
| Kazakstan              | Zhezqazghan     |
| Mexico                 | Zapopan         |
| Mexico                 | Zamora          |
| Mexico                 | Zitácuaro       |
| Mexico                 | Zacatecas       |
| Mexico                 | Zinacantepec    |
| Mexico                 | Zumpango        |
| Netherlands            | Zoetermeer      |
| Netherlands            | Zaanstad        |
| Netherlands            | Zwolle          |
| Niger                  | Zinder          |
| Nigeria                | Zaria           |
| Philippines            | Zamboanga       |
| Poland                 | Zabrze          |
| Poland                 | Zielona Góra    |
| Russian Federation     | Zeleznogorsk    |
| Russian Federation     | Zelenograd      |
| Russian Federation     | Zlatoust        |
| Russian Federation     | Zelenodolsk     |
| Russian Federation     | Zeleznodoroznyi |
| Russian Federation     | Zeleznogorsk    |
| Russian Federation     | Zukovski        |
| Senegal                | Ziguinchor      |
| Spain                  | Zaragoza        |
| Switzerland            | Zürich          |
| Tanzania               | Zanzibar        |
| Turkey                 | Zonguldak       |
| Ukraine                | Zaporizzja      |
| Ukraine                | Zytomyr         |
+------------------------+-----------------+
59 rows in set (0.03 sec)

-- zaraz zrobimy przez podzapytanie, tylko jeszcze
-- przez złączenie zapytanie weryfikujące:
 
mysql> 
mysql> select p.name kraj, count(*) ile		
    -> from country p, city m				
    -> where								
    -> code = countrycode					
    -> and
    -> m.name like "z%"
    -> group by 1
    -> order by 2;							
+------------------------+-----+
| kraj                   | ile |
+------------------------+-----+
| Bosnia and Herzegovina |   1 |
| Egypt                  |   1 |
| Spain                  |   1 |
| Philippines            |   1 |
| Japan                  |   1 |
| Kazakstan              |   1 |
| Croatia                |   1 |
| Niger                  |   1 |
| Nigeria                |   1 |
| Germany                |   1 |
| Senegal                |   1 |
| Switzerland            |   1 |
| Tanzania               |   1 |
| Turkey                 |   1 |
| Poland                 |   2 |
| Ukraine                |   2 |
| Netherlands            |   3 |
| Iran                   |   3 |
| Mexico                 |   6 |
| Russian Federation     |   7 |
| China                  |  22 |
+------------------------+-----+
21 rows in set (0.03 sec)

mysql> -- sprawdzając, po ile jest miast w danym kraju,  dowiemy się, że jest 
mysql> -- ich 21, co pomoże w weryfikacji poprawności kolejnego
mysql> -- zapytania (poprzez podzapytanie)
mysql> --
mysql> -- używamy operatora EXISTS, który działa tak, że jeśli podzapytanie zwraca 
mysql> -- cokolwiek (zwraca 1 - prawda),to wypisywany jest wiersz zewnętrznego,
mysql> -- a jeśli nie, to 0 (fałsz) i nie wypisuje

mysql> select name kraj from country
    -> where EXISTS					
    -> (select * from city				
    -> where							
    -> code = countrycode
    -> and
    -> name like "z%");				
+------------------------+
| kraj                   |
+------------------------+
| Netherlands            |
| Bosnia and Herzegovina |
| Egypt                  |
| Spain                  |
| Philippines            |
| Iran                   |
| Japan                  |
| Kazakstan              |
| China                  |
| Croatia                |
| Mexico                 |
| Niger                  |
| Nigeria                |
| Poland                 |
| Germany                |
| Senegal                |
| Switzerland            |
| Tanzania               |
| Turkey                 |
| Ukraine                |
| Russian Federation     |
+------------------------+
21 rows in set (0.03 sec)

mysql> -- podobnie wygląda sytuacja z operatorem NOT EXISTS - wypisuje dla 0, dla 1 nie
mysql> --

mysql> -- ZADANIE: wypisz państwa, w których nie ma miasta na 10 najpopularniejszych liter
mysql> -- 
mysql> -- chciałoby się zrobić coś takiego:
mysql> --
mysql> select name kraj
    -> from country
    -> where NOT EXISTS
    -> (select * from city
    -> where
    -> code = countrycode
    -> and
    -> left(name, 1) in
    -> (select left(name,1)
    -> from city
    -> group by 1
    -> order by count(*)
    -> desc
    -> limit 10));
ERROR 1235 (42000): This version of MySQL doesn''t yet support 'LIMIT & IN/ALL/ANY/SOME subquery'
mysql> -- ale dowiadujemy się, że jeszcze ta wersja MySQL nie może łączyć 
mysql> -- operatora IN z limit ...
mysql> -- musimy więc wypisać te litery:
mysql> --
mysql> select name kraj 
    -> from country
    -> where NOT EXISTS		
    -> (select * from city		
    -> where					
    -> code = countrycode		
    -> and						
    -> left(name, 1) in ("S","B","M","C","K","A","T","P", "N", "L"));
+----------------------------------------------+
| kraj                                         |
+----------------------------------------------+
| Netherlands Antilles                         |
| Armenia                                      |
| Aruba                                        |
| Botswana                                     |
| Virgin Islands, British                      |
| Cayman Islands                               |
| Djibouti                                     |
| Dominica                                     |
| Gibraltar                                    |
| Guyana                                       |
| Iceland                                      |
| East Timor                                   |
| Christmas Island                             |
| Western Sahara                               |
| Marshall Islands                             |
| Martinique                                   |
| Mongolia                                     |
| Namibia                                      |
| Nauru                                        |
| Northern Mariana Islands                     |
| Qatar                                        |
| Saint Helena                                 |
| Solomon Islands                              |
| Seychelles                                   |
| Sierra Leone                                 |
| Tokelau                                      |
| Tuvalu                                       |
| Antarctica                                   |
| Bouvet Island                                |
| British Indian Ocean Territory               |
| South Georgia and the South Sandwich Islands |
| Heard Island and McDonald Islands            |
| French Southern territories                  |
| United States Minor Outlying Islands         |
+----------------------------------------------+
34 rows in set (0.03 sec)

mysql> -- widać, że wśród wypisanych państw są kraje, które nie tylko, że nie mają miast
mysql> -- na jedną spośród 10 najpopularniejszych liter, to więcej, nie mają miast w ogóle
mysql> --
mysql> -- ZADANIE: zmień powyższe zapytanie tak, aby pominąć kraje bez miast
mysql> --
mysql> -- można w tym celu użyć złączenia (ale nie LEFT JOIN)
mysql> --
mysql> select distinct p.name kraj		
    -> from country p, city m			
    -> where							
    -> code = countrycode
    -> and not exists
    -> (select * from city
    -> where                         
    -> code = countrycode            
    -> and
    -> left(name, 1) in ("S","B","M",
    -> "C","K","A","T","P", "N", "L"));
+--------------------------+
| kraj                     |
+--------------------------+
| Netherlands Antilles     |
| Armenia                  |
| Aruba                    |
| Botswana                 |
| Virgin Islands, British  |
| Cayman Islands           |
| Djibouti                 |
| Dominica                 |
| Gibraltar                |
| Guyana                   |
| Iceland                  |
| East Timor               |
| Christmas Island         |
| Western Sahara           |
| Marshall Islands         |
| Martinique               |
| Mongolia                 |
| Namibia                  |
| Nauru                    |
| Northern Mariana Islands |
| Qatar                    |
| Saint Helena             |
| Solomon Islands          |
| Seychelles               |
| Sierra Leone             |
| Tokelau                  |
| Tuvalu                   |
+--------------------------+
27 rows in set (0.05 sec)

mysql> -- na koniec dwie ciekawostki: 
mysql> -- pierwsza dotyczy zagnieżdżania grupowania (rozbiliśmy to już przy okazji
mysql> -- wypisywania liczby osób pogrupowanych ze względu na płeć - stan cywilny)
mysql> -- jest jednak dodatkowa opcja, która pozwala na sumowanie w grupach:
mysql> --
mysql> -- wypiszemy nazwy kontynentów, ich regiony i liczbę miast w regionie
mysql> -- z sumowaniem tych liczb w grupach:
mysql> --
mysql> select continent kontynent, region, count(*) ile_państw
    -> from country
    -> group by 1, 2				-- grupowanie w podgrupach (jak płeć - stan)
    -> with rollup;					-- sumowanie po grupach
+---------------+---------------------------+-------------+
| kontynent     | region                    | ile_państw  |
+---------------+---------------------------+-------------+
| Asia          | Eastern Asia              |           8 |
| Asia          | Middle East               |          18 |
| Asia          | Southeast Asia            |          11 |
| Asia          | Southern and Central Asia |          14 |
| Asia          | NULL                      |          51 |
| Europe        | Baltic Countries          |           3 |
| Europe        | British Islands           |           2 |
| Europe        | Eastern Europe            |          10 |
| Europe        | Nordic Countries          |           7 |
| Europe        | Southern Europe           |          15 |
| Europe        | Western Europe            |           9 |
| Europe        | NULL                      |          46 |
| North America | Caribbean                 |          24 |
| North America | Central America           |           8 |
| North America | North America             |           5 |
| North America | NULL                      |          37 |
| Africa        | Central Africa            |           9 |
| Africa        | Eastern Africa            |          20 |
| Africa        | Northern Africa           |           7 |
| Africa        | Southern Africa           |           5 |
| Africa        | Western Africa            |          17 |
| Africa        | NULL                      |          58 |
| Oceania       | Australia and New Zealand |           5 |
| Oceania       | Melanesia                 |           5 |
| Oceania       | Micronesia                |           7 |
| Oceania       | Micronesia/Caribbean      |           1 |
| Oceania       | Polynesia                 |          10 |
| Oceania       | NULL                      |          28 |
| Antarctica    | Antarctica                |           5 |
| Antarctica    | NULL                      |           5 |
| South America | South America             |          14 |
| South America | NULL                      |          14 |
| NULL          | NULL                      |         239 |
+---------------+---------------------------+-------------+
33 rows in set (0.00 sec)

mysql> -- 
mysql> -- na konie każdego kontynentu pojawia się dodatkowy wiersz, który w nazwie regionu
mysql> -- ma NULL, a w 3 kolumnie sumę kolumn z liczbami krajów na kontynencie
mysql> -- na końcu jest suma sum, czyli liczba wszystkich miast
mysql> --
mysql> --
mysql> -- ciekawostka 2: 
mysql> --
mysql> -- jak zauważyliśmy już wielokrotnie również w poprzednich laboratoriach
mysql> -- wielkość liter nie ma znaczenia:
mysql> --
mysql> select name, population
    -> from country				
    -> where code like "PoL"; -- prawdziwy kod ma też wielkie O: "POL" jednak zapytanie przejdzie
+--------+------------+
| name   | population |
+--------+------------+
| Poland |   38653600 |
+--------+------------+
1 row in set (0.00 sec)

mysql> -- jeśli chcemy, żeby wielkość liter była uwzględniana, to zapytanie zmieniamy na:
mysql> --
mysql> select name, population
    -> from country				
    -> where code like BINARY "PoL";
Empty set (0.00 sec)

mysql> -- 
mysql> -- ostatnia uwaga:
mysql> -- opcji BINARY można użyć już na etapie tworzenia tabel/bazy
mysql> -- wtedy wielkość liter będzie miała znaczenia "z definicji"
mysql> --

