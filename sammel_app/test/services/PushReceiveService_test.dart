import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:test/test.dart';

import '../shared/Mocks.dart';

main() {
  FirebaseMessaging firebaseMock;
  UserService userService = ConfiguredUserServiceMock();

  setUp(() {
    firebaseMock = FirebaseMessagingMock();
    when(firebaseMock.getToken()).thenAnswer((_) async => "firebase-token");
  });

  group('FirebaseReceiveService', () {
    test('takes Mock if given', () {
      when(firebaseMock.getToken()).thenAnswer((_) => null);
      var firebaseListener = FirebaseReceiveService(firebaseMock);

      expect(firebaseListener.firebaseMessaging, firebaseMock);
      expect(firebaseListener.firebaseMessaging is FirebaseMessagingMock, true);
    });

    test('registers onMessage listener', () {
      when(firebaseMock.getToken()).thenAnswer((_) => null);
      var firebaseListener = FirebaseReceiveService(firebaseMock);
      var onMessage = (_) async => null;

      firebaseListener.subscribe(onMessage: onMessage);

      verify(firebaseMock.configure(onMessage: onMessage)).called(1);
    });
  });

  group('PullReceiveService', () {
    Backend backend = BackendMock();
    PullReceiveService service;

    setUp(() {
      reset(backend);
      service = PullReceiveService(userService, backend);
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
        when(backend.get('service/push/pull', any))
            .thenAnswer((_) async => HttpClientResponseBodyMock([], 200));

        await service.pull();

        verify(backend.get('service/push/pull', any));
      });

      test('calls not onMessage if messages null or empty', () async {
        var onMessage =
            (_) async => fail('onMessage should not have been called');
        service.subscribe(onMessage: onMessage);

        when(backend.get('service/push/pull', any))
            .thenAnswer((_) async => HttpClientResponseBodyMock(null, 200));
        await service.pull();

        when(backend.get('service/push/pull', any))
            .thenAnswer((_) async => HttpClientResponseBodyMock([], 200));
        await service.pull();
      });

      test('calls onMessage for every message', () async {
        var called = 0;
        var onMessage = (_) async => called++;
        service.subscribe(onMessage: onMessage);
        when(backend.get('service/push/pull', any)).thenAnswer((_) async =>
            HttpClientResponseBodyMock(
                [Map<String, dynamic>(), Map<String, dynamic>()], 200));

        await service.pull();

        expect(called, 2);
      });

      test('calls onMessage only w/ status code ~200', () async {
        var onMessage =
            (_) async => fail('onMessage should not have been called');
        service.subscribe(onMessage: onMessage);
        when(backend.get('service/push/pull', any)).thenAnswer((_) async =>
            HttpClientResponseBodyMock(
                [Map<String, dynamic>(), Map<String, dynamic>()], 403));

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
