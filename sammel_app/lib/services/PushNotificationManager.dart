import 'dart:async';

import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';

import 'BackendService.dart';
import 'ErrorService.dart';

class PushNotificationListener {
  void receive_message(Map<dynamic, dynamic> data) {***REMOVED***
***REMOVED***

class PushNotificationManager {
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
    var token = await firebaseService.token;
    if (token == null || token.isEmpty) {
      ErrorService.pushMessage(
          'Problem beim Einrichten von Push-Nachrichten',
          'Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. '
              'Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. '
              'Der Chat und Benachrichtungen funktionieren ohne Google-Services leider nicht. '
              'Dies sind Einschränkungen, die auf Googles restriktive Android-Architektur zurückgehen.');
      listener = PullReceiveService(userService, backend);
    ***REMOVED*** else {
      listener = firebaseService;
      // For testing purposes print the Firebase Messaging token
      print("Firebase token: $token");
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

    Future<dynamic> onMessageCallback(Map<String, dynamic> message) async {
      print('message received' + message.toString());
      Map<dynamic, dynamic> data = message['data'];
      if (data.containsKey('type')) {
        String type = data['type'];
        if (callback_map.containsKey(type)) {
          data.remove('type');
          callback_map[type].receive_message(data);
        ***REMOVED***
      ***REMOVED***
    ***REMOVED***

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
