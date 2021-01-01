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

  void subscribeToTopic(String topic);

  void unsubscribeFromTopic(String topic);
}

class FirebaseReceiveService implements PushReceiveService {
  FirebaseMessaging firebaseMessaging;

  Future<String> token;

  FirebaseReceiveService([FirebaseMessaging firebaseMock]) {
    firebaseMessaging =
        firebaseMock != null ? firebaseMock : FirebaseMessaging();
    initializeFirebase();
  }

  initializeFirebase() async {
    // DEBUG
    if (pullMode) return;

    // For iOS request permission first.
    await firebaseMessaging.requestNotificationPermissions();

    token = firebaseMessaging
        .getToken()
        .timeout(Duration(seconds: 5), onTimeout: () => null);
  }

  @override
  void subscribe({onMessage, onResume, onLaunch, onBackgroundMessage}) =>
      firebaseMessaging.configure(
          onMessage: onMessage,
          onResume: onResume,
          onLaunch: onLaunch,
          onBackgroundMessage: onBackgroundMessage);

  @override
  void subscribeToTopic(String topic) {
    if (pullMode) {
      print('Subscribe zu Topic $topic');
      var topicEnc = Uri.encodeComponent(topic);
      firebaseMessaging.subscribeToTopic(topicEnc);
    } else {
      // TODO
    }
  }

  @override
  void unsubscribeFromTopic(String topic) {
    if (pullMode) {
      print('Unsubscribe zu Topic $topic');
      var topicEnc = Uri.encodeComponent(topic);
      firebaseMessaging.unsubscribeFromTopic(topicEnc);
    } else {
      // TODO
    }
  }
}

class PullService extends BackendService implements PushReceiveService {
  Timer timer;
  MessageHandler onMessage = (_) async => Map();

  PullService(AbstractUserService userService, Backend backend)
      : super(userService, backend) {
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
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context:
              'Beim Abrufen von Nachrichten ist ein Fehler aufgetreten. Das regelmäßige Abrufen von Nachrichten wird deshalb deaktiviert');
      timer.cancel();
    }
  }

  @override
  void subscribeToTopic(String topic) {
    // TODO: implement subscribeToKiezActionTopics
  }

  @override
  void unsubscribeFromTopic(String topic) {
    // TODO: implement unsubscribeFromKiezActionTopics
  }
}
