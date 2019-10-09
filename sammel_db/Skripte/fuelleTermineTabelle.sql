INSERT INTO db.Termine (id, beginn, ende, ort) VALUES (1, '2020-02-05 09:00:00', '2020-02-05 12:00:00', '1');
INSERT INTO db.Termine (id, beginn, ende, ort) VALUES (2, '2020-02-07 11:00:00', '2020-02-07 13:00:00', '2');
INSERT INTO db.Termine (id, beginn, ende, ort) VALUES (3, '2020-02-11 23:00:00', '2020-02-11 02:00:00', '3');

INSERT INTO db.Termin_Teilnehmer (termin, teilnehmer) VALUES (1, 1);
INSERT INTO db.Termin_Teilnehmer (termin, teilnehmer) VALUES (1, 2);
INSERT INTO db.Termin_Teilnehmer (termin, teilnehmer) VALUES (2, 1);
INSERT INTO db.Termin_Teilnehmer (termin, teilnehmer) VALUES (3, 2);