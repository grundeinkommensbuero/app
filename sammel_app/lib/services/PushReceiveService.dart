import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_server/http_server.dart';
import 'package:sammel_app/Provisioning.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/UserService.dart';

import 'ErrorService.dart';

abstract class PushReceiveService {
  void subscribe(
      {Function(RemoteMessage)? onMessage,
      Function(RemoteMessage)? onResume,
      Function(RemoteMessage)? onLaunch,
      Function(RemoteMessage)? onBackgroundMessage});

  void subscribeToTopics(List<String> topics);

  void unsubscribeFromTopics(List<String> topic);

  abstract Future<String?> token;
}

class FirebaseReceiveService implements PushReceiveService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static StreamController<String?> _tokenStreamController =
      StreamController.broadcast();
  @override
  Future<String?> token = _tokenStreamController.stream.first;

  final bool pullMode;

  FirebaseReceiveService(
      [this.pullMode = false, FirebaseMessaging? firebaseMock]) {
    if (firebaseMock != null)
      firebaseMessaging = firebaseMock;
    else if (pullMode) {
      // DEBUG
      _tokenStreamController.add(null);
    } else
      initializeFirebase();
  }

  initializeFirebase() async {
    await Firebase.initializeApp();
    await firebaseMessaging
        .getToken()
        .timeout(Duration(seconds: 5), onTimeout: () => null)
        .then((token) => _tokenStreamController.add(token));

    // For iOS request permission first.
    firebaseMessaging.requestPermission();

    if (await token != null) {
      var topicEnc = Uri.encodeComponent('${topicPrefix}global');
      firebaseMessaging.subscribeToTopic(topicEnc);
    }

    print('Firebase initialisiert mit Token: ${await token}');
  }

  @override
  void subscribe({onMessage, onResume, onLaunch, onBackgroundMessage}) {
    if (Platform.isIOS) onBackgroundMessage = null;
    if (onMessage != null)
      FirebaseMessaging.onMessage.listen((message) => onMessage(message));
    if (onResume != null)
      FirebaseMessaging.onMessageOpenedApp
          .listen((message) => onResume(message));
    if (onLaunch != null)
      firebaseMessaging.getInitialMessage().then((message) => onLaunch);
    if (onBackgroundMessage != null)
      FirebaseMessaging.onBackgroundMessage(
          (message) => onBackgroundMessage!(message));
  }

  @override
  void subscribeToTopics(List<String> topics) {
    for (String topic in topics) {
      var topicEnc = Uri.encodeComponent('$topicPrefix$topic');
      firebaseMessaging.subscribeToTopic(topicEnc);
    }
  }

  @override
  void unsubscribeFromTopics(List<String> topics) {
    for (String topic in topics) {
      var topicEnc = Uri.encodeComponent('$topicPrefix$topic');
      firebaseMessaging.unsubscribeFromTopic(topicEnc);
    }
  }
}

class PullService extends BackendService implements PushReceiveService {
  late Timer timer;
  Function(RemoteMessage) onMessage = (_) => Future.value({});

  PullService(AbstractUserService userService, Backend backend)
      : super(userService, backend) {
    timer = Timer.periodic(Duration(seconds: 10), (_) => pull());
  }

  @override
  void subscribe({onMessage, onResume, onLaunch, onBackgroundMessage}) {
    // ignore onResume, onLaunch and onBackgroundMessage, since they are not happening in Pull Mode
    if (onMessage != null) this.onMessage = onMessage;
  }

  Future<void> pull() async {
    try {
      HttpClientResponseBody reponse = await get('service/push/pull');
      Iterable<RemoteMessage> messages = (reponse.body as List).map((json) =>
          RemoteMessage(
              notification: RemoteNotification(
                  title: json['notification']?['title'],
                  body: json['notification']?['body']),
              data: json['data']));
      messages.forEach((message) => onMessage(message));
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
          context: 'Fehler beim Anmelden der Benachrichtigungen zu {topics}'
              .tr(namedArgs: {'topics': topics.toString()}));
    }
  }

  @override
  void unsubscribeFromTopics(List<String> topics) {
    try {
      post('service/push/pull/subscribe', jsonEncode(topics));
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Fehler beim Abmelden der Benachrichtigungen zu {topics}'
              .tr(namedArgs: {'topics': topics.toString()}));
    }
  }

  @override
  Future<String?> token = Future.value('Pull-Modus');
}
