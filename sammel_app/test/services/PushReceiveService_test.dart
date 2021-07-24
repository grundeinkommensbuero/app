import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_server/http_server.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:test/test.dart';

import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.trainer.dart';

main() {
  trainTranslation(MockTranslations());

  FirebaseMessaging firebaseMock = MockFirebaseMessaging();
  MockUserService userService = MockUserService();

  setUp(() {
    reset(firebaseMock);
    when(firebaseMock.getToken()).thenAnswer((_) async => "firebase-token");
    reset(userService);
    trainUserService(userService);
  ***REMOVED***);

  group('FirebaseReceiveService', () {
    when(firebaseMock.getToken()).thenAnswer((_) async => '123');

    test('takes Mock if given', () {
      FirebaseReceiveService(false, firebaseMock);

      expect(FirebaseReceiveService.firebaseMessaging, firebaseMock);
      expect(FirebaseReceiveService.firebaseMessaging is MockFirebaseMessaging,
          true);
    ***REMOVED***);

    // neues Firebase-Framework nicht mehr sinnvoll mockbar...
    // test('listens to onMessage', () {
    //   var firebaseListener = FirebaseReceiveService(false, firebaseMock);
    //   var invoked = false;
    //   var onMessage = (_) async => invoked = true;
    //
    //   firebaseListener.subscribe(onMessage: onMessage);
    //
    //   verify(FirebaseMessaging.onMessage(onMessage)).called(1);
    // ***REMOVED***);
  ***REMOVED***);

  group('PullService', () {
    MockBackend backend = MockBackend();
    trainBackend(backend);
    late PullService service;

    setUp(() {
      reset(backend);
      service = PullService(userService, backend);
    ***REMOVED***);

    group('initially', () {
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
                trainHttpResponse(MockHttpClientResponseBody(), 200, [])));

        await service.pull();

        verify(backend.get('service/push/pull', any));
      ***REMOVED***);

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
      ***REMOVED***);

      test('calls onMessage for every message', () async {
        var called = 0;
        var onMessage = (_) async => called++;
        service.subscribe(onMessage: onMessage);
        when(backend.get('service/push/pull', any)).thenAnswer((_) =>
            Future<HttpClientResponseBody>.value(
                trainHttpResponse(MockHttpClientResponseBody(), 200, [
              {
                'notification': {'title': 'Titel', 'body': 'Inhalt'***REMOVED***,
                'data': <String, dynamic>{***REMOVED***
              ***REMOVED***,
              {
                'notification': {'title': 'Titel', 'body': 'Inhalt'***REMOVED***,
                'data': <String, dynamic>{***REMOVED***
              ***REMOVED***
            ])));

        await service.pull();

        expect(called, 2);
      ***REMOVED***);

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
