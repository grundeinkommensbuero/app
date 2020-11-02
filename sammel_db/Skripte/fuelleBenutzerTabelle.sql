INSERT INTO Benutzer (id, name, color) VALUES (1, 'app', 1);
INSERT INTO Benutzer (id, name, color) VALUES (2, 'website', 2);
INSERT INTO Benutzer (id, name, color) VALUES (11, 'Karl Marx', 4294198070);
INSERT INTO Benutzer (id, name, color) VALUES (12, 'Rosa Luxemburg', 4288423856);

# Secret b97c7597-f669-4feb-9ba2-3214c1822339
# BASE64-encodiertes BASIC-AUTH MTpiOTdjNzU5Ny1mNjY5LTRmZWItOWJhMi0zMjE0YzE4MjIzMzk=
INSERT INTO Credentials (id, secret, salt, iterations, firebasekey) VALUES (1, '518f85a68dcfec2d9fec23bded0f0fb0cc44822d227983', 'a757a25a0c624165f2102584510e055a', 10, 'iamnokey');
# Secret 8fd76e31-4bba-44de-b6fe-bb548cfc2225
# BASE64-encodiertes BASIC-AUTH d2Vic2l0ZTo4ZmQ3NmUzMS00YmJhLTQ0ZGUtYjZmZS1iYjU0OGNmYzIyMjU=
INSERT INTO Credentials (id, secret, salt, iterations, firebasekey) VALUES (2, '643b489a2c7d98eb86ab137a4609ef7f929ef8139b6038', 'b31e3f36a330ff1cd3db3021b5adc45f', 10, 'iamnokey');
# Secret BASIC-AUTH ac430960-05eb-11eb-8a26-fdc7683a84bc
# BASE64-encodiertes BASIC-AUTH MTE6YWM0MzA5NjAtMDVlYi0xMWViLThhMjYtZmRjNzY4M2E4NGJj
INSERT INTO Credentials (id, secret, salt, iterations, firebasekey) VALUES (11, '90818603d7da23266d968f0c526850f13bc50e0610aca3', '57fdb727bd21f83e3594f0a0da384492', 10, 'AAAAAAAA');
# Secret 76f19030-05ee-11eb-afef-a5be559f6b58
# BASE64-encodiertes BASIC-AUTH MTI6NzZmMTkwMzAtMDVlZS0xMWViLWFmZWYtYTViZTU1OWY2YjU4
INSERT INTO Credentials (id, secret, salt, iterations, firebasekey) VALUES (12, '7deda08f740e1c27f50e1ce5749fe36f50fe61e53be7b1', '527d86a9d319f00b72af9a9bf554df76', 10, 'BBBBBBBB');

INSERT INTO Roles (id, role) VALUES (1, 'app');
INSERT INTO Roles (id, role) VALUES (2, 'website');
INSERT INTO Roles (id, role) VALUES (11, 'app');
INSERT INTO Roles (id, role) VALUES (11, 'user');
INSERT INTO Roles (id, role) VALUES (11, 'named');
INSERT INTO Roles (id, role) VALUES (12, 'app');
INSERT INTO Roles (id, role) VALUES (12, 'user');
INSERT INTO Roles (id, role) VALUES (12, 'named');