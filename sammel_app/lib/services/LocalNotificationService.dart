import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sammel_app/model/PushMessage.dart';

// Siehe https://pub.dev/packages/flutter_local_notifications

void initializeLocalNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('push_icon');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  final MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
***REMOVED***

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) {
  // TODO für ältere iOS-Versionen
***REMOVED***

Future selectNotification(String payload) {
  print('Nachricht geklickt');
  // TODO on tap
***REMOVED***

Future sendChatNotification(ChatMessagePushData chatMessage) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  initializeLocalNotifications(flutterLocalNotificationsPlugin);

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('action-chats', 'Aktionen-Chats',
          'Chat-Nachrichten zu Aktionen an denen du teilnimmst',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          ticker: 'ticker');
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  print('Setze Notification ab');
  await flutterLocalNotificationsPlugin.show(
      chatMessage.channel.hashCode,
      'Nachricht von ${chatMessage.message.sender_name***REMOVED***',
      chatMessage.message.text,
      platformChannelSpecifics);
***REMOVED***
