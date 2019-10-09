import 'dart:convert';

import 'package:sammel_app/services/Benutzer.dart';
import 'package:sammel_app/services/BenutzerService.dart';
import 'package:test/test.dart';

void main() {
  group('Login', () {
    test('Constructor mitName erzeugt Login-Instanz mit Benutzer', () {
      var login = Login.ausName('name', 'passwort');
      expect(login.benutzer, isNotNull);
      expect(login.benutzer.name, 'name');
    });
  });

  test('serialisiert Benutzer-Unterobjekt korrekt', () {
    var json = jsonEncode(Login(Benutzer('name'), 'passwort'));
    expect(json,
        '{"benutzer":{"name":"name","telefonnummer":null},"passwortHash":"passwort"}');
  });
}
