import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/Benutzer.dart';
import 'package:test/test.dart';

import '../routes/TerminCard_test.dart';

void main() {
  group('serialisere', () {
    test(
        'serialisiert Temin mit id, Beginn, Ende, Ort und leerer Teilnehmerliste',
        () {
      expect(
          jsonEncode(Termin(
              1,
              DateTime(2020, 1, 2, 15, 0, 0),
              DateTime(2020, 1, 2, 18, 0, 0),
              Ort(15, 'Friedrichshain-Kreuzberg', 'Fhain - Nordkiez'),
              'Sammel-Termin', [])),
          '{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez"***REMOVED***,'
          '"typ":"Sammel-Termin",'
          '"teilnehmer":[]***REMOVED***');
    ***REMOVED***);

    test('serialisiert Temin mit id, Beginn, Ende, Ort und Teilnehmerliste',
        () {
      expect(
          jsonEncode(Termin(
              1,
              DateTime(2020, 1, 2, 15, 0, 0),
              DateTime(2020, 1, 2, 18, 0, 0),
              Ort(15, "Friedrichshain-Kreuzberg", "Fhain - Nordkiez"),
              'Sammel-Termin', [
            Benutzer("Karla Kolumna", "01456972524"),
            Benutzer("D0min4tor_1337")
          ])),
          '{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez"***REMOVED***,'
          '"typ":"Sammel-Termin",'
          '"teilnehmer":['
          '{"name":"Karla Kolumna","telefonnummer":"01456972524"***REMOVED***,'
          '{"name":"D0min4tor_1337","telefonnummer":null***REMOVED***]***REMOVED***');
    ***REMOVED***);
  ***REMOVED***);
  group('deserialisiere', () {
    test(
        'deserialisiert Temin mit id, Beginn, Ende, Ort und ohne Teilnehmerliste',
        () {
      var termin = Termin.fromJson(jsonDecode('{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez"***REMOVED***,'
          '"typ":"Sammel-Termin",'
          '"teilnehmer":[]***REMOVED***'));
      expect(termin.id, 1);
      expect(termin.beginn, equals(DateTime(2020, 1, 2, 15, 0, 0)));
      expect(termin.ende, equals(DateTime(2020, 1, 2, 18, 0, 0)));
      expect(termin.typ, 'Sammel-Termin');
      expect(termin.ort.toString(),
          Ort(15, 'Friedrichshain-Kreuzberg', 'Fhain - Nordkiez').toString());
      expect(termin.teilnehmer, []);
    ***REMOVED***);

    test(
        'deserialisiert Temin mit id, Beginn, Ende, Ort und mit Teilnehmerliste',
        () {
      var termin = Termin.fromJson(jsonDecode('{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez"***REMOVED***,'
          '"typ":"Sammel-Termin",'
          '"teilnehmer":['
          '{"name":"Karla Kolumna","telefonnummer":"01456972524"***REMOVED***,'
          '{"name":"D0min4tor_1337","telefonnummer":null***REMOVED***]***REMOVED***'));
      expect(termin.id, 1);
      expect(termin.beginn, equals(DateTime(2020, 1, 2, 15, 0, 0)));
      expect(termin.ende, equals(DateTime(2020, 1, 2, 18, 0, 0)));
      expect(termin.ort.toString(),
          Ort(15, 'Friedrichshain-Kreuzberg', 'Fhain - Nordkiez').toString());
      expect(termin.typ, 'Sammel-Termin');
      expect(termin.teilnehmer.length, 2);
      expect(termin.teilnehmer[0].toString(),
          Benutzer("Karla Kolumna", "01456972524").toString());
      expect(termin.teilnehmer[1].toString(),
          Benutzer("D0min4tor_1337").toString());
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

class TerminTestDaten {
  static Termin terminOhneTeilnehmer() => Termin(0, DateTime(2019, 11, 4, 17, 9, 0),
      DateTime(2019, 11, 4, 18, 9, 0), nordkiez(), 'Sammel-Termin', []);
***REMOVED***
