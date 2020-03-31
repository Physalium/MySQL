create database znajomi;
use znajomi;
create table osoby(
    id_o tinyint unsigned not null auto_increment,
    imie char(9) not null,
    nazwisko char(15) not null,
    wiek tinyint,
    miasto char(23) default "Gliwice",
    primary key(id_o))
    engine = innodb
    default character set utf8
    collate utf8_unicode_ci;

create table telefony(
    id_t tinyint unsigned not null auto_increment,
    numer char (9) not null,
    typ enum("komórkowy","stacjonarny") default "komórkowy",
    operator enum("tp","era","plus","play","tu_biedronka"),
    primary key(id_t))
    engine=innodb
    default character set utf8
    collate utf8_unicode_ci;

create table k(
id_k tinyint unsigned not null auto_increment,
id_o tinyint unsigned not null,
id_t tinyint unsigned not null,
primary key(id_k),
foreign key(id_o) references osoby(id_o),
foreign key(id_t) references telefony(id_t))
engine = innodb
default character set utf8
collate utf8_unicode_ci;

show tables;

