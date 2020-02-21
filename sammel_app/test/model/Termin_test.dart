import 'dart:convert';

import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:test/test.dart';

import 'Ort_test.dart';
import 'TerminDetails_test.dart';

void main() {
  group('serialisere', () {
    test('serialisiert Temin mit id, Beginn, Ende, Ort und ohne Details', () {
      expect(
          jsonEncode(Termin(
              1,
              DateTime(2020, 1, 2, 15, 0, 0),
              DateTime(2020, 1, 2, 18, 0, 0),
              Ort(15, 'Friedrichshain-Kreuzberg', 'Fhain - Nordkiez'),
              'Sammeln',
              52.52116,
              13.41331,
              null)),
          '{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez"},'
          '"typ":"Sammeln",'
          '"lattitude":52.52116,'
          '"longitude":13.41331,'
          '"details":null}');
    });

    test('serialisiert Temin mit id, Beginn, Ende, Ort und mit Details', () {
      expect(
          jsonEncode(Termin(
              1,
              DateTime(2020, 1, 2, 15, 0, 0),
              DateTime(2020, 1, 2, 18, 0, 0),
              Ort(15, "Friedrichshain-Kreuzberg", "Fhain - Nordkiez"),
              'Sammeln',
              52.52116,
              13.41331,
              TerminDetailsTestDaten.terminDetailsTestDaten())),
          '{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez"},'
          '"typ":"Sammeln",'
          '"lattitude":52.52116,'
          '"longitude":13.41331,'
          '"details":{'
          '"id":null,'
          '"treffpunkt":"Weltzeituhr",'
          '"kommentar":"Bringe Westen und Klämmbretter mit",'
          '"kontakt":"Ruft an unter 012345678"}'
          '}');
    });
  });
  group('deserialisiere', () {
    test('deserialisiert Temin mit id, Beginn, Ende, Ort und ohne Details', () {
      var termin = Termin.fromJson(jsonDecode('{'
          '"id":1,'
          '"beginn":"2020-01-02T15:00:00.000",'
          '"ende":"2020-01-02T18:00:00.000",'
          '"ort":{"id":15,"bezirk":"Friedrichshain-Kreuzberg","ort":"Fhain - Nordkiez"},'
          '"typ":"Sammeln",'
          '"lattitude":52.52116,'
          '"longitude":13.41331}'));
      expect(termin.id, 1);
      expect(termin.beginn, equals(DateTime(2020, 1, 2, 15, 0, 0)));
      expect(termin.ende, equals(DateTime(2020, 1, 2, 18, 0, 0)));
      expect(termin.typ, 'Sammeln');
      expect(termin.lattitude, 52.52116);
      expect(termin.longitude, 13.41331);
      expect(termin.ort.toString(),
          Ort(15, 'Friedrichshain-Kreuzberg', 'Fhain - Nordkiez').toString());
      expect(termin.details, isNull);
    });

    test('deserialisiert Temin mit Details', () {
      var termin = Termin.fromJson(jsonDecode(
          '{'
              '"beginn":"2020-02-05T09:00:00",'
              '"details":{'
              '"id":1,'
              '"kommentar":"wir stellen uns an die Ubhf-Eingänge. ihr erkennt mich an der DWE-Weste",'
              '"kontakt":"kalle@revo.de",'
              '"treffpunkt":"Weltzeituhr"},'
              '"ende":"2020-02-05T12:00:00",'
              '"id":1,'
              '"ort":{"bezirk":"Friedrichshain-Kreuzberg","id":1,"ort":"Friedrichshain Nordkiez"},'
              '"typ":"Sammeln"}'));
      expect(termin.details.treffpunkt, "Weltzeituhr");
      expect(termin.details.kommentar,
          "wir stellen uns an die Ubhf-Eingänge. ihr erkennt mich an der DWE-Weste");
      expect(termin.details.kontakt, "kalle@revo.de");
    });
  });

  test('compareByStart orders actions by Start value', () {
    var now = DateTime.now();
    var action1 = Termin(
        1,
        now,
        now.add(Duration(hours: 1)),
        goerli(),
        'Sammeln',
        52.52116,
        13.41331,
        null);
    var action2 = Termin(
        2,
        now.add(Duration(days: 1)),
        now.add(Duration(days: 1)).add(Duration(hours: 1)),
        nordkiez(),
        'Sammeln',
        52.52116,
        13.41331,
        null);
    var action3 = Termin(
        3,
        now.add(Duration(days: 365)),
        now.add(Duration(days: 365, hours: 1)),
        treptowerPark(),
        'Sammeln',
        52.52116,
        13.41331,
        null);
    var action4 = Termin(
        4,
        now.subtract(Duration(hours: 1)),
        now.add(Duration(hours: 1)),
        treptowerPark(),
        'Sammeln',
        52.52116,
        13.41331,
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
  });
}

class TerminTestDaten {
  static Termin einTermin() => Termin(
      0,
      DateTime(2019, 11, 4, 17, 9, 0),
      DateTime(2019, 11, 4, 18, 9, 0),
      nordkiez(),
      'Sammeln',
      52.52116,
      13.41331,
      null);

  static Termin anActionFrom(DateTime date) => Termin(
      0,
      date,
      date.add(Duration(hours: 1)),
      nordkiez(),
      'Sammeln',
      52.52116,
      13.41331,
      null);

  static einTerminMitDetails() => Termin(
      0,
      DateTime(2019, 11, 4, 17, 9, 0),
      DateTime(2019, 11, 4, 18, 9, 0),
      nordkiez(),
      'Sammeln',
      52.52116,
      13.41331,
      TerminDetailsTestDaten.terminDetailsTestDaten());
}
