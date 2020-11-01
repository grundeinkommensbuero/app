import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationListener {
  void receive_message(Map<dynamic, dynamic> data) {}
}

class PushNotificationManager {
  PushNotificationManager._();

  factory PushNotificationManager() => _instance;

  static final PushNotificationManager _instance =
      PushNotificationManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool _initialized = false;
  Map callback_map = Map();

  Future<String> get firebaseToken async => await _firebaseMessaging.getToken();

  Future<void> init() async {
    if (!_initialized) {
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
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
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
