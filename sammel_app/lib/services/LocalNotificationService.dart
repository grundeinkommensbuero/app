import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sammel_app/model/ActionListPushData.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';

// Siehe https://pub.dev/packages/flutter_local_notifications

AndroidNotificationChannel participationChannel = AndroidNotificationChannel(
  'Teilnahmen und Absagen', // id
  'Teilnahmen und Absagen', // title
  'Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst',
  playSound: false,
  ledColor: CampaignTheme.secondary,
);

AndroidNotificationChannel changesChannel = AndroidNotificationChannel(
  'Änderungen an Aktionen', // id
  'Änderungen an Aktionen', // title
  'Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst',
  playSound: true,
  ledColor: CampaignTheme.secondary,
);

AndroidNotificationChannel actionChatChannel = AndroidNotificationChannel(
  'Aktionen-Chats', // id
  'Aktionen-Chats', // title
  'Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst',
  ledColor: CampaignTheme.secondary,
);

AndroidNotificationChannel newActionsChannel = AndroidNotificationChannel(
  'Aktionen im Kiez', // id
  'Aktionen im Kiez', // title
  'Benachrichtigungen über neue Aktionen in deinem Kiez',
  playSound: true,
  ledColor: CampaignTheme.secondary,
);

AndroidNotificationChannel topicChatChannel = AndroidNotificationChannel(
  'Topic-Chats', // id
  'Topic-Chats', // title
  'Benachrichtigungen über neue Topic-Nachrichten',
);

AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
  'Infos', // id
  'Infos', // title
  'Allgemeine Infos',
  playSound: false,
  ledColor: CampaignTheme.secondary,
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
  notifications?.createNotificationChannel(topicChatChannel);

  return plugin;
}

class LocalNotificationService {
  FlutterLocalNotificationsPlugin? plugin;

  late AbstractPushNotificationManager pushManager;
  late Function(String) onTap;

  LocalNotificationService(this.pushManager) {
    onTap = (String message) async => await pushManager.onTap(RemoteMessage(
        data: {'payload': jsonDecode(message), 'encrypted': 'Plain'}));
  }

  Future sendChatNotification(ActionChatMessagePushData chatMessage) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Aktionen-Chats', 'Aktionen-Chats',
            'Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst',
            ticker:
                'Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst',
            color: CampaignTheme.secondary,
            playSound: false);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin!.show(
        chatMessage.channel.hashCode,
        'Nachricht von ${chatMessage.message.senderName}',
        chatMessage.message.text,
        platformChannelSpecifics,
        payload: jsonEncode(chatMessage.toJson()));
  }

  Future<void> sendParticipationNotification(ParticipationPushData data) async {
    if (data.message == null) return;
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'Teilnahmen und Absagen',
            'Teilnahmen und Absagen',
            'Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst',
            ticker:
                'Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst',
            color: CampaignTheme.secondary,
            playSound: false);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin!.show(
        data.channel.hashCode,
        data.message!.joins
            ? 'Verstärkung für deine Aktion'
            : 'Absage bei deiner Aktion',
        data.message!.joins
            ? '${data.message!.username} ist deiner Aktion beigetreten'
            : '${data.message!.username} hat deine Aktion verlassen',
        platformChannelSpecifics,
        payload: jsonEncode(data.toJson()));
  }

  Future<void> sendNewActionsNotification(
      ActionListPushData partMessage) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Aktionen im Kiez', 'Aktionen im Kiez',
            'Benachrichtigungen über neue Aktionen in deinem Kiez',
            ticker: 'Benachrichtigungen über neue Aktionen in deinem Kiez',
            color: CampaignTheme.secondary,
            playSound: true);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    String body;
    if (partMessage.actions.length == 1)
      body = '${partMessage.actions[0].typ} '
          'am ${ChronoHelfer.formatDateOfDateTime(partMessage.actions[0].beginn)} '
          'um ${ChronoHelfer.dateTimeToStringHHmm(partMessage.actions[0].beginn)} '
          ', ${partMessage.actions[0].ort.ortsteil}';
    else
      body =
          '${partMessage.actions.length} neue Aktionen in ${partMessage.actions[0].ort.name}';

    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin!.show('newactions:${partMessage.actions[0].ort.name}'.hashCode,
        'Neue Aktionen in deinem Kiez', body, platformChannelSpecifics,
        payload: jsonEncode(partMessage.toJson()));
  }

  Future<void> sendActionDeletedNotification(
      ActionListPushData partMessage) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Änderung an Aktion', 'Änderung an Aktion',
            'Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst',
            ticker:
                'Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst',
            color: CampaignTheme.secondary,
            playSound: true);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin!.show(
        'action:change:${partMessage.actions[0].id}'.hashCode,
        'Eine Aktion an der du teilnimmst wurde abgesagt',
        '${partMessage.actions[0].typ} '
            'am ${ChronoHelfer.formatDateOfDateTime(partMessage.actions[0].beginn)} '
            'in ${partMessage.actions[0].ort.name} (${partMessage.actions[0].details!.treffpunkt}) '
            ' wurde von der Ersteller*in gelöscht',
        platformChannelSpecifics,
        payload: jsonEncode(partMessage.toJson()));
  }

  Future<void> sendActionChangedNotification(
      ActionListPushData partMessage) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Änderung an Aktion', 'Änderung an Aktion',
            'Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst',
            ticker:
                'Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst',
            color: CampaignTheme.secondary,
            playSound: true);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin!.show(
        'action:change:${partMessage.actions[0].id}'.hashCode,
        'Eine Aktion an der du teilnimmst hat sich geändert',
        '${partMessage.actions[0].typ} '
            'am ${ChronoHelfer.formatDateOfDateTime(partMessage.actions[0].beginn)} '
            'in ${partMessage.actions[0].ort.name} (${partMessage.actions[0].details!.treffpunkt})',
        platformChannelSpecifics,
        payload: jsonEncode(partMessage.toJson()));
  }

  Future<void> sendOtherNotification(Map<String, dynamic> data) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Infos', 'Infos', 'Allgemeine Infos',
            ticker: 'Allgemeine Infos',
            color: CampaignTheme.secondary,
            playSound: true);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin!.show(0, data['notification']['title'], data['notification']['body'],
        platformChannelSpecifics,
        payload: jsonEncode(data['data']));
  }

  void sendTopicChatNotification(
      TopicChatMessagePushData topicChatMessagePushData) async {
    if (topicChatMessagePushData.message == null) return;
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Topic-Chats', 'Topic-Chats',
            'Benachrichtigungen über neue Topic-Nachrichten',
            ticker:
                'Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst');

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin!.show(
        topicChatMessagePushData.channel.hashCode,
        'Nachricht von ${topicChatMessagePushData.message!.senderName}',
        topicChatMessagePushData.message!.text,
        platformChannelSpecifics,
        payload: jsonEncode(topicChatMessagePushData.toJson()));
  }
}
