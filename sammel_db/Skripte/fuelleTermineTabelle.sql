INSERT INTO Termine (id, beginn, ende, ort, typ, latitude, longitude) VALUES (1, '2020-02-05 09:00:00', '2020-02-05 12:00:00', 'Frankfurter Allee Nord', 'Sammeln', 52.52116, 13.41331);
INSERT INTO Termine (id, beginn, ende, ort, typ, latitude, longitude) VALUES (2, '2020-02-07 11:00:00', '2020-02-07 13:00:00', 'Tempelhofer Vorstadt', 'Sammeln', 52.48756, 13.46336);
INSERT INTO Termine (id, beginn, ende, ort, typ, latitude, longitude) VALUES (3, '2020-02-11 23:00:00', '2020-02-12 02:00:00', 'Alexanderplatz', 'Sammeln', 52.49655, 13.43759);
INSERT INTO Termine (id, beginn, ende, ort, typ, latitude, longitude) VALUES (4, '2020-02-13 18:00:00', '2020-02-13 20:30:00', 'Tempelhofer Vorstadt', 'Infoveranstaltung', 52.48612, 13.47192);

INSERT INTO TerminDetails (termin_id, treffpunkt, beschreibung, kontakt) VALUES (1, 'Weltzeituhr', 'wir stellen uns an die Ubhf-Eingänge. ihr erkennt mich an der DWE-Weste', 'kalle@revo.de');
INSERT INTO TerminDetails (termin_id, treffpunkt, beschreibung, kontakt) VALUES (2, 'Friseurladen', 'Klemmbrett raus und los!', 'kalle@revo.de');
INSERT INTO TerminDetails (termin_id, treffpunkt, beschreibung, kontakt) VALUES (3, 'Zeitungsviertel', 'kommt zahlreich!', 'rosa@spartakus.de');
INSERT INTO TerminDetails (termin_id, treffpunkt, beschreibung, kontakt) VALUES (4, 'DGB-Haus, Raum 223', 'Ihr seid alle eingeladen. Lasst uns über die weitere Sammel-Strategie diskutieren.', 'info@dwenteignen.de');

INSERT INTO Termin_Teilnehmer (termin, teilnehmer) VALUES (1, 11);
INSERT INTO Termin_Teilnehmer (termin, teilnehmer) VALUES (1, 12);
INSERT INTO Termin_Teilnehmer (termin, teilnehmer) VALUES (2, 11);
INSERT INTO Termin_Teilnehmer (termin, teilnehmer) VALUES (3, 12);
INSERT INTO Termin_Teilnehmer (termin, teilnehmer) VALUES (4, 11);
INSERT INTO Termin_Teilnehmer (termin, teilnehmer) VALUES (4, 12);