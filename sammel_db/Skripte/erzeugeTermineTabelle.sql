create table Termine
(
    id      int auto_increment        primary key,
    beginn  datetime    null,
    ende    datetime    null,
    ort     int         null,
    typ     varchar(40) null,
    lattitude  double   null,
    longitude  double   null,
    constraint Termine_Ort_fk
        foreign key (Ort) references Stamm_Orte (id)
            on update cascade
);

create table TerminDetails
(
    termin_id       int auto_increment        primary key,
    treffpunkt      text     null,
    beschreibung    longtext null,
    kontakt         text     null,
    constraint TerminDetails_Termine_fk
        foreign key (termin_id) references Termine (id)
            on update cascade on delete cascade
)
    comment 'naehere Infos zu Terminen';

create table Termin_Teilnehmer
(
    termin     int null,
    teilnehmer int null,
    constraint Termin_Teilnehmer_Benutzer_fk
        foreign key (teilnehmer) references Benutzer (id)
            on delete cascade,
    constraint Termin_Teilnehmer_Termine_fk
        foreign key (termin) references Termine (id)
            on delete cascade
)
    comment 'Liste der Teilnehmer der Termine';
