import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/services/GeoService.dart';

main() {
  group('JSON', () {
    test('parses complete address', () {
      GeoData g = GeoData.fromJson({
        'name': 'my name',
        'address': {'road': 'my street', 'house_number': '15'}
      });

      expect(g.description, 'my name, my street 15');
    });

    test('parses address without name', () {
      GeoData g = GeoData.fromJson({
        'address': {'road': 'my street', 'house_number': '15'}
      });

      expect(g.description, 'my street 15');
    });

    test('parses address without street', () {
      GeoData g = GeoData.fromJson({
        'name': 'my name',
        'address': {'house_number': '15'}
      });

      expect(g.description, 'my name, 15');
    });
  });
}
