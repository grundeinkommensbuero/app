import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/model/Message.dart';

void main() {
  var timestamp = DateTime(2020, 12, 17, 0, 52);

  group('fromJson', () {
    final participationMessage =
        ParticipationMessage(true, timestamp, 'Karl Marx', true);
    final chatMessage = ChatMessage(
        text: 'This is my last resort',
        sender_name: 'Karl Marx',
        timestamp: timestamp,
        message_color: Colors.red,
        obtained_from_server: true,
        user_id: 1);

    test('deserializes ParticipationMessages', () {
      var channel = ChatChannel.fromJSON({
        'id': '1',
        'messages': [participationMessage.toJson()]
      });

      expect(channel.channel_messages.length, 1);
      expect(channel.channel_messages[0] is ParticipationMessage, true);
    });

    test('deserializes ChatMessages', () {
      var channel = ChatChannel.fromJSON({
        'id': '1',
        'messages': [chatMessage.toJson()]
      });

      expect(channel.channel_messages.length, 1);
      expect(channel.channel_messages[0] is ChatMessage, true);
    });

    test('deserializes throws Error on unknown message type', () {
      expect(
          () => ChatChannel.fromJSON({
                'id': '1',
                'messages': [
                  {'id': '1', 'type': 'faulty'}
                ]
              }),
          throwsA((e) => e is UnkownMessageTypeError));
    });

    test('deserializes deserializes mixed type messages', () {
      var channel = ChatChannel.fromJSON({
        'id': '1',
        'messages': [chatMessage.toJson(), participationMessage.toJson()]
      });

      expect(channel.channel_messages.length, 2);
      expect(channel.channel_messages[0] is ChatMessage, true);
      expect(channel.channel_messages[1] is ParticipationMessage, true);
    });
  });
}
