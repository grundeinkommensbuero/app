import 'package:flutter_test/flutter_test.dart';
import 'package:http_server/http_server.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/AuthFehler.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/services/UserService.dart';

import '../shared/mocks.trainer.dart';
import '../shared/TestdatenVorrat.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.costumized.dart';

main() {
  AbstractUserService userService = MockUserService();
  MockHttpClientResponseBody http200Mock =
      trainHttpResponse(MockHttpClientResponseBody(), 200, null);

  group('BackendService', () {
    late MockBackend backend;

    setUp(() {
      backend = MockBackend();
    ***REMOVED***);

    group('authentication', () {
      late BackendService service;

      setUp(() {
        service = BackendService(userService, backend);
      ***REMOVED***);

      test('knows app auth', () {
        expect(BackendService.appHeaders['Authorization'],
            'Basic MTpiOTdjNzU5Ny1mNjY5LTRmZWItOWJhMi0zMjE0YzE4MjIzMzk=');
      ***REMOVED***);

      test('needs UserService and throws error if missing', () {
        expect(() => BackendService(null, MockBackend()),
            throwsA((e) => e is ArgumentError));
      ***REMOVED***);

      test('needs no UserService if it is UserService', () {
        var storageServiceMock = MockStorageService();
        when(storageServiceMock.loadUser()).thenAnswer((_) async => karl());
        when(storageServiceMock.loadSecret()).thenAnswer((_) async => "secret");
        var service = UserService(
            storageServiceMock, MockFirebaseReceiveService(), MockBackend());
        expect(service, isNotNull);
      ***REMOVED***);

      group('uses app credentials if appAuth flag is set', () {
        setUp(() {
          when(backend.get(any, any)).thenAnswer(
              (_) => Future<HttpClientResponseBody>.value(http200Mock));
          when(backend.post(any, any, any)).thenAnswer(
              (_) => Future<HttpClientResponseBody>.value(http200Mock));
          when(backend.delete(any, any, any)).thenAnswer(
              (_) => Future<HttpClientResponseBody>.value(http200Mock));
        ***REMOVED***);

        test('with get requests', () async {
          await service.get('anyUrl', appAuth: true);

          verify(backend.get('anyUrl', BackendService.appHeaders));
        ***REMOVED***);

        test('with post requests', () async {
          await service.post('anyUrl', '', appAuth: true);

          verify(backend.post('anyUrl', '', BackendService.appHeaders));
        ***REMOVED***);

        test('with delete requests', () async {
          await service.delete('anyUrl', '', appAuth: true);

          verify(backend.delete('anyUrl', '', BackendService.appHeaders));
        ***REMOVED***);
      ***REMOVED***);

      group('uses user credentials if appAuth flag is not set or false', () {
        setUp(() {
          var response200 =
              trainHttpResponse(MockHttpClientResponseBody(), 200, null);
          when(backend.get(any, any)).thenAnswer(
              (_) => Future<HttpClientResponseBody>.value(response200));
          when(backend.post(any, any, any)).thenAnswer(
              (_) => Future<HttpClientResponseBody>.value(response200));
          when(backend.delete(any, any, any)).thenAnswer(
              (_) => Future<HttpClientResponseBody>.value(response200));
        ***REMOVED***);

        test('with get requests', () async {
          await service.get('anyUrl');
          var userHeaders = {'Authorization': 'userCreds'***REMOVED***

          verify(backend.get('anyUrl', userHeaders));
        ***REMOVED***);

        test('with post requests', () async {
          await service.post('anyUrl', '');
          var userHeaders = {'Authorization': 'userCreds'***REMOVED***

          verify(backend.post('anyUrl', '', userHeaders));
        ***REMOVED***);

        test('with delete requests', () async {
          await service.delete('anyUrl', '', appAuth: false);
          var userHeaders = {'Authorization': 'userCreds'***REMOVED***

          verify(backend.delete('anyUrl', '', userHeaders));
        ***REMOVED***);
      ***REMOVED***);

      test(
          'authHeaders throws Error if appAuth flag is not set but no user credentials can be determined in 10 seconds',
          () async {
        final userService = MockUserService();
        when(userService.user).thenAnswer((_) => Stream.value(karl()));
        when(userService.userHeaders).thenAnswer((_) => Future.delayed(
            Duration(seconds: 11), () => {'Authorization': 'my creds'***REMOVED***));

        final service = BackendService(userService, MockBackend());

        expect(service.authHeaders(false), throwsA(NoUserAuthException));
      ***REMOVED***);
    ***REMOVED***);

    group('uses backend mock', () {
      late BackendService service;
      late MockBackend mock;
      setUp(() {
        mock = MockBackend();
        service = BackendService(userService, mock);
      ***REMOVED***);

      test('for get', () async {
        when(mock.get('', {***REMOVED***)).thenAnswer((_) {
          return Future<HttpClientResponseBody>.value(http200Mock);
        ***REMOVED***);
        await service.get('any URL');
        verify(mock.get('any URL', any)).called(1);
      ***REMOVED***);

      test('for post', () async {
        when(mock.post(any, any, any)).thenAnswer(
            (_) => Future<HttpClientResponseBody>.value(http200Mock));
        await service.post('any URL', 'any data');
        verify(mock.post('any URL', 'any data', any)).called(1);
      ***REMOVED***);

      test('for delete', () async {
        when(mock.delete(any, any, any)).thenAnswer((_) =>
            Future<HttpClientResponseBody>.value(
                trainHttpResponse(MockHttpClientResponseBody(), 200, null)));
        await service.delete('any URL', 'any data');
        verify(mock.delete('any URL', 'any data', any)).called(1);
      ***REMOVED***);
    ***REMOVED***);
  ***REMOVED***);

  group('DemoBackendService', () {
    var demoBackend = DemoBackend();
    test('throws error when get called', () async {
      expect(() => demoBackend.get('any url', {***REMOVED***),
          throwsA((e) => e is DemoBackendShouldNeverBeUsedError));
    ***REMOVED***);
    test('throws error when post called', () async {
      expect(() => demoBackend.post('any url', '', {***REMOVED***),
          throwsA((e) => e is DemoBackendShouldNeverBeUsedError));
    ***REMOVED***);
    test('throws error when delete called', () async {
      expect(() => demoBackend.delete('any url', '', {***REMOVED***),
          throwsA((e) => e is DemoBackendShouldNeverBeUsedError));
    ***REMOVED***);
  ***REMOVED***);
  group('error handling', () {
    late BackendService service;
    late MockBackend mock = MockBackend();

    setUp(() {
      trainBackend(mock);
      service = BackendService(userService, mock);
    ***REMOVED***);

    test('throws rest error on non-200 and non-403 status code', () {
      when(mock.get(any, any)).thenAnswer((_) {
        return Future<HttpClientResponseBody>.value(trainHttpResponse(
            MockHttpClientResponseBody(), 400, 'Dies ist ein Fehler'));
      ***REMOVED***);

      expect(() => service.get('anyUrl'), throwsA((e) => e is RestFehler));
    ***REMOVED***);

    test('throws auth error on 403 status code', () {
      when(mock.get(any, any)).thenAnswer((_) {
        return Future<HttpClientResponseBody>.value(trainHttpResponse(
            MockHttpClientResponseBody(), 403, 'Dies ist ein Fehler'));
      ***REMOVED***);

      expect(() => service.get('anyUrl'), throwsA((e) => e is AuthFehler));
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
