import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/TermineFilter.dart';

void main() {
  group('serialisere', () {
    test('serialisiert leeren TermineFilter', () {
      expect(jsonEncode(TermineFilter.leererFilter()),
          '{"typen":[],"tage":[],"von":null,"bis":null,"orte":[],"nurEigene":false,"immerEigene":true}');
    });

    test('serialisiert gefuellten TermineFilter', () {
      expect(
          jsonEncode(TermineFilter(
              ["Sammeln", "Infoveranstaltung"],
              [DateTime(2019, 11, 22, 0, 0, 0), DateTime(2019, 1, 30, 0, 0, 0)],
              TimeOfDay(hour: 4, minute: 10),
              TimeOfDay(hour: 23, minute: 0),
              ['Frankfurter Allee Süd'],
              true,
              false)),
          '{'
          '"typen":["Sammeln","Infoveranstaltung"],'
          '"tage":["2019-11-22","2019-01-30"],'
          '"von":"04:10:00",'
          '"bis":"23:00:00",'
          '"orte":["Frankfurter Allee Süd"],'
          '"nurEigene":true,'
          '"immerEigene":false'
          '}');
    });
  });
  group("deserialisiere", () {
    test("deserialisert leeren TermineFilter", () {
      var termineFilter = TermineFilter.fromJSON(jsonDecode('{'
          '"typen":[],'
          '"tage":[],'
          '"von":null,'
          '"bis":null,'
          '"orte":[]'
          '}'));
      expect(termineFilter.typen.length, 0);
      expect(termineFilter.tage.length, 0);
      expect(termineFilter.von, null);
      expect(termineFilter.bis, null);
      expect(termineFilter.orte.length, 0);
    });
    test("deserialisert gefuellten TermineFilter", () {
      var termineFilter = TermineFilter.fromJSON(jsonDecode('{'
          '"typen":["Sammeln","Infoveranstaltung"],'
          '"tage":["2019-11-22","2019-01-02"],'
          '"von":"23:59:00",'
          '"bis":"01:02:00",'
          '"orte":["Frankfurter Allee Nord"]'
          '}'));
      expect(termineFilter.typen.length, 2);
      expect(termineFilter.typen[0], "Sammeln");
      expect(termineFilter.typen[1], "Infoveranstaltung");
      expect(termineFilter.tage.length, 2);
      expect([
        termineFilter.tage[0].day,
        termineFilter.tage[0].month,
        termineFilter.tage[0].year
      ], [
        22,
        11,
        2019
      ]);
      expect([
        termineFilter.tage[1].day,
        termineFilter.tage[1].month,
        termineFilter.tage[1].year
      ], [
        2,
        1,
        2019
      ]);
      expect([termineFilter.von?.hour, termineFilter.von?.minute], [23, 59]);
      expect([termineFilter.bis?.hour, termineFilter.bis?.minute], [1, 2]);
      expect(termineFilter.orte.length, 1);
      expect(termineFilter.orte[0], 'Frankfurter Allee Nord');
    });
  });

  group('isEmpty', () {
    test('returns true on empty filter', () {
      expect(TermineFilter([], [], null, null, [], false, true).isEmpty, true);
      expect(TermineFilter([], [], null, null, [], null, null).isEmpty,
          true);
    });

    test('returns false if types set', () {
      expect(
          TermineFilter(['Sammeln'], [], null, null, [], false, false).isEmpty,
          false);
    });

    test('returns false if days set', () {
      expect(
          TermineFilter([], [DateTime.now()], null, null, [], false, false)
              .isEmpty,
          false);
    });

    test('returns false if types set', () {
      expect(
          TermineFilter([], [], TimeOfDay.now(), null, [], false, false)
              .isEmpty,
          false);
    });

    test('returns false if types set', () {
      expect(
          TermineFilter([], [], null, TimeOfDay.now(), [], false, false)
              .isEmpty,
          false);
    });

    test('returns false if types set', () {
      expect(TermineFilter([], [], null, null, ['Kiez'], false, false).isEmpty,
          false);
    });

    test('seralizes properly with default values', () {
      var termineFilter = TermineFilter.fromJSON(jsonDecode('{'
          '"typen":[],'
          '"tage":[],'
          '"von":null,'
          '"bis":null,'
          '"orte":[]'
          '}'));
      expect(jsonEncode(termineFilter),
          '{"typen":[],"tage":[],"von":null,"bis":null,"orte":[],"nurEigene":false,"immerEigene":true}');
    });
  });
}
