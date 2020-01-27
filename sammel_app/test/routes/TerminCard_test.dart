import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:test/test.dart';

import '../model/Ort_test.dart';

void main() {
  group('erzeugeDatumZeile berechnet Dauer', () {
    test('korrekt', () {
      var datumText = TerminCard.erzeugeDatumText(
          DateTime(2019, 10, 30, 20), DateTime(2019, 10, 30, 23));

      expect(datumText.substring(datumText.lastIndexOf(',') + 2), '3 Stunden');
    ***REMOVED***);

    test('und rundet ab', () {
      var datumText = TerminCard.erzeugeDatumText(
          DateTime(2019, 10, 30, 20, 55), DateTime(2019, 10, 30, 23, 54));

      expect(datumText.substring(datumText.lastIndexOf(',') + 2), '2 Stunden');
    ***REMOVED***);

    test('und singularisiert bei einer Stunde', () {
      var datumText = TerminCard.erzeugeDatumText(
          DateTime(2019, 10, 30, 20), DateTime(2019, 10, 30, 21));

      expect(datumText.substring(datumText.lastIndexOf(',') + 2), '1 Stunde');
    ***REMOVED***);
  ***REMOVED***);
  group('ermittlePrefix', () {
    test('ermittelt Heute richtig', () {
      var heute = DateTime(now().year, now().month, now().day, 20);
      var datumText = TerminCard.ermittlePrefix(heute);

      expect(datumText.substring(0, datumText.indexOf(',')), 'Heute');
    ***REMOVED***);

    test('ermittelt Morgen richtig', () {
      var morgen = DateTime(now().year, now().month, now().day, 20)
          .add(Duration(days: 1));
      var datumText = TerminCard.ermittlePrefix(morgen);

      expect(datumText.substring(0, datumText.indexOf(',')), 'Morgen');
    ***REMOVED***);

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
    ***REMOVED***);
  ***REMOVED***);
  group('faerbeVergangeneTermine', () {
    test('colors past actions', () {
      DateTime gestern = DateTime.now().subtract(Duration(days: 1));
      expect(TerminCard.actionColor(gestern, false),
          equals(DweTheme.yellowBright));

      DateTime vor1Stunde = DateTime.now().subtract(Duration(hours: 1));
      expect(TerminCard.actionColor(vor1Stunde, false),
          equals(DweTheme.yellowBright));

      DateTime vor1Minute = DateTime.now().subtract(Duration(minutes: 1));
      expect(TerminCard.actionColor(vor1Minute, false),
          equals(DweTheme.yellowBright));
    ***REMOVED***);

    test('colors future actions', () {
      DateTime morgen = DateTime.now().add(Duration(days: 1));
      expect(TerminCard.actionColor(morgen, false),
          equals(DweTheme.yellowLight));

      DateTime in1Stunde = DateTime.now().add(Duration(hours: 1));
      expect(TerminCard.actionColor(in1Stunde, false),
          equals(DweTheme.yellowLight));

      DateTime in1Minute = DateTime.now().add(Duration(minutes: 1));
      expect(TerminCard.actionColor(in1Minute, false),
          equals(DweTheme.yellowLight));
    ***REMOVED***);
    test('colors own past actions', () {
      DateTime gestern = DateTime.now().subtract(Duration(days: 1));
      expect(TerminCard.actionColor(gestern, true),
          equals(DweTheme.greenLight));

      DateTime vor1Stunde = DateTime.now().subtract(Duration(hours: 1));
      expect(TerminCard.actionColor(vor1Stunde, true),
          equals(DweTheme.greenLight));

      DateTime vor1Minute = DateTime.now().subtract(Duration(minutes: 1));
      expect(TerminCard.actionColor(vor1Minute, true),
          equals(DweTheme.greenLight));
    ***REMOVED***);

    test('colors own future actions', () {
      DateTime morgen = DateTime.now().add(Duration(days: 1));
      expect(TerminCard.actionColor(morgen, true),
          equals(DweTheme.green));

      DateTime in1Stunde = DateTime.now().add(Duration(hours: 1));
      expect(TerminCard.actionColor(in1Stunde, true),
          equals(DweTheme.green));

      DateTime in1Minute = DateTime.now().add(Duration(minutes: 1));
      expect(TerminCard.actionColor(in1Minute, true),
          equals(DweTheme.green));
    ***REMOVED***);
  ***REMOVED***);
  group('erzeugeOrtText', () {
    test('konkateniert Bezirk und Ort', () {
      var text = TerminCard.erzeugeOrtText(nordkiez());

      expect(text, 'Friedrichshain-Kreuzberg, Friedrichshain Nordkiez');
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

DateTime now() => DateTime.now();