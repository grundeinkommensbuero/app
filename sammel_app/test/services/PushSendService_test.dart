import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/UserService.dart';

import '../shared/Mocks.dart';

main() {
  UserService userService = ConfiguredUserServiceMock();

  var backendMock = BackendMock();

  group('PushService', () {
    PushSendService service;
    setUp(() {
      reset(backendMock);
      service = PushSendService(userService, backendMock);
    ***REMOVED***);

    test('pushToDevices erwartet Empfänger', () {
      expect(
          () => service.pushToDevices(
              null, PushData(), PushNotification('Titel', "Inhalt")),
          throwsA((e) => e is MissingTargetError));

      expect(
          () => service.pushToDevices(
              [], PushData(), PushNotification('Titel', "Inhalt")),
          throwsA((e) => e is MissingTargetError));
    ***REMOVED***);

    test('pushToDevices sendet Push-Nachricht an Server', () async {
      when(backendMock.post(any, any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock(null, 200));
      await service.pushToDevices(
          ['Empfänger'], PushData(), PushNotification('Titel', 'Inhalt'));

      verify(backendMock.post(
          'service/push/devices',
          '{"recipients":["Empfänger"],"data":{"encrypted":"Base64","payload":"eyJ0eXBlIjpudWxsfQ=="***REMOVED***,"notification":{"title":"Titel","body":"Inhalt"***REMOVED******REMOVED***',
          any));
    ***REMOVED***);

    test('pushToTopic erwartet Thema', () {
      expect(
          () => service.pushToTopic(
              null, PushData(), PushNotification('Titel', "Inhalt")),
          throwsA((e) => e is MissingTargetError));

      expect(
          () => service.pushToTopic(
              '', PushData(), PushNotification('Titel', "Inhalt")),
          throwsA((e) => e is MissingTargetError));
    ***REMOVED***);

    test('pushToTopic sendet Push-Nachricht an Server', () async {
      when(backendMock.post(any, any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock(null, 200));
      await service.pushToTopic(
          'Thema', PushData(), PushNotification('Titel', 'Inhalt'));

      verify(backendMock.post(
          'service/push/topic/Thema',
          '{"recipients":null,"data":{"encrypted":"Base64","payload":"eyJ0eXBlIjpudWxsfQ=="***REMOVED***,"notification":{"title":"Titel","body":"Inhalt"***REMOVED******REMOVED***',
          any));
    ***REMOVED***);
  ***REMOVED***);

  group('DemoPushService', () {
    DemoPushSendService service;

    setUp(() {
      reset(backendMock);
      service = DemoPushSendService(userService);
    ***REMOVED***);

    test('pushToDevices erwartet Empfänger', () {
      expect(
          () => service.pushToDevices(
              null, PushData(), PushNotification('Titel', "Inhalt")),
          throwsA((e) => e is MissingTargetError));

      expect(
          () => service.pushToDevices(
              [], PushData(), PushNotification('Titel', "Inhalt")),
          throwsA((e) => e is MissingTargetError));
    ***REMOVED***);

    test('pushToDevices legt Nachricht in Stream', () async {
      List<PushData> gesendeteNachrichten = [];
      service.stream.listen((data) => gesendeteNachrichten.add(data));

      var pushData1 = PushData();
      var pushData2 = PushData();
      await service.pushToDevices(
          ['Empfänger'], pushData1, PushNotification('Titel', "Inhalt"));
      await service.pushToDevices(
          ['Empfänger'], pushData2, PushNotification('Titel', "Inhalt"));

      expect(gesendeteNachrichten.length, 2);
      expect(true, gesendeteNachrichten.contains(pushData1));
      expect(true, gesendeteNachrichten.contains(pushData2));
    ***REMOVED***);

    test('pushToTopic erwartet Thema', () {
      expect(
          () => service.pushToTopic(
              null, PushData(), PushNotification('Titel', "Inhalt")),
          throwsA((e) => e is MissingTargetError));

      expect(
          () => service.pushToTopic(
              '', PushData(), PushNotification('Titel', "Inhalt")),
          throwsA((e) => e is MissingTargetError));
    ***REMOVED***);

    test('pushToTopic legt Nachricht in Stream', () async {
      List<PushData> gesendeteNachrichten = [];
      service.stream.listen((data) => gesendeteNachrichten.add(data));

      var pushData1 = PushData();
      var pushData2 = PushData();
      await service.pushToTopic(
          'Thema', pushData1, PushNotification('Titel', "Inhalt"));
      await service.pushToTopic(
          'Thema', pushData2, PushNotification('Titel', "Inhalt"));

      expect(gesendeteNachrichten.length, 2);
      expect(true, gesendeteNachrichten.contains(pushData1));
      expect(true, gesendeteNachrichten.contains(pushData2));
    ***REMOVED***);

    test('pushToAction legt Nachricht in Stream', () async {
      List<PushData> gesendeteNachrichten = [];
      service.stream.listen((data) => gesendeteNachrichten.add(data));

      var pushData1 = PushData();
      var pushData2 = PushData();
      await service.pushToAction(
          1, pushData1, PushNotification('Titel', "Inhalt"));
      await service.pushToAction(
          1, pushData2, PushNotification('Titel', "Inhalt"));

      expect(gesendeteNachrichten.length, 2);
      expect(true, gesendeteNachrichten.contains(pushData1));
      expect(true, gesendeteNachrichten.contains(pushData2));
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
