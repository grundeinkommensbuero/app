import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/Building.dart';
import 'package:sammel_app/services/VisitedHousesService.dart';
import '../shared/TestdatenVorrat.dart';
import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.trainer.dart';

void main() {
  final _userService = MockUserService();
  setUp(() {
    reset(_userService);
    trainUserService(_userService);
  ***REMOVED***);

  group('VisitedHousesService', () {
    late MockBackend _backend;
    late VisitedHousesService service;

    setUp(() {
      _backend = MockBackend();
      trainBackend(_backend);
      service = VisitedHousesService(MockGeoService(), _userService, _backend);
    ***REMOVED***);

    test('loadVisitedHouses calls right path', () async {
      when(_backend.get('service/besuchteHaeuser', any)).thenAnswer((_) =>
          Future.value(
              trainHttpResponse(MockHttpClientResponseBody(), 200, [])));

      await service.loadVisitedHouses();

      verify(_backend.get('service/besuchteHaeuser', any));
    ***REMOVED***);

    test('loadVisitedHouses deserializes Response', () async {
      when(_backend.get('service/besuchteHaeuser', any)).thenAnswer((_) {
        var houses = [
          kanzlerinamt().toJson(),
          hausundgrund().toJson(),
          konradadenauerhaus().toJson()
        ];
        return Future.value(
            trainHttpResponse(MockHttpClientResponseBody(), 200, houses));
      ***REMOVED***);

      var response = await service.loadVisitedHouses();

      expect(response[0].osmId, 1);
      expect(response[1].osmId, 2);
      expect(response[2].osmId, 3);
    ***REMOVED***);

    test('createVisitedHouse sends serialized house to right path', () async {
      when(_backend.post('service/besuchteHaeuser/neu', any, any)).thenAnswer(
          (_) => Future.value(trainHttpResponse(
              MockHttpClientResponseBody(), 200, kanzlerinamt().toJson())));

      var house = kanzlerinamt();
      house.visitationEvents[0].id = null;
      await service.createVisitedHouse(house);

      verify(_backend.post(
          'service/besuchteHaeuser/neu',
          '{'
              '"osmId":1,'
              '"id":null,'
              '"latitude":52.52014,'
              '"longitude":13.36911,'
              '"adresse":"Willy-Brandt-Straße 1, Tiergarten, Mitte, Berlin, 10557",'
              '"hausteil":"Westflügel",'
              '"datum":"2021-07-18",'
              '"benutzer":11'
              ',"shape":"[]"'
              '***REMOVED***',
          any));
    ***REMOVED***);

    test('createVisitedHouse returns house from database with Id', () async {
      when(_backend.post('service/besuchteHaeuser/neu', any, any)).thenAnswer(
          (_) => Future.value(trainHttpResponse(
              MockHttpClientResponseBody(), 200, kanzlerinamt().toJson())));

      var house = kanzlerinamt();
      //house.id = null;
      var response = await service.createVisitedHouse(house);

      expect(response!.osmId, 1);
    ***REMOVED***);

    test('createVisitedHouse returns null on Error', () async {
      when(_backend.post('service/besuchteHaeuser/neu', any, any))
          .thenThrow(Error());

      var response = await service.createVisitedHouse(kanzlerinamt());

      expect(response, isNull);
    ***REMOVED***);

    test('deleteVisitedHouse calls right path with id', () async {
      when(_backend.delete('service/besuchteHaeuser/1', any, any)).thenAnswer(
          (_) => Future.value(
              trainHttpResponse(MockHttpClientResponseBody(), 200, null)));

      await service.deleteVisitedHouse(1);

      verify(_backend.delete('service/besuchteHaeuser/1', any, any));
    ***REMOVED***);
  ***REMOVED***);

  group('DemoVisitedHousesService', () {
    DemoVisitedHousesService visitedHousesService =
        DemoVisitedHousesService(_userService, MockGeoService());

    setUp(() {
      visitedHousesService =
          DemoVisitedHousesService(_userService, MockGeoService());
    ***REMOVED***);

    test('createVisitedHouse stores house with new id and returns it',
        () async {
      expect(visitedHousesService.visitedHouses.length, 3);

      var newHouse = await visitedHousesService
          .createVisitedHouse(VisitedHouse(0, 52.47541, 13.30508, [], [
        VisitedHouseEvent(
            0,
            'Mecklenburgische Straße 57, Wilmersdorf, Charlottenburg-Wilmersdorf, Berlin, 14197',
            'Haupteingang',
            11,
            DateTime(2021, 7, 18))
      ]));

      expect(visitedHousesService.visitedHouses.length, 4);
      expect(visitedHousesService.visitedHouses[3].osmId, 4);
      expect(newHouse.osmId, 4);
    ***REMOVED***);

    test('createVisitedHouse adds house with original id', () {
      expect(visitedHousesService.visitedHouses.length, 3);

      visitedHousesService
          .createVisitedHouse(VisitedHouse(10, 52.47541, 13.30508, [], [
        VisitedHouseEvent(
            10,
            'Mecklenburgische Straße 57, Wilmersdorf, Charlottenburg-Wilmersdorf, Berlin, 14197',
            'Haupteingang',
            11,
            DateTime(2021, 7, 18))
      ]));

      expect(visitedHousesService.visitedHouses.length, 4);
      expect(visitedHousesService.visitedHouses[3].osmId, 10);
    ***REMOVED***);

    test('deleteVisitedHouse removes corrrect house', () {
      expect(visitedHousesService.visitedHouses.length, 3);

      visitedHousesService.deleteVisitedHouse(3);

      expect(visitedHousesService.visitedHouses.length, 2);
      expect(visitedHousesService.visitedHouses.map((h) => h.osmId),
          containsAll([1, 2]));
    ***REMOVED***);

    test('deleteVisitedHouse ignores unkown house', () {
      expect(visitedHousesService.visitedHouses.length, 3);

      visitedHousesService.deleteVisitedHouse(4);

      expect(visitedHousesService.visitedHouses.length, 3);
    ***REMOVED***);

    test('loadVisitedHouses serves all houses', () async {
      var houses = await visitedHousesService.loadVisitedHouses();

      expect(houses.map((h) => h.osmId), containsAll([1, 2, 3]));
    ***REMOVED***);

    test('editVisitedHouses', () async {
      VisitedHouse house = VisitedHouse(4, 53, 11, [],
          [VisitedHouseEvent(null, 'tttt', 'hausteil', 3, DateTime(2100))]);
      visitedHousesService.editVisitedHouse(house);

      expect(visitedHousesService.localBuildingMap.length, 4);
      expect(visitedHousesService.localBuildingMap[4]!.osmId, 4);
      expect(
          visitedHousesService.localBuildingMap[4]!.visitationEvents.length, 1);
      expect(
          visitedHousesService.localBuildingMap[4]!.visitationEvents[0].id, 10);

      house = VisitedHouse(4, 53, 11, [],
          [VisitedHouseEvent(null, 'tttt', 'hausteil', 3, DateTime(2100, 3))]);
      visitedHousesService.editVisitedHouse(house);

      expect(visitedHousesService.localBuildingMap.length, 4);
      expect(visitedHousesService.localBuildingMap[4]!.osmId, 4);
      expect(
          visitedHousesService.localBuildingMap[4]!.visitationEvents.length, 2);
      expect(
          visitedHousesService.localBuildingMap[4]!.visitationEvents[0].id, 11);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
