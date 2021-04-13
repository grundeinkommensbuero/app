insert into FAQ (id, title, teaser, order_nr) values (
1,
'Wann geht''s los?',
'Am **26. Februar** ist _Sammelbeginn_.',
1.0
);

insert into FAQ_Tags (faq, tag) values (1, 'Start');
insert into FAQ_Tags (faq, tag) values (1, 'Beginn');
insert into FAQ_Tags (faq, tag) values (1, 'Sammelphase');

insert into FAQ (id, title, teaser, rest, order_nr) values (
2,
'Was sind die Stufen des Volksbegehrens?',
'Jedes Volksbegehren läuft in 3 Stufen ab.
Diese sind:',
        '''


| **Stufe** | **Erfolg** |
| ------------ | ------------ |
| Volksinitiative  | 50.000 Unterschriften  |
| Volksbegehren  | 170.000 Unterschriften  |
| Volksentscheid  | 613.000 Ja-Stimmen  |
',
2.0
);

insert into FAQ_Tags (faq, tag) values (2, 'Stufen');
insert into FAQ_Tags (faq, tag) values (2, 'Volksbegehren');
insert into FAQ_Tags (faq, tag) values (2, 'Volksinitiative');
insert into FAQ_Tags (faq, tag) values (2, 'Erfolg');
insert into FAQ_Tags (faq, tag) values (2, 'Unterschriften');

insert into FAQ (id, title, teaser, rest, order_nr) values (
3,
'Sammeltipps',
'Ein kurzer und inhaltlich einfacher Satz hat sich oft bewährt.

Ein paar Beispiele:
',
'> "Hast Du schon von unserem Volksbegehren gehört?“
> „Möchtest Du für XYZ unterschreiben?“
> „Wir sammeln Unterschriften gegen XYZ – möchten Sie unterschreiben?“

Nach kurzer Bedenkzeit der Person kann eine weitere erläuternder Satz nachgeschoben werden:

> „Wir sind von der Initiative XYZ“
> „Wir fordern dass ...“',
3.0
);

insert into FAQ_Tags (faq, tag) values (3, 'Tipps');
insert into FAQ_Tags (faq, tag) values (3, 'Sammeln');
insert into FAQ_Tags (faq, tag) values (3, 'Hinweise');
insert into FAQ_Tags (faq, tag) values (3, 'Ansprechen');

insert into FAQ (id, title, teaser, order_nr) values (
4,
'Feedback und Fehlermeldungen',
'Wenn du eine Fehler gefunden hast oder uns anderes Feedback zur App melden willst, dann schreib uns doch [per Mail](mailto:app@dwenteignen.de) oder öffne ein Bug-Ticket auf [der App-Webseite](https://www.gitlab.com/kybernetik/sammel-app)',
4.0
);

insert into FAQ_Tags (faq, tag) values (4, 'Bugs');
insert into FAQ_Tags (faq, tag) values (4, 'Kontakt');
insert into FAQ_Tags (faq, tag) values (4, 'Webseite');
insert into FAQ_Tags (faq, tag) values (4, 'Ansprechen');
insert into FAQ_Tags (faq, tag) values (4, 'E-Mail');

insert into FAQ_Timestamp (timestamp) values ('2021-04-12 16:00:00')