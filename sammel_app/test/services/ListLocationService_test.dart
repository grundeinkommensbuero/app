import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/ListLocation.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/ListLocationService.dart';

import '../TestdataStorage.dart';
import '../shared/Trainer.dart';
import '../shared/generated.mocks.dart';

void main() {
  MockUserService userService = MockUserService();
  trainUserService(userService);

  test('ListLocationService returns list locations', () async {
    var backend = MockBackend();
    trainBackend(backend);
    var service = ListLocationService(userService, backend);

    var cafeKottiJson = {
      'id': '2',
      'name': 'Café Kotti',
      'street': 'Adalbertstraße',
      'number': '96',
      'latitude': 52.5001477,
      'longitude': 13.4181523
    ***REMOVED***
    var zukunftJson = {
      'id': '3',
      'name': 'Zukunft',
      'street': 'Laskerstraße',
      'number': '5',
      'latitude': 52.5016524,
      'longitude': 13.4655402
    ***REMOVED***
    List<Map<String, dynamic>> listlocations = [cafeKottiJson, zukunftJson];
    when(backend.get('/service/listlocations/actives', any)).thenAnswer(
        (_) async => trainHttpResponse(
            MockHttpClientResponseBody(), 200, listlocations));

    List<ListLocation> ergebnis = await service.getActiveListLocations();

    expect(ergebnis.length, 2);

    expect(ergebnis[0].id, '2');
    expect(ergebnis[0].name, 'Café Kotti');
    expect(ergebnis[0].street, 'Adalbertstraße');
    expect(ergebnis[0].number, '96');
    expect(ergebnis[0].latitude, 52.5001477);
    expect(ergebnis[0].longitude, 13.4181523);
    expect(ergebnis[1].id, '3');
    expect(ergebnis[1].name, 'Zukunft');
    expect(ergebnis[1].street, 'Laskerstraße');
    expect(ergebnis[1].number, '5');
    expect(ergebnis[1].latitude, 52.5016524);
    expect(ergebnis[1].longitude, 13.4655402);
  ***REMOVED***);

  group('DemoListLocationService', () {
    var service;
    setUp(() {
      service = DemoListLocationService(userService);
    ***REMOVED***);

    test('uses DemoBackend', () {
      expect(service.backend is DemoBackend, true);
    ***REMOVED***);

    test('DemoListLocationService returns list locations', () async {
      List<ListLocation> result = await service.getActiveListLocations();
      expect(result.length, 3);

      expect(result[0].id, curry36().id);
      expect(result[0].name, curry36().name);
      expect(result[0].street, curry36().street);
      expect(result[0].number, curry36().number);
      expect(result[0].latitude, curry36().latitude);
      expect(result[0].longitude, curry36().longitude);

      expect(result[1].id, cafeKotti().id);
      expect(result[1].name, cafeKotti().name);
      expect(result[1].street, cafeKotti().street);
      expect(result[1].number, cafeKotti().number);
      expect(result[1].latitude, cafeKotti().latitude);
      expect(result[1].longitude, cafeKotti().longitude);

      expect(result[2].id, zukunft().id);
      expect(result[2].name, zukunft().name);
      expect(result[2].street, zukunft().street);
      expect(result[2].number, zukunft().number);
      expect(result[2].latitude, zukunft().latitude);
      expect(result[2].longitude, zukunft().longitude);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
