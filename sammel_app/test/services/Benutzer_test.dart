import 'dart:convert';

import 'package:sammel_app/services/Benutzer.dart';
import 'package:test/test.dart';

void main() {
  group('serialisere', () {
    test('serialisiert Benutzer mit Name und Telefonnummer', () {
      expect(
          jsonEncode(Benutzer('Egon Olsen', '123')),
          '{"name":"Egon Olsen","telefonnummer":"123"}');
    });

    test('serialisiert Benutzer mit Name ohne Telefonnummer', () {
      expect(
          jsonEncode(Benutzer('Egon Olsen')),
          '{"name":"Egon Olsen","telefonnummer":null}');
    });

    test('serialisiert Benutzer ohne Name ohne Telefonnummer', () {
      expect(
          jsonEncode(Benutzer(null)),
          '{"name":null,"telefonnummer":null}');
    });
  });
  group('deserialisiere', () {
    test('deserialisiert Benutzer mit Name und Telefonnummer', () {
      var benutzer = Benutzer.fromJson(jsonDecode('{"name":"Egon Olsen","telefonnummer":"123"}'));
      expect(benutzer.name,'Egon Olsen');
      expect(benutzer.telefonnummer,'123');
    });

    test('deserialisiert Benutzer mit Name ohne Telefonnummer', () {
      var benutzer = Benutzer.fromJson(jsonDecode('{"name":"Egon Olsen","telefonnummer":null}'));
      expect(benutzer.name,'Egon Olsen');
      expect(benutzer.telefonnummer,'');
    });

    test('deserialisiert Benutzer ohne Name ohne Telefonnummer', () {
      var benutzer = Benutzer.fromJson(jsonDecode('{"name":null,"telefonnummer":null}'));
      expect(benutzer.name,'Anonym');
      expect(benutzer.telefonnummer,'');
    });
  });
}