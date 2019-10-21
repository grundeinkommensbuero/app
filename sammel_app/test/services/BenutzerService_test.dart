import 'dart:convert';

import 'package:sammel_app/services/Benutzer.dart';
import 'package:sammel_app/services/BenutzerService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:test/test.dart';

void main() {
  group('Login', () {
    test('Constructor mitName erzeugt Login-Instanz mit Benutzer', () {
      var login = Login.ausName('name', 'passwort');
      expect(login.benutzer, isNotNull);
      expect(login.benutzer.name, 'name');
    ***REMOVED***);
  ***REMOVED***);

  test('serialisiert Benutzer-Unterobjekt korrekt', () {
    var json = jsonEncode(Login(Benutzer('name'), 'passwort'));
    expect(json,
        '{"benutzer":{"name":"name","telefonnummer":null***REMOVED***,"passwortHash":"passwort"***REMOVED***');
  ***REMOVED***);

  group('DemoBenutzerService', () {
    test('authentifiziert korrekten Login', () async {
      var testBenutzerService = DemoBenutzerService();
      Authentifizierung ergebnis =
          await testBenutzerService.authentifziereBenutzer(
              Login(Benutzer('Karl Marx'), 'Expropriation!'));
      expect(ergebnis.erfolgreich, true);
    ***REMOVED***);

    test('weist falschen Login zurück', () async {
      var testBenutzerService = DemoBenutzerService();
      Authentifizierung ergebnis =
          await testBenutzerService.authentifziereBenutzer(
              Login(Benutzer('Rosa Luxemburg'), 'Alles andere ist Quark'));
      expect(ergebnis.erfolgreich, false);
    ***REMOVED***);

    test('legt Benutzer an', () async {
      var testBenutzerService = DemoBenutzerService();
      Authentifizierung ergebnis =
          await testBenutzerService.authentifziereBenutzer(
              Login(Benutzer('Antonio Gramsci'), 'Organische Intellektuelle'));
      expect(ergebnis.erfolgreich, false);
      testBenutzerService.legeBenutzerAn(
          Login(Benutzer('Antonio Gramsci'), 'Organische Intellektuelle'));
      ergebnis = await testBenutzerService.authentifziereBenutzer(
          Login(Benutzer('Antonio Gramsci'), 'Organische Intellektuelle'));
      expect(ergebnis.erfolgreich, true);
    ***REMOVED***);
    group('DemoTermineService', () {
      test('liefert Termine aus', () async {
        var demoTermineService = DemoTermineService();
        var ergebnis = await demoTermineService.ladeTermine();
        expect(ergebnis.isNotEmpty, true);
      ***REMOVED***);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
