create table Token
(
    action_id   int     primary key,
    token       text     null
-- FIXME sollte eigentlich auf Termin verweisen und kaskadiert gelöscht werden
--    constraint Token_Termine_fk
--        foreign key (action_id) references Termine (id)
)
    comment 'Authentifzierung-Token zu Terminen';

