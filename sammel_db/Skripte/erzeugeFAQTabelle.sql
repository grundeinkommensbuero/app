create table FAQ
(
    id            int auto_increment not null,
    inhalt        text not null default "",
    constraint FAQ_pk
        primary key (id)
);