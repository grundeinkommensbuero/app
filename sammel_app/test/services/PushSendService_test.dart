import 'package:flutter_test/flutter_test.dart';
import 'package:http_server/http_server.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/PushSendService.dart';

import '../shared/mocks.trainer.dart';
import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';

main() {
  var userService = MockUserService();
  trainUserService(userService);

  var backendMock = MockBackend();
  trainBackend(backendMock);

  group('PushService', () {
    late PushSendService service;
    setUp(() {
      reset(backendMock);
      service = PushSendService(userService, backendMock);
    });

    test('pushToDevices erwartet Empfänger', () {
      expect(
          () => service.pushToDevices(
              null, PushData(), PushNotification('Titel', "Inhalt")),
          throwsA((e) => e is MissingTargetError));

      expect(
          () => service.pushToDevices(
              [], PushData(), PushNotification('Titel', "Inhalt")),
          throwsA((e) => e is MissingTargetError));
    });

    test('pushToDevices sendet Push-Nachricht an Server', () async {
      when(backendMock.post(any, any, any)).thenAnswer((_) async =>
          Future<HttpClientResponseBody>.value(
              trainHttpResponse(MockHttpClientResponseBody(), 200, null)));
      await service.pushToDevices(
          ['Empfänger'], PushData(), PushNotification('Titel', 'Inhalt'));

      verify(backendMock.post(
          'service/push/devices',
          '{"recipients":["Empfänger"],"data":{"type":null},"notification":{"title":"Titel","body":"Inhalt"}}',
          any,
          any));
    });
  });

  group('DemoPushService', () {
    late DemoPushSendService service;

    setUp(() {
      reset(backendMock);
      service = DemoPushSendService(userService);
    });

    test('pushToDevices erwartet Empfänger', () {
      expect(
          () => service.pushToDevices(
              null, PushData(), PushNotification('Titel', "Inhalt")),
          throwsA((e) => e is MissingTargetError));

      expect(
          () => service.pushToDevices(
              [], PushData(), PushNotification('Titel', "Inhalt")),
          throwsA((e) => e is MissingTargetError));
    });

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
    });

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
    });
  });
}
