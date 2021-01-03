import 'dart:async';

import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/LocalNotificationService.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/Crypter.dart';

import 'BackendService.dart';
import 'ErrorService.dart';

abstract class AbstractPushNotificationManager {
  void register_message_callback(String id, PushNotificationListener callback);

  void unsubscribeFromKiezActionTopics(List<String> kieze, String interval);

  void subscribeToKiezActionTopics(List<String> kieze, String interval);
}

abstract class PushNotificationListener {
  void receive_message(Map<dynamic, dynamic> data) {}

  void handleNotificationTap(Map<dynamic, dynamic> data) {}
}

class PushNotificationManager implements AbstractPushNotificationManager {
  PushReceiveService listener;
  StorageService storageService;
  AbstractUserService userService;

  PushNotificationManager(
      this.storageService, this.userService, firebaseService, Backend backend) {
    createPushListener(firebaseService, backend);
   // initializeLocalNotifications();
  }

  createPushListener(
      FirebaseReceiveService firebaseService, Backend backend) async {
    if (await storageService.isPullMode())
      listener = PullService(userService, backend);
    else {
      var token = await firebaseService.token;
      if (token == null || token.isEmpty) {
        ErrorService.pushMessage(
            'Problem beim Einrichten von Push-Nachrichten',
            'Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. '
                'Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. '
                'Darum kann die App nur Benachrichtigungen empfangen während sie geöffnet ist.');

        storageService.markPullMode();
        listener = PullService(userService, backend);
      } else {
        listener = firebaseService;
        // For testing purposes print the Firebase Messaging token
        print("Firebase token: $token");
      }
    }

    listener.subscribe(
        onMessage: onMessageCallback,
        onResume: onResumeCallback,
        onLaunch: onResumeCallback,
        onBackgroundMessage: backgroundMessageHandler);
  }

  Map<String, PushNotificationListener> callback_map = Map();

  Future<String> pushToken;

  Future<dynamic> onMessageCallback(Map<dynamic, dynamic> message) async {
    print('Push-Nachricht empfangen: $message');
    handle_message(message);
  }

  void handle_message(Map message) {
    try {
      var data = decrypt(message['data']);
      if (data.containsKey('type')) {
        String type = data['type'];
        if (callback_map.containsKey(type)) {
          callback_map[type].receive_message(data);
        }
      }
    } catch (e, s) {
      ErrorService.handleError(e, s);
    }
  }

  Future<dynamic> onResumeCallback(Map<dynamic, dynamic> message) async {
    print('Resume-Nachricht empfangen: $message');
    try {
      var data = decrypt(message['data']);
      if (data.containsKey('type')) {
        String type = data['type'];
        if (callback_map.containsKey(type)) {
          callback_map[type].handleNotificationTap(data);
        }
      }
    } catch (e, s) {
      ErrorService.handleError(e, s);
    }
  }

  @override
  void register_message_callback(String id, PushNotificationListener callback) {
    this.callback_map[id] = callback;
  }

  @override
  void subscribeToKiezActionTopics(List<String> kieze, String interval) {
    var topics = kieze.map((kiez) => '$kiez-$interval').toList();
    listener.subscribeToTopics(topics);
  }

  @override
  void unsubscribeFromKiezActionTopics(List<String> kieze, String interval) {
    var topics = kieze.map((kiez) => '$kiez-$interval').toList();
    listener.unsubscribeFromTopics(topics);
  }
}

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  var data = decrypt(message['data']);
  print('Background-Messenger meldet Nachrichten-Ankunft: $data');
  if (data['type'] == "SimpleChatMessage")
    handleBackgroundChatMessage(data);
  else
    print('Unbekannter Nachrichtentyp: ${data['type']}');
}

Future<void> handleBackgroundChatMessage(Map<String, dynamic> data) async {
  var chatMessage = ChatMessagePushData.fromJson(data);

  //sendChatNotification(chatMessage);

  var storageService = StorageService();
  var chatChannel = await storageService.loadChatChannel(data['channel']);
  chatChannel.add_message_or_mark_as_received(chatMessage.message);
  await storageService.saveChatChannel(chatChannel);
}

class DemoPushNotificationManager implements AbstractPushNotificationManager {
  DemoPushSendService pushService;
  PushNotificationListener callback;

  DemoPushNotificationManager(this.pushService);

  @override
  void register_message_callback(
      String type, PushNotificationListener callback) {
    pushService.stream
        .where((data) => data.type == type)
        .listen((data) => callback.receive_message(data.toJson()));
  }

  // Ignore
  @override
  void subscribeToKiezActionTopics(List<String> kieze, String interval) {}

  // Ignore
  @override
  void unsubscribeFromKiezActionTopics(List<String> kieze, String interval) {}
}
