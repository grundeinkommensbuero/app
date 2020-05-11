import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/BackendService.dart';

import '../shared/Mocks.dart';

main() {
  group('BackendService uses backend mock', () {
    BackendService service;
    Backend mock;
    setUp(() {
      mock = BackendMock();
      service = BackendService(mock);
    });

    test('for get', () {
      service.get('any URL');
      verify(mock.get('any URL')).called(1);
    });
    test('for post', () {
      service.post('any URL', 'any data');
      verify(mock.post('any URL', 'any data')).called(1);
    });
    test('for delete', () {
      service.delete('any URL', 'any data');
      verify(mock.delete('any URL', 'any data')).called(1);
    });
  });

  group('DemoBackendService', () {
    var demoBackend = DemoBackend();
    test('throws error when get called', () async {
      await expect(() => demoBackend.get('any url'),
          throwsA((e) => e is DemoBackendShouldNeverBeUsedError));
    });
    test('throws error when post called', () async {
      await expect(() => demoBackend.post('any url', ''),
          throwsA((e) => e is DemoBackendShouldNeverBeUsedError));
    });
    test('throws error when delete called', () async {
      await expect(() => demoBackend.delete('any url', ''),
          throwsA((e) => e is DemoBackendShouldNeverBeUsedError));
    });
  });
}
