import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/services/AuthFehler.dart';

main() {
  test('deserialises', () {
    String serialisedString = '{"meldung":"Der wahre Grund"}';

    var authFehler = AuthFehler.fromJson(jsonDecode(serialisedString));

    expect(authFehler.message, 'Der wahre Grund');
  });
}