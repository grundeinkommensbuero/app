create table FAQ
(
    id            int   unique  not null,
    titel         char(120)          not null,
    teaser        text          not null,
    rest          text          null,
    order_nr      double        not null,
    constraint FAQ_pk
        primary key (id)
);

create table FAQ_Tags
(
    faq           int                   not null,
    tag           char(40)              not null
);

create table FAQ_Timestamp
(
    timestamp     datetime              not null,
    constraint FAQ_pk
        primary key (timestamp)
);