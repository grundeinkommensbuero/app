import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:test/test.dart';

void main() {
  group('erzeugeDatumZeile berechnet Dauer', () {
    test('korrekt', () {
      var datumText = TerminCard.erzeugeDatumText(
          DateTime(2019, 10, 30, 20), DateTime(2019, 10, 30, 23));

      expect(datumText.substring(datumText.lastIndexOf(',') + 2), '3 Stunden');
    });

    test('und rundet ab', () {
      var datumText = TerminCard.erzeugeDatumText(
          DateTime(2019, 10, 30, 20, 55), DateTime(2019, 10, 30, 23, 54));

      expect(datumText.substring(datumText.lastIndexOf(',') + 2), '2 Stunden');
    });

    test('und singularisiert bei einer Stunde', () {
      var datumText = TerminCard.erzeugeDatumText(
          DateTime(2019, 10, 30, 20), DateTime(2019, 10, 30, 21));

      expect(datumText.substring(datumText.lastIndexOf(',') + 2), '1 Stunde');
    });
  });
  group('ermittlePrefix', () {
    test('ermittelt Heute richtig', () {
      var heute = DateTime(now().year, now().month, now().day, 20);
      var datumText = TerminCard.ermittlePrefix(heute);

      expect(datumText.substring(0, datumText.indexOf(',')), 'Heute');
    });

    test('ermittelt Morgen richtig', () {
      var morgen = DateTime(now().year, now().month, now().day, 20)
          .add(Duration(days: 1));
      var datumText = TerminCard.ermittlePrefix(morgen);

      expect(datumText.substring(0, datumText.indexOf(',')), 'Morgen');
    });

    test('gibt Wochentag an für übermorgen bis in 7 Tagen', () {
      var spaeter = DateTime(now().year, now().month, now().day, 20)
          .add(Duration(days: 2));
      var datumText = TerminCard.ermittlePrefix(spaeter);

      expect(datumText.substring(0, datumText.indexOf(',')),
          ChronoHelfer.wochentag(spaeter));
      spaeter = DateTime(now().year, now().month, now().day, 20)
          .add(Duration(days: 7));
      datumText = TerminCard.ermittlePrefix(spaeter);

      expect(datumText.substring(0, datumText.indexOf(',')),
          ChronoHelfer.wochentag(spaeter));
    });
  });
  group('faerbeVergangeneTermine', () {
    test('faerbt vergangene Termine hellgelb', () {
      DateTime gestern = DateTime.now().subtract(Duration(days: 1));
      expect(TerminCard.faerbeVergangeneTermine(gestern),
          equals(DweTheme.yellowLight));

      DateTime vor1Stunde = DateTime.now().subtract(Duration(hours: 1));
      expect(TerminCard.faerbeVergangeneTermine(vor1Stunde),
          equals(DweTheme.yellowLight));

      DateTime vor1Minute = DateTime.now().subtract(Duration(minutes: 1));
      expect(TerminCard.faerbeVergangeneTermine(vor1Minute),
          equals(DweTheme.yellowLight));
    });

    test('faerbt zukünftige Termine dunkelgelb', () {
      DateTime morgen = DateTime.now().add(Duration(days: 1));
      expect(TerminCard.faerbeVergangeneTermine(morgen),
          equals(DweTheme.yellowLight));

      DateTime in1Stunde = DateTime.now().add(Duration(hours: 1));
      expect(TerminCard.faerbeVergangeneTermine(in1Stunde),
          equals(DweTheme.yellowLight));

      DateTime in1Minute = DateTime.now().add(Duration(minutes: 1));
      expect(TerminCard.faerbeVergangeneTermine(in1Minute),
          equals(DweTheme.yellowLight));
    });
  });
  group('erzeugeOrtText', () {
    test('konkateniert Bezirk und Ort', () {
      var text = TerminCard.erzeugeOrtText(nordkiez());

      expect(text, 'Friedrichshain-Kreuzberg, Friedrichshain Nordkiez');
    });
  });
}

DateTime now() => DateTime.now();

Ort nordkiez() => Ort(0, "Friedrichshain-Kreuzberg", "Friedrichshain Nordkiez");