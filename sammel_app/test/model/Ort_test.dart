import 'dart:convert';

import 'package:sammel_app/model/Ort.dart';
import 'package:test/test.dart';

void main() {
  group('serialisere', () {
    test('serialisiert Ort mit id, Bezirk und Ort', () {
      expect(jsonEncode(Ort(1, 'bezirk1', 'ort1', 52.49653, 13.43762)),
          '{"id":1,"bezirk":"bezirk1","ort":"ort1","lattitude":52.49653,"longitude":13.43762}');
    });
  });
  group('equals', () {
    test('returns true for equal locations', () {
      expect(nordkiez().equals(nordkiez()), true);
      expect(goerli().equals(goerli()), true);
      expect(treptowerPark().equals(treptowerPark()), true);
    });
    test('returns true for null locations', () {
      expect(
          Ort(null, null, null, null, null)
              .equals(Ort(null, null, null, null, null)),
          true);
    });

    test('returns false for different id', () {
      expect(
          Ort(1, 'Bezirk', 'Ort', 52.48993, 13.46839)
              .equals(Ort(2, 'Bezirk', 'Ort', 52.48993, 13.46839)),
          false);
    });
    test('returns false for null id', () {
      expect(
          Ort(null, 'Bezirk', 'Ort', 52.48993, 13.46839)
              .equals(Ort(1, 'Bezirk', 'Ort', 52.48993, 13.46839)),
          false);
    });
    test('returns false for id and null', () {
      expect(
          Ort(1, 'Bezirk', 'Ort', 52.48993, 13.46839)
              .equals(Ort(null, 'Bezirk', 'Ort', 52.48993, 13.46839)),
          false);
    });

    test('returns false for different location', () {
      expect(
          Ort(1, 'Bezirk 1', 'Ort', 52.48993, 13.46839)
              .equals(Ort(1, 'Bezirk 2', 'Ort', 52.48993, 13.46839)),
          false);
    });
    test('returns false for null location', () {
      expect(
          Ort(null, null, 'Ort', 52.48993, 13.46839)
              .equals(Ort(1, 'Bezirk', 'Ort', 52.48993, 13.46839)),
          false);
    });
    test('returns false for location and null', () {
      expect(
          Ort(1, 'Bezirk', 'Ort', 52.48993, 13.46839)
              .equals(Ort(null, null, 'Ort', 52.48993, 13.46839)),
          false);
    });

    test('returns false for different place', () {
      expect(
          Ort(1, 'Bezirk', 'Ort 1', 52.48993, 13.46839)
              .equals(Ort(1, 'Bezirk', 'Ort 2', 52.48993, 13.46839)),
          false);
    });
    test('returns false for null place', () {
      expect(
          Ort(1, 'Bezirk', null, 52.48993, 13.46839)
              .equals(Ort(1, 'Bezirk', 'Ort', 52.48993, 13.46839)),
          false);
    });
    test('returns false for place and null', () {
      expect(
          Ort(1, 'Bezirk', 'Ort', 52.48993, 13.46839)
              .equals(Ort(1, 'Bezirk', null, 52.48993, 13.46839)),
          false);
    });

    test('returns false for different coordinates', () {
      expect(
          Ort(1, 'Bezirk', 'Ort', 52.48993, 13.46839)
              .equals(Ort(1, 'Bezirk', 'Ort', 53.48993, 14.46839)),
          false);
    });
    test('returns false for null coordinates', () {
      expect(
          Ort(1, 'Bezirk', 'Ort', null, null)
              .equals(Ort(1, 'Bezirk', 'Ort', 52.48993, 13.46839)),
          false);
    });
    test('returns false for coordinates and null', () {
      expect(
          Ort(1, 'Bezirk', 'Ort', 52.48993, 13.46839)
              .equals(Ort(1, 'Bezirk', 'Ort', null, null)),
          false);
    });
  });
}

Ort nordkiez() => Ort(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez',
    52.51579, 13.45399);

Ort goerli() => Ort(0, 'Friedrichshain-Kreuzberg',
    'Görlitzer Park und Umgebung', 52.48993, 13.46839);

Ort treptowerPark() =>
    Ort(2, 'Treptow-Köpenick', 'Treptower Park', 52.49653, 13.43762);
