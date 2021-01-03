import 'dart:async';
import 'dart:convert';

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

  void subscribeToTopics(List<String> topics);

  void unsubscribeFromTopics(List<String> topic);
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
  void subscribeToTopics(List<String> topics) {
    for (String topic in topics) {
      print('Subscribe zu Topic $topic');
      var topicEnc = Uri.encodeComponent(topic);
      firebaseMessaging.subscribeToTopic(topicEnc);
    ***REMOVED***
  ***REMOVED***

  @override
  void unsubscribeFromTopics(List<String> topics) {
    for (String topic in topics) {
      print('Unsubscribe von Topic $topic');
      var topicEnc = Uri.encodeComponent(topic);
      firebaseMessaging.unsubscribeFromTopic(topicEnc);
    ***REMOVED***
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
  void subscribeToTopics(List<String> topics) {
    try {
      post('service/push/pull/subscribe', jsonEncode(topics));
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Fehler beim Anmelden der Benachrichtigungen zu $topics');
    ***REMOVED***
  ***REMOVED***

  @override
  void unsubscribeFromTopics(List<String> topics) {
    try {
      post('service/push/pull/subscribe', jsonEncode(topics));
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Fehler beim Abmelden der Benachrichtigungen zu $topics');
    ***REMOVED***
  ***REMOVED***
***REMOVED***
