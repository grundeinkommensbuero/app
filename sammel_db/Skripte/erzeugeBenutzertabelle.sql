create table Benutzer
(
    id            int auto_increment not null,
    name          varchar(40) unique not null,
    passwort      varchar(100)       not null,
    telefonnummer varchar(40)        null,
    constraint Benutzer_pk
        primary key (id)
);

