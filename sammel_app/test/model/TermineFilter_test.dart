import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/TermineFilter.dart';

void main() {
  group('serialisere', () {
    test('serialisiert vollstaendigen TermineFilter', () {
      var filter = TermineFilter(
          ["Sammel-Termin", "Info-Veranstaltung"],
          [DateTime.now(), DateTime.now().add(Duration(days: 1))],
          Time(10, 0, 0),
          Time(22, 0, 0),
          [Ort(1, "bezirk1", "ort1"), Ort(1, "bezirk2", "ort2")]);

      var json = jsonEncode(filter);

      expect(json, '{'
          '"typen":["Sammel-Termin","Info-Veranstaltung"],'
          '"tage":[],"von":null,"bis":null,"orte":[]***REMOVED***');
    ***REMOVED***);

    test('serialisiert leeren TermineFilter', () {
      var leererFilter = TermineFilter.leererFilter();
      var json = jsonEncode(leererFilter);

      expect(json, '{"typen":[],"tage":[],"von":null,"bis":null,"orte":[]***REMOVED***');
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
