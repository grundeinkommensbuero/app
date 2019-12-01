import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

void main() {
  group('timeToString', () {

    test('ergaenzt 00 Sekunden', () {
      var string = ChronoHelfer.timeToString(TimeOfDay(hour: 1, minute: 2));
      expect(string.endsWith(":00"), true);
    ***REMOVED***);

    test('stellt Null voran', () {
      var string = ChronoHelfer.timeToString(TimeOfDay(hour: 1, minute: 2));
      expect(string, "01:02:00");
    ***REMOVED***);

    test('kommt mit Nullen klar', () {
      var string = ChronoHelfer.timeToString(TimeOfDay(hour: 0, minute: 0));
      expect(string, "00:00:00");
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
