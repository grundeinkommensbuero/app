create table Termine
(
    id int auto_increment,
    beginn datetime null,
    ende datetime null,
    ort Int null,
    constraint Termine_pk
        primary key (id),
    constraint Termine_Ort_fk
        foreign key (ort) references Stamm_Orte (id)
            on update cascade
            on delete restrict
);

create table Termin_Teilnehmer
(
    Termin int null,
    Teilnehmer int null,
    constraint Termin_Teilnehmer_Benutzer_fk
        foreign key (Teilnehmer) references Benutzer (ID)
            on delete cascade,
    constraint Termin_Teilnehmer_Termine_fk
        foreign key (Termin) references Termine (ID)
            on delete cascade
)
    comment 'Liste der Teilnehmer der Termine';



