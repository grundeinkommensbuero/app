import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/TermineService.dart';

import '../model/Ort_test.dart';
import '../model/Termin_test.dart';
import '../shared/Mocks.dart';

void main() {
  group('DemoTermineService', () {
    DemoTermineService service;
    setUp(() {
      service = DemoTermineService();
    });

    test('uses DemoBackend', () {
      expect(service.backend is DemoBackend, true);
    });

    test('creates new Termin', () async {
      expect(
          (await service.ladeTermine(TermineFilter.leererFilter())).length, 4);

      var response = await service.createTermin(
          Termin(
              null,
              DateTime.now(),
              Jiffy(DateTime.now()).add(days: 1),
              Ort(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez',
                  52.51579, 13.45399),
              'Sammeln',
              52.52116,
              13.41331,
              [karl()],
              TerminDetails(
                  'U-Bahnhof Samariterstraße',
                  'wir gehen die Frankfurter Allee hoch',
                  'Ihr erreicht uns unter 0234567')),
          '');

      expect(response.id, 5);
      expect(
          (await service.ladeTermine(TermineFilter.leererFilter())).length, 5);
    });

    test('deletes action', () async {
      var actionsBefore =
          await service.ladeTermine(TermineFilter.leererFilter());
      expect(
          actionsBefore.map((action) => action.id), containsAll([1, 2, 3, 4]));

      await service.deleteAction(actionsBefore[1], '');

      var actionsAfter =
          await service.ladeTermine(TermineFilter.leererFilter());
      expect(actionsAfter.map((action) => action.id), containsAll([1, 3, 4]));
    });

    test('stores new action', () async {
      expect(service.termine[0].typ, 'Sammeln');
      expect(service.termine[0].ort.id, 1);
      expect(service.termine[0].details.kontakt, 'Ruft mich an unter 01234567');

      await service.saveAction(
          TerminTestDaten.einTermin()
            ..id = 1
            ..typ = 'Infoveranstaltung'
            ..ort = treptowerPark()
            ..details = TerminDetails('bla', 'blub', 'Test123'),
          '');

      expect(service.termine[0].typ, 'Infoveranstaltung');
      expect(service.termine[0].ort.id, 2);
      expect(service.termine[0].details.kontakt, 'Test123');
    });

    test('attendAction adds user to action', () async {
      service.termine[0].participants = [rosa()];

      await service.attendAction(service.termine[0], karl());

      expect(service.termine[0].participants.map((e) => e.id),
          containsAll([1, 2]));
    });

    test('attendAction ignores if user already partakes', () async {
      service.termine[0].participants = [rosa(), karl()];

      await service.attendAction(service.termine[0], karl());

      expect(service.termine[0].participants.map((e) => e.id),
          containsAll([1, 2]));
    });

    test('dismissAction removes user from action', () async {
      service.termine[0].participants = [rosa(), karl()];

      await service.dismissAction(service.termine[0], karl());

      expect(
          service.termine[0].participants.map((e) => e.id), containsAll([2]));
    });

    test('dismissAction ignores if user doesnt partake', () async {
      service.termine[0].participants = [rosa()];

      await service.dismissAction(service.termine[0], karl());

      expect(
          service.termine[0].participants.map((e) => e.id), containsAll([2]));
    });
  });

  group('Participation serialises', () {
    test('empty', () {
      expect(
          jsonEncode(Participation(null, null)), '{"action":null,"user":null}');
    });

    test('filled', () {
      expect(jsonEncode(Participation(TerminTestDaten.einTermin(), karl())),
          '{"action":${jsonEncode(TerminTestDaten.einTermin())},"user":{"id":1,"name":"Karl Marx","color":4294198070}}');
    });
  });

  group('TermineService', () {
    Backend backend;
    TermineService service;

    setUp(() {
      backend = BackendMock();
      service = TermineService(backend);
    });

    test('attendAction calls correct path', () {
      when(backend.post('service/termine/teilnahme', any))
          .thenAnswer((_) async => HttpClientResponseBodyMock(null, 202));

      service.attendAction(TerminTestDaten.einTermin(), karl());

      verify(backend.post(
          'service/termine/teilnahme',
          '{"action":${jsonEncode(TerminTestDaten.einTermin())},'
              '"user":${jsonEncode(karl())}}'));
    });

    test('dismissAction calls correct path', () {
      when(backend.post('service/termine/absage', any))
          .thenAnswer((_) async => HttpClientResponseBodyMock(null, 202));

      service.dismissAction(TerminTestDaten.einTermin(), karl());

      verify(backend.post(
          'service/termine/absage',
          '{"action":${jsonEncode(TerminTestDaten.einTermin())},'
              '"user":${jsonEncode(karl())}}'));
    });
  });
}
