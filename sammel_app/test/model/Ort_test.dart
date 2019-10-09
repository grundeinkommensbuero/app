import 'dart:convert';

import 'package:sammel_app/model/Ort.dart';
import 'package:test/test.dart';

void main() {
  group('serialisere', () {
    test('serialisiert Ort mit id, Bezirk und Ort', () {
      expect(
          jsonEncode(Ort(1, 'bezirk1', 'ort1')),
          '{"id":1,"bezirk":"bezirk1","ort":"ort1"}');
    });
  });
}