import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_server/http_server.dart';
import 'package:sammel_app/main.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/UserService.dart';

import 'ErrorService.dart';

abstract class PushReceiveService {
  void subscribe(
      {MessageHandler onMessage,
      MessageHandler onResume,
      MessageHandler onLaunch,
      MessageHandler onBackgroundMessage});
}

class FirebaseReceiveService implements PushReceiveService {
  FirebaseMessaging firebaseMessaging;

  Future<String> token;

  FirebaseReceiveService([FirebaseMessaging firebaseMock]) {
    firebaseMessaging =
        firebaseMock != null ? firebaseMock : FirebaseMessaging();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    // DEBUG
    if (pullMode) return;

    // For iOS request permission first.
    await firebaseMessaging.requestNotificationPermissions();

    token = firebaseMessaging.getToken();
    await token;
  }

  @override
  void subscribe({onMessage, onResume, onLaunch, onBackgroundMessage}) =>
      firebaseMessaging.configure(
          onMessage: onMessage,
          onResume: onResume,
          onLaunch: onLaunch,
          onBackgroundMessage: onBackgroundMessage);
}

class PullReceiveService extends BackendService implements PushReceiveService {
  Timer timer;
  MessageHandler onMessage = (_) async => Map();

  PullReceiveService(AbstractUserService userService, [Backend backendMock])
      : super(userService, backendMock) {
    timer = Timer.periodic(Duration(seconds: 10), (_) => pull());
  }

  @override
  void subscribe({onMessage, onResume, onLaunch, onBackgroundMessage}) {
    // ignore onResume, onLaunch and onBackgroundMessage, since they are not happening in Pull Mode
    this.onMessage = onMessage;
  }

  Future<void> pull() async {
    try {
      HttpClientResponseBody reponse = await get('service/push/pull');
      List content = reponse.body;
      if (content != null && content.isNotEmpty)
        content.forEach((message) => onMessage(message));
    } catch (e) {
      ErrorService.handleError(e,
          additional:
              'Beim Abrufen von Nachrichten ist ein Fehler aufgetreten. Das regelmäßige Abrufen von Nachrichten wird deshalb deaktiviert');
      timer.cancel();
    }
  }
}
