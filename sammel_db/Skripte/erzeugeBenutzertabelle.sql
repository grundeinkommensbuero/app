create table Benutzer
(
    id            int auto_increment not null,
    name          varchar(40) unique null,
    color         int unsigned null,
    constraint Benutzer_pk
        primary key (id)
);

create table Credentials
(
    id            int unique not null,
    secret        varchar(1024) not null,
    salt          varchar(1024) not null,
    iterations    int not null default 10,
    firebasekey   varchar(256) not null,
    constraint Credentials_pk
        primary key (id)
);

create table Roles
(
    id            int not null,
    role          varchar(256) not null
);
