import 'dart:convert';

import 'package:sammel_app/model/Evaluation.dart';
import 'package:test/test.dart';

void main() {
  test('serialisiert', () {
    expect(
        jsonEncode(Evaluation(1, 10, 20, 3, 3.5, 'nice', 'normal')),
        '{'
        '"termin_id":1,'
        '"teilnehmer":10,'
        '"unterschriften":20,'
        '"bewertung":3,'
        '"stunden":3.5,'
        '"kommentar":"nice",'
        '"situation":"normal",'
        '"ausgefallen":false}');
  });
}
