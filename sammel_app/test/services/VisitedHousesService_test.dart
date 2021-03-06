import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/VisitedHousesService.dart';
import '../shared/TestdatenVorrat.dart';
import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.trainer.dart';

void main() {
  final userService = MockUserService();
  setUp(() {
    reset(userService);
    trainUserService(userService);
  });

  group('VisitedHousesService', () {
    late MockBackend backend;
    late VisitedHousesService service;

    setUp(() {
      backend = MockBackend();
      trainBackend(backend);
      service = VisitedHousesService(userService, backend);
    });

    test('loadVisitedHouses calls right path', () async {
      when(backend.get('service/besuchteHaeuser', any)).thenAnswer((_) =>
          Future.value(
              trainHttpResponse(MockHttpClientResponseBody(), 200, [])));

      await service.loadVisitedHouses();

      verify(backend.get('service/besuchteHaeuser', any));
    });

    test('loadVisitedHouses deserializes Response', () async {
      when(backend.get('service/besuchteHaeuser', any)).thenAnswer((_) {
        var houses = [
          kanzlerinamt().toJson(),
          hausundgrund().toJson(),
          konradadenauerhaus().toJson()
        ];
        return Future.value(
            trainHttpResponse(MockHttpClientResponseBody(), 200, houses));
      });

      var response = await service.loadVisitedHouses();

      expect(response[0].id, 1);
      expect(response[1].id, 2);
      expect(response[2].id, 3);
      expect(response[0].adresse,
          'Willy-Brandt-Straße 1, Tiergarten, Mitte, Berlin, 10557');
      expect(response[1].adresse, 'Potsdamer Straße 143, 10783 Berlin');
      expect(response[2].adresse,
          'Klingelhöferstraße 8,Botschaftsviertel, Tiergarten, Mitte, Berlin, 10785');
    });

    test('createVisitedHouse sends serialized house to right path', () async {
      when(backend.post('service/besuchteHaeuser/neu', any, any)).thenAnswer(
          (_) => Future.value(trainHttpResponse(
              MockHttpClientResponseBody(), 200, kanzlerinamt().toJson())));

      var house = kanzlerinamt();
      house.id = null;
      await service.createVisitedHouse(house);

      verify(backend.post(
          'service/besuchteHaeuser/neu',
          '{'
              '"id":null,'
              '"latitude":52.52014,'
              '"longitude":13.36911,'
              '"adresse":"Willy-Brandt-Straße 1, Tiergarten, Mitte, Berlin, 10557",'
              '"hausteil":"Westflügel",'
              '"datum":"2021-07-18",'
              '"benutzer":11'
              '}',
          any));
    });

    test('createVisitedHouse returns house from database with Id', () async {
      when(backend.post('service/besuchteHaeuser/neu', any, any)).thenAnswer(
          (_) => Future.value(trainHttpResponse(
              MockHttpClientResponseBody(), 200, kanzlerinamt().toJson())));

      var house = kanzlerinamt();
      house.id = null;
      var response = await service.createVisitedHouse(house);

      expect(response!.id, 1);
    });

    test('createVisitedHouse returns null on Error', () async {
      when(backend.post('service/besuchteHaeuser/neu', any, any))
          .thenThrow(Error());

      var response = await service.createVisitedHouse(kanzlerinamt());

      expect(response, isNull);
    });

    test('deleteVisitedHouse calls right path with id', () async {
      when(backend.delete('service/besuchteHaeuser/1', any, any)).thenAnswer(
          (_) => Future.value(
              trainHttpResponse(MockHttpClientResponseBody(), 200, null)));

      await service.deleteVisitedHouse(1);

      verify(backend.delete('service/besuchteHaeuser/1', any, any));
    });
  });

  group('DemoVisitedHousesService', () {
    DemoVisitedHousesService visitedHousesService =
        DemoVisitedHousesService(userService, DemoBackend());

    setUp(() {
      visitedHousesService =
          DemoVisitedHousesService(userService, DemoBackend());
    });

    test('createVisitedHouse stores house with new id and returns it',
        () async {
      expect(visitedHousesService.visitedHouses.length, 3);

      var newHouse = await visitedHousesService.createVisitedHouse(
          VisitedHouseDummy(
              0,
              52.47541,
              13.30508,
              'Mecklenburgische Straße 57, Wilmersdorf, Charlottenburg-Wilmersdorf, Berlin, 14197',
              'Haupteingang',
              DateTime(2021, 7, 18),
              11,
              ''));

      expect(visitedHousesService.visitedHouses.length, 4);
      expect(visitedHousesService.visitedHouses[3].id, 4);
      expect(newHouse.id, 4);
    });

    test('createVisitedHouse adds house with original id', () {
      expect(visitedHousesService.visitedHouses.length, 3);

      visitedHousesService.createVisitedHouse(VisitedHouseDummy(
          10,
          52.47541,
          13.30508,
          'Mecklenburgische Straße 57, Wilmersdorf, Charlottenburg-Wilmersdorf, Berlin, 14197',
          'Haupteingang',
          DateTime(2021, 7, 18),
          11,
          ''));

      expect(visitedHousesService.visitedHouses.length, 4);
      expect(visitedHousesService.visitedHouses[3].id, 10);
    });

    test('deleteVisitedHouse removes corrrect house', () {
      expect(visitedHousesService.visitedHouses.length, 3);

      visitedHousesService.deleteVisitedHouse(3);

      expect(visitedHousesService.visitedHouses.length, 2);
      expect(visitedHousesService.visitedHouses.map((h) => h.id),
          containsAll([1, 2]));
    });

    test('deleteVisitedHouse ignores unkown house', () {
      expect(visitedHousesService.visitedHouses.length, 3);

      visitedHousesService.deleteVisitedHouse(4);

      expect(visitedHousesService.visitedHouses.length, 3);
    });

    test('loadVisitedHouses serves all houses', () async {
      var houses = await visitedHousesService.loadVisitedHouses();

      expect(houses.map((h) => h.id), containsAll([1, 2, 3]));
    });
  });
}
