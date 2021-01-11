create table Subscriptions
(
    benutzer      int not null,
    topic         varchar(256) not null,
    constraint Subscription_pk
        primary key (benutzer, topic),
    constraint Subscriptions_Benutzer_fk
    foreign key (benutzer) references Benutzer (id)
        on update cascade on delete cascade
);