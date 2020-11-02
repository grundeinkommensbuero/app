import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:uuid/uuid.dart';

class PushNotificationListener {
  void receive_message(Map<dynamic, dynamic> data) {}
}

class PushNotificationManager {
  StorageService storageService;

  PushNotificationManager(this.storageService);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool _initialized = false;
  Map callback_map = Map();

  Future<String> pushToken;

  Future<void> init() async {
    if (!_initialized) {
      pushToken = _firebaseMessaging.getToken();
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();

      _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
        onMessageCallback(message);
      }, onResume: (Map<String, dynamic> message) async {
        onMessageCallback(message);
      }, onLaunch: (Map<String, dynamic> message) async {
        onMessageCallback(message);
      }); //, onBackgroundMessage: onBackgroundMessage2);
      // _firebaseMessaging.configure(onMessage: ()=>this.onMessage);

      // For testing purposes print the Firebase Messaging token
      String token = await pushToken;
      if (token == null || token.isEmpty) {
        pushToken = await getCostumToken();
        print("Costum token: $pushToken");
      } else {
        print("Firebase token: $pushToken");
      }

      _initialized = true;
    }
  }

  Future<FutureOr<String>> getCostumToken() async {
    String costumToken = await storageService.loadCostumPushToken();
    if (costumToken == null) {
      ErrorService.pushMessage(
          'Problem beim Einrichten von Push-Nachrichten',
          'Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. '
              'Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. '
              'Der Chat und Benachrichtungen funktionieren ohne Google-Services leider nicht. '
              'Dies sind Einschränkungen, die auf Googles restriktive Android-Architektur zurückgehen.');
      costumToken = await Future.value(Uuid().v1());
      await storageService.saveCostumPushToken(costumToken);
    }
    return costumToken;
  }

  /*
  void onMessageCallback(Map<String, dynamic> message) async {
    print('message received' + message.toString());
    Map<String, dynamic> data = message['data'];
    if (data.containsKey('type')) {
      String type = data['type'];
      if (callback_map.containsKey(type)) {
        data.remove('type');
        callback_map[type](data);
      }
    }
   */

    void onMessageCallback(Map<String, dynamic> message) async {
      print('message received' + message.toString());
      Map<dynamic, dynamic> data = message['data'];
      if (data.containsKey('type')) {
        String type = data['type'];
        if (callback_map.containsKey(type)) {
          data.remove('type');
          callback_map[type].receive_message(data);
        }
      }
    }


  void register_message_callback(String id, PushNotificationListener callback) {
    this.callback_map[id] = callback;
  }

  void subscribeToChannel(String topic) async {
    _firebaseMessaging.subscribeToTopic(topic);
  }

  void unsubscribeFromChannel(String topic) async {
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}
