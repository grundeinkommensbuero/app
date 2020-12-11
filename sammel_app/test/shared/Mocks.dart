import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_server/http_server.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChatMessageService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';

import 'TestdatenVorrat.dart';

class StammdatenServiceMock extends Mock implements StammdatenService {}

class TermineServiceMock extends Mock implements AbstractTermineService {}

class ListLocationServiceMock extends Mock
    implements AbstractListLocationService {}

class StorageServiceMock extends Mock implements StorageService {}

class PushSendServiceMock extends Mock implements PushSendService {}

class PushNotificationManagerMock extends Mock
    implements PushNotificationManager {}

class UserServiceMock extends Mock implements UserService {}

class ConfiguredUserServiceMock extends Mock implements UserService {
  ConfiguredUserServiceMock() {
    when(this.user).thenAnswer((_) => Stream.value(karl()));
    when(this.latestUser).thenAnswer((_) => karl());
    when(this.userHeaders)
        .thenAnswer((_) async => {'Authorization': 'userCreds'});
  }
}

class ChatMessageServiceMock extends Mock implements ChatMessageService {}

class BackendMock extends Mock implements Backend {
  BackendMock() {
    when(this.post('service/benutzer/authentifiziere', any, any))
        .thenAnswer((_) async => HttpClientResponseBodyMock(true, 200));
  }
}

class HttpClientResponseMock extends Mock implements HttpClientResponse {
  HttpClientResponseMock(int status) {
    when(this.statusCode).thenReturn(status);
  }
}

class HttpClientResponseBodyMock extends Mock
    implements HttpClientResponseBody {
  HttpClientResponseBodyMock(dynamic content, int status) {
    var response = HttpClientResponseMock(status);
    when(this.body).thenReturn(content);
    when(this.response).thenAnswer((_) => response);
  }
}

class FirebaseMessagingMock extends Mock implements FirebaseMessaging {}

class FirebaseReceiveServiceMock extends Mock
    implements FirebaseReceiveService {}

class DemoPushSendServiceMock extends Mock implements DemoPushSendService {}
