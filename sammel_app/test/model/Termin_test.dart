import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/User.dart';
import 'package:test/test.dart';

import 'Ort_test.dart';
import 'TerminDetails_test.dart';

void main() {
  group('serialisere', () {
    test('serialisiert Temin ohne Teilnehmer oder Details', () {
      print(Termin(
              1,
              DateTime(2020, 1, 2, 15, 0, 0),
              DateTime(2020, 1, 2, 18, 0, 0),
              Ort(15, 'Friedrichshain-Kreuzberg', 'Fhain - Nordkiez', 52.49653,
                  13.43762),
              'Sammeln',
              52.52116,
              13.41331,
              [],
              null)
          .toJson());
      expect(
          jsonEncode(Termin(
              1,
              DateTime(2020, 1, 2, 15, 0, 0),
              DateTime(2020, 1, 2, 18, 0, 0),
              Ort(15, 'Friedrichshain-Kreuzberg', 'Fhain - Nordkiez', 52.49653,
                  13.43762),
              'Sammeln',
              52.52116,
              13.41331,
              null,
              null)),
          '{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez","lattitude":52.49653,"longitude":13.43762***REMOVED***,'
          '"typ":"Sammeln",'
          '"lattitude":52.52116,'
          '"longitude":13.41331,'
          '"participants":null,'
          '"details":null***REMOVED***');
    ***REMOVED***);
    test('serialisiert Temin mit Teilnehmer und ohne Details', () {
      expect(
          jsonEncode(Termin(
              1,
              DateTime(2020, 1, 2, 15, 0, 0),
              DateTime(2020, 1, 2, 18, 0, 0),
              Ort(15, 'Friedrichshain-Kreuzberg', 'Fhain - Nordkiez', 52.49653,
                  13.43762),
              'Sammeln',
              52.52116,
              13.41331,
              [],
              null)),
          '{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez","lattitude":52.49653,"longitude":13.43762***REMOVED***,'
          '"typ":"Sammeln",'
          '"lattitude":52.52116,'
          '"longitude":13.41331,'
          '"participants":[],'
          '"details":null***REMOVED***');
    ***REMOVED***);

    test('serialisiert Temin mit Teilnehmern und Details', () {
      expect(
          jsonEncode(Termin(
              1,
              DateTime(2020, 1, 2, 15, 0, 0),
              DateTime(2020, 1, 2, 18, 0, 0),
              Ort(15, "Friedrichshain-Kreuzberg", "Fhain - Nordkiez", 52.49653,
                  13.43762),
              'Sammeln',
              52.52116,
              13.41331,
              [karl()],
              TerminDetailsTestDaten.terminDetailsTestDaten())),
          '{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez","lattitude":52.49653,"longitude":13.43762***REMOVED***,'
          '"typ":"Sammeln",'
          '"lattitude":52.52116,'
          '"longitude":13.41331,'
          '"participants":[{"id":1,"name":"Karl Marx","color":4294198070***REMOVED***],'
          '"details":{'
          '"id":null,'
          '"treffpunkt":"Weltzeituhr",'
          '"kommentar":"Bringe Westen und Klämmbretter mit",'
          '"kontakt":"Ruft an unter 012345678"***REMOVED***'
          '***REMOVED***');
    ***REMOVED***);
  ***REMOVED***);
  group('deserialisiere', () {
    test('deserialisiert Temin ohne Teilnehmer und Details', () {
      var termin = Termin.fromJson(jsonDecode('{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez","lattitude":52.49653,"longitude":13.43762***REMOVED***,'
          '"typ":"Sammeln",'
          '"lattitude":52.52116,'
          '"longitude":13.41331***REMOVED***'));
      expect(termin.id, 1);
      expect(termin.beginn, equals(DateTime(2020, 1, 2, 15, 0, 0)));
      expect(termin.ende, equals(DateTime(2020, 1, 2, 18, 0, 0)));
      expect(termin.typ, 'Sammeln');
      expect(termin.latitude, 52.52116);
      expect(termin.longitude, 13.41331);
      expect(
          termin.ort.toString(),
          Ort(15, 'Friedrichshain-Kreuzberg', 'Fhain - Nordkiez', 52.49653,
                  13.43762)
              .toString());
      expect(termin.participants, isNull);
      expect(termin.details, isNull);
    ***REMOVED***);

    test('deserialisiert Temin mit Teilnehmer und Details', () {
      var termin = Termin.fromJson(jsonDecode('{'
          '"beginn":"2020-02-05T09:00:00",'
          '"participants":[{"id":1,"name":"Karl Marx", "color":4294198070***REMOVED***],'
          '"details":{'
          '"id":1,'
          '"kommentar":"wir stellen uns an die Ubhf-Eingänge. ihr erkennt mich an der DWE-Weste",'
          '"kontakt":"kalle@revo.de",'
          '"treffpunkt":"Weltzeituhr"***REMOVED***,'
          '"ende":"2020-02-05T12:00:00",'
          '"id":1,'
          '"ort":{"bezirk":"Friedrichshain-Kreuzberg","id":1,"ort":"Friedrichshain Nordkiez"***REMOVED***,'
          '"typ":"Sammeln"***REMOVED***'));
      expect(termin.details.treffpunkt, "Weltzeituhr");
      expect(termin.details.kommentar,
          "wir stellen uns an die Ubhf-Eingänge. ihr erkennt mich an der DWE-Weste");
      expect(termin.details.kontakt, "kalle@revo.de");
      expect(termin.participants.single.id, 1);
      expect(termin.participants.single.name, 'Karl Marx');
      expect(termin.participants.single.color.value, Colors.red.value);
    ***REMOVED***);
  ***REMOVED***);

  test('compareByStart orders actions by Start value', () {
    var now = DateTime.now();
    var action1 = Termin(1, now, now.add(Duration(hours: 1)), goerli(),
        'Sammeln', 52.52116, 13.41331, [], null);
    var action2 = Termin(
        2,
        now.add(Duration(days: 1)),
        now.add(Duration(days: 1)).add(Duration(hours: 1)),
        nordkiez(),
        'Sammeln',
        52.52116,
        13.41331,
        [],
        null);
    var action3 = Termin(
        3,
        now.add(Duration(days: 365)),
        now.add(Duration(days: 365, hours: 1)),
        treptowerPark(),
        'Sammeln',
        52.52116,
        13.41331,
        [],
        null);
    var action4 = Termin(
        4,
        now.subtract(Duration(hours: 1)),
        now.add(Duration(hours: 1)),
        treptowerPark(),
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
***REMOVED***

class TerminTestDaten {
  static Termin einTermin() => Termin(
      0,
      DateTime(2019, 11, 4, 17, 9, 0),
      DateTime(2019, 11, 4, 18, 9, 0),
      nordkiez(),
      'Sammeln',
      52.52116,
      13.41331,
      [],
      null);

  static Termin anActionFrom(DateTime date) => Termin(
      0,
      date,
      date.add(Duration(hours: 1)),
      nordkiez(),
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
      nordkiez(),
      'Sammeln',
      52.52116,
      13.41331,
      [],
      TerminDetailsTestDaten.terminDetailsTestDaten());
***REMOVED***

User karl() => User(1, 'Karl Marx', Colors.red);

User rosa() => User(2, 'Rosa Luxemburg', Colors.purple);
