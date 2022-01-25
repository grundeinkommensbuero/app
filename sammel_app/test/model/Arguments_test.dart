import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Arguments.dart';

main() {
  test('serializes correctly', () {
    var json =
        Arguments('Neubau (2), Kosten', DateTime(2021, 8, 8), '10243')
            .toJson();

    expect(json['vorbehalte'], 'Neubau (2), Kosten');
    expect(json['datum'], '2021-08-08');
    expect(json['ort'], '10243');
  });

  test('serializes without Kiez', () {
    var json =
        Arguments('Neubau (2), Kosten', DateTime(2021, 8, 8), null).toJson();

    expect(json['vorbehalte'], 'Neubau (2), Kosten');
    expect(json['datum'], '2021-08-08');
    expect(json['ort'], null);
  });
}
