import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:test/test.dart';

import '../shared/TestdatenVorrat.dart';
import 'TerminDetails_test.dart';

void main() {
  group('serialisere', () {
    test('serialisiert Termin ohne Teilnehmer oder Details', () {
      expect(
          jsonEncode(Termin(
              1,
              DateTime(2020, 1, 2, 15, 0, 0),
              DateTime(2020, 1, 2, 18, 0, 0),
              ffAlleeNord(),
              'Sammeln',
              52.52116,
              13.41331,
              null,
              null)),
          '{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":"Frankfurter Allee Nord",'
          '"typ":"Sammeln",'
          '"latitude":52.52116,'
          '"longitude":13.41331,'
          '"participants":null,'
          '"details":null***REMOVED***');
    ***REMOVED***);
    test('serialisiert Termin mit Teilnehmer und ohne Details', () {
      expect(
          jsonEncode(Termin(
              1,
              DateTime(2020, 1, 2, 15, 0, 0),
              DateTime(2020, 1, 2, 18, 0, 0),
              ffAlleeNord(),
              'Sammeln',
              52.52116,
              13.41331,
              [],
              null)),
          '{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":"Frankfurter Allee Nord",'
          '"typ":"Sammeln",'
          '"latitude":52.52116,'
          '"longitude":13.41331,'
          '"participants":[],'
          '"details":null***REMOVED***');
    ***REMOVED***);

    test('serialisiert Termin mit Teilnehmern und Details', () {
      expect(
          jsonEncode(Termin(
              1,
              DateTime(2020, 1, 2, 15, 0, 0),
              DateTime(2020, 1, 2, 18, 0, 0),
              ffAlleeNord(),
              'Sammeln',
              52.52116,
              13.41331,
              [karl()],
              TerminDetailsTestDaten.terminDetailsTestDaten())),
          '{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":"Frankfurter Allee Nord",'
          '"typ":"Sammeln",'
          '"latitude":52.52116,'
          '"longitude":13.41331,'
          '"participants":[{"id":11,"name":"Karl Marx","color":4294198070***REMOVED***],'
          '"details":{'
          '"id":null,'
          '"treffpunkt":"Weltzeituhr",'
          '"beschreibung":"Bringe Westen und Klämmbretter mit",'
          '"kontakt":"Ruft an unter 012345678"***REMOVED***'
          '***REMOVED***');
    ***REMOVED***);

    test('serializes filled ActionWithToken', () {
      expect(
          jsonEncode(ActionWithToken(TerminTestDaten.einTermin(), 'Token')),
          '{'
          '"action":${jsonEncode(TerminTestDaten.einTermin())***REMOVED***,'
          '"token":"Token"'
          '***REMOVED***');
    ***REMOVED***);

    test('serializes empty ActionWithToken', () {
      expect(
          jsonEncode(ActionWithToken(null, null)),
          '{'
          '"action":null,'
          '"token":null'
          '***REMOVED***');
    ***REMOVED***);
  ***REMOVED***);
  group('deserialisiere', () {
    test('deserialisiert Termin ohne Teilnehmer und Details', () {
      var termin = Termin.fromJson(
          jsonDecode('{'
              '"id":1,'
              '"beginn":"2020-01-02T15:00:00.000",'
              '"ende":"2020-01-02T18:00:00.000",'
              '"ort":"Frankfurter Allee Nord",'
              '"typ":"Sammeln",'
              '"latitude":52.52116,'
              '"longitude":13.41331***REMOVED***'),
          [ffAlleeNord()].toSet());
      expect(termin.id, 1);
      expect(termin.beginn, equals(DateTime(2020, 1, 2, 15, 0, 0)));
      expect(termin.ende, equals(DateTime(2020, 1, 2, 18, 0, 0)));
      expect(termin.typ, 'Sammeln');
      expect(termin.latitude, 52.52116);
      expect(termin.longitude, 13.41331);
      expect(termin.ort.toString(), ffAlleeNord().toString());
      expect(termin.participants, isNull);
      expect(termin.details, isNull);
    ***REMOVED***);

    test('deserialisiert Termin mit Teilnehmer und Details', () {
      var termin = Termin.fromJson(
          jsonDecode('{'
              '"beginn":"2020-02-05T09:00:00",'
              '"participants":[{"id":11,"name":"Karl Marx", "color":4294198070***REMOVED***],'
              '"details":{'
              '"id":1,'
              '"beschreibung":"wir stellen uns an die Ubhf-Eingänge. ihr erkennt mich an der DWE-Weste",'
              '"kontakt":"kalle@revo.de",'
              '"treffpunkt":"Weltzeituhr"***REMOVED***,'
              '"ende":"2020-02-05T12:00:00",'
              '"id":1,'
              '"ort":"Frankfurter Allee Nord",'
              '"typ":"Sammeln"***REMOVED***'),
          [ffAlleeNord()].toSet());
      expect(termin.details?.treffpunkt, "Weltzeituhr");
      expect(termin.details?.beschreibung,
          "wir stellen uns an die Ubhf-Eingänge. ihr erkennt mich an der DWE-Weste");
      expect(termin.details?.kontakt, "kalle@revo.de");
      expect(termin.participants?.single.id, 11);
      expect(termin.participants?.single.name, 'Karl Marx');
      expect(termin.participants?.single.color?.value, Colors.red.value);
    ***REMOVED***);
  ***REMOVED***);

  test('compareByStart orders actions by Start value', () {
    var now = DateTime.now();
    var action1 = Termin(1, now, now.add(Duration(hours: 1)), tempVorstadt(),
        'Sammeln', 52.52116, 13.41331, [], null);
    var action2 = Termin(
        2,
        now.add(Duration(days: 1)),
        now.add(Duration(days: 1)).add(Duration(hours: 1)),
        ffAlleeNord(),
        'Sammeln',
        52.52116,
        13.41331,
        [],
        null);
    var action3 = Termin(
        3,
        now.add(Duration(days: 365)),
        now.add(Duration(days: 365, hours: 1)),
        plaenterwald(),
        'Sammeln',
        52.52116,
        13.41331,
        [],
        null);
    var action4 = Termin(
        4,
        now.subtract(Duration(hours: 1)),
        now.add(Duration(hours: 1)),
        plaenterwald(),
        'Sammeln',
        52.52116,
        13.41331,
        [],
        null);

    // same
    expect(Termin.compareByStart(action1, action1), 0);

    // first lesser then second
    expect(Termin.compareByStart(action1, action2), -1);

    // first greater then second
    expect(Termin.compareByStart(action2, action1), 1);

    // first lesser then second by a year
    expect(Termin.compareByStart(action1, action3), -1);

    // first lesser then second by start, but not by end
    expect(Termin.compareByStart(action4, action1), -1);
  ***REMOVED***);

  group('isEvaluated', () {
    test('returns true if action is in list and of type Sammeln', () {
      final sammeln = TerminTestDaten.einTermin()..typ = 'Sammeln';
      expect(sammeln.isEvaluated([0]), true);
    ***REMOVED***);

    test('returns false if list is Empty', () {
      final sammeln1 = TerminTestDaten.einTermin()..typ = 'Sammeln';
      expect(sammeln1.isEvaluated(null), false);

      final sammeln2 = TerminTestDaten.einTermin()..typ = 'Sammeln';
      expect(sammeln2.isEvaluated([]), false);
    ***REMOVED***);

    test('returns true for any Action that is not Sammeln', () {
      final infova = TerminTestDaten.einTermin()..typ = 'Infoveranstaltung';
      expect(infova.isEvaluated([infova.id!]), true);

      final ws = TerminTestDaten.einTermin()..typ = 'Workshop';
      expect(ws.isEvaluated([ws.id!]), true);

      final plakatieren = TerminTestDaten.einTermin()..typ = 'Plakatieren';
      expect(plakatieren.isEvaluated([plakatieren.id!]), true);
    ***REMOVED***);

    test('returns false if action is not in list', () {
      final sammeln = TerminTestDaten.einTermin()..typ = 'Sammeln';
      expect(sammeln.isEvaluated([1, 2, 3]), false);
    ***REMOVED***);
  ***REMOVED***);

  group('getAsset', () {
    var infoveranstaltung = TerminTestDaten.einTermin();

    test('returns asset icon path if exists', () {
      infoveranstaltung.typ = 'Infoveranstaltung';
      expect(
          infoveranstaltung.getAsset(), 'assets/images/Infoveranstaltung.png');
    ***REMOVED***);

    test('returns placeholder when type is unknown', () {
      infoveranstaltung.typ = 'Unbekannt';
      expect(infoveranstaltung.getAsset(centered: false),
          'assets/images/logo_transparent.png');
    ***REMOVED***);

    test('returns non-centered icon path', () {
      infoveranstaltung.typ = 'Sammeln';
      expect(infoveranstaltung.getAsset(centered: false),
          'assets/images/Sammeln.png');
    ***REMOVED***);

    test('returns centered icon path', () {
      infoveranstaltung.typ = 'Sammeln';
      expect(infoveranstaltung.getAsset(centered: true),
          'assets/images/Sammeln_centered.png');
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

class TerminTestDaten {
  static Termin einTermin() => Termin(
      0,
      DateTime(2019, 11, 4, 17, 9, 0),
      DateTime(2019, 11, 4, 18, 9, 0),
      ffAlleeNord(),
      'Sammeln',
      52.52116,
      13.41331,
      [],
      null);

  static Termin anActionFrom(DateTime date) => Termin(
      0,
      date,
      date.add(Duration(hours: 1)),
      ffAlleeNord(),
      'Sammeln',
      52.52116,
      13.41331,
      [],
      null);

  static Termin einTerminMitTeilisUndDetails() =>
      einTerminOhneTeilisMitDetails()..participants = [karl()];

  static Termin einTerminOhneTeilisMitDetails() => Termin(
      0,
      DateTime(2019, 11, 4, 17, 9, 0),
      DateTime(2019, 11, 4, 18, 9, 0),
      ffAlleeNord(),
      'Sammeln',
      52.52116,
      13.41331,
      [],
      TerminDetailsTestDaten.terminDetailsTestDaten());
***REMOVED***
