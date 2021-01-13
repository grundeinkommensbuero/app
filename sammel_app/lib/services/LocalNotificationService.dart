import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sammel_app/model/ActionListPushData.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';

// Siehe https://pub.dev/packages/flutter_local_notifications

AndroidNotificationChannel participationChannel = AndroidNotificationChannel(
  'Teilnahmen und Absagen', // id
  'Teilnahmen und Absagen', // title
  'Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst',
  playSound: false,
  ledColor: DweTheme.purple,
);

AndroidNotificationChannel changesChannel = AndroidNotificationChannel(
  'Änderungen an Aktionen', // id
  'Änderungen an Aktionen', // title
  'Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst',
  playSound: true,
  ledColor: DweTheme.purple,
);

AndroidNotificationChannel actionChatChannel = AndroidNotificationChannel(
  'Aktionen-Chats', // id
  'Aktionen-Chats', // title
  'Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst',
  ledColor: DweTheme.purple,
);

AndroidNotificationChannel newActionsChannel = AndroidNotificationChannel(
  'Aktionen im Kiez', // id
  'Aktionen im Kiez', // title
  'Benachrichtigungen über neue Aktonen in deinem Kiez',
  playSound: true,
  ledColor: DweTheme.purple,
);

AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
  'Infos', // id
  'Infos', // title
  'Allgemeine Infos',
  playSound: false,
  ledColor: DweTheme.purple,
);

Future<FlutterLocalNotificationsPlugin> initializeLocalNotifications(
    onTab) async {
  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  const androidInitializationSettings =
      AndroidInitializationSettings('push_icon');
  const AndroidInitializationSettings initializationSettingsAndroid =
      androidInitializationSettings;

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();
  final MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await plugin.initialize(initializationSettings, onSelectNotification: onTab);

  final notifications = plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  notifications?.createNotificationChannel(participationChannel);
  notifications?.createNotificationChannel(changesChannel);
  notifications?.createNotificationChannel(actionChatChannel);
  notifications?.createNotificationChannel(newActionsChannel);
  notifications?.createNotificationChannel(defaultChannel);

  return plugin;
***REMOVED***

class LocalNotificationService {
  FlutterLocalNotificationsPlugin plugin;

  AbstractPushNotificationManager pushManager;
  Function(String) onTap;

  LocalNotificationService(this.pushManager) {
    assert(pushManager != null);
    onTap = (String message) async => await pushManager.onTap({
          'data': {'payload': jsonDecode(message), 'encrypted': 'Plain'***REMOVED***
        ***REMOVED***);
  ***REMOVED***

  // LocalNotificationService.emptyCallback() {
  //   onTap = (_) {print('### Das war wohl nix... ###'); return Future.value();***REMOVED***
  // ***REMOVED***

  Future sendChatNotification(ChatMessagePushData chatMessage) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Aktionen-Chats', 'Aktionen-Chats',
            'Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst',
            ticker:
                'Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst',
            color: DweTheme.purple,
            playSound: false);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    print('Setze Notification ab');
    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin.show(
        chatMessage.channel.hashCode,
        'Nachricht von ${chatMessage.message.sender_name***REMOVED***',
        chatMessage.message.text,
        platformChannelSpecifics,
        payload: jsonEncode(chatMessage.toJson()));
  ***REMOVED***

  Future<void> sendParticipationNotification(
      ParticipationPushData partMessage) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'Teilnahmen und Absagen',
            'Teilnahmen und Absagen',
            'Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst',
            ticker:
                'Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst',
            color: DweTheme.purple,
            playSound: false);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    print('Setze Notification ab');
    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin.show(
        partMessage.channel.hashCode,
        'Verstärkung für deine Aktion',
        '${partMessage.message.username***REMOVED*** ist deiner Aktion beigetreten',
        platformChannelSpecifics,
        payload: jsonEncode(partMessage.toJson()));
  ***REMOVED***

  Future<void> sendNewActionsNotification(
      ActionListPushData partMessage) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Aktionen im Kiez', 'Aktionen im Kiez',
            'Benachrichtigungen über neue Aktonen in deinem Kiez',
            ticker: 'Benachrichtigungen über neue Aktonen in deinem Kiez',
            color: DweTheme.purple,
            playSound: true);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    String body;
    if (partMessage.actions.length == 1)
      body = '''${partMessage.actions[0].typ***REMOVED*** 
          am ${ChronoHelfer.formatDateOfDateTime(partMessage.actions[0].beginn)***REMOVED*** 
          um ${ChronoHelfer.dateTimeToStringHHmm(partMessage.actions[0].beginn)***REMOVED***
          , ${partMessage.actions[0].ort.ortsteil***REMOVED***''';
    else
      body =
          '${partMessage.actions.length***REMOVED*** neue Aktionen in ${partMessage.actions[0].ort.name***REMOVED***';

    print('Setze Notification ab');
    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin.show('newactions:${partMessage.actions[0].ort.name***REMOVED***'.hashCode,
        'Neue Aktionen in deinem Kiez', body, platformChannelSpecifics,
        payload: jsonEncode(partMessage.toJson()));
  ***REMOVED***

  Future<void> sendActionDeletedNotification(
      ActionListPushData partMessage) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Änderung an Aktion', 'Änderung an Aktion',
            'Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst',
            ticker:
                'Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst',
            color: DweTheme.purple,
            playSound: true);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    print('Setze Notification ab');
    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin.show(
        'action:change:${partMessage.actions[0].id***REMOVED***'.hashCode,
        'Eine Aktion an der du teilnimmst wurde abgesagt',
        '''${partMessage.actions[0].typ***REMOVED*** 
        am ${ChronoHelfer.formatDateOfDateTime(partMessage.actions[0].beginn)***REMOVED*** 
        in ${partMessage.actions[0].ort.name***REMOVED*** (${partMessage.actions[0].details.treffpunkt***REMOVED***) 
        wurde von der Ersteller*in gelöscht''',
        platformChannelSpecifics,
        payload: jsonEncode(partMessage.toJson()));
  ***REMOVED***

  Future<void> sendActionChangedNotification(
      ActionListPushData partMessage) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Änderung an Aktion', 'Änderung an Aktion',
            'Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst',
            ticker:
                'Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst',
            color: DweTheme.purple,
            playSound: true);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    print('Setze Notification ab');
    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin.show(
        'action:change:${partMessage.actions[0].id***REMOVED***'.hashCode,
        'Eine Aktion an der du teilnimmst hat sich geändert',
        '''${partMessage.actions[0].typ***REMOVED*** 
        am ${ChronoHelfer.formatDateOfDateTime(partMessage.actions[0].beginn)***REMOVED*** 
        in ${partMessage.actions[0].ort.name***REMOVED*** (${partMessage.actions[0].details.treffpunkt***REMOVED***)''',
        platformChannelSpecifics,
        payload: jsonEncode(partMessage.toJson()));
  ***REMOVED***

  Future<void> sendOtherNotification(Map<String, dynamic> data) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Infos', 'Infos', 'Allgemeine Infos',
            ticker: 'Allgemeine Infos',
            color: DweTheme.purple,
            playSound: true);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    print('Setze Notification ab');
    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin.show(0, data['notification']['title'], data['notification']['body'],
        platformChannelSpecifics,
        payload: jsonEncode(data['data']));
  ***REMOVED***
***REMOVED***
