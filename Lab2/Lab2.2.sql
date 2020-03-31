insert into telefony
(numer, typ, operator)
values
(51571870, 'komorkowy', 'era'), #parsuje na char z bomby
(23232321, 'komorkowy', 'plus'),
    (24562456, "stacjonarny", "tp"),
    (46234272, "komorkowy", "tp"),
    (64236426, "stacjonarny", "tu_biedronka"),
    (23462362, "komorkowy", "plus"),
    (53453534, "stacjonarny", "play"),
    (64353543, "komorkowy", "play");
alter table osoby modify nazwisko char(20) not null;
insert into osoby
(imie, nazwisko, wiek, miasto)
values
    ('Pierdas', 'Bombieszczyk', 30, 'Niweczka'),
    ('Karoleł', 'Nawroteł', 12, 'WieśZaKAto'),
    ('Rafalek', 'Zabijaka', 85, 'Sosnowiec'),
    ('Aneta', 'Gazeta', 45, 'Ursynów'),
    ('Jolanta', 'Chleb', 30, 'Bytum'),
    ('Mama', 'Dawida', 50, 'Zabrze'),
    ('Jaro', 'Korzeniowski', 46, 'Ateny'),
    ('Bohdan', 'Lato', 90, 'Las Palmas');


insert into k (id_k, id_o, id_t) values (1, 1, 1);
insert into k (id_k, id_o, id_t) values (2, 1, 2);
insert into k (id_k, id_o, id_t) values (3, 2, 3);
insert into k (id_k, id_o, id_t) values (4, 2, 4);
insert into k (id_k, id_o, id_t) values (5, 3, 5);
insert into k (id_k, id_o, id_t) values (6, 4, 6);
insert into k (id_k, id_o, id_t) values (7, 5, 8);
insert into k (id_k, id_o, id_t) values (8, 7, 7);

show databases ;
use znajomi;
select * from osoby;

#eksportowanie bazy

create table t(
    i char(9),
    w int);

insert into t
select  imie, miasto from osoby;

select * from t;

drop table osoby; # nie mozna dropowac bo jest w relacji z kluczem
drop table t; # to juz dziala

insert into telefony
(numer, typ, operator)
values
(null, 'komorkowy', null);

select * from telefony;




