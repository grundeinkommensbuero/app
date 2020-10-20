import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/AuthFehler.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/services/UserService.dart';

import '../shared/Mocks.dart';
import '../shared/TestdatenVorrat.dart';

main() {
  var userService = ConfiguredUserServiceMock();

  group('BackendService', () {
    BackendMock backend;

    setUp(() {
      backend = BackendMock();
    ***REMOVED***);

    group('authentication', () {
      BackendService service;

      setUp(() {
        service = BackendService(userService, backend);
      ***REMOVED***);

      test('knows app auth', () {
        expect(BackendService.appHeaders['Authorization'],
            'Basic MTpiOTdjNzU5Ny1mNjY5LTRmZWItOWJhMi0zMjE0YzE4MjIzMzk=');
      ***REMOVED***);

      test('needs UserService and throws error if missing', () {
        expect(() => BackendService(null, BackendMock()),
            throwsA((e) => e is ArgumentError));
      ***REMOVED***);

      test('needs no UserService if it is UserService', () {
        var storageServiceMock = StorageServiceMock();
        when(storageServiceMock.loadUser()).thenAnswer((_) async => karl());
        var service = UserService(
            storageServiceMock, PushNotificationsManagerMock(), BackendMock());
        expect(service, isNotNull);
      ***REMOVED***);

      test('determines UserHeaders from UserAuth of UserService', () async {
        when(userService.userAuthCreds)
            .thenAnswer((_) async => 'Base64kodierte User Credentials');

        var service = BackendService(userService, BackendMock());

        var userHeaders = await service.userHeaders;

        expect(userHeaders['Authorization'],
            'Basic Base64kodierte User Credentials');
      ***REMOVED***);

      group('uses app credentials if appAuth flag is set', () {
        setUp(() {
          when(backend.get(any, any))
              .thenAnswer((_) async => HttpClientResponseBodyMock(null, 200));
          when(backend.post(any, any, any))
              .thenAnswer((_) async => HttpClientResponseBodyMock(null, 200));
          when(backend.delete(any, any, any))
              .thenAnswer((_) async => HttpClientResponseBodyMock(null, 200));
        ***REMOVED***);

        test('with get requests', () async {
          await service.get('anyUrl', appAuth: true);

          verify(backend.get('anyUrl', BackendService.appHeaders));
        ***REMOVED***);

        test('with post requests', () async {
          await service.post('anyUrl', null, appAuth: true);

          verify(backend.post('anyUrl', null, BackendService.appHeaders));
        ***REMOVED***);

        test('with delete requests', () async {
          await service.delete('anyUrl', null, appAuth: true);

          verify(backend.delete('anyUrl', null, BackendService.appHeaders));
        ***REMOVED***);
      ***REMOVED***);

      group('uses user credentials if appAuth flag is not set or false', () {
        setUp(() {
          when(backend.get(any, any))
              .thenAnswer((_) async => HttpClientResponseBodyMock(null, 200));
          when(backend.post(any, any, any))
              .thenAnswer((_) async => HttpClientResponseBodyMock(null, 200));
          when(backend.delete(any, any, any))
              .thenAnswer((_) async => HttpClientResponseBodyMock(null, 200));
        ***REMOVED***);

        test('with get requests', () async {
          await service.get('anyUrl');
          var userHeaders = await service.userHeaders;

          verify(backend.get('anyUrl', userHeaders));
        ***REMOVED***);

        test('with post requests', () async {
          await service.post('anyUrl', null);
          var userHeaders = await service.userHeaders;

          verify(backend.post('anyUrl', null, userHeaders));
        ***REMOVED***);

        test('with delete requests', () async {
          await service.delete('anyUrl', null, appAuth: false);
          var userHeaders = await service.userHeaders;

          verify(backend.delete('anyUrl', null, userHeaders));
        ***REMOVED***);
      ***REMOVED***);

      test(
          'authHeaders throws Error if appAuth flag is not set but no user credentials can be determined in 10 seconds',
          () async {
        service.userHeaders = Future.delayed(
            Duration(seconds: 11), () => {'Authorization': 'my creds'***REMOVED***);

        expect(service.authHeaders(false), throwsA(NoUserAuthException));
      ***REMOVED***);
    ***REMOVED***);

    group('uses backend mock', () {
      BackendService service;
      Backend mock;
      setUp(() {
        mock = BackendMock();
        service = BackendService(userService, mock);
      ***REMOVED***);

      test('for get', () async {
        when(mock.get(any, any)).thenAnswer(
            (_) async => HttpClientResponseBodyMock('response', 200));
        await service.get('any URL');
        verify(mock.get('any URL', any)).called(1);
      ***REMOVED***);

      test('for post', () async {
        when(mock.post(any, any, any)).thenAnswer(
            (_) async => HttpClientResponseBodyMock('response', 200));
        await service.post('any URL', 'any data');
        verify(mock.post('any URL', 'any data', any)).called(1);
      ***REMOVED***);

      test('for delete', () async {
        when(mock.delete(any, any, any)).thenAnswer(
            (_) async => HttpClientResponseBodyMock('response', 200));
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
    BackendService service;
    Backend mock;
    setUp(() {
      mock = BackendMock();
      service = BackendService(userService, mock);
    ***REMOVED***);

    test('throws rest error on non-200 and non-403 status code', () {
      when(mock.get(any, any)).thenAnswer(
          (_) async => HttpClientResponseBodyMock('Dies ist ein Fehler', 400));

      expect(() => service.get('anyUrl'), throwsA((e) => e is RestFehler));
    ***REMOVED***);

    test('throws auth error on 403 status code', () {
      when(mock.get(any, any)).thenAnswer(
          (_) async => HttpClientResponseBodyMock('Dies ist ein Fehler', 403));

      expect(() => service.get('anyUrl'), throwsA((e) => e is AuthFehler));
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
