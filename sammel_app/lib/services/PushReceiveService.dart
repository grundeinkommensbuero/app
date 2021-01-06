import 'dart:async';
import 'dart:convert';

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

  void subscribeToTopics(List<String> topics);

  void unsubscribeFromTopics(List<String> topic);

  Future<String> token;
}

class FirebaseReceiveService implements PushReceiveService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  static StreamController<String> _tokenStreamController =
      StreamController.broadcast();
  @override
  Future<String> token = _tokenStreamController.stream.first;

  FirebaseReceiveService([FirebaseMessaging firebaseMock]) {
    if (firebaseMock != null)
      firebaseMessaging = firebaseMock;
    else if (pullMode) { // DEBUG
      _tokenStreamController.add(null);
    } else
      initializeFirebase();
  }

  initializeFirebase() async {
    print('Initialisiere Firebase');
    await firebaseMessaging
        .getToken()
        .timeout(Duration(seconds: 5), onTimeout: () => null)
        .then((token) => _tokenStreamController.add(token));

    print('Firebase initialisiert mit Token: ${await token}');

    // For iOS request permission first.
    firebaseMessaging.requestNotificationPermissions();
  }

  @override
  void subscribe({onMessage, onResume, onLaunch, onBackgroundMessage}) =>
      firebaseMessaging.configure(
          onMessage: onMessage,
          onResume: onResume,
          onLaunch: onLaunch,
          onBackgroundMessage: onBackgroundMessage);

  @override
  void subscribeToTopics(List<String> topics) {
    for (String topic in topics) {
      print('Subscribe zu Topic $topic');
      var topicEnc = Uri.encodeComponent(topic);
      firebaseMessaging.subscribeToTopic(topicEnc);
    }
  }

  @override
  void unsubscribeFromTopics(List<String> topics) {
    for (String topic in topics) {
      print('Unsubscribe von Topic $topic');
      var topicEnc = Uri.encodeComponent(topic);
      firebaseMessaging.unsubscribeFromTopic(topicEnc);
    }
  }
}

class PullService extends BackendService implements PushReceiveService {
  Timer timer;
  MessageHandler onMessage = (_) async => Map();

  PullService(AbstractUserService userService, Backend backend)
      : super(userService, backend) {
    print('Starte Pulling');
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
  void subscribeToTopics(List<String> topics) {
    try {
      post('service/push/pull/subscribe', jsonEncode(topics));
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Fehler beim Anmelden der Benachrichtigungen zu $topics');
    }
  }

  @override
  void unsubscribeFromTopics(List<String> topics) {
    try {
      post('service/push/pull/subscribe', jsonEncode(topics));
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Fehler beim Abmelden der Benachrichtigungen zu $topics');
    }
  }

  @override
  Future<String> token = Future.value('Pull-Modus');
}
