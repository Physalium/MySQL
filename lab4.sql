 use swiat;
show databases;
 --
 -- na pocz�tek rozgrzewka i przypomnienie, �e MySQL nie spe��nia
 -- wszystkich standard�w SQL, jednym z nich jest ograniczenie na
 -- kolumny na etapie tworzenia tabeli, np. mogliby�my ��da�, aby
 -- wiek nie by� ujemny, w standardzie SQL odpowiada za to CHECK
 --
 -- zr�bmy testow� tabel�:
 --
 create table test(
    wiek int not null,
     CONSTRAINT zabezpieczenie -- zabezpieczenie to nazwa warunku
     CHECK(wiek > 0))
     engine=innodb; -- engine, �eby pokaza�, �e nawet przy tym silniku jest :-(
Query OK, 0 rows affected (0.43 sec)

 -- zr�bmy wpisy, w tym niepoprawne
 --
 insert test values (34), (9), (-12), (4);
Query OK, 4 rows affected (0.39 sec)
Records: 4  Duplicates: 0  Warnings: 0

 -- 0 error, 0 warning, zobaczmy co jest w tabeli
 --
 select * from test;
+------+
| wiek |
+------+
|   34 |
|    9 |
|  -12 |
|    4 |
+------+
4 rows in set (0.00 sec)

 -- jak wida�, wpis z ujemnym wiekiem jest w tabeli
 -- na szcz�cie da si� to zrobi� w inny spos�b,
 -- b�dziemy si� tym zajmowa� w przysz��o��ci
 --
 -- ZADANIE (szczeg�lnie dla os�b z zainstalowan� najnowsz� wersj� MySQL)
 -- sprawdzi�, czy CHECK jest ju� zaimplementowany (poprawnie) i je��li tak,
 -- to podzieli� si� t� radosn� nowin� z innymi
 --
 -- �eby nie psu� ��wiata, usu�my tabel� test
 --
 drop table test;
Query OK, 0 rows affected (0.12 sec)

 -- sprawdzimy teraz, jak radzi� sobie z warto��ciami NULL
 --
 select name, gnpold from country  -- trzy pa�stwa maj� null w kolumnie gnpold
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
12 rows in set (0.00 sec)

 -- wybranie tych pa�stw nie mo�e si� odby� na spos�b:

 select name, gnpold from country
     where name like "P%"
    and
    (-- gnpold = null -- nie zadzia�a
     -- or
      gnpold = "null" -- nie zadzia�a, wygeneruje niegro�ny warning
     -- or
      -- gnpold = "" -- nie zadzia�a
     -- or
     -- gnpold = 0
        ); -- nie zadzia�a


 -- null to specyficzny typ danej, wybieramy go za pomoc� IS NULL
 select name, gnpold from country
     where name like "P%"
     and GNPOld is null;
+-----------+--------+
| name      | gnpold |
+-----------+--------+
| Palau     |   NULL |
| Pitcairn  |   NULL |
| Palestine |   NULL |
+-----------+--------+
3 rows in set (0.00 sec)

 -- oczywi��cie jest r�wnie� tego negacja
 select name, gnpold from country
     where name like "P%"
     and gnpold is not null;

+------------------+-----------+
| name             | gnpold    |
+------------------+-----------+
| Philippines      |  82239.00 |
| Pakistan         |  58549.00 |
| Panama           |   8700.00 |
| Papua New Guinea |   6328.00 |
| Paraguay         |   9555.00 |
| Peru             |  65186.00 |
| Portugal         | 102133.00 |
| Puerto Rico      |  32100.00 |
| Poland           | 135636.00 |
+------------------+-----------+
9 rows in set (0.00 sec)

 -- ale negacj� mo�na wybra� r�wnie� i tak,
 -- co dodatkowo pokazuje specyfik� waro��ci NULL
 --
 select name, gnpold from country
     where name like "P%"
     and gnpold like "%";
+------------------+-----------+
| name             | gnpold    |
+------------------+-----------+
| Philippines      |  82239.00 |
| Pakistan         |  58549.00 |
| Panama           |   8700.00 |
| Papua New Guinea |   6328.00 |
| Paraguay         |   9555.00 |
| Peru             |  65186.00 |
| Portugal         | 102133.00 |
| Puerto Rico      |  32100.00 |
| Poland           | 135636.00 |
+------------------+-----------+
9 rows in set (0.00 sec)

 -- dali��my warunek �eby w kolumnie gnpold by��o cokolwiek
 -- (dowolny ci�g znak�w), ale NULL nie jest cokolwiekiem,
 -- jednak nie jest te� nie-cokolwiekiem:
 select name, gnpold from country
     where name like "P%"
     and gnpold like "%";
+------------------+-----------+
| name             | gnpold    |
+------------------+-----------+
| Philippines      |  82239.00 |
| Pakistan         |  58549.00 |
| Panama           |   8700.00 |
| Papua New Guinea |   6328.00 |
| Paraguay         |   9555.00 |
| Peru             |  65186.00 |
| Portugal         | 102133.00 |
| Puerto Rico      |  32100.00 |
| Poland           | 135636.00 |
+------------------+-----------+
9 rows in set (0.00 sec)

 select name, gnpold from country
     where name like "P%"
     and gnpold not like "%";
Empty set (0.00 sec)

 -- operacje na warto��ciach NULL
 --
 -- wi�kszo��� dzia��a�/funkcji wywo��ywanych na (chocia�by jednym)
 -- argumencie NULL b�dzie zwraca� wynik NULL
 -- r�wnie� dzia��ania/funckje wywo��ywane na argumentach
 -- spoza dziedziny b�d� zwraca� warto�ci NULL
 --
 select null+3, 4-null, null*pi(), 3/NULL, sqrt(null), 3/0, sqrt(-2), log(-1);
+--------+--------+-----------+--------+------------+------+----------+---------+
| null+3 | 4-null | null*pi() | 3/NULL | sqrt(null) | 3/0  | sqrt(-2) | log(-1) |
+--------+--------+-----------+--------+------------+------+----------+---------+
|   NULL |   NULL |      NULL |   NULL |       NULL | NULL |     NULL |    NULL |
+--------+--------+-----------+--------+------------+------+----------+---------+
1 row in set (0.00 sec)

 -- w pewnych sytuacjach istnieje potrzeba "ukrycia" null-a (bez jego
 -- zmiany warto��ci w bazie, co�� w stylu aliasu kolumny)
 -- w�wczas mo�emy u�y� funkcji IFNULL(x, y), gdzie x jest kolumn�,
 -- na kt�rej dzia��a IFNULL, a y - tym, co b�dzie wida�
 --
 select name, gnp, ifnull(gnpold,"tu był null") "działanie ifnull-a",
     gnp*gnpold from country
     where name like"P%";
+------------------+-----------+--------------------+----------------+
| name             | gnp       | dzia�anie ifnull-a | gnp*gnpold     |
+------------------+-----------+--------------------+----------------+
| Philippines      |  65107.00 | 82239.00           |  5354334573.00 |
| Pakistan         |  61289.00 | 58549.00           |  3588409661.00 |
| Palau            |    105.00 | tu by� null        |           NULL |
| Panama           |   9131.00 | 8700.00            |    79439700.00 |
| Papua New Guinea |   4988.00 | 6328.00            |    31564064.00 |
| Paraguay         |   8444.00 | 9555.00            |    80682420.00 |
| Peru             |  64140.00 | 65186.00           |  4181030040.00 |
| Pitcairn         |      0.00 | tu by� null        |           NULL |
| Portugal         | 105954.00 | 102133.00          | 10821399882.00 |
| Puerto Rico      |  34100.00 | 32100.00           |  1094610000.00 |
| Poland           | 151697.00 | 135636.00          | 20575574292.00 |
| Palestine        |   4173.00 | tu by� null        |           NULL |
+------------------+-----------+--------------------+----------------+
12 rows in set (0.00 sec)

 -- ZADANIE: przerobi� powy�sze zapytanie, tak aby NULL by�� widziany
 -- przez u�ytkownika jako 0
 --
 select name, gnp, ifnull(gnpold,0) "gnpold",
     ifnull(gnp+gnpold,GNP) "gnp+gnpold" from country
     where name like "P%";
+------------------+-----------+-----------+----------------+
| name             | gnp       | gnpold    | gnp*gnpold     |
+------------------+-----------+-----------+----------------+
| Philippines      |  65107.00 |  82239.00 |  5354334573.00 |
| Pakistan         |  61289.00 |  58549.00 |  3588409661.00 |
| Palau            |    105.00 |      0.00 |           0.00 |
| Panama           |   9131.00 |   8700.00 |    79439700.00 |
| Papua New Guinea |   4988.00 |   6328.00 |    31564064.00 |
| Paraguay         |   8444.00 |   9555.00 |    80682420.00 |
| Peru             |  64140.00 |  65186.00 |  4181030040.00 |
| Pitcairn         |      0.00 |      0.00 |           0.00 |
| Portugal         | 105954.00 | 102133.00 | 10821399882.00 |
| Puerto Rico      |  34100.00 |  32100.00 |  1094610000.00 |
| Poland           | 151697.00 | 135636.00 | 20575574292.00 |
| Palestine        |   4173.00 |      0.00 |           0.00 |
+------------------+-----------+-----------+----------------+
12 rows in set (0.00 sec)

 -- ZADANIE (na poz�r proste): przerobi� powy�sze zapytanie
 -- zamieniaj�c * na +
 --
 select name, gnp, ifnull(gnpold,0) "gnpold",
     ifnull(gnp+gnpold,gnp) "gnp+gnpold" from country
     where name like "P%";
+------------------+-----------+-----------+------------+
| name             | gnp       | gnpold    | gnp+gnpold |
+------------------+-----------+-----------+------------+
| Philippines      |  65107.00 |  82239.00 |  147346.00 |
| Pakistan         |  61289.00 |  58549.00 |  119838.00 |
| Palau            |    105.00 |      0.00 |     105.00 |
| Panama           |   9131.00 |   8700.00 |   17831.00 |
| Papua New Guinea |   4988.00 |   6328.00 |   11316.00 |
| Paraguay         |   8444.00 |   9555.00 |   17999.00 |
| Peru             |  64140.00 |  65186.00 |  129326.00 |
| Pitcairn         |      0.00 |      0.00 |       0.00 |
| Portugal         | 105954.00 | 102133.00 |  208087.00 |
| Puerto Rico      |  34100.00 |  32100.00 |   66200.00 |
| Poland           | 151697.00 | 135636.00 |  287333.00 |
| Palestine        |   4173.00 |      0.00 |    4173.00 |
+------------------+-----------+-----------+------------+
12 rows in set (0.00 sec)

 -- rozwi�zanie to dzia��a, bo wiemy, �e w kolumnie gnp (dla pa�stw na "P")
 -- nie ma waro��ci NULL, jak mo�na przygotowa� si� na tak� okoliczno��� (�e jest)?
 --
 -- ZMIENNE TYPU DATA-CZAS
 --
 -- dotychczas nie u�ywali�my tego rodzaju zmiennych (ani w ��wiecie, ani
 -- w znajomych nie ma kolumn tego typu), stworzymy tabel� testow�:
 --
 create table test
     (imie varchar(12) not null,
     kiedy date, -- kolumna z dat�
     zamawia datetime, -- kolumna z dat� i czasem
     czas time, -- kolumna z czasem
     zwrot timestamp); -- kolumna z dat� i czasem, kt�ra mo�e si� autouzupe�nia�
Query OK, 0 rows affected (0.16 sec)

 desc test;
+---------+-------------+------+-----+-------------------+-----------------------------+
| Field   | Type        | Null | Key | Default           | Extra                       |
+---------+-------------+------+-----+-------------------+-----------------------------+
| imie    | varchar(12) | NO   |     | NULL              |                             |
| kiedy   | date        | YES  |     | NULL              |                             |
| zamawia | datetime    | YES  |     | NULL              |                             |
| czas    | time        | YES  |     | NULL              |                             |
| zwrot   | timestamp   | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
+---------+-------------+------+-----+-------------------+-----------------------------+
5 rows in set (0.03 sec)

 insert test values
     ("Jan","1975:07:23","2007.05.30 21-12-56","12:43:55","1999:04:20 11-12-13"); -- poprawny wpis
Query OK, 1 row affected (0.42 sec)

 select * from test;
+------+------------+---------------------+----------+---------------------+
| imie | kiedy      | zamawia             | czas     | zwrot               |
+------+------------+---------------------+----------+---------------------+
| Jan  | 1975-07-23 | 2007-05-30 21:12:56 | 12:43:55 | 1999-04-20 11:12:13 |
+------+------------+---------------------+----------+---------------------+
1 row in set (0.00 sec)

 -- jak wida�, sk��adnia daty i czasu ustawia si� domy��lna, niezale�nie od tego,
 -- jakie podamy separatory pomi�dzy rok-miesi�c... minuta-sekunda
 -- separatory te nie mog� by� dowolne (przynajmniej jeszcze nie)
 -- ZADANIE: poeksperymentowa� z r�nymi separatorami
 --
 insert test (imie, kiedy, zamawia, czas) values -- podamy bez zwrotu, sam si� doda
     ("Ewa","1945-07-23","2007.05.30 21-12-56","12:43:55"),  -- data  bez "" jaki da efekt ?
      ("Ola",now(),now(),now()), -- aktualna data/czas (worning jest z zamawia, ale wpis jest ok)
     ("Iza","2012-12.12","2000,12-12 12-1:2","0:3:07");    -- inne formy separator�w
Query OK, 3 rows affected, 2 warnings (0.43 sec)
Records: 3  Duplicates: 0  Warnings: 2

 select * from test;
delete from test ;

+------+------------+---------------------+----------+---------------------+
| imie | kiedy      | zamawia             | czas     | zwrot               |
+------+------------+---------------------+----------+---------------------+
| Jan  | 1975-07-23 | 2007-05-30 21:12:56 | 12:43:55 | 1999-04-20 11:12:13 |
| Ewa  | 0000-00-00 | 2007-05-30 21:12:56 | 12:43:55 | 2020-03-23 12:06:09 |
| Ola  | 2020-03-23 | 2020-03-23 12:06:09 | 12:06:09 | 2020-03-23 12:06:09 |
| Iza  | 2012-12-12 | 2000-12-12 12:01:02 | 00:03:07 | 2020-03-23 12:06:09 |
+------+------------+---------------------+----------+---------------------+
4 rows in set (0.00 sec)

 -- format daty i czasu mo�na zmienia� (podobnie jak separatory)
 --
 select CURRENT_DATE() "1", CURRENT_TIME() "2", -- domy�lne
     DATE_FORMAT(current_date(), "%w<-%M~~-~~%Y..:.:.:..%d") "3", -- wymy��lne
     TIME_FORMAT(current_time(), "%H |_| %i \\?/ %s <-- %p") "4"; -- wymy�l�ne format, separator czasu
+------------+----------+--------------------------------+---------------------------+
| 1          | 2        | 3                              | 4                         |
+------------+----------+--------------------------------+---------------------------+
| 2020-03-23 | 12:12:02 | 1<-March~~-~~2020..:.:.:..23 | 12 |_| 12 \?/ 02 <-- PM |
+------------+----------+--------------------------------+---------------------------+
1 row in set (0.00 sec)

 -- mo�liwe "synonimy" dni, miesi�cy, sekund itp. i ich wygl�d mo�na znale�� na stronie
 -- https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html
 -- oto pocz�tkowych 5 przyk��ad�w z tabeli z tej strony
 -- %aAbbreviated weekday name (Sun..Sat)
 -- %bAbbreviated month name (Jan..Dec)
 -- %cMonth, numeric (0..12)
 -- %DDay of the month with English suffix (0th, 1st, 2nd, 3rd, ...)
 -- %dDay of the month, numeric (00..31)
 --
 -- z dat�/czasem zwi�zane s� odpowiednie funkcje, kt�re z kolumn typu data/czas
 -- potrafi� "wybra�" odpowiedni� sk��adow�, oto kilka z nich:
 --
 select year(now()), month(now()), day(now()), hour(now()), second(now());
+-------------+--------------+------------+-------------+---------------+
| year(now()) | month(now()) | day(now()) | hour(now()) | second(now()) |
+-------------+--------------+------------+-------------+---------------+
|        2020 |            3 |         23 |          12 |            37 |
+-------------+--------------+------------+-------------+---------------+
1 row in set (0.00 sec)

 -- ZADANIE: za���my, �e w tabeli test kolumna kiedy jest dat� urodzenia danej osoby
 -- wypisz imi� i wiek wszystkich os�b z tej tabeli
 --
 select imie, year(now()) - year(kiedy) wiek
     from test;
+------+------+
| imie | wiek |
+------+------+
| Jan  |   45 |
| Ewa  | 2020 |
| Ola  |    0 |
| Iza  |    8 |
+------+------+
4 rows in set (0.00 sec)

 -- pomi�my osoby, kt�re na pewno maj� b���dny wiek (z powodu podania b���dnej daty,
 -- kt�ra uzupe��nia si� zerami) i posortujmy po kolumnie typu data lub data-czas,
 -- np. po ostatniej kolumnie (porz�dek sortowania odwrotny)
 --
 select imie, year(now()) - year(kiedy) wiek
     from test
     where year(kiedy) > 0
     order by czas desc;
+------+------+
| imie | wiek |
+------+------+
| Jan  |   45 |
| Ola  |    0 |
| Iza  |    8 |
+------+------+
3 rows in set (0.00 sec)

 --
 --
 -- FUNKCJE CI�G�W ZNAK�W
 --
 --
 -- czasem istnieje potrzeba wypisywania danych z r�nych kolumn w jednej
 -- mo�na to zrealizowa� przy pomocy polecenia CONCAT, ma ono dowoln�
 -- liczb� argument�w, kt�re ���czy w jeden ci�g znak�w
 --
 -- ZADANIE: wypisz kraje i rz�dz�cych nimi (jako "kraj-g�owa") i ��redni�
 -- d��ugo�� �ycia w tych krajach (jako "�ycie") dla pa�stw na "P"
 -- wyniki posortuj malej�co po d��ugo��ci �ycia
 --
 select CONCAT(name, headofstate) "kraj-g��owa", lifeexpectancy �ycie
     from country
     where
     name like "p%"
     order by 2 desc;
+--------------------------------------+-------+
| kraj-g��owa                           | �ycie |
+--------------------------------------+-------+
| PortugalJorge Samp?io                |  75.8 |
| Puerto RicoGeorge W. Bush            |  75.6 |
| PanamaMireya Elisa Moscoso Rodr�guez |  75.5 |
| ParaguayLuis �ngel Gonz�lez Macchi   |  73.7 |
| PolandAleksander Kwasniewski         |  73.2 |
| PalestineYasser (Yasir) Arafat       |  71.4 |
| PeruValentin Paniagua Corazao        |  70.0 |
| PalauKuniwo Nakamura                 |  68.6 |
| PhilippinesGloria Macapagal-Arroyo   |  67.5 |
| Papua New GuineaElisabeth II         |  63.1 |
| PakistanMohammad Rafiq Tarar         |  61.1 |
| PitcairnElisabeth II                 |  NULL |
+--------------------------------------+-------+
12 rows in set (0.00 sec)

 -- mo�emy zauwa�y�, �e warto��� NULL jest "najmniejsza" oraz, �e kraj
 -- i g��owa s� sklejone; poprawmy to i posortujmy po rz�dz�cym
 --
 select CONCAT(name, " - ",headofstate) "kraj-g�owa", lifeexpectancy �ycie
     from country
     where
     name like "p%"
     order by headofstate;
+-------------------------------------------+-------+
| kraj-g��owa                                | �ycie |
+-------------------------------------------+-------+
| Poland - Aleksander Kwasniewski         |  73.2 |
| Pitcairn - Elisabeth II                 |  NULL |
| Papua New Guinea - Elisabeth II         |  63.1 |
| Puerto Rico - George W. Bush            |  75.6 |
| Philippines - Gloria Macapagal-Arroyo   |  67.5 |
| Portugal - Jorge Samp?io                |  75.8 |
| Palau - Kuniwo Nakamura                 |  68.6 |
| Paraguay - Luis �ngel Gonz�lez Macchi   |  73.7 |
| Panama - Mireya Elisa Moscoso Rodr�guez |  75.5 |
| Pakistan - Mohammad Rafiq Tarar         |  61.1 |
| Peru - Valentin Paniagua Corazao        |  70.0 |
| Palestine - Yasser (Yasir) Arafat       |  71.4 |
+-------------------------------------------+-------+
12 rows in set (0.00 sec)

 -- ZADANIE: przerobi� powy�sze tak, aby odpowiedzi� by��o zdanie:
 --  W kraju "nazwa kraju" panuje "rz�dz�cy".
 --
 select concat("W panstwie ",name," rzadzi ",headofstate,".") "kraj-g��owa"
     from country
     where
     name like "p%"
     order by headofstate;
+-------------------------------------------------------+
| kraj-g��owa                                            |
+-------------------------------------------------------+
| W kraju Poland panuje Aleksander Kwasniewski.         |
| W kraju Pitcairn panuje Elisabeth II.                 |
| W kraju Papua New Guinea panuje Elisabeth II.         |
| W kraju Puerto Rico panuje George W. Bush.            |
| W kraju Philippines panuje Gloria Macapagal-Arroyo.   |
| W kraju Portugal panuje Jorge Samp?io.                |
| W kraju Palau panuje Kuniwo Nakamura.                 |
| W kraju Paraguay panuje Luis �ngel Gonz�lez Macchi.   |
| W kraju Panama panuje Mireya Elisa Moscoso Rodr�guez. |
| W kraju Pakistan panuje Mohammad Rafiq Tarar.         |
| W kraju Peru panuje Valentin Paniagua Corazao.        |
| W kraju Palestine panuje Yasser (Yasir) Arafat.       |
+-------------------------------------------------------+
12 rows in set (0.00 sec)

 -- ZADANIE: sprawdzi� co si� stanie, gdy s��owo "kraju" zast�pimy s��owem
 -- "pa�stwie", a s��owo "panuje" s��owem "rz�dzi" (z polskimi znakami)
 --
 --
 -- kolejne funkcje dzia�aj�ce na ci�gach znak�w
 --
 select LEFT("Ala ma kota.",5); -- dzia��anie left
+------------------------+
| LEFT("Ala ma kota.",5) |
+------------------------+
| Ala m                  |
+------------------------+
1 row in set (0.00 sec)

 select RIGHT("Ala ma kota.",3); -- dzia��anie right
+-------------------------+
| RIGHT("Ala ma kota.",3) |
+-------------------------+
| ta.                     |
+-------------------------+
1 row in set (0.00 sec)

 select upper("abC DefG HiJkLm O"); "litery WIELKIE" -- dzia��anie UPPER
+-------------------+
| litery WIELKIE    |
+-------------------+
| ABC DEFG HIJKLM O |
+-------------------+
1 row in set (0.00 sec)

 select lower("abC DefG HiJkLm O"); "litery ma��e" -- dzia��anie LOWER
+-------------------+
| litery ma��e       |
+-------------------+
| abc defg hijklm o |
+-------------------+
1 row in set (0.00 sec)

 -- przed kolejnym zadaniem dodajmy jeszcze kilka wpis�w do tabeli test:
 insert test (imie, kiedy, zamawia, czas) value
     (" alA", now(), now(), now()),
     ("eWa ", now(), now(), now()),
     (" leNa ", now(), now(), now());
Query OK, 3 rows affected, 3 warnings (0.42 sec)
Records: 3  Duplicates: 0  Warnings: 3

 select length("Ala ma kota.");   -- dzia��anie LENGTH, wliczane s� te� bia��e znaki
+------------------------+
| length("Ala ma kota.") |
+------------------------+
|                     12 |
+------------------------+
1 row in set (0.00 sec)

 --
 -- ZADANIE: wypisz imiona z tabeli test ale tak, aby pierwsza
 -- litera by�a wielka, a pozosta��e ma��e, bo teraz jest tak:
 --
 select concat(upper(left(imie,1)),lower(right(imie,length(imie)-1))) imie from test;
+--------+
| imie   |
+--------+
| Jan    |
| Ewa    |
| Ola    |
| Iza    |
|  alA   |
| eWa    |
|  leNa  |
+--------+
7 rows in set (0.00 sec)

 select concat(upper(left(imie,1)),lower(right(imie,length(imie)-1))) imie from test;
+--------+
| imie   |
+--------+
| Jan    |
| Ewa    |
| Ola    |
| Iza    |
|  ala   |
| Ewa    |
|  lena  |
+--------+
7 rows in set (0.00 sec)

 -- Ewie pomog��o, ale Ali i Lenie nie ... winne s� przypadkowe bia��e znaki na pocz�tku
 --
 -- oto lekarstwo:
 --
 select ltrim("  Ala   ma  kota.   ") napis; -- usuwa bi�e znaki z lewej
+--------------------+
| napis              |
+--------------------+
| Ala   ma  kota.    |
+--------------------+
1 row in set (0.00 sec)

 -- poprawiamy zapytanie
 --
 select concat(upper(left(ltrim(imie),1)),lower(right(imie,length(ltrim(imie))-1)))
     imie from test;
+-------+
| imie  |
+-------+
| Jan   |
| Ewa   |
| Ola   |
| Iza   |
| Ala   |
| Ewa   |
| Lena  |
+-------+
7 rows in set (0.00 sec)

 -- poza tym s� jeszcze:
 select rtrim("  Ala   ma  kota.   ") napis; -- usuwa bi��e znaki z prawej
+-------------------+
| napis             |
+-------------------+
|   Ala   ma  kota. |
+-------------------+
1 row in set (0.00 sec)

 select trim("  Ala   ma  kota.   ") napis; -- usuwa bi��e znaki z obu
+-----------------+
| napis           |
+-----------------+
| Ala   ma  kota. |
+-----------------+
1 row in set (0.00 sec)

 -- jest te� u�yteczna funkcja SUBSRT, kt�ra mo�e mie� 2 argumenty,
 -- wtedy wybiera podci�g znak�w podanego ci�gu znak�w od danego miejsca
 -- albo 3 argumenty: podci�g od danego miejsca o danej d�ugo�ci
 --
 select substr("Ala ma kota.",3); -- od 3 do ko�ca
+--------------------------+
| substr("Ala ma kota.",3) |
+--------------------------+
| a ma kota.               |
+--------------------------+
1 row in set (0.00 sec)

 select substr("Ala ma kota.",5,6); -- od 3 d�ugo�ci 6
+----------------------------+
| substr("Ala ma kota.",5,8) |
+----------------------------+
| ma kot                     |
+----------------------------+
1 row in set (0.00 sec)

 --
 -- ZADANIE: zak��adaj�c, �e ostatnia litera imienia okre��la p��e� ("a" - kobieta,
 -- nie "a" - m�czyzna), wypisz kolumny imi� i p��e� z tabeli test
 --
 -- w tym celu poznajmy konstrukcj� IF:

 select if(2+4=6,"dobrze","�le"); -- konstrukcja if-a
+--------------------------+
| if(2+4=6,"dobrze","�le") |
+--------------------------+
| dobrze                   |
+--------------------------+
1 row in set (0.00 sec)

 select if(2+4=1,"dobrze","�le");-- uwaga na pojedynczy znak =
+--------------------------+
| if(2+4=1,"dobrze","�le") |
+--------------------------+
| �le                      |
+--------------------------+
1 row in set (0.00 sec)

 --
 -- mo�emy rozwi�za� zadanie:
 --
 select imie, if(right(trim(imie),1)="a","kobieta","facet") p�e� from test;
+--------+---------+
| imie   | p�e�    |
+--------+---------+
| Jan    | facet   |
| Ewa    | kobieta |
| Ola    | kobieta |
| Iza    | kobieta |
|  alA   | kobieta |
| eWa    | kobieta |
|  leNa  | kobieta |
+--------+---------+
7 rows in set (0.00 sec)

 -- bez trim eWa by��aby facetem :-(
 -- po��czmy teraz dwa powy�sze zapytania: p��e� i litery
 --
 select concat(upper(left(ltrim(imie),1)),lower(right(imie,length(ltrim(imie))-1)))
     imie, if(right(trim(imie),1)="a","kobieta","facet") p�e� from test;
+-------+---------+
| imie  | p�e�    |
+-------+---------+
| Jan   | facet   |
| Ewa   | kobieta |
| Ola   | kobieta |
| Iza   | kobieta |
| Ala   | kobieta |
| Ewa   | kobieta |
| Lena  | kobieta |
+-------+---------+
7 rows in set (0.00 sec)

 -- podzi�kujmy za wsp�prac� tabeli test
 drop table test;
Query OK, 0 rows affected (0.40 sec)
