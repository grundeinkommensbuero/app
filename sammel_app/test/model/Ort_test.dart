import 'dart:convert';

import 'package:sammel_app/model/Ort.dart';
import 'package:test/test.dart';

void main() {
  group('serialisere', () {
    test('serialisiert Ort mit id, Bezirk und Ort', () {
      expect(jsonEncode(Ort(1, 'bezirk1', 'ort1',52.49653, 13.43762)),
          '{"id":1,"bezirk":"bezirk1","ort":"ort1","lattitude":52.49653,"longitude":13.43762***REMOVED***');
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

Ort nordkiez() => Ort(1, "Friedrichshain-Kreuzberg", "Friedrichshain Nordkiez", 52.51579, 13.45399);

Ort goerli() => Ort(0, "Friedrichshain-Kreuzberg", "Görlitzer Park und Umgebung", 52.48993, 13.46839);

Ort treptowerPark() => Ort(2, "Friedrichshain-Kreuzberg", "Treptower Park", 52.49653, 13.43762);

/*import 'dart:convert';

import 'package:sammel_app/model/Ort.dart';
import 'package:test/test.dart';

void main() {
  group('serialisere', () {
    test('serialisiert Ort mit id, Bezirk und Ort', () {
      expect(jsonEncode(Ort(1, 'bezirk1', 'ort1', 52.49653, 13.43762)),
          '{"id":1,"bezirk":"bezirk1","ort":"ort1","lattitude":52.49653,"longitude":13.43762***REMOVED***');
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

Ort goerli() => Ort(0, 'Friedrichshain-Kreuzberg',
    'Görlitzer Park und Umgebung', 52.51579, 13.45399);

Ort nordkiez() => Ort(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez',
    52.48993, 13.46839);

Ort treptowerPark() =>
    Ort(2, 'Friedrichshain-Kreuzberg', 'Treptower Park', 52.49653, 13.43762);*/
