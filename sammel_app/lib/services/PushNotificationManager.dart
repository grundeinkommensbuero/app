import 'dart:async';
import 'dart:io';

import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/PushUpdateService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/Crypter.dart';
import 'package:validators/validators.dart';

import 'BackendService.dart';
import 'ChatMessageService.dart';
import 'ErrorService.dart';

abstract class AbstractPushNotificationManager {
  void register_message_callback(String id, PushNotificationListener callback);

  void unsubscribeFromKiezActionTopics(List<String> kieze, String interval);

  void subscribeToKiezActionTopics(List<String> kieze, String interval);

  Future<String> get pushToken;

  onTap(Map<String, Map<String, dynamic>> map);

  updateMessages() {***REMOVED***
***REMOVED***

abstract class PushNotificationListener {
  void receive_message(Map<String, dynamic> data) {***REMOVED***

  void handleNotificationTap(Map<dynamic, dynamic> data) {***REMOVED***

  void updateMessages(List<Map<String, dynamic>> data) {***REMOVED***
***REMOVED***

class PushNotificationManager implements AbstractPushNotificationManager {
  PushReceiveService listener;
  StorageService storageService;
  AbstractUserService userService;
  PushUpdateService updateService;

  @override
  Future<String> pushToken;

  PushNotificationManager(this.storageService, this.userService,
      FirebaseReceiveService firebaseService, Backend backend) {
    var listener = createPushListener(firebaseService, backend);
    pushToken = listener.then((listener) => listener.token);
    updateService = PushUpdateService(userService, backend);
    updateMessages();
  ***REMOVED***

  Future<PushReceiveService> createPushListener(
      FirebaseReceiveService firebaseService, Backend backend) async {
    if (await storageService.isPullMode())
      listener = PullService(userService, backend);
    else {
      pushToken = firebaseService.token;
      if (isNull(await pushToken) || (await pushToken).isEmpty) {
        ErrorService.pushError('Problem beim Einrichten von Push-Nachrichten',
            '''Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. 
                'Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. 
                'Darum kann die App nur Benachrichtigungen empfangen während sie geöffnet ist.''');

        storageService.markPullMode();
        listener = PullService(userService, backend);
      ***REMOVED*** else {
        listener = firebaseService;
      ***REMOVED***
    ***REMOVED***

    listener.subscribe(
        onMessage: onReceived,
        onResume: onTap,
        onLaunch: onTap,
        onBackgroundMessage: backgroundMessageHandler);

    return listener;
  ***REMOVED***

  Map<String, PushNotificationListener> callback_map = Map();

  Future<dynamic> onReceived(Map<dynamic, dynamic> message) async {
    print('onReceived: Push-Nachricht empfangen: $message');
    final data = extractData(message);

    try {
      if (data.containsKey('type'))
        callback_map[data['type']]?.receive_message(data);
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s);
    ***REMOVED***
  ***REMOVED***

  Future<dynamic> onTap(Map<dynamic, dynamic> message) async {
    print(
        'onTap: Push-Nachricht empfangen: $message \nund Callback-Map für: ${callback_map.keys***REMOVED***');
    final data = extractData(message);

    try {
      if (data.containsKey('type')) {
        String type = data['type'];
        print("contains type ${callback_map.containsKey(type)***REMOVED***");
        if (callback_map.containsKey(type)) {
          print('Callback gefunden!');
          callback_map[type].handleNotificationTap(data);
        ***REMOVED***
      ***REMOVED***
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s);
    ***REMOVED***
  ***REMOVED***

  Map<String, dynamic> extractData(Map message) {
    // iOS sendet nur Data, Android verpackt es
    if (Platform.isAndroid)
      return decrypt(message['data']);
    else
      return decrypt(message);
  ***REMOVED***

  @override
  void register_message_callback(String id, PushNotificationListener callback) {
    print('Registriere Callback für $id');
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

  @override
  Future<void> updateMessages() async {
    final messages = await updateService.getLatestPushMessages();
    if (messages == null) return;
    final decrypted =
        messages.map((message) => decrypt(message['data'])).toList();
    final messageMap = sortMessagesByType(decrypted);

    print('${messageMap.keys.length***REMOVED*** Push-Nachrichten vom Server geupdated');
    try {
      messageMap.forEach((type, messages) {
        callback_map[type]?.updateMessages(messages);
      ***REMOVED***);
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s);
    ***REMOVED***
  ***REMOVED***
***REMOVED***

Map<String, List<Map<String, dynamic>>> sortMessagesByType(
        List<Map<String, dynamic>> messages) =>
    messages
        .where((message) => message != null)
        .where((data) => data != null && data['type'] != null)
        .fold(Map<String, List<Map<String, dynamic>>>(), (typeMap, data) {
      if (typeMap[data['type']] == null) typeMap[data['type']] = [];
      typeMap[data['type']].add(data);
      return typeMap;
    ***REMOVED***);

// funktioniert nur unter Android
Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  print('Background-Messenger meldet Nachrichten-Ankunft: $message');
  var data = decrypt(message['data']);

  if (data['type'] == PushDataTypes.SimpleChatMessage) {
    var pushData =
        ChatMessagePushData(ChatMessage.fromJson(data), data['channel']);
    handleBackgroundChatMessage(pushData);
    // LocalNotificationService.emptyCallback().sendChatNotification(pushData);

  ***REMOVED*** else if (data['type'] == PushDataTypes.ParticipationMessage) {
    var pushData = ParticipationPushData(
        ParticipationMessage.fromJson(data), data['channel']);
    handleBackgroundChatMessage(pushData);
    // LocalNotificationService.emptyCallback()
    //     .sendParticipationNotification(pushData);

    // ***REMOVED*** else
    //   LocalNotificationService.emptyCallback().sendOtherNotification(message);
  ***REMOVED***
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

  // Ignore - no Push-Messages in Demo-Mode
  @override
  onTap(Map<String, Map<String, dynamic>> map) {
    throw UnimplementedError();
  ***REMOVED***

  // Ignore - no Push-Messages in Demo-Mode
  @override
  updateMessages() {***REMOVED***
***REMOVED***
