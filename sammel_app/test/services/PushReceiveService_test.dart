import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_server/http_server.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:test/test.dart';

import '../shared/Mocks.dart';

main() {
  mockTranslation();

  FirebaseMessaging firebaseMock = FirebaseMessagingMock();
  UserService userService = ConfiguredUserServiceMock();

  setUp(() {
    reset(firebaseMock);
    when(firebaseMock.getToken()).thenAnswer((_) async => "firebase-token");
  ***REMOVED***);

  group('FirebaseReceiveService', () {
    when(firebaseMock.getToken()).thenAnswer((_) async => '123');

    test('takes Mock if given', () {
      FirebaseReceiveService(false, firebaseMock);

      expect(FirebaseReceiveService.firebaseMessaging, firebaseMock);
      expect(FirebaseReceiveService.firebaseMessaging is FirebaseMessagingMock,
          true);
    ***REMOVED***);

    test('registers onMessage listener', () {
      var firebaseListener = FirebaseReceiveService(false, firebaseMock);
      var onMessage = (_) async => null;

      firebaseListener.subscribe(onMessage: onMessage);

      verify(firebaseMock.configure(onMessage: onMessage)).called(1);
    ***REMOVED***);
  ***REMOVED***);

  group('PullService', () {
    Backend backend = BackendMock();
    late PullService service;

    setUp(() {
      reset(backend);
      service = PullService(userService, backend);
    ***REMOVED***);

    group('initially', () {
      test('uses dummy handlers', () {
        expect(service.onMessage(null), isNotNull);
      ***REMOVED***);

      test('stores handlers', () {
        var onMessage = (_) async => Map();

        service.subscribe(onMessage: onMessage);

        expect(service.onMessage, onMessage);
      ***REMOVED***);

      test('starts timer', () {
        expect(service.timer.isActive, true);
      ***REMOVED***);
    ***REMOVED***);

    group("pull", () {
      test('requests messages from server', () async {
        when(backend.get('service/push/pull', any)).thenAnswer((_) =>
            Future<HttpClientResponseBody>.value(
                HttpClientResponseBodyMock([], 200)));

        await service.pull();

        verify(backend.get('service/push/pull', any));
      ***REMOVED***);

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
      ***REMOVED***);

      test('calls onMessage for every message', () async {
        var called = 0;
        var onMessage = (_) async => called++;
        service.subscribe(onMessage: onMessage);
        when(backend.get('service/push/pull', any)).thenAnswer((_) =>
            Future<HttpClientResponseBody>.value(HttpClientResponseBodyMock(
                [Map<String, dynamic>(), Map<String, dynamic>()], 200)));

        await service.pull();

        expect(called, 2);
      ***REMOVED***);

      test('calls onMessage only w/ status code ~200', () async {
        var onMessage =
            (_) async => fail('onMessage should not have been called');
        service.subscribe(onMessage: onMessage);
        when(backend.get('service/push/pull', any)).thenAnswer((_) =>
            Future<HttpClientResponseBody>.value(HttpClientResponseBodyMock(
                [Map<String, dynamic>(), Map<String, dynamic>()], 403)));

        try {
          service.pull();
        ***REMOVED*** catch (e) {***REMOVED***
      ***REMOVED***);

      test('stops timer on error', () async {
        when(backend.get('service/push/pull', any)).thenThrow(Error());

        expect(service.timer.isActive, true);

        try {
          await service.pull();
        ***REMOVED*** on Error catch (_) {***REMOVED***

        expect(service.timer.isActive, false);
      ***REMOVED***);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
