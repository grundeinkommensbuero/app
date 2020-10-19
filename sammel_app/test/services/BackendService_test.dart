import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/AuthFehler.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/RestFehler.dart';

import '../shared/Mocks.dart';

main() {
  var userService = UserServiceMock();

  group('BackendService uses backend mock', () {
    BackendService service;
    Backend mock;
    setUp(() {
      mock = BackendMock();
      service = BackendService(userService, mock);
    });

    test('for get', () {
      when(mock.get(any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock('response', 200));
      service.get('any URL');
      verify(mock.get('any URL', any)).called(1);
    });

    test('for post', () {
      when(mock.post(any, any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock('response', 200));
      service.post('any URL', 'any data');
      verify(mock.post('any URL', 'any data', any)).called(1);
    });

    test('for delete', () {
      when(mock.delete(any, any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock('response', 200));
      service.delete('any URL', 'any data');
      verify(mock.delete('any URL', 'any data', any)).called(1);
    });
  });

  group('DemoBackendService', () {
    var demoBackend = DemoBackend();
    test('throws error when get called', () async {
      expect(() => demoBackend.get('any url', any),
          throwsA((e) => e is DemoBackendShouldNeverBeUsedError));
    });
    test('throws error when post called', () async {
      expect(() => demoBackend.post('any url', '', any),
          throwsA((e) => e is DemoBackendShouldNeverBeUsedError));
    });
    test('throws error when delete called', () async {
      expect(() => demoBackend.delete('any url', '', any),
          throwsA((e) => e is DemoBackendShouldNeverBeUsedError));
    });
  });
  group('error handling', () {
    BackendService service;
    Backend mock;
    setUp(() {
      mock = BackendMock();
      service = BackendService(userService, mock);
    });

    test('throws rest error on non-200 and non-403 status code', () {
      when(mock.get(any, any)).thenAnswer(
          (_) async => HttpClientResponseBodyMock('Dies ist ein Fehler', 400));

      expect(() => service.get('anyUrl'), throwsA((e) => e is RestFehler));
    });

    test('throws auth error on 403 status code', () {
      when(mock.get(any, any)).thenAnswer(
          (_) async => HttpClientResponseBodyMock('Dies ist ein Fehler', 403));

      expect(() => service.get('anyUrl'), throwsA((e) => e is AuthFehler));
    });
  });
}
