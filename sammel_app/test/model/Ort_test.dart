import 'dart:convert';

import 'package:sammel_app/model/Ort.dart';
import 'package:test/test.dart';

void main() {
  group('serialisere', () {
    test('serialisiert Ort mit id, Bezirk und Ort', () {
      expect(jsonEncode(Ort(1, 'bezirk1', 'ort1')),
          '{"id":1,"bezirk":"bezirk1","ort":"ort1"***REMOVED***');
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

Ort goerli() => Ort(0, "Friedrichshain-Kreuzberg", "Görlitzer Park und Umgebung");

Ort nordkiez() => Ort(0, "Friedrichshain-Kreuzberg", "Friedrichshain Nordkiez");

Ort treptowerPark() => Ort(0, "Friedrichshain-Kreuzberg", "Treptower Park");
