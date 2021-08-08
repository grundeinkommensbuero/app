import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/Arguments.dart';
import 'package:sammel_app/services/ArgumentsService.dart';

import '../shared/TestdatenVorrat.dart';
import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.trainer.dart';

main() {
  final userService = MockUserService();
  setUp(() {
    reset(userService);
    trainUserService(userService);
  ***REMOVED***);

  group('ArgumentsService', () {
    late MockBackend backend;
    late ArgumentsService service;

    setUp(() {
      backend = MockBackend();
      trainBackend(backend);
      service = ArgumentsService(userService, backend);
    ***REMOVED***);

    test('calls backend service with right path and sends arguments', () async {
      when(backend.post('service/vorbehalte', any, any)).thenAnswer((_) =>
          Future.value(trainHttpResponse(
              MockHttpClientResponseBody(), 200, placard1().toJson())));

      await service.createArguments(Arguments(
          'Genossenschaften', DateTime(2021, 8, 8), ffAlleeNord()));

      verify(backend.post(
          'service/vorbehalte',
          '{'
              '"vorbehalte":"Genossenschaften",'
              '"datum":"2021-08-08",'
              '"ort":"Frankfurter Allee Nord"'
              '***REMOVED***',
          any));
    ***REMOVED***);
  ***REMOVED***);

  group('DemoArgumentsService', () {
    test('does nothing', () {
      DemoArgumentsService(userService).createArguments(Arguments(
          'Genossenschaften', DateTime(2021, 8, 8), ffAlleeNord()));
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
