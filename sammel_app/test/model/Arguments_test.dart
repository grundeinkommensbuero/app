import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Arguments.dart';

import '../shared/TestdatenVorrat.dart';

main() {
  test('serializes correctly', () {
    var json =
        Arguments('Neubau (2), Kosten', 11, DateTime(2021, 8, 8), ffAlleeNord())
            .toJson();

    expect(json['vorbehalte'], 'Neubau (2), Kosten');
    expect(json['benutzer'], 11);
    expect((json['datum'] as DateTime).year, 2021);
    expect((json['datum'] as DateTime).month, 8);
    expect((json['datum'] as DateTime).day, 8);
    expect(json['ort'], 'Frankfurter Allee Nord');
  ***REMOVED***);
***REMOVED***
