import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_server/http_server.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:test/test.dart';

import '../shared/Mocks.dart';

main() {
  FirebaseMessaging firebaseMock = FirebaseMessagingMock();
  UserService userService = ConfiguredUserServiceMock();

  setUp(() {
    reset(firebaseMock);
    when(firebaseMock.getToken()).thenAnswer((_) async => "firebase-token");
  });

  group('FirebaseReceiveService', () {
    when(firebaseMock.getToken()).thenAnswer((_) async => '123');

    test('takes Mock if given', () {
      FirebaseReceiveService(firebaseMock);

      expect(FirebaseReceiveService.firebaseMessaging, firebaseMock);
      expect(FirebaseReceiveService.firebaseMessaging is FirebaseMessagingMock,
          true);
    });

    test('registers onMessage listener', () {
      var firebaseListener = FirebaseReceiveService(firebaseMock);
      var onMessage = (_) async => null;

      firebaseListener.subscribe(onMessage: onMessage);

      verify(firebaseMock.configure(onMessage: onMessage)).called(1);
    });
  });

  group('PullService', () {
    Backend backend = BackendMock();
    PullService service;

    setUp(() {
      reset(backend);
      service = PullService(userService, backend);
    });

    group('initially', () {
      test('uses dummy handlers', () {
        expect(service.onMessage(null), isNotNull);
      });

      test('stores handlers', () {
        var onMessage = (_) async => Map();

        service.subscribe(onMessage: onMessage);

        expect(service.onMessage, onMessage);
      });

      test('starts timer', () {
        expect(service.timer.isActive, true);
      });
    });

    group("pull", () {
      test('requests messages from server', () async {
        when(backend.get('service/push/pull', any)).thenAnswer((_) =>
            Future<HttpClientResponseBody>.value(
                HttpClientResponseBodyMock([], 200)));

        await service.pull();

        verify(backend.get('service/push/pull', any));
      });

      test('calls not onMessage if messages null or empty', () async {
        var onMessage =
            (_) async => fail('onMessage should not have been called');
        service.subscribe(onMessage: onMessage);

        when(backend.get('service/push/pull', any)).thenAnswer((_) =>
            Future<HttpClientResponseBody>.value(
                HttpClientResponseBodyMock(null, 200)));
        await service.pull();

        when(backend.get('service/push/pull', any)).thenAnswer((_) =>
            Future<HttpClientResponseBody>.value(
                HttpClientResponseBodyMock([], 200)));
        await service.pull();
      });

      test('calls onMessage for every message', () async {
        var called = 0;
        var onMessage = (_) async => called++;
        service.subscribe(onMessage: onMessage);
        when(backend.get('service/push/pull', any)).thenAnswer((_) =>
            Future<HttpClientResponseBody>.value(HttpClientResponseBodyMock(
                [Map<String, dynamic>(), Map<String, dynamic>()], 200)));

        await service.pull();

        expect(called, 2);
      });

      test('calls onMessage only w/ status code ~200', () async {
        var onMessage =
            (_) async => fail('onMessage should not have been called');
        service.subscribe(onMessage: onMessage);
        when(backend.get('service/push/pull', any)).thenAnswer((_) =>
            Future<HttpClientResponseBody>.value(HttpClientResponseBodyMock(
                [Map<String, dynamic>(), Map<String, dynamic>()], 403)));

        await service.pull();
      });

      test('stops timer on error', () async {
        when(backend.get('service/push/pull', any)).thenThrow(Error());

        expect(service.timer.isActive, true);

        await service.pull();

        expect(service.timer.isActive, false);
      });
    });
  });
}
