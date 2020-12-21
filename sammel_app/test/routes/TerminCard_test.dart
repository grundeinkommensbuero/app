import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:test/test.dart';

import '../shared/TestdatenVorrat.dart';

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
  group('erzeugeOrtText', () {
    test('konkateniert Bezirk und Ort', () {
      var text = TerminCard.erzeugeOrtText(ffAlleeNord());

      expect(text, 'Friedrichshain-Kreuzberg, Frankfurter Allee Nord');
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

DateTime now() => DateTime.now();