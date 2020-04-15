 -- ZŁĄCZENIA TABEL
 --
 -- do tej pory zapytania wydobywały dane tylko z jednej tabeli, najczęściej
 -- pobiera się dane z wielu tabel równocześnie
 -- złączenie tabel tworzy na początek iloczyn kartezjański tych tabel
 -- tzn. tworzy wszystkie możliwe pary a-b, gdzie a jest dowolnym (każdym)
 -- wierszem tabeli pierwszej, b - tabeli drugiej
 --
 use znajomi
Database changed
 select imie, numer    -- jeśli nazwa kolumny jest jednoznaczna, można tak
     from osoby, telefony; -- przecinek oznacza tu stworzenie iloczynu kartezjańskiego

+-------+-----------+
| imie  | numer     |
+-------+-----------+
| Jan   | 565432789 |
| Jan   | 609784512 |
| Jan   | 588890789 |
| Jan   | 565490789 |
| Jan   | 565490789 |
| Jan   | 512342789 |
| Jan   | 777444111 |
| Ola   | 565432789 |
| Ola   | 609784512 |
| Ola   | 588890789 |
| Ola   | 565490789 |
| Ola   | 565490789 |
| Ola   | 512342789 |
| Ola   | 777444111 |
| Ela   | 565432789 |
| Ela   | 609784512 |
| Ela   | 588890789 |
| Ela   | 565490789 |
| Ela   | 565490789 |
| Ela   | 512342789 |
| Ela   | 777444111 |
| Ala   | 565432789 |
| Ala   | 609784512 |
| Ala   | 588890789 |
| Ala   | 565490789 |
| Ala   | 565490789 |
| Ala   | 512342789 |
| Ala   | 777444111 |
| Iza   | 565432789 |
| Iza   | 609784512 |
| Iza   | 588890789 |
| Iza   | 565490789 |
| Iza   | 565490789 |
| Iza   | 512342789 |
| Iza   | 777444111 |
| Marek | 565432789 |
| Marek | 609784512 |
| Marek | 588890789 |
| Marek | 565490789 |
| Marek | 565490789 |
| Marek | 512342789 |
| Marek | 777444111 |
| imie  | 565432789 |
| imie  | 609784512 |
| imie  | 588890789 |
| imie  | 565490789 |
| imie  | 565490789 |
| imie  | 512342789 |
| imie  | 777444111 |
| Ela   | 565432789 |
| Ela   | 609784512 |
| Ela   | 588890789 |
| Ela   | 565490789 |
| Ela   | 565490789 |
| Ela   | 512342789 |
| Ela   | 777444111 |
| www   | 565432789 |
| www   | 609784512 |
| www   | 588890789 |
| www   | 565490789 |
| www   | 565490789 |
| www   | 512342789 |
| www   | 777444111 |
+-------+-----------+
63 rows in set (0.41 sec)

 -- jak widać każde i imion z tabeli osoby zostało połączone z
 -- każdym numerem z tabeli telefony
 --
 -- prawie nigdy nie jest potrzebny pełny taki iloczyn
 -- wybiera się tylko wybrane (nowo utworzone) wiersza poprzez WHERE
 --

 -- jeśli nazwy kolumn nie są jednoznaczne (bo nie muszą być pomiędzy tabelami)
 -- to nazwę kolumny TRZEBA poprzedzić nazwą tabeli, z której pochodzi
 -- jeśli jest jednoznaczna, to MOŻNA:
 --
 select osoby.imie, telefony.numer
     from osoby, telefony
     limit 5; -- tylko po to, żeby nie zasypało nas znowu 63 wierszami
+------+-----------+
| imie | numer     |
+------+-----------+
| Jan  | 565432789 |
| Jan  | 609784512 |
| Jan  | 588890789 |
| Jan  | 565490789 |
| Jan  | 565490789 |
+------+-----------+
5 rows in set (0.00 sec)

 -- jeżeli chcemy żeby wypisać z tego pełnego iloczynu tylko te dane, które
 -- mają największy sens - czyli osobę i jego numer telefonu (tych wyników
 -- będzie tyle, ile jest wpisów w tabeli łączącej osoby i telefony)
 -- musimy poprzez WHERE określić, które wiersze nas interesują
 --
 -- w tym przypadku w tabeli "pol" id osoby i id telefonu muszą się zgadzać
 -- z id osoby (w tabeli osoby) i z id tel. (z tabeli telefony)
 --
 select imie, nazwisko, wiek, numer, operator, typ
     from osoby, telefony
     where
     osoby.id_o = pol.id_o
     and
     telefony.id_t = pol.id_t;
ERROR 1054 (42S22): Unknown column 'pol.id_o' in 'where clause'

 -- zapytanie zakończyo się błędem, bo chociaż nie wypisujemy danych z tabeli pol,
 -- to jednak z niej korzystamy - musi być ona wypisana we FROM:
 --
 select imie, nazwisko, wiek, numer, operator, typ
     from osoby, telefony, pol
     where
     osoby.id_o = pol.id_o
     and
     telefony.id_t = pol.id_t;
+------+----------+------+-----------+----------+-------------+
| imie | nazwisko | wiek | numer     | operator | typ         |
+------+----------+------+-----------+----------+-------------+
| Ola  | Nowak    |   56 | 512342789 | heyah    | komórka     |
| Ola  | Nowak    |   56 | 565432789 | era      | komórka     |
| Ela  | Maj      |   21 | 512342789 | heyah    | komórka     |
| Jan  | Lis      |    0 | 588890789 | tp       | stacjonarny |
| Ola  | Nowak    |   56 | 565490789 | orange   | komórka     |
| Ola  | Nowak    |   56 | 565490789 | orange   | komórka     |
+------+----------+------+-----------+----------+-------------+
6 rows in set (0.36 sec)

 -- często poprzedzanie nazwy kolumny nazwą tabeli (niezależnie od jednoznaczności nazwy)
 -- jest praktykowane przez informatyków, zapytanie powyższe wyglądaoby wtedy tak:

 select osoby.imie, osoby.nazwisko, osoby.wiek, telefony.numer, telefony.operator, telefony.typ
     from osoby, telefony, pol
     where
     osoby.id_o = pol.id_o
     and
     telefony.id_t = pol.id_t;
+------+----------+------+-----------+----------+-------------+
| imie | nazwisko | wiek | numer     | operator | typ         |
+------+----------+------+-----------+----------+-------------+
| Ola  | Nowak    |   56 | 512342789 | heyah    | komórka     |
| Ola  | Nowak    |   56 | 565432789 | era      | komórka     |
| Ela  | Maj      |   21 | 512342789 | heyah    | komórka     |
| Jan  | Lis      |    0 | 588890789 | tp       | stacjonarny |
| Ola  | Nowak    |   56 | 565490789 | orange   | komórka     |
| Ola  | Nowak    |   56 | 565490789 | orange   | komórka     |
+------+----------+------+-----------+----------+-------------+
6 rows in set (0.00 sec)

 -- zapis ten można skrócić, używając aliasów dla tabel
 -- teraz wyłącznie do uproszczenia zapisu, w przyszłości
 -- aliasów tabel będziemy używać do ważniejszych celów
 --
 select o.imie, o.nazwisko, wiek, t.numer, operator, t.typ   -- można stosować taktykę
     from osoby o, telefony t, pol p   -- mieszaną, tzn. część
     where  -- poprzedzać, a część nie
     o.id_o = p.id_o
     and
     t.id_t = p.id_t;
+------+----------+------+-----------+----------+-------------+
| imie | nazwisko | wiek | numer     | operator | typ         |
+------+----------+------+-----------+----------+-------------+
| Ola  | Nowak    |   56 | 512342789 | heyah    | komórka     |
| Ola  | Nowak    |   56 | 565432789 | era      | komórka     |
| Ela  | Maj      |   21 | 512342789 | heyah    | komórka     |
| Jan  | Lis      |    0 | 588890789 | tp       | stacjonarny |
| Ola  | Nowak    |   56 | 565490789 | orange   | komórka     |
| Ola  | Nowak    |   56 | 565490789 | orange   | komórka     |
+------+----------+------+-----------+----------+-------------+
6 rows in set (0.00 sec)

 -- idziemy do świata, żeby rozwiązać
 -- ZADANIE: wypisz kraje na "P" i ich stolice
 --
 use swiat;
Database changed

 select k.name kraj, m.name stolica -- tu musimy poprzedzić, bo name jest niejednoznaczna
     from country k, city m -- łączymy kraje z miastami, to co je łączy (w tym zadaniu)
     where -- to stolica, więc wybieramy kraje na "K":
     k.name like "p%"
     and				-- i ich stolice, to są kolumny, które mają
     capital = id --  mieć te same wartości, żeby ze wszystkich par kraj-miasto
     order by 1; -- wybrać tylko te, które są stolicami danego kraju;
+------------------+------------------+
| kraj             | stolica          |
+------------------+------------------+
| Pakistan         | Islamabad        |
| Palau            | Koror            |
| Palestine        | Gaza             |
| Panama           | Ciudad de Panam  |
| Papua New Guinea | Port Moresby     |
| Paraguay         | Asunción         |
| Peru             | Lima             |
| Philippines      | Manila           |
| Pitcairn         | Adamstown        |
| Poland           | Warszawa         |
| Portugal         | Lisboa           |
| Puerto Rico      | San Juan         |
+------------------+------------------+
12 rows in set (0.00 sec)


 -- ZADANIE: wypisz z bazy świat kody państw, ich nazwy (na P lub H), języki informację
 -- o tym, czy jest on oficjalny (słowo "urzędowy") czy nie ("nieoficjalny")

 select code kod, name kraj, language język,
     if(isofficial = "t", "urzędowy", "nieoficjalny") jaki
     from country, countrylanguage
     where code = countrycode
     and (name like "p%" or name like "h%") -- czy ten nawias jest potrzebny? SPRAWDŹ, co będzie
     order by 2, 4 desc, 3;				  -- jeśli go nie będzie
+-----+-------------------------------+----------------------+--------------+
| kod | kraj                          | język                | jaki         |
+-----+-------------------------------+----------------------+--------------+
| HTI | Haiti                         | French               | urzędowy     |
| HTI | Haiti                         | Haiti Creole         | nieoficjalny |
| VAT | Holy See (Vatican City State) | Italian              | urzędowy     |
| HND | Honduras                      | Spanish              | urzędowy     |
| HND | Honduras                      | Creole English       | nieoficjalny |
| HND | Honduras                      | Garifuna             | nieoficjalny |
| HND | Honduras                      | Miskito              | nieoficjalny |
| HKG | Hong Kong                     | English              | urzędowy     |
| HKG | Hong Kong                     | Canton Chinese       | nieoficjalny |
| HKG | Hong Kong                     | Chiu chau            | nieoficjalny |
| HKG | Hong Kong                     | Fukien               | nieoficjalny |
| HKG | Hong Kong                     | Hakka                | nieoficjalny |
| HUN | Hungary                       | Hungarian            | urzędowy     |
| HUN | Hungary                       | German               | nieoficjalny |
| HUN | Hungary                       | Romani               | nieoficjalny |
| HUN | Hungary                       | Romanian             | nieoficjalny |
| HUN | Hungary                       | Serbo-Croatian       | nieoficjalny |
| HUN | Hungary                       | Slovak               | nieoficjalny |
| PAK | Pakistan                      | Urdu                 | urzędowy     |
| PAK | Pakistan                      | Balochi              | nieoficjalny |
| PAK | Pakistan                      | Brahui               | nieoficjalny |
| PAK | Pakistan                      | Hindko               | nieoficjalny |
| PAK | Pakistan                      | Pashto               | nieoficjalny |
| PAK | Pakistan                      | Punjabi              | nieoficjalny |
| PAK | Pakistan                      | Saraiki              | nieoficjalny |
| PAK | Pakistan                      | Sindhi               | nieoficjalny |
| PLW | Palau                         | English              | urzędowy     |
| PLW | Palau                         | Palau                | urzędowy     |
| PLW | Palau                         | Chinese              | nieoficjalny |
| PLW | Palau                         | Philippene Languages | nieoficjalny |
| PSE | Palestine                     | Arabic               | nieoficjalny |
| PSE | Palestine                     | Hebrew               | nieoficjalny |
| PAN | Panama                        | Spanish              | urzędowy     |
| PAN | Panama                        | Arabic               | nieoficjalny |
| PAN | Panama                        | Creole English       | nieoficjalny |
| PAN | Panama                        | Cuna                 | nieoficjalny |
| PAN | Panama                        | Embera               | nieoficjalny |
| PAN | Panama                        | Guaymˇ               | nieoficjalny |
| PNG | Papua New Guinea              | Malenasian Languages | nieoficjalny |
| PNG | Papua New Guinea              | Papuan Languages     | nieoficjalny |
| PRY | Paraguay                      | Guaranˇ              | urzędowy     |
| PRY | Paraguay                      | Spanish              | urzędowy     |
| PRY | Paraguay                      | German               | nieoficjalny |
| PRY | Paraguay                      | Portuguese           | nieoficjalny |
| PER | Peru                          | Aimar                | urzędowy     |
| PER | Peru                          | Ketçua               | urzędowy     |
| PER | Peru                          | Spanish              | urzędowy     |
| PHL | Philippines                   | Pilipino             | urzędowy     |
| PHL | Philippines                   | Bicol                | nieoficjalny |
| PHL | Philippines                   | Cebuano              | nieoficjalny |
| PHL | Philippines                   | Hiligaynon           | nieoficjalny |
| PHL | Philippines                   | Ilocano              | nieoficjalny |
| PHL | Philippines                   | Maguindanao          | nieoficjalny |
| PHL | Philippines                   | Maranao              | nieoficjalny |
| PHL | Philippines                   | Pampango             | nieoficjalny |
| PHL | Philippines                   | Pangasinan           | nieoficjalny |
| PHL | Philippines                   | Waray-waray          | nieoficjalny |
| PCN | Pitcairn                      | Pitcairnese          | nieoficjalny |
| POL | Poland                        | Polish               | urzędowy     |
| POL | Poland                        | Belorussian          | nieoficjalny |
| POL | Poland                        | German               | nieoficjalny |
| POL | Poland                        | Ukrainian            | nieoficjalny |
| PRT | Portugal                      | Portuguese           | urzędowy     |
| PRI | Puerto Rico                   | Spanish              | urzędowy     |
| PRI | Puerto Rico                   | English              | nieoficjalny |
+-----+-------------------------------+----------------------+--------------+
65 rows in set (0.49 sec)

 -- w literaturze złączenia realizowane są przez JOIN (CROSS JOIN, INNER JOIN, ...)
 -- w teorii różnią się one (przynajmniej częć) między sobą, ale jak już wiemy
 -- standardy swoje a implementacja swoje ... w MySQL (przynajmniej w tej wersji)
 -- działają one tak samo, w literaturze złączenia realizowane są warunkiem ON
 -- (odpowiednik WHERE), więc powyższe zapytanie wyglądałoby tak:
 --
 select code kod, name kraj, language język,
     if(isofficial = "t", "urzędowy", "nieoficjalny") jaki
     from country JOIN countrylanguage -- lub CROSS JOIN, INNER JOIN,
     ON code = countrycode -- do warunku złączenia: ON
     where name like "p%" or name like "h%"-- dla dodatkowych warunków: WHERE
     order by 2, 4 desc, 3;
+-----+-------------------------------+----------------------+--------------+
| kod | kraj                          | język                | jaki         |
+-----+-------------------------------+----------------------+--------------+
| HTI | Haiti                         | French               | urzędowy     |
| HTI | Haiti                         | Haiti Creole         | nieoficjalny |
| VAT | Holy See (Vatican City State) | Italian              | urzędowy     |
| HND | Honduras                      | Spanish              | urzędowy     |
| HND | Honduras                      | Creole English       | nieoficjalny |
| HND | Honduras                      | Garifuna             | nieoficjalny |
| HND | Honduras                      | Miskito              | nieoficjalny |
| HKG | Hong Kong                     | English              | urzędowy     |
| HKG | Hong Kong                     | Canton Chinese       | nieoficjalny |
| HKG | Hong Kong                     | Chiu chau            | nieoficjalny |
| HKG | Hong Kong                     | Fukien               | nieoficjalny |
| HKG | Hong Kong                     | Hakka                | nieoficjalny |
| HUN | Hungary                       | Hungarian            | urzędowy     |
| HUN | Hungary                       | German               | nieoficjalny |
| HUN | Hungary                       | Romani               | nieoficjalny |
| HUN | Hungary                       | Romanian             | nieoficjalny |
| HUN | Hungary                       | Serbo-Croatian       | nieoficjalny |
| HUN | Hungary                       | Slovak               | nieoficjalny |
| PAK | Pakistan                      | Urdu                 | urzędowy     |
| PAK | Pakistan                      | Balochi              | nieoficjalny |
| PAK | Pakistan                      | Brahui               | nieoficjalny |
| PAK | Pakistan                      | Hindko               | nieoficjalny |
| PAK | Pakistan                      | Pashto               | nieoficjalny |
| PAK | Pakistan                      | Punjabi              | nieoficjalny |
| PAK | Pakistan                      | Saraiki              | nieoficjalny |
| PAK | Pakistan                      | Sindhi               | nieoficjalny |
| PLW | Palau                         | English              | urzędowy     |
| PLW | Palau                         | Palau                | urzędowy     |
| PLW | Palau                         | Chinese              | nieoficjalny |
| PLW | Palau                         | Philippene Languages | nieoficjalny |
| PSE | Palestine                     | Arabic               | nieoficjalny |
| PSE | Palestine                     | Hebrew               | nieoficjalny |
| PAN | Panama                        | Spanish              | urzędowy     |
| PAN | Panama                        | Arabic               | nieoficjalny |
| PAN | Panama                        | Creole English       | nieoficjalny |
| PAN | Panama                        | Cuna                 | nieoficjalny |
| PAN | Panama                        | Embera               | nieoficjalny |
| PAN | Panama                        | Guaymˇ               | nieoficjalny |
| PNG | Papua New Guinea              | Malenasian Languages | nieoficjalny |
| PNG | Papua New Guinea              | Papuan Languages     | nieoficjalny |
| PRY | Paraguay                      | Guaranˇ              | urzędowy     |
| PRY | Paraguay                      | Spanish              | urzędowy     |
| PRY | Paraguay                      | German               | nieoficjalny |
| PRY | Paraguay                      | Portuguese           | nieoficjalny |
| PER | Peru                          | Aimar                | urzędowy     |
| PER | Peru                          | Ketçua               | urzędowy     |
| PER | Peru                          | Spanish              | urzędowy     |
| PHL | Philippines                   | Pilipino             | urzędowy     |
| PHL | Philippines                   | Bicol                | nieoficjalny |
| PHL | Philippines                   | Cebuano              | nieoficjalny |
| PHL | Philippines                   | Hiligaynon           | nieoficjalny |
| PHL | Philippines                   | Ilocano              | nieoficjalny |
| PHL | Philippines                   | Maguindanao          | nieoficjalny |
| PHL | Philippines                   | Maranao              | nieoficjalny |
| PHL | Philippines                   | Pampango             | nieoficjalny |
| PHL | Philippines                   | Pangasinan           | nieoficjalny |
| PHL | Philippines                   | Waray-waray          | nieoficjalny |
| PCN | Pitcairn                      | Pitcairnese          | nieoficjalny |
| POL | Poland                        | Polish               | urzędowy     |
| POL | Poland                        | Belorussian          | nieoficjalny |
| POL | Poland                        | German               | nieoficjalny |
| POL | Poland                        | Ukrainian            | nieoficjalny |
| PRT | Portugal                      | Portuguese           | urzędowy     |
| PRI | Puerto Rico                   | Spanish              | urzędowy     |
| PRI | Puerto Rico                   | English              | nieoficjalny |
+-----+-------------------------------+----------------------+--------------+
65 rows in set (0.01 sec)

 -- teraz potestujemy składnię złączeń na przykładzie
 -- ZADANIE: wypisz kraje i ich miasta, kraje i ich miasta mają mieć te same litery początkowe,
 -- różne litery końcowe i równe długości, wyniki posortuj po krajach, a wewnątrz po miastach
 --
 select k.name kraj, m.name miasto
     from country k, city m -- złączenie przez ","
     where
     code = countrycode -- warunek złączenia na to, żeby miasto leżało w danym kraju
     and
     left(k.name,1) = left(m.name,1) -- początkowe litery takie same
     and
     right(k.name,1) <> right(m.name,1) -- końcowe litery różne
     and
     length(k.name) = length(m.name) -- równe długości nawz
     order by 1, 2; -- sortowanie
+-------------+-------------+
| kraj        | miasto      |
+-------------+-------------+
| Belarus     | Borisov     |
| Iran        | Ilam        |
| Kazakstan   | K”kshetau   |
| Mexico      | M‚rida      |
| New Zealand | North Shore |
| Pakistan    | Peshawar    |
| Peru        | Puno        |
| Poland      | Poznan      |
| San Marino  | Serravalle  |
| Taiwan      | Taipei      |
| Taiwan      | Taliao      |
| Taiwan      | Touliu      |
| Turkey      | Tarsus      |
| Ukraine     | Uzgorod     |
+-------------+-------------+
14 rows in set (0.00 sec)

 -- no to teraz przez JOIN
 select k.name kraj, m.name miasto
     from country k JOIN city m -- złączenie przez JOIN
     ON
     code = countrycode -- warunek złączenia na to, żeby miasto leżało w danym kraju
     where -- pozostałe warunki
     left(k.name,1) = left(m.name,1) -- początkowe litery takie same
     and
     right(k.name,1) <> right(m.name,1) -- końcowe litery różne
     and
     length(k.name) = length(m.name) -- równe długości nawz
     order by 1, 2; -- sortowanie
+-------------+-------------+
| kraj        | miasto      |
+-------------+-------------+
| Belarus     | Borisov     |
| Iran        | Ilam        |
| Kazakstan   | K”kshetau   |
| Mexico      | M‚rida      |
| New Zealand | North Shore |
| Pakistan    | Peshawar    |
| Peru        | Puno        |
| Poland      | Poznan      |
| San Marino  | Serravalle  |
| Taiwan      | Taipei      |
| Taiwan      | Taliao      |
| Taiwan      | Touliu      |
| Turkey      | Tarsus      |
| Ukraine     | Uzgorod     |
+-------------+-------------+
14 rows in set (0.00 sec)

 -- teraz JOIN bez ON:
 select k.name kraj, m.name miasto
     from country k JOIN city m -- złączenie przez JOIN
     where
     code = countrycode -- warunek na to, żeby miasto leżało w danym kraju
     and -- pozostae warunki
     left(k.name,1) = left(m.name,1) -- początkowe litery takie same
     and
     right(k.name,1) <> right(m.name,1) -- końcowe litery różne
     and
     length(k.name) = length(m.name) -- równe długości nawz
     order by 1, 2; -- sortowanie
+-------------+-------------+
| kraj        | miasto      |
+-------------+-------------+
| Belarus     | Borisov     |
| Iran        | Ilam        |
| Kazakstan   | K”kshetau   |
| Mexico      | M‚rida      |
| New Zealand | North Shore |
| Pakistan    | Peshawar    |
| Peru        | Puno        |
| Poland      | Poznan      |
| San Marino  | Serravalle  |
| Taiwan      | Taipei      |
| Taiwan      | Taliao      |
| Taiwan      | Touliu      |
| Turkey      | Tarsus      |
| Ukraine     | Uzgorod     |
+-------------+-------------+
14 rows in set (0.00 sec)

 -- jak widać - działa, teraz JOIN bez WHERE:
 select k.name kraj, m.name miasto
     from country k JOIN city m -- złączenie przez JOIN
     on
     code = countrycode -- warunek na to, żeby miasto leżało w danym kraju
     and -- pozostae warunki
     left(k.name,1) = left(m.name,1) -- początkowe litery takie same
     and
     right(k.name,1) <> right(m.name,1) -- końcowe litery różne
     and
     length(k.name) = length(m.name) -- równe długości nawz
     order by 1, 2; -- sortowanie
+-------------+-------------+
| kraj        | miasto      |
+-------------+-------------+
| Belarus     | Borisov     |
| Iran        | Ilam        |
| Kazakstan   | K”kshetau   |
| Mexico      | M‚rida      |
| New Zealand | North Shore |
| Pakistan    | Peshawar    |
| Peru        | Puno        |
| Poland      | Poznan      |
| San Marino  | Serravalle  |
| Taiwan      | Taipei      |
| Taiwan      | Taliao      |
| Taiwan      | Touliu      |
| Turkey      | Tarsus      |
| Ukraine     | Uzgorod     |
+-------------+-------------+
14 rows in set (0.00 sec)

 -- znowu działa, tu wszystkie warunki byy wykonane poprzez ON
 -- a teraz "," z ON:
 select k.name kraj, m.name miasto
     from country k, city m -- złączenie przez ","
     on
     code = countrycode -- warunek na to, żeby miasto leżao w danym kraju
     where -- pozostałe warunki
     left(k.name,1) = left(m.name,1) -- początkowe litery takie same
     and
     right(k.name,1) <> right(m.name,1) -- końcowe litery różne
     and
     length(k.name) = length(m.name) -- równe długości nawz
     order by 1, 2; -- sortowanie
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'on' ...

 -- nie działa, "," nie współpracuje z ON (gdyby nie byo WHERE, również byby błąd)
 --
 --
 --
 -- JOIN-y (a tym samym i ",") produkują iloczyn kartezjański tylko dla wyników, które mają
 -- swoich "kolegów" w drugiej z tabel (np. wypisując kraje i ich stolice, wypisujemy tylko
 -- te kraje, które mają stolice, pomijamy kraje bez stolic - np. Antarktyda), jeli chcemy
 -- uwzględnić również i te bez "kolegów" (np. kraje bez stolic), musimy użyć innego rodzaju
 -- złączenia LEFT JOIN lub RIGHT JOIN (kierunek wskazuje, która tabela może nie mieć "kolegów")
 --
 -- ZADANIE: wypisz kraje na "p" lub "h" i ich stolice
 --
 select k.name kraj, m.name stolica
     from country k, city m
     where
     capital = id -- warunek złączenia country-city (kraj-stolica)
     and
     (k.name like "p%" or k.name like "h%")
     order by 1;
+-------------------------------+--------------------+
| kraj                          | stolica            |
+-------------------------------+--------------------+
| Haiti                         | Port-au-Prince     |
| Holy See (Vatican City State) | Citt? del Vaticano |
| Honduras                      | Tegucigalpa        |
| Hong Kong                     | Victoria           |
| Hungary                       | Budapest           |
| Pakistan                      | Islamabad          |
| Palau                         | Koror              |
| Palestine                     | Gaza               |
| Panama                        | Ciudad de Panam    |
| Papua New Guinea              | Port Moresby       |
| Paraguay                      | Asunción           |
| Peru                          | Lima               |
| Philippines                   | Manila             |
| Pitcairn                      | Adamstown          |
| Poland                        | Warszawa           |
| Portugal                      | Lisboa             |
| Puerto Rico                   | San Juan           |
+-------------------------------+--------------------+
17 rows in set (0.00 sec)

 -- a teraz przez JOIN:
 select k.name kraj, m.name stolica
     from country k JOIN city m
     ON
     capital = id
     where -- ponieważ dodatkowe warunki zaczynają się tu, to nawias jest niepotrzebny
     k.name like "p%" or k.name like "h%" -- ale mógłby być
     order by 1;
+-------------------------------+--------------------+
| kraj                          | stolica            |
+-------------------------------+--------------------+
| Haiti                         | Port-au-Prince     |
| Holy See (Vatican City State) | Citt? del Vaticano |
| Honduras                      | Tegucigalpa        |
| Hong Kong                     | Victoria           |
| Hungary                       | Budapest           |
| Pakistan                      | Islamabad          |
| Palau                         | Koror              |
| Palestine                     | Gaza               |
| Panama                        | Ciudad de Panam    |
| Papua New Guinea              | Port Moresby       |
| Paraguay                      | Asunción           |
| Peru                          | Lima               |
| Philippines                   | Manila             |
| Pitcairn                      | Adamstown          |
| Poland                        | Warszawa           |
| Portugal                      | Lisboa             |
| Puerto Rico                   | San Juan           |
+-------------------------------+--------------------+
17 rows in set (0.00 sec)

 -- a teraz LEFT JOIN-em - będą również kraje bez stolic
 --
 select k.name kraj, m.name stolica
     from country k LEFT JOIN city m
     ON
     capital = id
     where
     k.name like "p%" or k.name like "h%"
     order by 1;
+-----------------------------------+--------------------+
| kraj                              | stolica            |
+-----------------------------------+--------------------+
| Haiti                             | Port-au-Prince     |
| Heard Island and McDonald Islands | NULL               |
| Holy See (Vatican City State)     | Citt? del Vaticano |
| Honduras                          | Tegucigalpa        |
| Hong Kong                         | Victoria           |
| Hungary                           | Budapest           |
| Pakistan                          | Islamabad          |
| Palau                             | Koror              |
| Palestine                         | Gaza               |
| Panama                            | Ciudad de Panam    |
| Papua New Guinea                  | Port Moresby       |
| Paraguay                          | Asunción           |
| Peru                              | Lima               |
| Philippines                       | Manila             |
| Pitcairn                          | Adamstown          |
| Poland                            | Warszawa           |
| Portugal                          | Lisboa             |
| Puerto Rico                       | San Juan           |
+-----------------------------------+--------------------+
18 rows in set (0.00 sec)

 -- jest nowy kraj: Heard Island and McDonald Islands - bez stolicy
 --
 -- sprawdźmy jak działa LEFT JOIN bez warunku zadanego przez ON:
 --
 select k.name kraj, m.name stolica
     from country k LEFT JOIN city m
     WHERE
     capital = id
     and
     k.name like "p%" or k.name like "h%"
     order by 1;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'WHERE ...' at line 3
  --
 -- jak widać - nie działa, LEFT/RIGHT JOIN musi mieć warunek złączenia poprzez ON
 --


 -- a teraz dokładamy do tego języki, najpierw tylko ze stolicą i językami oficjalnymi:
 --
 select k.name kraj, m.name stolica, language jczyk
     from country k, city m, countrylanguage j
     where capital = id -- warunek złączenia country-city (kraj-stolica)
     and code = j.countrycode -- warunek złączenia country-countrylanguage (kraj-język)
     and (k.name like "p%" or k.name like "h%") and isofficial = "t"
     order by 1, 3;
+-------------------------------+--------------------+------------+
| kraj                          | stolica            | język      |
+-------------------------------+--------------------+------------+
| Haiti                         | Port-au-Prince     | French     |
| Holy See (Vatican City State) | Citt? del Vaticano | Italian    |
| Honduras                      | Tegucigalpa        | Spanish    |
| Hong Kong                     | Victoria           | English    |
| Hungary                       | Budapest           | Hungarian  |
| Pakistan                      | Islamabad          | Urdu       |
| Palau                         | Koror              | English    |
| Palau                         | Koror              | Palau      |
| Panama                        | Ciudad de Panam    | Spanish    |
| Paraguay                      | Asunción           | Guaranˇ    |
| Paraguay                      | Asunción           | Spanish    |
| Peru                          | Lima               | Aimar      |
| Peru                          | Lima               | Ketçua     |
| Peru                          | Lima               | Spanish    |
| Philippines                   | Manila             | Pilipino   |
| Poland                        | Warszawa           | Polish     |
| Portugal                      | Lisboa             | Portuguese |
| Puerto Rico                   | San Juan           | Spanish    |
+-------------------------------+--------------------+------------+
18 rows in set (0.00 sec)

 -- tylko 17, bo pewne kraje nie mają języków oficjalnych (pewne mają kilka, wszyo 17 przypadkiem)
 -- teraz łączymy LEFT JOIN-em, będą również te bez stolic/języków
 -- najpierw tak jak podpowiadaaby intuicja (czyli w tym przypadku nie najlepiej):
 --
 select k.name kraj, m.name stolica, language jezyk
     from country k left join city m left join countrylanguage j
     on capital = id
     on code = j.countrycode
     where
     (k.name like "p%" or k.name like "h%")
     and
     isofficial = "t"
     order by 1, 3;
ERROR 1054 (42S22): Unknown column 'capital' in 'on clause'
 -- błąd nietypowy, ogólnie łączy się "etapami" po każdym podając warunek złączenia:
 --
 select k.name kraj, m.name stolica, language jezyk
     from country k left join city m
     on capital = id
     left join countrylanguage j
     on code = j.countrycode
     where
     (k.name like "p%" or k.name like "h%")
     and
     isofficial = "t"
     order by 1, 3;
+-------------------------------+--------------------+------------+
| kraj                          | stolica            | jezyk      |
+-------------------------------+--------------------+------------+
| Haiti                         | Port-au-Prince     | French     |
| Holy See (Vatican City State) | Citt? del Vaticano | Italian    |
| Honduras                      | Tegucigalpa        | Spanish    |
| Hong Kong                     | Victoria           | English    |
| Hungary                       | Budapest           | Hungarian  |
| Pakistan                      | Islamabad          | Urdu       |
| Palau                         | Koror              | English    |
| Palau                         | Koror              | Palau      |
| Panama                        | Ciudad de Panam    | Spanish    |
| Paraguay                      | Asunción           | Guaranˇ    |
| Paraguay                      | Asunción           | Spanish    |
| Peru                          | Lima               | Aimar      |
| Peru                          | Lima               | Ketçua     |
| Peru                          | Lima               | Spanish    |
| Philippines                   | Manila             | Pilipino   |
| Poland                        | Warszawa           | Polish     |
| Portugal                      | Lisboa             | Portuguese |
| Puerto Rico                   | San Juan           | Spanish    |
+-------------------------------+--------------------+------------+
18 rows in set (0.00 sec)

 -- wygląda OK, ale gdzie są NULL-e? nie ma, bo warunek na język
 -- powoduje, że nie "wyłapuje NULL-i", zmieniamy
 -- dokładając warunek do złączenia ON:

 select k.name kraj, m.name stolica, language jezyk
     from country k left join city m
     on
     capital = id
     left join countrylanguage j
     on
     code = j.countrycode
	 and
     isofficial = "t"
     where
     k.name like "p%" or k.name like "h%"
     order by 1, 3;
+-----------------------------------+--------------------+------------+
| kraj                              | stolica            | jezyk      |
+-----------------------------------+--------------------+------------+
| Haiti                             | Port-au-Prince     | French     |
| Heard Island and McDonald Islands | NULL               | NULL       |
| Holy See (Vatican City State)     | Citt? del Vaticano | Italian    |
| Honduras                          | Tegucigalpa        | Spanish    |
| Hong Kong                         | Victoria           | English    |
| Hungary                           | Budapest           | Hungarian  |
| Pakistan                          | Islamabad          | Urdu       |
| Palau                             | Koror              | English    |
| Palau                             | Koror              | Palau      |
| Palestine                         | Gaza               | NULL       |
| Panama                            | Ciudad de Panam    | Spanish    |
| Papua New Guinea                  | Port Moresby       | NULL       |
| Paraguay                          | Asunción           | Guaranˇ    |
| Paraguay                          | Asunción           | Spanish    |
| Peru                              | Lima               | Aimar      |
| Peru                              | Lima               | Ketçua     |
| Peru                              | Lima               | Spanish    |
| Philippines                       | Manila             | Pilipino   |
| Pitcairn                          | Adamstown          | NULL       |
| Poland                            | Warszawa           | Polish     |
| Portugal                          | Lisboa             | Portuguese |
| Puerto Rico                       | San Juan           | Spanish    |
+-----------------------------------+--------------------+------------+
22 rows in set (0.00 sec)

-- są nowe  kraje bez stolic lub  bez języków (lub to i to)

 -- ZADANIE: wypisz nazwy miast polski i województwa, w którym ono leży
 -- przy założeniu, że nie znamy kodu Polski

 select m.name miasto, district wojewodztwo
     from city m, country k
     where
     countrycode = code-- zakładamy, że nie znamy kodu Polski
     and
     k.name = "Poland"
     order by 2, 1;
+---------------------+---------------------+
| miasto              | wojewodztwo         |
+---------------------+---------------------+
| Jelenia Góra        | Dolnoslaskie        |
| Legnica             | Dolnoslaskie        |
| Walbrzych           | Dolnoslaskie        |
| Wroclaw             | Dolnoslaskie        |
| Bydgoszcz           | Kujawsko-Pomorskie  |
| Grudziadz           | Kujawsko-Pomorskie  |
| Torun               | Kujawsko-Pomorskie  |
| Wloclawek           | Kujawsko-Pomorskie  |
| Lódz                | Lodzkie             |
| Lublin              | Lubelskie           |
| Gorzów Wielkopolski | Lubuskie            |
| Zielona Góra        | Lubuskie            |
| Kraków              | Malopolskie         |
| Tarnów              | Malopolskie         |
| Plock               | Mazowieckie         |
| Radom               | Mazowieckie         |
| Warszawa            | Mazowieckie         |
| Opole               | Opolskie            |
| Rzeszów             | Podkarpackie        |
| Bialystok           | Podlaskie           |
| Gdansk              | Pomorskie           |
| Gdynia              | Pomorskie           |
| Slupsk              | Pomorskie           |
| Bielsko-Biala       | Slaskie             |
| Bytom               | Slaskie             |
| Chorzów             | Slaskie             |
| Czestochowa         | Slaskie             |
| Dabrowa Górnicza    | Slaskie             |
| Gliwice             | Slaskie             |
| Jastrzebie-Zdrój    | Slaskie             |
| Jaworzno            | Slaskie             |
| Katowice            | Slaskie             |
| Ruda Slaska         | Slaskie             |
| Rybnik              | Slaskie             |
| Sosnowiec           | Slaskie             |
| Tychy               | Slaskie             |
| Zabrze              | Slaskie             |
| Kielce              | Swietokrzyskie      |
| Elblag              | Warminsko-Mazurskie |
| Olsztyn             | Warminsko-Mazurskie |
| Kalisz              | Wielkopolskie       |
| Poznan              | Wielkopolskie       |
| Koszalin            | Zachodnio-Pomorskie |
| Szczecin            | Zachodnio-Pomorskie |
+---------------------+---------------------+
44 rows in set (0.01 sec)

 -- ZADANIE: wypisz nazwy województw i ilość miast tych województw
 -- przy założeniu, że nie znamy kodu Polski, ale znamy jej nazwę regionalną

 select district województwo, count(*) ile
     from city, country
     where code = countrycode
     and localname = "Polska"
     group by 1
     order by 2, 1;
+---------------------+-----+
| województwo         | ile |
+---------------------+-----+
| Lodzkie             |   1 |
| Lubelskie           |   1 |
| Opolskie            |   1 |
| Podkarpackie        |   1 |
| Podlaskie           |   1 |
| Swietokrzyskie      |   1 |
| Lubuskie            |   2 |
| Malopolskie         |   2 |
| Warminsko-Mazurskie |   2 |
| Wielkopolskie       |   2 |
| Zachodnio-Pomorskie |   2 |
| Mazowieckie         |   3 |
| Pomorskie           |   3 |
| Dolnoslaskie        |   4 |
| Kujawsko-Pomorskie  |   4 |
| Slaskie             |  14 |
+---------------------+-----+
16 rows in set (0.00 sec)

 -- połączenie wiadomoci z poprzednich zajęć - grupowanie i HAVING i tych - złączenia:
 --
 -- ZADANIE: wypisz nazwy krajów (na P lub H), populacje państw i sumę populacji
 -- miast tych państw oraz odsetek mieszczuchów dla odsetków większych od 0,3

 select k.name kraj, k.population ilu_kraj, sum(m.population) ilu_miasta,
     sum(m.population)/k.population odsetek
     from city m, country k
     where code = countrycode
     and (k.name like "P%" or k.name like "h%")
     group by 1
     having odsetek > 0.3
     order by 4;
+-------------------------------+----------+------------+---------+
| kraj                          | ilu_kraj | ilu_miasta | odsetek |
+-------------------------------+----------+------------+---------+
| Poland                        | 38653600 |   11687431 |  0.3024 |
| Puerto Rico                   |  3869000 |    1564174 |  0.4043 |
| Philippines                   | 75967000 |   30934791 |  0.4072 |
| Holy See (Vatican City State) |     1000 |        455 |  0.4550 |
| Peru                          | 25662000 |   12147242 |  0.4734 |
| Hong Kong                     |  6782000 |    3300633 |  0.4867 |
| Palau                         |    19000 |      12000 |  0.6316 |
| Pitcairn                      |       50 |         42 |  0.8400 |
+-------------------------------+----------+------------+---------+
8 rows in set (0.00 sec)

 -- na koniec ciekawostka, jak można by byo wyświetlić powyższe odrobinę ładniej:
 --
 select k.name kraj, k.population ilu_kraj, sum(m.population) ilu_miasta,
     concat(LPAD(TRUNCATE(100*sum(m.population)/k.population,1),6," "),"%") odsetek
     from city m, country k -- ŁADNIEJSZA WERSJA POWYŻSZEGO
     where code = countrycode -- funkcja TRUNCATE(n,m) wyświetla liczbę n,
     and k.name like "P%" -- gdzie m jest ilością cyfr po przecinku
     group by 1 -- LPAD(kloumna,n,znak) uzupełnia z lewej strony
     having odsetek > 0.3 -- dane z kolumny do długości n znakami znak
     order by 4; -- sortowanie po string-u, spacje dają, że jest ok
+------------------+-----------+------------+---------+
| kraj             | ilu_kraj  | ilu_miasta | odsetek |
+------------------+-----------+------------+---------+
| Papua New Guinea |   4807000 |     247000 |    5.1% |
| Portugal         |   9997600 |    1145011 |   11.4% |
| Paraguay         |   5496000 |    1020020 |   18.5% |
| Pakistan         | 156483000 |   31546745 |   20.1% |
| Panama           |   2856000 |     786755 |   27.5% |
| Palestine        |   3101000 |     902360 |   29.0% |
| Poland           |  38653600 |   11687431 |   30.2% |
| Puerto Rico      |   3869000 |    1564174 |   40.4% |
| Philippines      |  75967000 |   30934791 |   40.7% |
| Peru             |  25662000 |   12147242 |   47.3% |
| Palau            |     19000 |      12000 |   63.1% |
| Pitcairn         |        50 |         42 |   84.0% |
+------------------+-----------+------------+---------+
12 rows in set (0.00 sec)

