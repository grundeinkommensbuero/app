import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_server/http_server.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/shared/FileReader.dart';

import 'TestdatenVorrat.dart';

class StammdatenServiceMock extends Mock implements StammdatenService {***REMOVED***

class TermineServiceMock extends Mock implements AbstractTermineService {***REMOVED***

class ListLocationServiceMock extends Mock
    implements AbstractListLocationService {***REMOVED***

class StorageServiceMock extends Mock implements StorageService {***REMOVED***

class PushSendServiceMock extends Mock implements PushSendService {***REMOVED***

class PushNotificationManagerMock extends Mock
    implements PushNotificationManager {***REMOVED***

class UserServiceMock extends Mock implements UserService {***REMOVED***

class ConfiguredUserServiceMock extends Mock implements UserService {
  final me = karl();

  ConfiguredUserServiceMock() {
    when(this.user).thenAnswer((_) => Stream.value(me));
    when(this.userHeaders)
        .thenAnswer((_) async => {'Authorization': 'userCreds'***REMOVED***);
  ***REMOVED***
***REMOVED***

class ChatMessageServiceMock extends Mock implements ChatMessageService {***REMOVED***

class BackendMock extends Mock implements Backend {
  BackendMock() {
    when(this.post('service/benutzer/authentifiziere', any, any)).thenAnswer(
        (_) => Future<HttpClientResponseBody>.value(
            HttpClientResponseBodyMock(true, 200)));
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

class FirebaseMessagingMock extends Mock implements FirebaseMessaging {***REMOVED***

class FirebaseReceiveServiceMock extends Mock
    implements FirebaseReceiveService {***REMOVED***

class DemoPushSendServiceMock extends Mock implements DemoPushSendService {***REMOVED***

class FileReaderMock extends Mock implements FileReader {***REMOVED***

class GeoServiceMock extends Mock implements GeoService {***REMOVED***
