select 3+9, 5-7, 7*8, pow(2,10), sqrt(2);
select sin(3.1415192653589/2),4*atan(1), abs(-4), log(2.7181818),mod(123,6) G;

use znajomi;
select * from osoby; # nie używać *

select id_o,imie,nazwisko,wiek,miasto from osoby;
select imie,miasto,imie,wiek,imie,imie from osoby; # można kilka razy se wypisać

select imie as Imię, nazwisko, miasto as skąd from osoby; # można nazywać kolumny ( as ) do wyświetlania (alias)

select imie Imię,nazwisko,wiek "ile ma lat" from osoby; #as jest wstawiane automatycznie

select imie AS Imię, nazwisko, miasto Imię from osoby; # można se 2 tak samo nazwac ale nwm co za debil by tak robil

select imie nazwisko, nazwisko, wiek nazwisko from osoby; # to można też

select * from osoby order by miasto desc; # ascending - asc, descending-desc

select * from osoby order by miasto,imie;

select imie kto, nazwisko, miasto gdzie from osoby order by gdzie, nazwisko desc; # mozna sortowac po aliasach

select imie kto,nazwisko, miasto kto from osoby order by kto; #niejednoznaczne polecenie i nie przechodzi

select imie kto,nazwisko, miasto imie from osoby order by imie;

select imie kto, nazwisko, miasto nazwisko from osoby order by nazwisko; # niejednoznacznosc;

select imie kto, nazwisko, miasto nazwisko from osoby order by 3 desc, 2 desc; # mozna sortować po numerze kolumny też, a wgl to se mozna to mieszać

select * from telefony order by operator;

select * from osoby
where wiek > 40 and wiek<65;

# na kolokwium bedzie zadanie gdzie beda 3 spojniki (lub, i itd)
select * from osoby where wiek>18 and (wiek <40 or id_o >=1); # nawiasy maja znaczenie

select * from osoby where wiek not between 20 and 65; # jebac prawa demorgana

select * from osoby where imie <= "dgh"; # sortuje po kolei - 1 litera imienia mniejsza albo rowna d, 2 g itd

select * from osoby where miasto <> "zabrze"; # <> i  !=  to to samo

select * from osoby where miasto like "zabrze"; # to jest to samo co = ale fajniejsze

select * from osoby where miasto like "_____"; #imiona 5 literowe, _ to jedna litera, tylko like interpretuje to

select * from osoby where nazwisko like "%ą%"; # %- dowolna ilosc znakow

select * from osoby where miasto like "%k%" and miasto not like "k%" and miasto not like "%k";

select * from osoby where miasto in ("zabrze","ateny");

select * from osoby limit 2,6; # kod od 3 id i 6 takich osob

select imie kto,nazwisko, wiek, miasto skąd from osoby where wiek >= 20 or imie between "abc" and "xyz" order by 4,2 desc limit 1,3;

