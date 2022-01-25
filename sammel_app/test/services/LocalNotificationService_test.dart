import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/LocalNotificationService.dart';

import '../shared/mocks.mocks.dart';

main() {
  MockPushNotificationManager mockPushNotificationManager =
      MockPushNotificationManager();
  LocalNotificationService l =
      LocalNotificationService(mockPushNotificationManager);
  MockFlutterLocalNotificationsPlugin plugin =
      MockFlutterLocalNotificationsPlugin();
  l.plugin = plugin;
  group('sendChatNotification', () {
    test('sends chat notification', () {
      ActionChatMessagePushData message = ActionChatMessagePushData(
          ChatMessage(text: 'hello', senderName: 'Tester'), 1, 'my channel');

      l.sendChatNotification(message);
      verify(plugin.show(message.channel.hashCode, 'Nachricht von Tester',
          'hello', any,
          payload: jsonEncode(message.toJson())));
    });
  });
}
