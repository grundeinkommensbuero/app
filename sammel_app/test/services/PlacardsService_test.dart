import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/Placard.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/PlacardsService.dart';
import '../shared/TestdatenVorrat.dart';
import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.trainer.dart';

void main() {
  final userService = MockUserService();
  setUp(() {
    reset(userService);
    trainUserService(userService);
  ***REMOVED***);

  group('PlacardsService', () {
    late MockBackend backend;
    late PlacardsService service;

    setUp(() {
      backend = MockBackend();
      trainBackend(backend);
      service = PlacardsService(userService, backend);
    ***REMOVED***);

    test('loadPlacards calls right path', () async {
      when(backend.get('service/plakate', any)).thenAnswer((_) => Future.value(
          trainHttpResponse(MockHttpClientResponseBody(), 200, [])));

      await service.loadPlacards();

      verify(backend.get('service/plakate', any));
    ***REMOVED***);

    test('loadPlacards deserializes Response', () async {
      when(backend.get('service/plakate', any)).thenAnswer((_) {
        var placards = [
          placard1().toJson(),
          placard2().toJson(),
          placard3().toJson()
        ];
        return Future.value(
            trainHttpResponse(MockHttpClientResponseBody(), 200, placards));
      ***REMOVED***);

      var response = await service.loadPlacards();

      expect(response[0].id, 1);
      expect(response[1].id, 2);
      expect(response[2].id, 3);
      expect(response[0].adresse, '12161, Friedrich-Wilhelm-Platz 57');
      expect(response[1].adresse, '12161, Bundesallee 76');
      expect(response[2].adresse, '12161, Goßlerstraße 29');
    ***REMOVED***);

    test('createPlacard sends serialized placard to right path', () async {
      when(backend.post('service/plakate/neu', any, any)).thenAnswer((_) =>
          Future.value(trainHttpResponse(
              MockHttpClientResponseBody(), 200, placard1().toJson())));

      var placard = placard1();
      placard.id = null;
      await service.createPlacard(placard);

      verify(backend.post(
          'service/plakate/neu',
          '{'
              '"id":null,'
              '"latitude":52.472246,'
              '"longitude":13.327783,'
              '"adresse":"12161, Friedrich-Wilhelm-Platz 57",'
              '"benutzer":11'
              '***REMOVED***',
          any));
    ***REMOVED***);

    test('createPlacard returns placard from database with Id', () async {
      when(backend.post('service/plakate/neu', any, any)).thenAnswer((_) =>
          Future.value(trainHttpResponse(
              MockHttpClientResponseBody(), 200, placard1().toJson())));

      var placard = placard1();
      placard.id = null;
      var response = await service.createPlacard(placard);

      expect(response!.id, 1);
    ***REMOVED***);

    test('createPlacard returns null on Error', () async {
      when(backend.post('service/plakate/neu', any, any)).thenThrow(Error());

      var response = await service.createPlacard(placard1());

      expect(response, isNull);
    ***REMOVED***);

    test('deletePlacard calls right path with id', () async {
      when(backend.delete('service/plakate/1', any, any)).thenAnswer((_) =>
          Future.value(
              trainHttpResponse(MockHttpClientResponseBody(), 200, null)));

      await service.deletePlacard(1);

      verify(backend.delete('service/plakate/1', any, any));
    ***REMOVED***);
  ***REMOVED***);

  group('DemoPlacardsService', () {
    DemoPlacardsService placardService = DemoPlacardsService(userService);

    setUp(() {
      placardService = DemoPlacardsService(userService);
    ***REMOVED***);

    test('createPlacard stores placard with new id and returns it', () async {
      expect(placardService.placards.length, 3);

      var newPlacard = await placardService.createPlacard(
          Placard(0, 52.47065, 13.3285, '12161, Bundesallee 129', 11));

      expect(placardService.placards.length, 4);
      expect(placardService.placards[3].id, 4);
      expect(newPlacard.id, 4);
    ***REMOVED***);

    test('createPlacard adds placard with original id', () {
      expect(placardService.placards.length, 3);

      placardService.createPlacard(
          Placard(10, 52.47065, 13.3285, '12161, Bundesallee 129', 11));

      expect(placardService.placards.length, 4);
      expect(placardService.placards[3].id, 10);
    ***REMOVED***);

    test('deletePlacard removes corrrect placard', () {
      expect(placardService.placards.length, 3);

      placardService.deletePlacard(3);

      expect(placardService.placards.length, 2);
      expect(placardService.placards.map((pl) => pl.id), containsAll([1, 2]));
    ***REMOVED***);

    test('deletePlacard ignores unkown placard', () {
      expect(placardService.placards.length, 3);

      placardService.deletePlacard(4);

      expect(placardService.placards.length, 3);
    ***REMOVED***);

    test('loadPlacards serves all placards', () async {
      var placards = await placardService.loadPlacards();

      expect(placards.map((pl) => pl.id), containsAll([1, 2, 3]));
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
