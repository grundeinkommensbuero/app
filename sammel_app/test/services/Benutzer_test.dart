import 'dart:convert';

import 'package:sammel_app/services/Benutzer.dart';
import 'package:test/test.dart';

void main() {
  group('serialisere', () {
    test('serialisiert Benutzer mit Name und Telefonnummer', () {
      expect(
          jsonEncode(Benutzer('Egon Olsen', '123')),
          '{"name":"Egon Olsen","telefonnummer":"123"***REMOVED***');
    ***REMOVED***);

    test('serialisiert Benutzer mit Name ohne Telefonnummer', () {
      expect(
          jsonEncode(Benutzer('Egon Olsen')),
          '{"name":"Egon Olsen","telefonnummer":null***REMOVED***');
    ***REMOVED***);

    test('serialisiert Benutzer ohne Name ohne Telefonnummer', () {
      expect(
          jsonEncode(Benutzer(null)),
          '{"name":null,"telefonnummer":null***REMOVED***');
    ***REMOVED***);
  ***REMOVED***);
  group('deserialisiere', () {
    test('deserialisiert Benutzer mit Name und Telefonnummer', () {
      var benutzer = Benutzer.fromJson(jsonDecode('{"name":"Egon Olsen","telefonnummer":"123"***REMOVED***'));
      expect(benutzer.name,'Egon Olsen');
      expect(benutzer.telefonnummer,'123');
    ***REMOVED***);

    test('deserialisiert Benutzer mit Name ohne Telefonnummer', () {
      var benutzer = Benutzer.fromJson(jsonDecode('{"name":"Egon Olsen","telefonnummer":null***REMOVED***'));
      expect(benutzer.name,'Egon Olsen');
      expect(benutzer.telefonnummer,null);
    ***REMOVED***);

    test('deserialisiert Benutzer ohne Name ohne Telefonnummer', () {
      var benutzer = Benutzer.fromJson(jsonDecode('{"name":null,"telefonnummer":null***REMOVED***'));
      expect(benutzer.name,null);
      expect(benutzer.telefonnummer,null);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***