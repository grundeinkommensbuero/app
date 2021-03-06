create table BesuchteHaeuser
(
    id        int auto_increment        primary key,
    latitude  double       not null,
    longitude double       not null,
    adresse   varchar(120) not null,
    hausteil  varchar(120) null,
    polygon   text         null,
    osm_id     varchar(20)  null,
    datum     datetime     not null,
    user_id   int          not null
);