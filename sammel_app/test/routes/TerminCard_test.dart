import 'dart:ui';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:test/test.dart';

import '../shared/mocks.trainer.dart';
import '../shared/TestdatenVorrat.dart';
import '../shared/mocks.mocks.dart';

void main() {
  trainTranslation(MockTranslations());
  initializeDateFormatting('en');

  group('erzeugeDatumZeile berechnet Dauer', () {
    test('korrekt', () {
      var datumText = TerminCard.erzeugeDatumText(
          DateTime(2019, 10, 30, 20), DateTime(2019, 10, 30, 23), Locale('de'));

      expect(datumText.substring(datumText.lastIndexOf(',') + 2),
          '3 Stunden.other');
    ***REMOVED***);

    test('und rundet ab', () {
      var datumText = TerminCard.erzeugeDatumText(
          DateTime(2019, 10, 30, 20, 55),
          DateTime(2019, 10, 30, 23, 54),
          Locale('de'));

      expect(
          datumText.substring(datumText.lastIndexOf(',') + 2), '2 Stunden.two');
    ***REMOVED***);

    test('und singularisiert bei einer Stunde', () {
      var datumText = TerminCard.erzeugeDatumText(
          DateTime(2019, 10, 30, 20), DateTime(2019, 10, 30, 21), Locale('de'));

      expect(
          datumText.substring(datumText.lastIndexOf(',') + 2), '1 Stunden.one');
    ***REMOVED***);

    test('und markiert Teiträume kleiner als 1 Stunde', () {
      var datumText = TerminCard.erzeugeDatumText(DateTime(2019, 10, 30, 20),
          DateTime(2019, 10, 30, 20, 30), Locale('de'));

      expect(datumText.substring(datumText.lastIndexOf(',') + 2),
          '< 1 Stunden.one');
    ***REMOVED***);
  ***REMOVED***);
  group('ermittlePrefix', () {
    test('ermittelt Heute richtig', () {
      var heute = DateTime(now().year, now().month, now().day, 20);
      var datumText = TerminCard.ermittlePrefix(heute, Locale('de'));

      expect(datumText.substring(0, datumText.indexOf(',')), 'Heute');
    ***REMOVED***);

    test('ermittelt Morgen richtig', () {
      var morgen = DateTime(now().year, now().month, now().day, 20)
          .add(Duration(days: 1));
      var datumText = TerminCard.ermittlePrefix(morgen, Locale('de'));

      expect(datumText.substring(0, datumText.indexOf(',')), 'Morgen');
    ***REMOVED***);

    test('gibt Wochentag an für übermorgen bis in 7 Tagen', () {
      var spaeter = DateTime(now().year, now().month, now().day, 20)
          .add(Duration(days: 2));
      var datumText = TerminCard.ermittlePrefix(spaeter, Locale('de'));

      expect(datumText.substring(0, datumText.indexOf(',')),
          DateFormat.EEEE('de').format(spaeter));
      spaeter = DateTime(now().year, now().month, now().day, 20)
          .add(Duration(days: 7));
      datumText = TerminCard.ermittlePrefix(spaeter, Locale('de'));

      expect(datumText.substring(0, datumText.indexOf(',')),
          DateFormat.EEEE('de').format(spaeter));
    ***REMOVED***);
  ***REMOVED***);
  group('erzeugeOrtText', () {
    test('konkateniert Bezirk und Ort', () {
      var text = TerminCard.erzeugeOrtText(ffAlleeNord());

      expect(text, 'Friedrichshain Ost, Frankfurter Allee Nord');
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

DateTime now() => DateTime.now();
