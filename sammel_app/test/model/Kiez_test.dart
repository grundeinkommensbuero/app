import 'dart:convert';

import 'package:sammel_app/model/Kiez.dart';
import 'package:test/test.dart';

void main() {
  group('serialisere', () {
    test('serialisiert Ort mit id, Bezirk und Ort', () {
      expect(jsonEncode(Kiez(1, 'bezirk1', 'ort1', 52.49653, 13.43762)),
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
          Kiez(null, null, null, null, null)
              .equals(Kiez(null, null, null, null, null)),
          true);
    });

    test('returns false for different id', () {
      expect(
          Kiez(1, 'Bezirk', 'Ort', 52.48993, 13.46839)
              .equals(Kiez(2, 'Bezirk', 'Ort', 52.48993, 13.46839)),
          false);
    });
    test('returns false for null id', () {
      expect(
          Kiez(null, 'Bezirk', 'Ort', 52.48993, 13.46839)
              .equals(Kiez(1, 'Bezirk', 'Ort', 52.48993, 13.46839)),
          false);
    });
    test('returns false for id and null', () {
      expect(
          Kiez(1, 'Bezirk', 'Ort', 52.48993, 13.46839)
              .equals(Kiez(null, 'Bezirk', 'Ort', 52.48993, 13.46839)),
          false);
    });

    test('returns false for different location', () {
      expect(
          Kiez(1, 'Bezirk 1', 'Ort', 52.48993, 13.46839)
              .equals(Kiez(1, 'Bezirk 2', 'Ort', 52.48993, 13.46839)),
          false);
    });
    test('returns false for null location', () {
      expect(
          Kiez(null, null, 'Ort', 52.48993, 13.46839)
              .equals(Kiez(1, 'Bezirk', 'Ort', 52.48993, 13.46839)),
          false);
    });
    test('returns false for location and null', () {
      expect(
          Kiez(1, 'Bezirk', 'Ort', 52.48993, 13.46839)
              .equals(Kiez(null, null, 'Ort', 52.48993, 13.46839)),
          false);
    });

    test('returns false for different place', () {
      expect(
          Kiez(1, 'Bezirk', 'Ort 1', 52.48993, 13.46839)
              .equals(Kiez(1, 'Bezirk', 'Ort 2', 52.48993, 13.46839)),
          false);
    });
    test('returns false for null place', () {
      expect(
          Kiez(1, 'Bezirk', null, 52.48993, 13.46839)
              .equals(Kiez(1, 'Bezirk', 'Ort', 52.48993, 13.46839)),
          false);
    });
    test('returns false for place and null', () {
      expect(
          Kiez(1, 'Bezirk', 'Ort', 52.48993, 13.46839)
              .equals(Kiez(1, 'Bezirk', null, 52.48993, 13.46839)),
          false);
    });

    test('returns false for different coordinates', () {
      expect(
          Kiez(1, 'Bezirk', 'Ort', 52.48993, 13.46839)
              .equals(Kiez(1, 'Bezirk', 'Ort', 53.48993, 14.46839)),
          false);
    });
    test('returns false for null coordinates', () {
      expect(
          Kiez(1, 'Bezirk', 'Ort', null, null)
              .equals(Kiez(1, 'Bezirk', 'Ort', 52.48993, 13.46839)),
          false);
    });
    test('returns false for coordinates and null', () {
      expect(
          Kiez(1, 'Bezirk', 'Ort', 52.48993, 13.46839)
              .equals(Kiez(1, 'Bezirk', 'Ort', null, null)),
          false);
    });
  });
}

Kiez nordkiez() => Kiez(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez',
    52.51579, 13.45399);

Kiez goerli() => Kiez(0, 'Friedrichshain-Kreuzberg',
    'Görlitzer Park und Umgebung', 52.48993, 13.46839);

Kiez treptowerPark() =>
    Kiez(2, 'Treptow-Köpenick', 'Treptower Park', 52.49653, 13.43762);
