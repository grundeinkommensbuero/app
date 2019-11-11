INSERT INTO db.TerminDetails (id, treffpunkt, kommentar, kontakt) VALUES (1, 'Weltzeituhr', 'wir stellen uns an die Ubhf-Eingänge. ihr erkennt mich an der DWE-Weste', 'kalle@revo.de');
INSERT INTO db.TerminDetails (id, treffpunkt, kommentar, kontakt) VALUES (2, 'Friseurladen', 'Klemmbrett raus und los!', 'kalle@revo.de');
INSERT INTO db.TerminDetails (id, treffpunkt, kommentar, kontakt) VALUES (3, 'Zeitungsviertel', 'kommt zahlreich!', 'rosa@spartakus.de');
INSERT INTO db.TerminDetails (id, treffpunkt, kommentar, kontakt) VALUES (4, 'DGB-Haus, Raum 223', 'Ihr seid alle eingeladen. Lasst uns über die weitere Sammel-Strategie diskutieren.', 'info@dwenteignen.de');

INSERT INTO db.Termine (id, beginn, ende, ort, typ, Details) VALUES (1, '2020-02-05 09:00:00', '2020-02-05 12:00:00', 1, 'Sammel-Termin', 1);
INSERT INTO db.Termine (id, beginn, ende, ort, typ, Details) VALUES (2, '2020-02-07 11:00:00', '2020-02-07 13:00:00', 2, 'Sammel-Termin', 2);
INSERT INTO db.Termine (id, beginn, ende, ort, typ, Details) VALUES (3, '2020-02-11 23:00:00', '2020-02-12 02:00:00', 3, 'Sammel-Termin', 3);
INSERT INTO db.Termine (id, beginn, ende, ort, typ, Details) VALUES (4, '2020-02-13 18:00:00', '2020-02-13 20:30:00', 2, 'Info-Veranstaltung', 4);

INSERT INTO db.Termin_Teilnehmer (termin, teilnehmer) VALUES (1, 1);
INSERT INTO db.Termin_Teilnehmer (termin, teilnehmer) VALUES (1, 2);
INSERT INTO db.Termin_Teilnehmer (termin, teilnehmer) VALUES (2, 1);
INSERT INTO db.Termin_Teilnehmer (termin, teilnehmer) VALUES (3, 2);
INSERT INTO db.Termin_Teilnehmer (termin, teilnehmer) VALUES (4, 1);
INSERT INTO db.Termin_Teilnehmer (termin, teilnehmer) VALUES (4, 2);