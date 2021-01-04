import 'dart:convert';

import 'package:sammel_app/model/Kiez.dart';
import 'package:test/test.dart';

import '../shared/TestdatenVorrat.dart';

void main() {
  group('serialisere', () {
    test('serialisiert nur Kiez', () {
      expect(jsonEncode(Kiez('kiez1', 'bezirk1', [])), '"kiez1"');
    });
  });
  group('equals', () {
    test('returns true for equal locations', () {
      expect(ffAlleeNord().equals(ffAlleeNord()), true);
      expect(tempVorstadt().equals(tempVorstadt()), true);
      expect(plaenterwald().equals(plaenterwald()), true);
    });

    test('returns true for null locations', () {
      expect(Kiez(null, null, []).equals(Kiez(null, null, [])), true);
    });

    test('returns false for different location', () {
      expect(Kiez('Bezirk 1', 'Kiez', []).equals(Kiez('Bezirk 2', 'Kiez', [])),
          false);
    });
    test('returns false for null location', () {
      expect(Kiez(null, 'Kiez', []).equals(Kiez('Kiez', 'Bezirk', [])), false);
    });
    test('returns false for location and null', () {
      expect(Kiez('Kiez', 'Bezirk', []).equals(Kiez(null, 'Kiez', [])), false);
    });

    test('returns false for different place', () {
      expect(Kiez('Ort 1', 'Bezirk', []).equals(Kiez('Bezirk', 'Ort 2', [])),
          false);
    });
    test('returns false for null place', () {
      expect(
          Kiez(null, 'Bezirk', [])
              .equals(Kiez('Kiez', 'Bezirk', [])),
          false);
    });
    test('returns false for place and null', () {
      expect(
          Kiez('Kiez', 'Bezirk', [])
              .equals(Kiez('Bezirk', null, [])),
          false);
    });
  });
}
