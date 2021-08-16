import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/services/GeoService.dart';

main() {
  group('JSON', () {
    test('parses complete address', () {
      GeoData g = GeoData.fromJson({
        'name': 'my name',
        'address': {
          'road': 'my street',
          'house_number': '15',
          'postcode': '12345',
          'city': 'Berlin'
        ***REMOVED***
      ***REMOVED***);

      expect(g.name, 'my name');
      expect(g.street, 'my street');
      expect(g.number, '15');
      expect(g.postcode, '12345');
      expect(g.city, 'Berlin');

      expect(g.description, 'my name, my street 15');
      expect(g.fullAdress, 'my street 15, 12345 Berlin');
    ***REMOVED***);

    test('parses address without name', () {
      GeoData g = GeoData.fromJson({
        'address': {
          'road': 'my street',
          'house_number': '15',
          'postcode': '12345',
          'city': 'Berlin'
        ***REMOVED***
      ***REMOVED***);

      expect(g.street, 'my street');
      expect(g.number, '15');
      expect(g.postcode, '12345');
      expect(g.city, 'Berlin');

      expect(g.description, 'my street 15');
      expect(g.fullAdress, 'my street 15, 12345 Berlin');
    ***REMOVED***);

    test('parses address without street', () {
      GeoData g = GeoData.fromJson({
        'name': 'my name',
        'address': {'house_number': '15'***REMOVED***
      ***REMOVED***);

      expect(g.description, 'my name, 15');
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
