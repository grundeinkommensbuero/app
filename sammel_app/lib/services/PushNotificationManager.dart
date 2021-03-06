import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/PushUpdateService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/Crypter.dart';

import 'BackendService.dart';
import 'ErrorService.dart';

abstract class AbstractPushNotificationManager {
  void registerMessageCallback(String id, PushNotificationListener callback);

  void unsubscribeFromKiezActionTopics(List<String> kieze, String interval);

  void subscribeToKiezActionTopics(List<String> kieze, String interval);

  Future<String?> get pushToken;

  onTap(RemoteMessage message);

  updateMessages() {}
}

abstract class PushNotificationListener {
  void receiveMessage(Map<String, dynamic> data) {}

  void handleNotificationTap(Map<String, dynamic> data) {}

  void updateMessages(List<Map<String, dynamic>> data) {}
}

class PushNotificationManager implements AbstractPushNotificationManager {
  late PushReceiveService listener;
  late StorageService storageService;
  late AbstractUserService userService;
  late PushUpdateService updateService;

  @override
  late Future<String?> pushToken;

  PushNotificationManager(this.storageService, this.userService,
      FirebaseReceiveService firebaseService, Backend backend) {
    var listener = createPushListener(firebaseService, backend);
    updateService = PushUpdateService(userService, backend);

    listener.then((listener) {
      pushToken = listener.token;
      updateMessages();
    });
  }

  Future<PushReceiveService> createPushListener(
      FirebaseReceiveService firebaseService, Backend backend) async {
    final pushToken = await firebaseService.token;
    if (pushToken == null || pushToken.isEmpty) {
      listener = PullService(userService, backend);
      if (!await storageService.isPullMode()) {
        ErrorService.pushError(
            'Problem beim Einrichten von Push-Nachrichten',
            'Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. '
                'Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. '
                'Darum kann die App nur Benachrichtigungen empfangen w??hrend sie ge??ffnet ist.');

        storageService.setPullMode();
      }
    } else {
      listener = firebaseService;
      storageService.unsetPullMode();
    }

    listener.subscribe(onMessage: onReceived, onResume: onTap, onLaunch: onTap);

    return listener;
  }

  Map<String, PushNotificationListener> callbackMap = Map();

  onReceived(RemoteMessage message) async {
    final data = await decrypt(message.data);

    try {
      if (data.containsKey('type'))
        callbackMap[data['type']]?.receiveMessage(data);
    } catch (e, s) {
      ErrorService.handleError(e, s);
    }
  }

  onTap(RemoteMessage message) async {
    print(
        'onTap: Push-Nachricht empfangen: $message \nund Callback-Map f??r: ${callbackMap.keys}');
    final data = await decrypt(message.data);

    try {
      if (data.containsKey('type')) {
        String type = data['type'];
        if (callbackMap.containsKey(type)) {
          callbackMap[type]?.handleNotificationTap(data);
        }
      }
    } catch (e, s) {
      ErrorService.handleError(e, s);
    }
  }

  @override
  void registerMessageCallback(String id, PushNotificationListener callback) {
    this.callbackMap[id] = callback;
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

  @override
  Future<void> updateMessages() async {
    final messages = await updateService.getLatestPushMessages();
    if (messages == null) return;
    List<Map<String, dynamic>> decrypted = [];
    for (var message in messages) {
      final decryptedMessage = await decrypt(message['data']);
      decrypted.add(decryptedMessage);
    }
    final messageMap = sortMessagesByType(decrypted);

    if (listener is PullService)
      return; // im Pull-Modus sollen Push-Nachrichten regul??r vom Timer geladen werden
    try {
      messageMap.forEach((type, messages) {
        callbackMap[type]?.updateMessages(messages);
      });
    } catch (e, s) {
      ErrorService.handleError(e, s);
    }
  }
}

Map<String, List<Map<String, dynamic>>> sortMessagesByType(
        List<Map<String, dynamic>> messages) =>
    messages
        .where((data) => data['type'] != null)
        .fold(Map<String, List<Map<String, dynamic>>>(), (typeMap, data) {
      if (typeMap[data['type']] == null) typeMap[data['type']] = [];
      typeMap[data['type']]?.add(data);
      return typeMap;
    });

class DemoPushNotificationManager implements AbstractPushNotificationManager {
  DemoPushSendService pushService;

  DemoPushNotificationManager(this.pushService);

  @override
  void registerMessageCallback(String type, PushNotificationListener callback) {
    pushService.stream
        .where((data) => data.type == type)
        .listen((data) => callback.receiveMessage(data.toJson()));
  }

  // Ignore
  @override
  void subscribeToKiezActionTopics(List<String> kieze, String interval) {}

  // Ignore
  @override
  void unsubscribeFromKiezActionTopics(List<String> kieze, String interval) {}

  @override
  Future<String> get pushToken => Future.value('Demo-Modus');

  // Ignore - no Push-Messages in Demo-Mode
  @override
  onTap(RemoteMessage message) => throw UnimplementedError();

  // Ignore - no Push-Messages in Demo-Mode
  @override
  updateMessages() {}
}
