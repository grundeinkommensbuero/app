import 'dart:io';

import 'package:http_server/http_server.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/PushService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChatMessageService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';

import 'TestdatenVorrat.dart';

class StammdatenServiceMock extends Mock implements StammdatenService {***REMOVED***

class TermineServiceMock extends Mock implements AbstractTermineService {***REMOVED***

class ListLocationServiceMock extends Mock
    implements AbstractListLocationService {***REMOVED***

class StorageServiceMock extends Mock implements StorageService {***REMOVED***

class PushServiceMock extends Mock implements PushService {***REMOVED***

class PushNotificationManagerMock extends Mock
    implements PushNotificationManager {***REMOVED***

class UserServiceMock extends Mock implements UserService {***REMOVED***

class ConfiguredUserServiceMock extends Mock implements UserService {
  ConfiguredUserServiceMock() {
    when(this.user)
        .thenAnswer((_) async => karl());
    when(this.userAuthCreds)
        .thenAnswer((_) async => 'userCreds');
  ***REMOVED***
***REMOVED***

class ChatMessageServiceMock extends Mock implements ChatMessageService {***REMOVED***

class BackendMock extends Mock implements Backend {
  BackendMock() {
    when(this.post('service/benutzer/authentifiziere', any, any))
        .thenAnswer((_) async => HttpClientResponseBodyMock(true, 200));
  ***REMOVED***
***REMOVED***

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
