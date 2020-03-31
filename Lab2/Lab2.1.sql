insert into telefony
    (numer, typ, operator)
values (51571870, 'komorkowy', 'era'), #parsuje na char z bomby
       (23232321, 'komorkowy', 'plus'),
       (24562456, "stacjonarny", "tp"),
       (46234272, "komorkowy", "tp"),
       (64236426, "stacjonarny", "tu_biedronka"),
       (23462362, "komorkowy", "plus"),
       (53453534, "stacjonarny", "play"),
       (64353543, "komorkowy", "play");
alter table osoby
    modify nazwisko char(20) not null;
insert into osoby
    (imie, nazwisko, wiek, miasto)
values ('Pierdas', 'Bombieszczyk', 30, 'Niweczka'),
       ('Karoleł', 'Nawroteł', 12, 'WieśZaKAto'),
       ('Rafalek', 'Zabijaka', 85, 'Sosnowiec'),
       ('Aneta', 'Gazeta', 45, 'Ursynów'),
       ('Jolanta', 'Chleb', 30, 'Bytum'),
       ('Mama', 'Dawida', 50, 'Zabrze'),
       ('Jaro', 'Korzeniowski', 46, 'Ateny'),
       ('Bohdan', 'Lato', 90, 'Las Palmas');


insert into k (id_k, id_o, id_t)
values (1, 1, 1);
insert into k (id_k, id_o, id_t)
values (2, 1, 2);
insert into k (id_k, id_o, id_t)
values (3, 2, 3);
insert into k (id_k, id_o, id_t)
values (4, 2, 4);
insert into k (id_k, id_o, id_t)
values (5, 3, 5);
insert into k (id_k, id_o, id_t)
values (6, 4, 6);
insert into k (id_k, id_o, id_t)
values (7, 5, 8);
insert into k (id_k, id_o, id_t)
values (8, 7, 7);

show databases;
use znajomi;
select *
from osoby;

#eksportowanie bazy

create table t
(
    i char(9),
    w int
);

insert into t
select imie, miasto
from osoby;

select *
from t;

drop table osoby; # nie mozna dropowac bo jest w relacji z kluczem
drop table t; # to juz dziala

insert into telefony
    (numer, typ, operator)
values (null, 'komorkowy', null);

select *
from telefony;


alter table osoby
    add nk int default 8; #dodawanie kolumny dodatkowej, ale jest na końcu dodana

desc osoby;

alter table osoby
    add nk2 char(5) not null first; #dodawanie kolumny jako pierwszą
desc osoby;

alter table osoby
    add nk3 char(5) after imie; #kolumna ma być po kolumnie imie
desc osoby;
select *
from osoby;

alter table osoby
    drop nk3; #wywalamy kolumne przez drop
desc osoby;

#alter table osoby drop id_o # nie mozna bo spojnosc sie zwali bo to klucz dla innej tabeli;

desc k;

alter table k
    drop primary key; #system wie co jest kluczem primary, ale jest autoincrement ktory moze istniec tylko do klucza glownego

alter table k
    modify
        id_k tinyint unsigned not null; #usuwamy autoincrement

alter table k
    drop primary key; #teraz dziala

desc k;

# zad domowe - jak usunac klucz obcy zeby ten mul usunal


alter table k
    add primary key (id_k);
desc k; #znowu dodajemy

alter table k
    change id_k idy tinyint unsigned not null auto_increment; #dodajemy autoincrement

desc k;

alter table k drop foreign key k_ibfk_1; # nw

desc k;

alter table osoby alter nk drop default;
desc osoby;
alter table osoby alter nk set default 11;

alter table k rename kabel; #zmiana nazwy
desc kabel;ą
show tables;

select * from osoby;

delete from osoby where id_o= 1; # mozemy tez dac where naziwsko=cos tam zeby wszystkie nazwiska wyjebac

update osoby set wiek=369 where id_o=3; #mozemy updatowac dane

drop database znajomi; #wywalamy
create database znajomi;


