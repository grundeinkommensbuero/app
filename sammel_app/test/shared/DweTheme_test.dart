import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/shared/DweTheme.dart';

void main() {
  group('faerbeVergangeneTermine', () {
    test('colors past actions', () {
      DateTime gestern = DateTime.now().subtract(Duration(days: 1));
      expect(DweTheme.actionColor(gestern, false, false),
          equals(DweTheme.yellowBright));

      DateTime vor1Stunde = DateTime.now().subtract(Duration(hours: 1));
      expect(DweTheme.actionColor(vor1Stunde, false, false),
          equals(DweTheme.yellowBright));

      DateTime vor1Minute = DateTime.now().subtract(Duration(minutes: 1));
      expect(DweTheme.actionColor(vor1Minute, false, false),
          equals(DweTheme.yellowBright));
    ***REMOVED***);

    test('colors future actions', () {
      DateTime morgen = DateTime.now().add(Duration(days: 1));
      expect(DweTheme.actionColor(morgen, false, false),
          equals(DweTheme.yellowLight));

      DateTime in1Stunde = DateTime.now().add(Duration(hours: 1));
      expect(DweTheme.actionColor(in1Stunde, false, false),
          equals(DweTheme.yellowLight));

      DateTime in1Minute = DateTime.now().add(Duration(minutes: 1));
      expect(DweTheme.actionColor(in1Minute, false, false),
          equals(DweTheme.yellowLight));
    ***REMOVED***);

    test('colors own past actions', () {
      DateTime gestern = DateTime.now().subtract(Duration(days: 1));
      expect(DweTheme.actionColor(gestern, true, true),
          equals(DweTheme.blueBright));

      DateTime vor1Stunde = DateTime.now().subtract(Duration(hours: 1));
      expect(DweTheme.actionColor(vor1Stunde, true, true),
          equals(DweTheme.blueBright));

      DateTime vor1Minute = DateTime.now().subtract(Duration(minutes: 1));
      expect(DweTheme.actionColor(vor1Minute, true, true),
          equals(DweTheme.blueBright));
    ***REMOVED***);

    test('colors own future actions', () {
      DateTime morgen = DateTime.now().add(Duration(days: 1));
      expect(DweTheme.actionColor(morgen, true, true),
          equals(DweTheme.blueLight));

      DateTime in1Stunde = DateTime.now().add(Duration(hours: 1));
      expect(DweTheme.actionColor(in1Stunde, true, true),
          equals(DweTheme.blueLight));

      DateTime in1Minute = DateTime.now().add(Duration(minutes: 1));
      expect(DweTheme.actionColor(in1Minute, true, true),
          equals(DweTheme.blueLight));
    ***REMOVED***);

    test('colors participating past actions', () {
      DateTime gestern = DateTime.now().subtract(Duration(days: 1));
      expect(DweTheme.actionColor(gestern, false, true),
          equals(DweTheme.greenLight));

      DateTime vor1Stunde = DateTime.now().subtract(Duration(hours: 1));
      expect(DweTheme.actionColor(vor1Stunde, false, true),
          equals(DweTheme.greenLight));

      DateTime vor1Minute = DateTime.now().subtract(Duration(minutes: 1));
      expect(DweTheme.actionColor(vor1Minute, false, true),
          equals(DweTheme.greenLight));
    ***REMOVED***);

    test('colors participating future actions', () {
      DateTime morgen = DateTime.now().add(Duration(days: 1));
      expect(DweTheme.actionColor(morgen, false, true),
          equals(DweTheme.green));

      DateTime in1Stunde = DateTime.now().add(Duration(hours: 1));
      expect(DweTheme.actionColor(in1Stunde, false, true),
          equals(DweTheme.green));

      DateTime in1Minute = DateTime.now().add(Duration(minutes: 1));
      expect(DweTheme.actionColor(in1Minute, false, true),
          equals(DweTheme.green));
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
