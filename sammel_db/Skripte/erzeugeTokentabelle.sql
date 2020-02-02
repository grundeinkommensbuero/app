create table Token
(
    id         int auto_increment,
    token text     null,
    constraint Token_Termine_fk
        foreign key (id) references Termine (id)
            on update cascade on delete cascade
)
    comment 'Authentifzierung-Token zu Terminen';

