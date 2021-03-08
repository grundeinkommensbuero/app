create table Termine
(
    id      int auto_increment        primary key,
    beginn  datetime     null,
    ende    datetime     null,
    ort     varchar(120) null,
    typ     varchar(40)  null,
    latitude  double     null,
    longitude  double    null
);

create table Evaluationen
(
    id              int auto_increment      primary key,
    termin_id       int     null,
    user_id         int     null,
    teilnehmer     int     null,
    unterschriften  int     null,
    bewertung       int     null,
    stunden         double  null,
    kommentar       text    null,
    situation       text    null,
    ausgefallen     bool    not null        default false,

    constraint Evaluationen_Benutzer_fk
        foreign key (user_id) references Benutzer (id)
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


