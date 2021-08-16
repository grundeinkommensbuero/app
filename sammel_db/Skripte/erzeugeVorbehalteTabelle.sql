create table Vorbehalte
(
    id          int auto_increment        primary key,
    vorbehalte  text         not null,
    benutzer    int          not null,
    datum       datetime     not null,
    ort         varchar(120) not null
);
