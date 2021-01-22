create table PushMessages
(
    id                  int unsigned auto_increment not null,
    empfaenger          int not null,
    daten               blob(1000) null default null,
    benachrichtigung    blob(400) null default null,
    constraint PushMessages_pk
        primary key (id),
    constraint PushMessages_Benutzer_fk
        foreign key (empfaenger) references Benutzer (id)
        on delete cascade
);