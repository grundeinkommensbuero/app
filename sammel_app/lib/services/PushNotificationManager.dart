import 'dart:async';

import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/Crypter.dart';

import 'BackendService.dart';
import 'ErrorService.dart';

abstract class AbstractPushNotificationManager {
  void register_message_callback(String id, PushNotificationListener callback);
***REMOVED***

abstract class PushNotificationListener {
  void receive_message(Map<dynamic, dynamic> data) {***REMOVED***
***REMOVED***

class PushNotificationManager implements AbstractPushNotificationManager {
  PushReceiveService listener;
  StorageService storageService;
  AbstractUserService userService;

  PushNotificationManager(
      this.storageService, this.userService, firebaseService,
      [Backend backend]) {
    createPushListener(firebaseService, backend);
  ***REMOVED***

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
      ***REMOVED*** else {
        listener = firebaseService;
        // For testing purposes print the Firebase Messaging token
        print("Firebase token: $token");
      ***REMOVED***
    ***REMOVED***

    listener.subscribe(
        onMessage: onMessageCallback,
        onResume: onMessageCallback,
        onLaunch: onMessageCallback);
    //, onBackgroundMessage: onBackgroundMessage2);
    // _firebaseMessaging.configure(onMessage: ()=>this.onMessage);
  ***REMOVED***

  Map callback_map = Map();

  Future<String> pushToken;

/*
  void onMessageCallback(Map<String, dynamic> message) async {
    print('message received' + message.toString());
    Map<String, dynamic> data = message['data'];
    if (data.containsKey('type')) {
      String type = data['type'];
      if (callback_map.containsKey(type)) {
        data.remove('type');
        callback_map[type](data);
      ***REMOVED***
    ***REMOVED***
   */

  Future<dynamic> onMessageCallback(Map<dynamic, dynamic> message) async {
    print('Push-Nachricht empfangen: $message');
    try {
      Map<dynamic, dynamic> data;
      data = decrypt(message['data']);
      if (data.containsKey('type')) {
        String type = data['type'];
        if (callback_map.containsKey(type)) {
          data.remove('type');
          callback_map[type].receive_message(data);
        ***REMOVED***
      ***REMOVED***
    ***REMOVED*** catch (e) {
      print('Fehler beim Verarbeiten von Push-Nachricht: $e');
    ***REMOVED***
  ***REMOVED***

  @override
  void register_message_callback(String id, PushNotificationListener callback) {
    this.callback_map[id] = callback;
  ***REMOVED***

/*void subscribeToChannel(String topic) async {
  listener.subscribeToTopic(topic);
***REMOVED***

void unsubscribeFromChannel(String topic) async {
  listener.unsubscribeFromTopic(topic);
***REMOVED****/
***REMOVED***

class DemoPushNotificationManager implements AbstractPushNotificationManager {
  DemoPushSendService pushService;
  PushNotificationListener callback;

  DemoPushNotificationManager(this.pushService);

  @override
  void register_message_callback(String id, PushNotificationListener callback) {
    pushService.stream
        .where((data) => data.type == id)
        .listen((data) => callback.receive_message(data.toJson()));
  ***REMOVED***
***REMOVED***
