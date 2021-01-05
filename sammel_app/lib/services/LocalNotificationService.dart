import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';

// Siehe https://pub.dev/packages/flutter_local_notifications

const AndroidNotificationChannel participationChannel =
    AndroidNotificationChannel(
  'Teilnahmen und Absagen', // id
  'Teilnahmen und Absagen', // title
  'Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst',
);

const AndroidNotificationChannel changesChannel = AndroidNotificationChannel(
  'Änderungen an Aktionen', // id
  'Änderungen an Aktionen', // title
  'Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst',
);

const AndroidNotificationChannel actionChatChannel = AndroidNotificationChannel(
  'Aktionen-Chats', // id
  'Aktionen-Chats', // title
  'Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst',
);

const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
  'Infos', // id
  'Infos', // title
  'Allgemeine Infos',
);

class LocalNotificationService
{
  ValueNotifier plugin = ValueNotifier(null);
  PushNotificationManager pnm = null;
  LocalNotificationService(PushNotificationManager pnm)
  {
    initializeLocalNotifications().then((value) => plugin.value = value);
    this.pnm = pnm;
  ***REMOVED***

  Future<FlutterLocalNotificationsPlugin> initializeLocalNotifications() async {
    final FlutterLocalNotificationsPlugin plugin =
    FlutterLocalNotificationsPlugin();

    const androidInitializationSettings =
    AndroidInitializationSettings('push_icon');
    const AndroidInitializationSettings initializationSettingsAndroid =
        androidInitializationSettings;

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    await plugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    final notifications = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    notifications?.createNotificationChannel(participationChannel);
    notifications?.createNotificationChannel(changesChannel);
    notifications?.createNotificationChannel(actionChatChannel);
    notifications?.createNotificationChannel(defaultChannel);

    return plugin;
  ***REMOVED***

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {
    // TODO wichtig für ältere iOS-Versionen
  ***REMOVED***

  Future selectNotification(String payload) {
    print('Nachricht geklickt');
    Map<dynamic, dynamic> json_data = jsonDecode(payload);
    pnm.onLocalMessageCallback(json_data);

    // TODO on tap
  ***REMOVED***

  Future sendChatNotification(ChatMessagePushData chatMessage) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('Aktionen-Chats', 'Aktionen-Chats',
        'Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst',
        ticker:
        'Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst');


    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    print('Setze Notification ab');
    if (plugin.value == null)
    {
      //sendchatnotification called before init complete
      plugin.addListener(() => plugin.value.show(
          chatMessage.channel.hashCode,
          'Nachricht von ${chatMessage.message.sender_name***REMOVED***',
          chatMessage.message.text,
          platformChannelSpecifics,
          payload: jsonEncode(chatMessage.toJson())));
    ***REMOVED***
    else {
      plugin.value.show(
          chatMessage.channel.hashCode,
          'Nachricht von ${chatMessage.message.sender_name***REMOVED***',
          chatMessage.message.text,
          platformChannelSpecifics,
          payload: jsonEncode(chatMessage.toJson()));
    ***REMOVED***
  ***REMOVED***


***REMOVED***

