create table points
(
    id            char(36) unique not null,
    Name          varchar(40) unique not null,
    Strasse       varchar(40) unique not null,
    Nr            varchar(40) unique not null,
    Laengengrad   double             not null,
    Breitengrad   double             not null,
    active        bool               not null,
    constraint points_pk
        primary key (id)
);