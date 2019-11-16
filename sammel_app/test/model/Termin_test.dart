import 'dart:convert';

import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/Benutzer.dart';
import 'package:test/test.dart';

import '../routes/TerminCard_test.dart';
import 'TerminDetails_test.dart';

void main() {
  group('serialisere', () {
    test(
        'serialisiert Temin mit id, Beginn, Ende, Ort, leerer Teilnehmerliste und ohne Details',
        () {
      expect(
          jsonEncode(Termin(
              1,
              DateTime(2020, 1, 2, 15, 0, 0),
              DateTime(2020, 1, 2, 18, 0, 0),
              Ort(15, 'Friedrichshain-Kreuzberg', 'Fhain - Nordkiez'),
              'Sammel-Termin',
              [],
              null)),
          '{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez"},'
          '"typ":"Sammel-Termin",'
          '"teilnehmer":[],'
          '"terminDetails":null}');
    });

    test(
        'serialisiert Temin mit id, Beginn, Ende, Ort, mit Teilnehmerliste und ohne Details',
        () {
      expect(
          jsonEncode(Termin(
              1,
              DateTime(2020, 1, 2, 15, 0, 0),
              DateTime(2020, 1, 2, 18, 0, 0),
              Ort(15, "Friedrichshain-Kreuzberg", "Fhain - Nordkiez"),
              'Sammel-Termin',
              [
                Benutzer("Karla Kolumna", "01456972524"),
                Benutzer("D0min4tor_1337")
              ],
              null)),
          '{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez"},'
          '"typ":"Sammel-Termin",'
          '"teilnehmer":['
          '{"name":"Karla Kolumna","telefonnummer":"01456972524"},'
          '{"name":"D0min4tor_1337","telefonnummer":null}],'
          '"terminDetails":null}');
    });

    test(
        'serialisiert Temin mit id, Beginn, Ende, Ort, mit Teilnehmerliste und mit Details',
        () {
      expect(
          jsonEncode(Termin(
              1,
              DateTime(2020, 1, 2, 15, 0, 0),
              DateTime(2020, 1, 2, 18, 0, 0),
              Ort(15, "Friedrichshain-Kreuzberg", "Fhain - Nordkiez"),
              'Sammel-Termin',
              [
                Benutzer("Karla Kolumna", "01456972524"),
                Benutzer("D0min4tor_1337")
              ],
              TerminDetailsTestDaten.terminDetailsTestDaten())),
          '{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez"},'
          '"typ":"Sammel-Termin",'
          '"teilnehmer":['
          '{"name":"Karla Kolumna","telefonnummer":"01456972524"},'
          '{"name":"D0min4tor_1337","telefonnummer":null}],'
          '"terminDetails":{"treffpunkt":"Weltzeituhr",'
          '"kommentar":"Bringe Westen und Klämmbretter mit",'
          '"kontakt":"Ruft an unter 012345678"}'
          '}');
    });
  });
  group('deserialisiere', () {
    test(
        'deserialisiert Temin mit id, Beginn, Ende, Ort und ohne Teilnehmerliste',
        () {
      var termin = Termin.fromJson(jsonDecode('{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez"},'
          '"typ":"Sammel-Termin",'
          '"teilnehmer":[]}'));
      expect(termin.id, 1);
      expect(termin.beginn, equals(DateTime(2020, 1, 2, 15, 0, 0)));
      expect(termin.ende, equals(DateTime(2020, 1, 2, 18, 0, 0)));
      expect(termin.typ, 'Sammel-Termin');
      expect(termin.ort.toString(),
          Ort(15, 'Friedrichshain-Kreuzberg', 'Fhain - Nordkiez').toString());
      expect(termin.teilnehmer, []);
    });

    test(
        'deserialisiert Temin mit id, Beginn, Ende, Ort und mit Teilnehmerliste',
        () {
      var termin = Termin.fromJson(jsonDecode('{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez"},'
          '"typ":"Sammel-Termin",'
          '"teilnehmer":['
          '{"name":"Karla Kolumna","telefonnummer":"01456972524"},'
          '{"name":"D0min4tor_1337","telefonnummer":null}]}'));
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
    });

    test('deserialisiert Temin mit Details', () {
      var termin = Termin.fromJson(jsonDecode('{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez"},'
          '"typ":"Sammel-Termin",'
          '"teilnehmer":['
          '{"name":"Karla Kolumna","telefonnummer":"01456972524"},'
          '{"name":"D0min4tor_1337","telefonnummer":null}],'
          '"terminDetails":{"treffpunkt":"Weltzeituhr",'
          '"kommentar":"Ich bringe Westen und Klämbretter mit",'
          '"kontakt":"Ruft mich an unter 01234567"}'
          '}'));
      expect(termin.terminDetails.treffpunkt, "Weltzeituhr");
      expect(termin.terminDetails.kommentar,
          "Ich bringe Westen und Klämbretter mit");
      expect(termin.terminDetails.kontakt, "Ruft mich an unter 01234567");
    });
  });
}

class TerminTestDaten {
  static Termin terminOhneTeilnehmer() => Termin(
      0,
      DateTime(2019, 11, 4, 17, 9, 0),
      DateTime(2019, 11, 4, 18, 9, 0),
      nordkiez(),
      'Sammel-Termin',
      [],
      TerminDetailsTestDaten.terminDetailsTestDaten());
}
