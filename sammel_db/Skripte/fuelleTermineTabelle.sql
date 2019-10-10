INSERT INTO db.Termine (id, beginn, ende, ort, Typ) VALUES (1, '2020-02-05 09:00:00', '2020-02-05 12:00:00', 1, 'Sammel-Termin');
INSERT INTO db.Termine (id, beginn, ende, ort, Typ) VALUES (2, '2020-02-07 11:00:00', '2020-02-07 13:00:00', 2, 'Sammel-Termin');
INSERT INTO db.Termine (id, beginn, ende, ort, Typ) VALUES (3, '2020-02-11 23:00:00', '2020-02-12 02:00:00', 3, 'Sammel-Termin');
INSERT INTO db.Termine (id, beginn, ende, ort, Typ) VALUES (4, '2020-02-13 18:00:00', '2020-02-13 20:30:00', 2, 'Info-Veranstaltung');

INSERT INTO db.Termin_Teilnehmer (Termin, Teilnehmer) VALUES (1, 1);
INSERT INTO db.Termin_Teilnehmer (Termin, Teilnehmer) VALUES (1, 2);
INSERT INTO db.Termin_Teilnehmer (Termin, Teilnehmer) VALUES (2, 1);
INSERT INTO db.Termin_Teilnehmer (Termin, Teilnehmer) VALUES (3, 2);
INSERT INTO db.Termin_Teilnehmer (Termin, Teilnehmer) VALUES (4, 1);
INSERT INTO db.Termin_Teilnehmer (Termin, Teilnehmer) VALUES (4, 2);