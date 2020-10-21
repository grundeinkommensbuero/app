INSERT INTO TerminDetails (id, treffpunkt, kommentar, kontakt) VALUES (1, 'Weltzeituhr', 'wir stellen uns an die Ubhf-Eingänge. ihr erkennt mich an der DWE-Weste', 'kalle@revo.de');
INSERT INTO TerminDetails (id, treffpunkt, kommentar, kontakt) VALUES (2, 'Friseurladen', 'Klemmbrett raus und los!', 'kalle@revo.de');
INSERT INTO TerminDetails (id, treffpunkt, kommentar, kontakt) VALUES (3, 'Zeitungsviertel', 'kommt zahlreich!', 'rosa@spartakus.de');
INSERT INTO TerminDetails (id, treffpunkt, kommentar, kontakt) VALUES (4, 'DGB-Haus, Raum 223', 'Ihr seid alle eingeladen. Lasst uns über die weitere Sammel-Strategie diskutieren.', 'info@dwenteignen.de');

INSERT INTO Termine (id, beginn, ende, ort, typ, lattitude, longitude, Details) VALUES (1, '2020-02-05 09:00:00', '2020-02-05 12:00:00', 1, 'Sammeln', 52.52116, 13.41331, 1);
INSERT INTO Termine (id, beginn, ende, ort, typ, lattitude, longitude, Details) VALUES (2, '2020-02-07 11:00:00', '2020-02-07 13:00:00', 2, 'Sammeln', 52.48756, 13.46336, 2);
INSERT INTO Termine (id, beginn, ende, ort, typ, lattitude, longitude, Details) VALUES (3, '2020-02-11 23:00:00', '2020-02-12 02:00:00', 3, 'Sammeln', 52.49655, 13.43759, 3);
INSERT INTO Termine (id, beginn, ende, ort, typ, lattitude, longitude, Details) VALUES (4, '2020-02-13 18:00:00', '2020-02-13 20:30:00', 2, 'Infoveranstaltung', 52.48612, 13.47192, 4);

INSERT INTO Termin_Teilnehmer (termin, teilnehmer) VALUES (1, 11);
INSERT INTO Termin_Teilnehmer (termin, teilnehmer) VALUES (1, 12);
INSERT INTO Termin_Teilnehmer (termin, teilnehmer) VALUES (2, 11);
INSERT INTO Termin_Teilnehmer (termin, teilnehmer) VALUES (3, 12);
INSERT INTO Termin_Teilnehmer (termin, teilnehmer) VALUES (4, 11);
INSERT INTO Termin_Teilnehmer (termin, teilnehmer) VALUES (4, 12);