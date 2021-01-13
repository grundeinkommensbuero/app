import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';

// Siehe https://pub.dev/packages/flutter_local_notifications

AndroidNotificationChannel participationChannel = AndroidNotificationChannel(
  'Teilnahmen und Absagen', // id
  'Teilnahmen und Absagen', // title
  'Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst',
);

AndroidNotificationChannel changesChannel = AndroidNotificationChannel(
  'Änderungen an Aktionen', // id
  'Änderungen an Aktionen', // title
  'Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst',
);

AndroidNotificationChannel actionChatChannel = AndroidNotificationChannel(
  'Aktionen-Chats', // id
  'Aktionen-Chats', // title
  'Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst',
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
  notifications?.createNotificationChannel(defaultChannel);
  notifications?.createNotificationChannel(topicChatChannel);

  return plugin;
}

class LocalNotificationService {
  FlutterLocalNotificationsPlugin plugin;

  AbstractPushNotificationManager pushManager;
  Function(String) onTap;

  LocalNotificationService(this.pushManager) {
    assert(pushManager != null);
    onTap = (String message) async => await pushManager.onTap({
          'data': {'payload': jsonDecode(message), 'encrypted': 'Plain'}
        });
  }

  // LocalNotificationService.emptyCallback() {
  //   onTap = (_) {print('### Das war wohl nix... ###'); return Future.value();};
  // }

  Future sendChatNotification(ChatMessagePushData chatMessage) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Aktionen-Chats', 'Aktionen-Chats',
            'Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst',
            ticker:
                'Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst');

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    print('Setze Notification ab');
    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin.show(
        chatMessage.channel.hashCode,
        'Nachricht von ${chatMessage.message.sender_name}',
        chatMessage.message.text,
        platformChannelSpecifics,
        payload: jsonEncode(chatMessage.toJson()));
  }

  Future<void> sendParticipationNotification(
      ParticipationPushData partMessage) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'Teilnahmen und Absagen',
            'Teilnahmen und Absagen',
            'Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst',
            ticker:
                'Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst');

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    print('Setze Notification ab');
    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin.show(
        partMessage.channel.hashCode,
        'Verstärkung für deine Aktion',
        '${partMessage.message.username} ist deiner Aktion beigetreten',
        platformChannelSpecifics,
        payload: jsonEncode(partMessage.toJson()));
  }

  Future<void> sendOtherNotification(Map<String, dynamic> data) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Infos', 'Infos', 'Allgemeine Infos',
            ticker: 'Allgemeine Infos');

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    print('Setze Notification ab');
    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin.show(0, data['notification']['title'], data['notification']['body'],
        platformChannelSpecifics,
        payload: jsonEncode(data['data']));
  }

  void sendTopicChatNotification(TopicChatMessagePushData topicChatMessagePushData) async{

    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('Topic-Chats', 'Topic-Chats',
        'Benachrichtigungen über neue Topic-Nachrichten',
        ticker:
        'Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst');

    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    print('Setze Topic Notification ab');
    print('${topicChatMessagePushData.toJson()}');

    if (plugin == null) plugin = await initializeLocalNotifications(onTap);
    plugin.show(
        topicChatMessagePushData.channel.hashCode,
        'Nachricht von ${topicChatMessagePushData.message.sender_name}',
        topicChatMessagePushData.message.text,
        platformChannelSpecifics,
        payload: jsonEncode(topicChatMessagePushData.toJson()));
  }
}
