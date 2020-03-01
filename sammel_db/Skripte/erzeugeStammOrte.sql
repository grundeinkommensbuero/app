create table Stamm_Orte
(
    id          int auto_increment not null,
    bezirk      varchar(40) not null,
    ort         varchar(40) not null,
    lattitude   double   null,
    longitude   double   null,
    constraint Stamm_Orte_pk
        primary key (id)
)
    comment 'Liste möglicher Orte für Temine';