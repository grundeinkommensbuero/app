import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/PushUpdateService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/Crypter.dart';
import 'package:validators/validators.dart';

import 'BackendService.dart';
import 'ErrorService.dart';

abstract class AbstractPushNotificationManager {
  void registerMessageCallback(String id, PushNotificationListener callback);

  void unsubscribeFromKiezActionTopics(List<String> kieze, String interval);

  void subscribeToKiezActionTopics(List<String> kieze, String interval);

  Future<String?> get pushToken;

  onTap(RemoteMessage message);

  updateMessages() {***REMOVED***
***REMOVED***

abstract class PushNotificationListener {
  void receiveMessage(Map<String, dynamic> data) {***REMOVED***

  void handleNotificationTap(Map<String, dynamic> data) {***REMOVED***

  void updateMessages(List<Map<String, dynamic>> data) {***REMOVED***
***REMOVED***

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
    pushToken = listener.then((listener) => listener.token);
    updateService = PushUpdateService(userService, backend);
    updateMessages();
  ***REMOVED***

  Future<PushReceiveService> createPushListener(
      FirebaseReceiveService firebaseService, Backend backend) async {
    print('### storageService.isPullMode() = ${await storageService.isPullMode()***REMOVED***');
    if (await storageService.isPullMode())
      listener = PullService(userService, backend);
    else {
      pushToken = firebaseService.token;
      if (isNull(await pushToken) || (await pushToken)!.isEmpty) {
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

    listener.subscribe(onMessage: onReceived, onResume: onTap, onLaunch: onTap);

    return listener;
  ***REMOVED***

  Map<String, PushNotificationListener> callbackMap = Map();

  onReceived(RemoteMessage message) async {
    final data = await decrypt(message.data);

    try {
      if (data.containsKey('type'))
        callbackMap[data['type']]?.receiveMessage(data);
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s);
    ***REMOVED***
  ***REMOVED***

  onTap(RemoteMessage message) async {
    print(
        'onTap: Push-Nachricht empfangen: $message \nund Callback-Map für: ${callbackMap.keys***REMOVED***');
    final data = await decrypt(message.data);

    try {
      if (data.containsKey('type')) {
        String type = data['type'];
        if (callbackMap.containsKey(type)) {
          callbackMap[type]?.handleNotificationTap(data);
        ***REMOVED***
      ***REMOVED***
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s);
    ***REMOVED***
  ***REMOVED***

  @override
  void registerMessageCallback(String id, PushNotificationListener callback) {
    this.callbackMap[id] = callback;
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

  @override
  Future<void> updateMessages() async {
    final messages = await updateService.getLatestPushMessages();
    if (messages == null) return;
    List<Map<String, dynamic>> decrypted = [];
    messages.forEach((msg) async => decrypted.add(await decrypt(msg['data'])));
    final messageMap = sortMessagesByType(decrypted);

    if (listener is PullService)
      return; // im Pull-Modus sollen Push-Nachrichten regulär vom Timer geladen werden
    try {
      messageMap.forEach((type, messages) {
        callbackMap[type]?.updateMessages(messages);
      ***REMOVED***);
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s);
    ***REMOVED***
  ***REMOVED***
***REMOVED***

Map<String, List<Map<String, dynamic>>> sortMessagesByType(
        List<Map<String, dynamic>> messages) =>
    messages
        .where((data) => data['type'] != null)
        .fold(Map<String, List<Map<String, dynamic>>>(), (typeMap, data) {
      if (typeMap[data['type']] == null) typeMap[data['type']] = [];
      typeMap[data['type']]?.add(data);
      return typeMap;
    ***REMOVED***);

class DemoPushNotificationManager implements AbstractPushNotificationManager {
  DemoPushSendService pushService;

  DemoPushNotificationManager(this.pushService);

  @override
  void registerMessageCallback(String type, PushNotificationListener callback) {
    pushService.stream
        .where((data) => data.type == type)
        .listen((data) => callback.receiveMessage(data.toJson()));
  ***REMOVED***

  // Ignore
  @override
  void subscribeToKiezActionTopics(List<String> kieze, String interval) {***REMOVED***

  // Ignore
  @override
  void unsubscribeFromKiezActionTopics(List<String> kieze, String interval) {***REMOVED***

  @override
  Future<String> get pushToken => Future.value('Demo-Modus');

  // Ignore - no Push-Messages in Demo-Mode
  @override
  onTap(RemoteMessage message) => throw UnimplementedError();

  // Ignore - no Push-Messages in Demo-Mode
  @override
  updateMessages() {***REMOVED***
***REMOVED***
