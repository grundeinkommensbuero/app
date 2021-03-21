import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_server/http_server.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:test/test.dart';

import '../shared/Trainer.dart';
import '../shared/generated.mocks.dart';

main() {
  trainTranslation(MockTranslations());

  FirebaseMessaging firebaseMock = MockFirebaseMessaging();
  MockUserService userService = MockUserService();
  trainUserService(userService);

  setUp(() {
    reset(firebaseMock);
    when(firebaseMock.getToken()).thenAnswer((_) async => "firebase-token");
  });

  group('FirebaseReceiveService', () {
    when(firebaseMock.getToken()).thenAnswer((_) async => '123');

    test('takes Mock if given', () {
      FirebaseReceiveService(false, firebaseMock);

      expect(FirebaseReceiveService.firebaseMessaging, firebaseMock);
      expect(FirebaseReceiveService.firebaseMessaging is MockFirebaseMessaging,
          true);
    });

    test('listens to onMessage', () {
      var firebaseListener = FirebaseReceiveService(false, firebaseMock);
      var invoked = false;
      var onMessage = (_) async => invoked = true;

      firebaseListener.subscribe(onMessage: onMessage);

      // TODO: Mock FirebaseMessaging
      // verify(FirebaseMessaging.onMessage(onMessage)).called(1);
      // verify(firebaseMock.configure(onMessage: onMessage)).called(1);
    });
  });

  group('PullService', () {
    MockBackend backend = MockBackend();
    trainBackend(backend);
    late PullService service;

    setUp(() {
      reset(backend);
      service = PullService(userService, backend);
    });

    group('initially', () {
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
                trainHttpResponse(MockHttpClientResponseBody(), 200, [])));

        await service.pull();

        verify(backend.get('service/push/pull', any));
      });

      test('calls not onMessage if messages null or empty', () async {
        var onMessage =
            (_) async => fail('onMessage should not have been called');
        service.subscribe(onMessage: onMessage);

        when(backend.get('service/push/pull', any)).thenAnswer((_) =>
            Future<HttpClientResponseBody>.value(
                trainHttpResponse(MockHttpClientResponseBody(), 200, null)));
        await service.pull();

        when(backend.get('service/push/pull', any)).thenAnswer((_) =>
            Future<HttpClientResponseBody>.value(
                trainHttpResponse(MockHttpClientResponseBody(), 200, [])));
        await service.pull();
      });

      test('calls onMessage for every message', () async {
        var called = 0;
        var onMessage = (_) async => called++;
        service.subscribe(onMessage: onMessage);
        when(backend.get('service/push/pull', any)).thenAnswer((_) =>
            Future<HttpClientResponseBody>.value(trainHttpResponse(
                MockHttpClientResponseBody(),
                200,
                [Map<String, dynamic>(), Map<String, dynamic>()])));

        await service.pull();

        expect(called, 2);
      });

      test('calls onMessage only w/ status code ~200', () async {
        var onMessage =
            (_) async => fail('onMessage should not have been called');
        service.subscribe(onMessage: onMessage);
        when(backend.get('service/push/pull', any)).thenAnswer((_) =>
            Future<HttpClientResponseBody>.value(trainHttpResponse(
                MockHttpClientResponseBody(),
                403,
                [Map<String, dynamic>(), Map<String, dynamic>()])));

        try {
          service.pull();
        } catch (e) {}
      });

      test('stops timer on error', () async {
        when(backend.get('service/push/pull', any)).thenThrow(Error());

        expect(service.timer.isActive, true);

        try {
          await service.pull();
        } on Error catch (_) {}

        expect(service.timer.isActive, false);
      });
    });
  });
}
