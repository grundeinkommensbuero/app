create table Termine
(
    id     int auto_increment
        primary key,
    beginn datetime    null,
    ende   datetime    null,
    ort    int         null,
    typ    varchar(40) null,
    constraint Termine_Ort_fk
        foreign key (ort) references Stamm_Orte (id)
            on update cascade
);

create table Termin_Teilnehmer
(
    Termin     int null,
    Teilnehmer int null,
    constraint Termin_Teilnehmer_Benutzer_fk
        foreign key (Teilnehmer) references Benutzer (id)
            on delete cascade,
    constraint Termin_Teilnehmer_Termine_fk
        foreign key (Termin) references Termine (id)
            on delete cascade
)
    comment 'Liste der Teilnehmer der Termine';



