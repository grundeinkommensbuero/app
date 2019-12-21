import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

void main() {
  group('timeToString', () {
    test('ergaenzt 00 Sekunden', () {
      var string =
          ChronoHelfer.timeToStringHHmmss(TimeOfDay(hour: 1, minute: 2));
      expect(string.endsWith(":00"), true);
    ***REMOVED***);

    test('stellt Null voran', () {
      var string =
          ChronoHelfer.timeToStringHHmmss(TimeOfDay(hour: 1, minute: 2));
      expect(string, "01:02:00");
    ***REMOVED***);

    test('kommt mit Nullen klar', () {
      var string =
          ChronoHelfer.timeToStringHHmmss(TimeOfDay(hour: 0, minute: 0));
      expect(string, "00:00:00");
    ***REMOVED***);
  ***REMOVED***);
  group('formatDateOfDateTime', () {

    test('formats null', () {
      expect(ChronoHelfer.formatDateOfDateTime(null), '');
    ***REMOVED***);

    test('formats regular date', () {
      expect(
          ChronoHelfer.formatDateOfDateTime(DateTime(2019, 12, 21, 22, 23, 24)),
          'Samstag, 21. Dezember 2019');
    ***REMOVED***);

    test('formats date w/o time', () {
      expect(ChronoHelfer.formatDateOfDateTime(DateTime(2019, 12, 21)),
          'Samstag, 21. Dezember 2019');
    ***REMOVED***);
  ***REMOVED***);
  group('formatFromToOfDateTimes', () {
    test('formats regular times', () {
      expect(
          ChronoHelfer.formatFromToTimeOfDateTimes(
              DateTime(2019, 12, 21, 22, 26, 00),
              DateTime(2019, 12, 21, 23, 59, 12)),
          'von 22:26 bis 23:59 Uhr');
    ***REMOVED***);

    test('formats null times', () {
      expect(
          ChronoHelfer.formatFromToTimeOfDateTimes(
              null,
              DateTime(2019, 12, 21, 23, 59, 12)),
          '');
    expect(
          ChronoHelfer.formatFromToTimeOfDateTimes(
              DateTime(2019, 12, 21, 22, 26, 00),
              null),
          '');
    expect(
          ChronoHelfer.formatFromToTimeOfDateTimes(
              null,
              null),
          '');
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
