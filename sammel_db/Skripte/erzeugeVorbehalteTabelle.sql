create table Vorbehalte
(
    id          int auto_increment        primary key,
    datum       datetime     not null,
    ort         varchar(120) not null,
    vorbehalte  text         not null
);
