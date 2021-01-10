import 'dart:async';

import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/Crypter.dart';
import 'package:validators/validators.dart';

import 'BackendService.dart';
import 'ErrorService.dart';

abstract class AbstractPushNotificationManager {
  void register_message_callback(String id, PushNotificationListener callback);

  void unsubscribeFromKiezActionTopics(List<String> kieze, String interval);

  void subscribeToKiezActionTopics(List<String> kieze, String interval);

  Future<String> get pushToken;
***REMOVED***

abstract class PushNotificationListener {
  void receive_message(Map<dynamic, dynamic> data) {***REMOVED***

  void handleNotificationTap(Map<dynamic, dynamic> data) {***REMOVED***
***REMOVED***

class PushNotificationManager implements AbstractPushNotificationManager {
  PushReceiveService listener;
  StorageService storageService;
  AbstractUserService userService;

  @override
  Future<String> pushToken;

  PushNotificationManager(this.storageService, this.userService,
      FirebaseReceiveService firebaseService, Backend backend) {
    var listener = createPushListener(firebaseService, backend);
    pushToken = listener.then((listener) => listener.token);
    // initializeLocalNotifications();
  ***REMOVED***

  Future<PushReceiveService> createPushListener(
      FirebaseReceiveService firebaseService, Backend backend) async {
    if (await storageService.isPullMode())
      listener = PullService(userService, backend);
    else {
      pushToken = firebaseService.token;
      if (isNull(await pushToken) || (await pushToken).isEmpty) {
        ErrorService.pushError(
            'Problem beim Einrichten von Push-Nachrichten',
            'Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. '
                'Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. '
                'Darum kann die App nur Benachrichtigungen empfangen während sie geöffnet ist.');

        storageService.markPullMode();
        listener = PullService(userService, backend);
      ***REMOVED*** else {
        listener = firebaseService;
      ***REMOVED***
    ***REMOVED***

    listener.subscribe(
      onMessage: onMessageCallback,
      onResume: onResumeCallback,
      onLaunch: onResumeCallback,
      onBackgroundMessage: backgroundMessageHandler
    );

    return listener;
  ***REMOVED***

  Map<String, PushNotificationListener> callback_map = Map();

  Future<dynamic> onMessageCallback(Map<dynamic, dynamic> message) async {
    print('Push-Nachricht empfangen: $message');
    handle_message(message);
  ***REMOVED***

  void handle_message(Map message) {
    try {
      var data = decrypt(message);
      if (data.containsKey('type')) {
        String type = data['type'];
        if (callback_map.containsKey(type)) {
          callback_map[type].receive_message(data);
        ***REMOVED***
      ***REMOVED***
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s);
    ***REMOVED***
  ***REMOVED***

  Future<dynamic> onResumeCallback(Map<dynamic, dynamic> message) async {
    print('Resume-Nachricht empfangen: $message');
    try {
      var data = decrypt(message);
      if (data.containsKey('type')) {
        String type = data['type'];
        if (callback_map.containsKey(type)) {
          callback_map[type].handleNotificationTap(data);
        ***REMOVED***
      ***REMOVED***
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s);
    ***REMOVED***
  ***REMOVED***

  @override
  void register_message_callback(String id, PushNotificationListener callback) {
    this.callback_map[id] = callback;
  ***REMOVED***

  @override
  void subscribeToKiezActionTopics(List<String> kieze, String interval) {
    var topics = kieze.map((kiez) => '$kiez-$interval').toList();
    listener.subscribeToTopics(topics);
  ***REMOVED***

  @override
  void unsubscribeFromKiezActionTopics(List<String> kieze, String interval) {
    var topics = kieze.map((kiez) => '$kiez-$interval').toList();
    listener.unsubscribeFromTopics(topics);
  ***REMOVED***
***REMOVED***

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  var data = decrypt(message);
  print('Background-Messenger meldet Nachrichten-Ankunft: $data');
  if (data['type'] == "SimpleChatMessage")
    handleBackgroundChatMessage(data);
  else
    print('Unbekannter Nachrichtentyp: ${data['type']***REMOVED***');
***REMOVED***

Future<void> handleBackgroundChatMessage(Map<String, dynamic> data) async {
  var chatMessage = ChatMessagePushData.fromJson(data);

  //sendChatNotification(chatMessage);

  var storageService = StorageService();
  var chatChannel = await storageService.loadChatChannel(data['channel']);
  chatChannel.add_message_or_mark_as_received(chatMessage.message);
  await storageService.saveChatChannel(chatChannel);
***REMOVED***

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
  ***REMOVED***

  // Ignore
  @override
  void subscribeToKiezActionTopics(List<String> kieze, String interval) {***REMOVED***

  // Ignore
  @override
  void unsubscribeFromKiezActionTopics(List<String> kieze, String interval) {***REMOVED***

  @override
  Future<String> get pushToken => Future.value('Demo-Modus');
***REMOVED***
