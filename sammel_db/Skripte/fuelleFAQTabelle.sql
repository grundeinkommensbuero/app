insert into FAQ (id, titel, teaser, rest, order_nr) values (
1,
'Wann geht''s los?',
'Am 26. Februar ist Sammelbeginn.',
null,
1.0
);

insert into FAQ_Tags (faq, tag) values (1, 'Start');
insert into FAQ_Tags (faq, tag) values (1, 'Beginn');
insert into FAQ_Tags (faq, tag) values (1, 'Sammelphase');

insert into FAQ (id, titel, teaser, rest, order_nr) values (
2,
'Wie lange wird gesammelt?',
'Die Sammelphase geht vom 26. Februar bis 25. Juni 2021, also vier Monate. **Dieser Zeitraum ist nicht verlängerbar.**',
null,
2.0
);

insert into FAQ_Tags (faq, tag) values (2, 'Ende');
insert into FAQ_Tags (faq, tag) values (2, 'Deadline');
insert into FAQ_Tags (faq, tag) values (2, 'Dauer');
insert into FAQ_Tags (faq, tag) values (2, 'Sammelphase');

insert into FAQ (id, titel, teaser, rest, order_nr) values (
3,
'Wessen Unterschrift ist gültig?',
'Wahlberechtigt sind alle Berliner\*innen mit deutschem Pass, die mindestens drei Monate in Berlin gemeldet und mindestens 18 Jahre alt sind. Die Unterschriften eines großen Teils der Einwohner\*innen Berlins, werden also für ungültig erklärt. Das ist unserer Meinung nach höchst undemokratisch und ein politischer Skandal. Wir freuen uns jedoch über jede Unterstützung und finden es deshalb gut, wenn auch Personen unterschreiben, die nicht wahlberechtigt sind.',
'### Eine Ausnahmeregelung gilt gemäß [Wahlgesetz](https://www.gesetze-im-internet.de/bwahlg/ "Wahlgesetz") jedoch:

> "Personen, die nicht in einem Melderegister der Bundesrepublik Deutschland verzeichnet sind oder nicht seit drei Monaten vor dem Tag der Unterzeichnung im Melderegister in Berlin gemeldet sind, können das Volksbegehren ebenfalls unterzeichnen. Sie müssen mit der Unterzeichnung in einer amtlichen Auslegungsstelle oder im Bezirksamt durch Versicherung an Eides Statt gegenüber dem Bezirksamt glaubhaft machen, dass sie sich in den letzten drei Monaten überwiegend in Berlin aufgehalten haben."

''Erklärt eine zustimmungswillige Person, dass sie nicht schreiben kann, so ist die Eintragung von Amts wegen in einer amtlichen Auslegungsstelle oder im Bezirksamt unter Vermerk dieser Erklärung vorzunehmen''.',
3.0
);

insert into FAQ_Tags (faq, tag) values (3, 'Gültigkeit');
insert into FAQ_Tags (faq, tag) values (3, 'Unterschriften');
insert into FAQ_Tags (faq, tag) values (3, 'Wer');

insert into FAQ_Timestamp (timestamp) values ('2021-04-12 16:00:00')