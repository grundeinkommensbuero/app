import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';

import '../model/Ort_test.dart';
import '../model/Termin_test.dart';
import '../shared/Mocks.dart';
import '../shared/TestdatenVorrat.dart';

void main() {
  UserService userService;

  setUp(() {
    userService = ConfiguredUserServiceMock();
  ***REMOVED***);

  group('DemoTermineService', () {
    DemoTermineService service;
    setUp(() {
      service = DemoTermineService(userService);
    ***REMOVED***);

    test('uses DemoBackend', () {
      expect(service.backend is DemoBackend, true);
    ***REMOVED***);

    test('creates new Termin', () async {
      expect(
          (await service.loadActions(TermineFilter.leererFilter())).length, 4);

      var response = await service.createAction(
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
          (await service.loadActions(TermineFilter.leererFilter())).length, 5);
    ***REMOVED***);

    test('deletes action', () async {
      var actionsBefore =
          await service.loadActions(TermineFilter.leererFilter());
      expect(
          actionsBefore.map((action) => action.id), containsAll([1, 2, 3, 4]));

      await service.deleteAction(actionsBefore[1], '');

      var actionsAfter =
          await service.loadActions(TermineFilter.leererFilter());
      expect(actionsAfter.map((action) => action.id), containsAll([1, 3, 4]));
    ***REMOVED***);

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
    ***REMOVED***);

    test('joinAction adds user to action', () async {
      service.termine[0].participants = [rosa()];

      await service.joinAction(service.termine[0], karl());

      expect(service.termine[0].participants.map((e) => e.id),
          containsAll([11, 12]));
    ***REMOVED***);

    test('joinAction ignores if user already partakes', () async {
      service.termine[0].participants = [rosa(), karl()];

      await service.joinAction(service.termine[0], karl());

      expect(service.termine[0].participants.map((e) => e.id),
          containsAll([11, 12]));
    ***REMOVED***);

    test('leaveAction removes user from action', () async {
      service.termine[0].participants = [rosa(), karl()];

      await service.leaveAction(service.termine[0], karl());

      expect(
          service.termine[0].participants.map((e) => e.id), containsAll([12]));
    ***REMOVED***);

    test('leaveAction ignores if user doesnt partake', () async {
      service.termine[0].participants = [rosa()];

      await service.leaveAction(service.termine[0], karl());

      expect(
          service.termine[0].participants.map((e) => e.id), containsAll([12]));
    ***REMOVED***);
  ***REMOVED***);

  group('Participation serialises', () {
    test('empty', () {
      expect(
          jsonEncode(Participation(null, null)), '{"action":null,"user":null***REMOVED***');
    ***REMOVED***);

    test('filled', () {
      expect(jsonEncode(Participation(TerminTestDaten.einTermin(), karl())),
          '{"action":${jsonEncode(TerminTestDaten.einTermin())***REMOVED***,"user":{"id":11,"name":"Karl Marx","color":4294198070***REMOVED******REMOVED***');
    ***REMOVED***);
  ***REMOVED***);

  group('TermineService', () {
    Backend backend;
    TermineService service;

    setUp(() {
      backend = BackendMock();
      service = TermineService(userService, backend);
      service.userService = userService;
    ***REMOVED***);

    test('loadActions calls right path and serializes Filter correctly',
        () async {
      when(backend.post('service/termine', any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock([], 200));

      await service.loadActions(einFilter());

      verify(backend.post(
          'service/termine',
          ''
              '{'
              '"typen":["Sammeln"],'
              '"tage":["2020-08-20"],'
              '"von":"15:00:00",'
              '"bis":"18:30:00",'
              '"orte":[{"id":1,"bezirk":"Friedrichshain-Kreuzberg","ort":"Friedrichshain Nordkiez","lattitude":52.51579,"longitude":13.45399***REMOVED***]'
              '***REMOVED***',
          any));
    ***REMOVED***);

    test('loadActions deserializes actions correctly', () async {
      when(backend.post('service/termine', any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock([
                TerminTestDaten.einTerminMitTeilisUndDetails().toJson(),
                TerminTestDaten.einTerminOhneTeilisMitDetails().toJson()
              ], 200));

      var actions = await service.loadActions(einFilter());

      expect(actions.length, 2);
      expect(actions[0].id, 0);
      expect(actions[0].beginn, DateTime(2019, 11, 4, 17, 9, 0));
      expect(actions[0].ende, DateTime(2019, 11, 4, 18, 9, 0));
      expect(actions[0].ort.id, 1);
      expect(actions[0].ort.bezirk, 'Friedrichshain-Kreuzberg');
      expect(actions[0].ort.ort, 'Friedrichshain Nordkiez');
      expect(actions[0].ort.latitude, 52.51579);
      expect(actions[0].ort.longitude, 13.45399);
      expect(actions[0].typ, 'Sammeln');
      expect(actions[0].latitude, 52.52116);
      expect(actions[0].longitude, 13.41331);
      expect(actions[0].participants.length, 1);
      expect(actions[0].participants[0].id, 11);
      expect(actions[0].participants[0].name, 'Karl Marx');
      expect(actions[0].participants[0].color.value, Colors.red.value);
      expect(
          actions[0].details.kommentar, 'Bringe Westen und Klämmbretter mit');
      expect(actions[0].details.treffpunkt, 'Weltzeituhr');
      expect(actions[0].details.kontakt, 'Ruft an unter 012345678');
      expect(actions[1].id, 0);
      expect(actions[1].beginn, DateTime(2019, 11, 4, 17, 9, 0));
      expect(actions[1].ende, DateTime(2019, 11, 4, 18, 9, 0));
      expect(actions[1].ort.id, 1);
      expect(actions[1].ort.bezirk, 'Friedrichshain-Kreuzberg');
      expect(actions[1].ort.ort, 'Friedrichshain Nordkiez');
      expect(actions[1].ort.latitude, 52.51579);
      expect(actions[1].ort.longitude, 13.45399);
      expect(actions[1].typ, 'Sammeln');
      expect(actions[1].latitude, 52.52116);
      expect(actions[1].longitude, 13.41331);
      expect(actions[1].participants.length, 0);
      expect(
          actions[1].details.kommentar, 'Bringe Westen und Klämmbretter mit');
      expect(actions[1].details.treffpunkt, 'Weltzeituhr');
      expect(actions[1].details.kontakt, 'Ruft an unter 012345678');
    ***REMOVED***);

    test(
        'createTermin calls right path and serializes action and token correctly',
        () async {
      when(backend.post('service/termine/neu', any, any)).thenAnswer(
          (_) async => HttpClientResponseBodyMock(
              TerminTestDaten.einTerminMitTeilisUndDetails().toJson(), 200));

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
              '"ort":'
              '{'
              '"id":1,'
              '"bezirk":"Friedrichshain-Kreuzberg",'
              '"ort":"Friedrichshain Nordkiez",'
              '"lattitude":52.51579,'
              '"longitude":13.45399'
              '***REMOVED***,'
              '"typ":"Sammeln",'
              '"lattitude":52.52116,'
              '"longitude":13.41331,'
              '"participants":[{"id":11,"name":"Karl Marx","color":4294198070***REMOVED***],'
              '"details":'
              '{'
              '"id":null,'
              '"treffpunkt":"Weltzeituhr",'
              '"kommentar":"Bringe Westen und Klämmbretter mit",'
              '"kontakt":"Ruft an unter 012345678"***REMOVED***'
              '***REMOVED***,'
              '"token":"Token"'
              '***REMOVED***',
          any));
    ***REMOVED***);

    test('createTermin deserializes action correctly', () async {
      when(backend.post('service/termine/neu', any, any)).thenAnswer(
          (_) async => HttpClientResponseBodyMock(
              TerminTestDaten.einTerminMitTeilisUndDetails().toJson(), 200));

      var action = await service.createAction(
          TerminTestDaten.einTerminMitTeilisUndDetails(), 'Token');

      expect(action.id, 0);
      expect(action.beginn, DateTime(2019, 11, 4, 17, 9, 0));
      expect(action.ende, DateTime(2019, 11, 4, 18, 9, 0));
      expect(action.ort.id, 1);
      expect(action.ort.bezirk, 'Friedrichshain-Kreuzberg');
      expect(action.ort.ort, 'Friedrichshain Nordkiez');
      expect(action.ort.latitude, 52.51579);
      expect(action.ort.longitude, 13.45399);
      expect(action.typ, 'Sammeln');
      expect(action.latitude, 52.52116);
      expect(action.longitude, 13.41331);
      expect(action.participants.length, 1);
      expect(action.participants[0].id, 11);
      expect(action.participants[0].name, 'Karl Marx');
      expect(action.participants[0].color.value, Colors.red.value);
      expect(action.details.kommentar, 'Bringe Westen und Klämmbretter mit');
      expect(action.details.treffpunkt, 'Weltzeituhr');
      expect(action.details.kontakt, 'Ruft an unter 012345678');
    ***REMOVED***);

    test('getActionWithDetails calls right path', () async {
      when(backend.get('service/termine/termin?id=0', any)).thenAnswer(
          (_) async => HttpClientResponseBodyMock(
              TerminTestDaten.einTerminMitTeilisUndDetails().toJson(), 200));

      await service.getActionWithDetails(0);

      verify(backend.get('service/termine/termin?id=0', any));
    ***REMOVED***);

    test('getActionWithDetails deserializes action correctly', () async {
      when(backend.get('service/termine/termin?id=0', any)).thenAnswer(
          (_) async => HttpClientResponseBodyMock(
              TerminTestDaten.einTerminMitTeilisUndDetails().toJson(), 200));

      var action = await service.getActionWithDetails(0);

      expect(action.id, 0);
      expect(action.beginn, DateTime(2019, 11, 4, 17, 9, 0));
      expect(action.ende, DateTime(2019, 11, 4, 18, 9, 0));
      expect(action.ort.id, 1);
      expect(action.ort.bezirk, 'Friedrichshain-Kreuzberg');
      expect(action.ort.ort, 'Friedrichshain Nordkiez');
      expect(action.ort.latitude, 52.51579);
      expect(action.ort.longitude, 13.45399);
      expect(action.typ, 'Sammeln');
      expect(action.latitude, 52.52116);
      expect(action.longitude, 13.41331);
      expect(action.participants.length, 1);
      expect(action.participants[0].id, 11);
      expect(action.participants[0].name, 'Karl Marx');
      expect(action.participants[0].color.value, Colors.red.value);
      expect(action.details.kommentar, 'Bringe Westen und Klämmbretter mit');
      expect(action.details.treffpunkt, 'Weltzeituhr');
      expect(action.details.kontakt, 'Ruft an unter 012345678');
    ***REMOVED***);

    test(
        'saveAction calls right path and serialises action and token correctly',
        () async {
      when(backend.post('service/termine/termin', any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock('response', 200));

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
              '"ort":'
              '{'
              '"id":1,'
              '"bezirk":"Friedrichshain-Kreuzberg",'
              '"ort":"Friedrichshain Nordkiez",'
              '"lattitude":52.51579,'
              '"longitude":13.45399'
              '***REMOVED***,'
              '"typ":"Sammeln",'
              '"lattitude":52.52116,'
              '"longitude":13.41331,'
              '"participants":[{"id":11,"name":"Karl Marx","color":4294198070***REMOVED***],'
              '"details":'
              '{'
              '"id":null,'
              '"treffpunkt":"Weltzeituhr",'
              '"kommentar":"Bringe Westen und Klämmbretter mit",'
              '"kontakt":"Ruft an unter 012345678"***REMOVED***'
              '***REMOVED***,'
              '"token":"Token"'
              '***REMOVED***',
          any));
    ***REMOVED***);

    test(
        'deleteAction calls right path and serialises action and token correctly',
        () async {
      when(backend.delete('service/termine/termin', any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock('response', 200));

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
              '"ort":'
              '{'
              '"id":1,'
              '"bezirk":"Friedrichshain-Kreuzberg",'
              '"ort":"Friedrichshain Nordkiez",'
              '"lattitude":52.51579,'
              '"longitude":13.45399'
              '***REMOVED***,'
              '"typ":"Sammeln",'
              '"lattitude":52.52116,'
              '"longitude":13.41331,'
              '"participants":[{"id":11,"name":"Karl Marx","color":4294198070***REMOVED***],'
              '"details":'
              '{'
              '"id":null,'
              '"treffpunkt":"Weltzeituhr",'
              '"kommentar":"Bringe Westen und Klämmbretter mit",'
              '"kontakt":"Ruft an unter 012345678"***REMOVED***'
              '***REMOVED***,'
              '"token":"Token"'
              '***REMOVED***',
          any));
    ***REMOVED***);

    test('joinAction calls correct path', () async {
      when(backend.post('service/termine/teilnahme', any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock(null, 202));

      await service.joinAction(TerminTestDaten.einTermin(), karl());

      verify(backend.post(
          'service/termine/teilnahme',
          '{"action":${jsonEncode(TerminTestDaten.einTermin())***REMOVED***,'
              '"user":${jsonEncode(karl())***REMOVED******REMOVED***',
          any));
    ***REMOVED***);

    test('leaveAction calls correct path', () async {
      when(backend.post('service/termine/absage', any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock(null, 202));

      await service.leaveAction(TerminTestDaten.einTermin(), karl());

      verify(backend.post(
          'service/termine/absage',
          '{"action":${jsonEncode(TerminTestDaten.einTermin())***REMOVED***,'
              '"user":${jsonEncode(karl())***REMOVED******REMOVED***',
          any));
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

TermineFilter einFilter() {
  var datum = DateTime.parse('2020-08-20');
  var start = DateTime.parse('2020-08-20 15:00:00');
  var end = DateTime.parse('2020-08-20 18:30:00');
  var einFilter = TermineFilter(["Sammeln"], [datum],
      TimeOfDay.fromDateTime(start), TimeOfDay.fromDateTime(end), [nordkiez()]);
  return einFilter;
***REMOVED***
