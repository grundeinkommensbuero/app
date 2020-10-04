INSERT INTO Benutzer (id, name, color) VALUES (1, 'Karl Marx', 4294198070);
INSERT INTO Benutzer (id, name, color) VALUES (2, 'Rosa Luxemburg', 4288423856);

# Secret ac430960-05eb-11eb-8a26-fdc7683a84bc
INSERT INTO Credentials (id, secret, salt, iterations, firebasekey) VALUES (1, '90818603d7da23266d968f0c526850f13bc50e0610aca3', '57fdb727bd21f83e3594f0a0da384492', 10, 'AAAAAAAA');
# Secret 76f19030-05ee-11eb-afef-a5be559f6b58
INSERT INTO Credentials (id, secret, salt, iterations, firebasekey) VALUES (2, '7deda08f740e1c27f50e1ce5749fe36f50fe61e53be7b1', '527d86a9d319f00b72af9a9bf554df76', 10, 'BBBBBBBB');

INSERT INTO Roles (id, role) VALUES (1, 'user')
INSERT INTO Roles (id, role) VALUES (2, 'named_user')