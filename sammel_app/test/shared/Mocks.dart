import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';

class StammdatenServiceMock extends Mock implements AbstractStammdatenService {}

class TermineServiceMock extends Mock implements AbstractTermineService {}

class ListLocationServiceMock extends Mock
    implements AbstractListLocationService {}

class StorageServiceMock extends Mock implements StorageService {}

class HttpClientMock extends Mock implements HttpClient {}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext securityContext) {
    return new HttpClientMock();
  }
}
