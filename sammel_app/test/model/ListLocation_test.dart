import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/ListLocation.dart';

import '../shared/TestdatenVorrat.dart';

main() {
  test('deserializes', () {
    var json = jsonDecode(
        '{'
            '"id":"1",'
            '"name":"Curry 36",'
            '"street":"Mehringdamm",'
            '"number":"36",'
            '"latitude":52.4935584,'
            '"longitude":13.3877282'
            '***REMOVED***');
    ListLocation listLocation = ListLocation.fromJson(json);

    expect(listLocation.id, curry36().id);
    expect(listLocation.name, curry36().name);
    expect(listLocation.street, curry36().street);
    expect(listLocation.number, curry36().number);
    expect(listLocation.latitude, curry36().latitude);
    expect(listLocation.longitude, curry36().longitude);
  ***REMOVED***);
***REMOVED***