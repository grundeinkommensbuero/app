import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_server/http_server.dart';
import 'package:sammel_app/main.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/UserService.dart';

import 'ErrorService.dart';

abstract class PushReceiveService {
  void subscribe(
      {MessageHandler onMessage,
      MessageHandler onResume,
      MessageHandler onLaunch,
      MessageHandler onBackgroundMessage***REMOVED***);

  void subscribeToKiezActionTopics(List<String> kieze, String option);

  void unsubscribeFromKiezActionTopics(List<String> kieze, String notification);
***REMOVED***

class FirebaseReceiveService implements PushReceiveService {
  FirebaseMessaging firebaseMessaging;

  Future<String> token;

  FirebaseReceiveService([FirebaseMessaging firebaseMock]) {
    firebaseMessaging =
        firebaseMock != null ? firebaseMock : FirebaseMessaging();
    initializeFirebase();
  ***REMOVED***

  initializeFirebase() async {
    // DEBUG
    if (pullMode) return;

    // For iOS request permission first.
    await firebaseMessaging.requestNotificationPermissions();

    token = firebaseMessaging
        .getToken()
        .timeout(Duration(seconds: 5), onTimeout: () => null);
  ***REMOVED***

  @override
  void subscribe({onMessage, onResume, onLaunch, onBackgroundMessage***REMOVED***) =>
      firebaseMessaging.configure(
          onMessage: onMessage,
          onResume: onResume,
          onLaunch: onLaunch,
          onBackgroundMessage: onBackgroundMessage);

  @override
  void unsubscribeFromKiezActionTopics(List<String> kieze, String interval) {
    kieze.forEach((kiez) {
      var topic = Uri.encodeComponent('$kiez-$interval');
      print('Unsubscribe zu Topic $topic');
      firebaseMessaging.unsubscribeFromTopic(topic);
    ***REMOVED***);
  ***REMOVED***

  @override
  void subscribeToKiezActionTopics(List<String> kieze, String interval) {
    kieze.forEach((kiez) {
      var topic = Uri.encodeComponent('$kiez-$interval');
      print('Subscribe zu Topic $topic');
      firebaseMessaging.subscribeToTopic(topic);
    ***REMOVED***);
  ***REMOVED***
***REMOVED***

class PullService extends BackendService implements PushReceiveService {
  Timer timer;
  MessageHandler onMessage = (_) async => Map();

  PullService(AbstractUserService userService, Backend backend)
      : super(userService, backend) {
    timer = Timer.periodic(Duration(seconds: 10), (_) => pull());
  ***REMOVED***

  @override
  void subscribe({onMessage, onResume, onLaunch, onBackgroundMessage***REMOVED***) {
    // ignore onResume, onLaunch and onBackgroundMessage, since they are not happening in Pull Mode
    this.onMessage = onMessage;
  ***REMOVED***

  Future<void> pull() async {
    try {
      HttpClientResponseBody reponse = await get('service/push/pull');
      List content = reponse.body;
      if (content != null && content.isNotEmpty)
        content.forEach((message) => onMessage(message));
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context:
              'Beim Abrufen von Nachrichten ist ein Fehler aufgetreten. Das regelmäßige Abrufen von Nachrichten wird deshalb deaktiviert');
      timer.cancel();
    ***REMOVED***
  ***REMOVED***

  @override
  void subscribeToKiezActionTopics(List<String> kieze, String option) {
    // TODO: implement subscribeToKiezActionTopics
  ***REMOVED***

  @override
  void unsubscribeFromKiezActionTopics(
      List<String> kieze, String notification) {
    // TODO: implement unsubscribeFromKiezActionTopics
  ***REMOVED***
***REMOVED***
