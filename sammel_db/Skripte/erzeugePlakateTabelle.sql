create table Plakate
(
    id        int auto_increment        primary key,
    latitude  double       not null,
    longitude double       not null,
    adresse   varchar(120) not null,
    user_id   int          not null
);