import 'dart:io';

import 'package:http_server/http_server.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/PushService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/push_notification_manager.dart';

class StammdatenServiceMock extends Mock implements StammdatenService {***REMOVED***

class TermineServiceMock extends Mock implements AbstractTermineService {***REMOVED***

class ListLocationServiceMock extends Mock
    implements AbstractListLocationService {***REMOVED***

class StorageServiceMock extends Mock implements StorageService {***REMOVED***

class PushServiceMock extends Mock implements PushService {***REMOVED***

class PushNotificationsManagerMock extends Mock
    implements PushNotificationsManager {***REMOVED***

class BackendMock extends Mock implements Backend {***REMOVED***

class HttpClientResponseMock extends Mock implements HttpClientResponse {
  HttpClientResponseMock(int status) {
    when(this.statusCode).thenReturn(status);
  ***REMOVED***
***REMOVED***

class HttpClientResponseBodyMock extends Mock
    implements HttpClientResponseBody {
  HttpClientResponseBodyMock(dynamic content, int status) {
    var response = HttpClientResponseMock(status);
    when(this.body).thenReturn(content);
    when(this.response).thenAnswer((_) => response);
  ***REMOVED***
***REMOVED***
