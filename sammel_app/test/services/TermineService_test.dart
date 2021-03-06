import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_server/http_server.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/TermineService.dart';

import '../model/Termin_test.dart';
import '../shared/TestdatenVorrat.dart';
import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.trainer.dart';

void main() {
  PushNotificationManager pushManager = MockPushNotificationManager();
  MockStammdatenService stammdatenService = MockStammdatenService();
  final localNotificationService = MockLocalNotificationService();
  final userService = MockUserService();

  setUp(() {
    reset(userService);
    trainUserService(userService);
    reset(stammdatenService);
    trainStammdatenService(stammdatenService);
  });

  group('DemoTermineService', () {
    late DemoTermineService service;
    setUp(() {
      service = DemoTermineService(
          stammdatenService, userService, GlobalKey<TermineSeiteState>());
    });

    test('uses DemoBackend', () {
      expect(service.backend is DemoBackend, true);
    });

    test('creates new Termin', () async {
      expect(
          (await service.loadActions(TermineFilter.leererFilter())).length, 4);

      var response = await service.createAction(
          Termin(
              null,
              DateTime.now(),
              (Jiffy(DateTime.now())..add(days: 1)).dateTime,
              ffAlleeNord(),
              'Sammeln',
              52.52116,
              13.41331,
              [karl()],
              TerminDetails(
                  'U-Bahnhof Samariterstra??e',
                  'wir gehen die Frankfurter Allee hoch',
                  'Ihr erreicht uns unter 0234567')),
          '');

      expect(response.id, 5);
      expect(
          (await service.loadActions(TermineFilter.leererFilter())).length, 5);
    });

    test('deletes action', () async {
      var actionsBefore =
          await service.loadActions(TermineFilter.leererFilter());
      expect(
          actionsBefore.map((action) => action.id), containsAll([1, 2, 3, 4]));

      await service.deleteAction(actionsBefore[1], '');

      var actionsAfter =
          await service.loadActions(TermineFilter.leererFilter());
      expect(actionsAfter.map((action) => action.id), containsAll([1, 3, 4]));
    });

    test('stores new action', () async {
      var termine = await service.termine;
      expect(termine[0].typ, 'Sammeln');
      expect(termine[0].ort.name, 'Frankfurter Allee Nord');
      expect(termine[0].details!.kontakt, 'Ruft mich an unter 01234567');

      await service.saveAction(
          TerminTestDaten.einTermin()
            ..id = 1
            ..typ = 'Infoveranstaltung'
            ..ort = plaenterwald()
            ..details = TerminDetails('bla', 'blub', 'Test123'),
          '');

      termine = await service.termine;
      expect(termine[0].typ, 'Infoveranstaltung');
      expect(termine[0].ort.name, 'Pl??nterwald');
      expect(termine[0].details!.kontakt, 'Test123');
    });

    test('joinAction adds user to action', () async {
      var termine = await service.termine;
      termine[0].participants = [rosa()];

      await service.joinAction(1);

      termine = await service.termine;
      expect(termine[0].participants!.map((e) => e.id), containsAll([11, 12]));
    });

    test('joinAction ignores if user already partakes', () async {
      var termine = await service.termine;
      termine[0].participants = [rosa(), karl()];

      await service.joinAction(1);

      termine = await service.termine;
      expect(termine[0].participants!.map((e) => e.id), containsAll([11, 12]));
    });

    test('leaveAction removes user from action', () async {
      var termine = await service.termine;
      termine[0].participants = [rosa(), karl()];

      await service.leaveAction(1);

      termine = await service.termine;
      expect(termine[0].participants!.map((e) => e.id), containsAll([12]));
    });

    test('leaveAction ignores if user doesnt partake', () async {
      var termine = await service.termine;
      termine[0].participants = [rosa()];

      await service.leaveAction(1);

      termine = await service.termine;
      expect(termine[0].participants!.map((e) => e.id), containsAll([12]));
    });
  });

  group('TermineService', () {
    late MockBackend backend;
    late TermineService service;

    setUp(() {
      backend = MockBackend();
      trainBackend(backend);
      service = TermineService(stammdatenService, userService, backend,
          pushManager, localNotificationService, GlobalKey());
      service.userService = userService;
    });

    test('loadActions calls right path and serializes Filter correctly',
        () async {
      when(backend.post('service/termine', any, any)).thenAnswer((_) =>
          Future.value(
              trainHttpResponse(MockHttpClientResponseBody(), 200, [])));

      await service.loadActions(einFilter());

      verify(backend.post(
          'service/termine',
          '{'
              '"typen":["Sammeln"],'
              '"tage":["2020-08-20"],'
              '"von":"15:00:00",'
              '"bis":"18:30:00",'
              '"orte":["Frankfurter Allee Nord"],'
              '"nurEigene":false,'
              '"immerEigene":false'
              '}',
          any));
    });

    test('loadActions deserializes actions correctly', () async {
      when(backend.post('service/termine', any, any)).thenAnswer((_) =>
          Future<HttpClientResponseBody>.value(
              trainHttpResponse(MockHttpClientResponseBody(), 200, [
            TerminTestDaten.einTerminMitTeilisUndDetails().toJson(),
            TerminTestDaten.einTerminOhneTeilisMitDetails().toJson()
          ])));

      var actions = await service.loadActions(einFilter());

      expect(actions.length, 2);
      expect(actions[0].id, 0);
      expect(actions[0].beginn, DateTime(2019, 11, 4, 17, 9, 0));
      expect(actions[0].ende, DateTime(2019, 11, 4, 18, 9, 0));
      expect(actions[0].ort.ortsteil, 'Friedrichshain');
      expect(actions[0].ort.region, 'Friedrichshain Ost');
      expect(actions[0].ort.name, 'Frankfurter Allee Nord');
      expect(actions[0].typ, 'Sammeln');
      expect(actions[0].latitude, 52.52116);
      expect(actions[0].longitude, 13.41331);
      expect(actions[0].participants!.length, 1);
      expect(actions[0].participants![0].id, 11);
      expect(actions[0].participants![0].name, 'Karl Marx');
      expect(actions[0].participants![0].color?.value, Colors.red.value);
      expect(actions[0].details!.beschreibung,
          'Bringe Westen und Kl??mmbretter mit');
      expect(actions[0].details!.treffpunkt, 'Weltzeituhr');
      expect(actions[0].details!.kontakt, 'Ruft an unter 012345678');
      expect(actions[1].id, 0);
      expect(actions[1].beginn, DateTime(2019, 11, 4, 17, 9, 0));
      expect(actions[1].ende, DateTime(2019, 11, 4, 18, 9, 0));
      expect(actions[1].ort.ortsteil, 'Friedrichshain');
      expect(actions[1].ort.region, 'Friedrichshain Ost');
      expect(actions[1].ort.name, 'Frankfurter Allee Nord');
      expect(actions[1].typ, 'Sammeln');
      expect(actions[1].latitude, 52.52116);
      expect(actions[1].longitude, 13.41331);
      expect(actions[1].participants!.length, 0);
      expect(actions[1].details!.beschreibung,
          'Bringe Westen und Kl??mmbretter mit');
      expect(actions[1].details!.treffpunkt, 'Weltzeituhr');
      expect(actions[1].details!.kontakt, 'Ruft an unter 012345678');
    });

    test(
        'createTermin calls right path and serializes action and token correctly',
        () async {
      when(backend.post('service/termine/neu', any, any)).thenAnswer((_) =>
          Future<HttpClientResponseBody>.value(trainHttpResponse(
              MockHttpClientResponseBody(),
              200,
              TerminTestDaten.einTerminMitTeilisUndDetails().toJson())));

      await service.createAction(
          TerminTestDaten.einTerminMitTeilisUndDetails(), 'Token');

      verify(backend.post(
          'service/termine/neu',
          '{'
              '"action":'
              '{'
              '"id":0,'
              '"beginn":"2019-11-04T17:09:00.000",'
              '"ende":"2019-11-04T18:09:00.000",'
              '"ort":"Frankfurter Allee Nord",'
              '"typ":"Sammeln",'
              '"latitude":52.52116,'
              '"longitude":13.41331,'
              '"participants":[{"id":11,"name":"Karl Marx","color":4294198070}],'
              '"details":'
              '{'
              '"id":null,'
              '"treffpunkt":"Weltzeituhr",'
              '"beschreibung":"Bringe Westen und Kl??mmbretter mit",'
              '"kontakt":"Ruft an unter 012345678"}'
              '},'
              '"token":"Token"'
              '}',
          any));
    });

    test('createTermin deserializes action correctly', () async {
      when(backend.post('service/termine/neu', any, any)).thenAnswer((_) =>
          Future<HttpClientResponseBody>.value(trainHttpResponse(
              MockHttpClientResponseBody(),
              200,
              TerminTestDaten.einTerminMitTeilisUndDetails().toJson())));

      var action = await service.createAction(
          TerminTestDaten.einTerminMitTeilisUndDetails(), 'Token');

      expect(action.id, 0);
      expect(action.beginn, DateTime(2019, 11, 4, 17, 9, 0));
      expect(action.ende, DateTime(2019, 11, 4, 18, 9, 0));
      expect(action.ort.ortsteil, 'Friedrichshain');
      expect(action.ort.region, 'Friedrichshain Ost');
      expect(action.ort.name, 'Frankfurter Allee Nord');
      expect(action.typ, 'Sammeln');
      expect(action.latitude, 52.52116);
      expect(action.longitude, 13.41331);
      expect(action.participants!.length, 1);
      expect(action.participants![0].id, 11);
      expect(action.participants![0].name, 'Karl Marx');
      expect(action.participants![0].color?.value, Colors.red.value);
      expect(
          action.details!.beschreibung, 'Bringe Westen und Kl??mmbretter mit');
      expect(action.details!.treffpunkt, 'Weltzeituhr');
      expect(action.details!.kontakt, 'Ruft an unter 012345678');
    });

    test('getActionWithDetails calls right path', () async {
      when(backend.get('service/termine/termin?id=0', any)).thenAnswer((_) =>
          Future<HttpClientResponseBody>.value(trainHttpResponse(
              MockHttpClientResponseBody(),
              200,
              TerminTestDaten.einTerminMitTeilisUndDetails().toJson())));

      await service.getActionWithDetails(0);

      verify(backend.get('service/termine/termin?id=0', any));
    });

    test('getActionWithDetails deserializes action correctly', () async {
      when(backend.get('service/termine/termin?id=0', any)).thenAnswer((_) =>
          Future<HttpClientResponseBody>.value(trainHttpResponse(
              MockHttpClientResponseBody(),
              200,
              TerminTestDaten.einTerminMitTeilisUndDetails().toJson())));

      var action = await service.getActionWithDetails(0);

      expect(action.id, 0);
      expect(action.beginn, DateTime(2019, 11, 4, 17, 9, 0));
      expect(action.ende, DateTime(2019, 11, 4, 18, 9, 0));
      expect(action.ort.ortsteil, 'Friedrichshain');
      expect(action.ort.region, 'Friedrichshain Ost');
      expect(action.ort.name, 'Frankfurter Allee Nord');
      expect(action.typ, 'Sammeln');
      expect(action.latitude, 52.52116);
      expect(action.longitude, 13.41331);
      expect(action.participants!.length, 1);
      expect(action.participants![0].id, 11);
      expect(action.participants![0].name, 'Karl Marx');
      expect(action.participants![0].color?.value, Colors.red.value);
      expect(
          action.details!.beschreibung, 'Bringe Westen und Kl??mmbretter mit');
      expect(action.details!.treffpunkt, 'Weltzeituhr');
      expect(action.details!.kontakt, 'Ruft an unter 012345678');
    });

    test(
        'saveAction calls right path and serialises action and token correctly',
        () async {
      when(backend.post('service/termine/termin', any, any)).thenAnswer((_) =>
          Future<HttpClientResponseBody>.value(trainHttpResponse(
              MockHttpClientResponseBody(), 200, 'response')));

      await service.saveAction(
          TerminTestDaten.einTerminMitTeilisUndDetails(), 'Token');

      verify(backend.post(
          'service/termine/termin',
          '{'
              '"action":'
              '{'
              '"id":0,'
              '"beginn":"2019-11-04T17:09:00.000",'
              '"ende":"2019-11-04T18:09:00.000",'
              '"ort":"Frankfurter Allee Nord",'
              '"typ":"Sammeln",'
              '"latitude":52.52116,'
              '"longitude":13.41331,'
              '"participants":[{"id":11,"name":"Karl Marx","color":4294198070}],'
              '"details":'
              '{'
              '"id":null,'
              '"treffpunkt":"Weltzeituhr",'
              '"beschreibung":"Bringe Westen und Kl??mmbretter mit",'
              '"kontakt":"Ruft an unter 012345678"}'
              '},'
              '"token":"Token"'
              '}',
          any));
    });

    test(
        'deleteAction calls right path and serialises action and token correctly',
        () async {
      when(backend.delete('service/termine/termin', any, any)).thenAnswer((_) =>
          Future<HttpClientResponseBody>.value(trainHttpResponse(
              MockHttpClientResponseBody(), 200, 'response')));

      await service.deleteAction(
          TerminTestDaten.einTerminMitTeilisUndDetails(), 'Token');

      verify(backend.delete(
          'service/termine/termin',
          '{'
              '"action":'
              '{'
              '"id":0,'
              '"beginn":"2019-11-04T17:09:00.000",'
              '"ende":"2019-11-04T18:09:00.000",'
              '"ort":"Frankfurter Allee Nord",'
              '"typ":"Sammeln",'
              '"latitude":52.52116,'
              '"longitude":13.41331,'
              '"participants":[{"id":11,"name":"Karl Marx","color":4294198070}],'
              '"details":'
              '{'
              '"id":null,'
              '"treffpunkt":"Weltzeituhr",'
              '"beschreibung":"Bringe Westen und Kl??mmbretter mit",'
              '"kontakt":"Ruft an unter 012345678"}'
              '},'
              '"token":"Token"'
              '}',
          any));
    });

    test('joinAction calls correct path with parameters', () async {
      when(backend.post(any, any, any, any)).thenAnswer((_) =>
          Future<HttpClientResponseBody>.value(
              trainHttpResponse(MockHttpClientResponseBody(), 202, null)));

      await service.joinAction(0);

      Map<String, String> parameters = verify(
              backend.post('service/termine/teilnahme', any, any, captureAny))
          .captured
          .single;
      expect(parameters.length, 1);
      expect(parameters['id'], '0');
    });

    test('leaveAction calls correct path with parameters', () async {
      when(backend.post(any, any, any, any)).thenAnswer((_) =>
          Future<HttpClientResponseBody>.value(
              trainHttpResponse(MockHttpClientResponseBody(), 200, null)));

      await service.leaveAction(0);

      Map<String, String> parameters =
          verify(backend.post('service/termine/absage', any, any, captureAny))
              .captured
              .single;
      expect(parameters.length, 1);
      expect(parameters['id'], '0');
    });
  });
}

TermineFilter einFilter() {
  var datum = DateTime.parse('2020-08-20');
  var start = DateTime.parse('2020-08-20 15:00:00');
  var end = DateTime.parse('2020-08-20 18:30:00');
  var einFilter = TermineFilter(
      ["Sammeln"],
      [datum],
      TimeOfDay.fromDateTime(start),
      TimeOfDay.fromDateTime(end),
      [ffAlleeNord().name],
      false,
      false);
  return einFilter;
}
