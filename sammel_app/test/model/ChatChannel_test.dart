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
        senderName: 'Karl Marx',
        timestamp: timestamp,
        messageColor: Colors.red,
        obtainedFromServer: true,
        userId: 1);

    test('deserializes ParticipationMessages', () {
      var channel = ChatChannel.fromJSON({
        'id': '1',
        'messages': [participationMessage.toJson()]
      ***REMOVED***);

      expect(channel.channelMessages.length, 1);
      expect(channel.channelMessages[0] is ParticipationMessage, true);
    ***REMOVED***);

    test('deserializes ChatMessages', () {
      var channel = ChatChannel.fromJSON({
        'id': '1',
        'messages': [chatMessage.toJson()]
      ***REMOVED***);

      expect(channel.channelMessages.length, 1);
      expect(channel.channelMessages[0] is ChatMessage, true);
    ***REMOVED***);

    test('deserializes throws Error on unknown message type', () {
      expect(
          () => ChatChannel.fromJSON({
                'id': '1',
                'messages': [
                  {'id': '1', 'type': 'faulty'***REMOVED***
                ]
              ***REMOVED***),
          throwsA((e) => e is UnkownMessageTypeError));
    ***REMOVED***);

    test('deserializes deserializes mixed type messages', () {
      var channel = ChatChannel.fromJSON({
        'id': '1',
        'messages': [chatMessage.toJson(), participationMessage.toJson()]
      ***REMOVED***);

      expect(channel.channelMessages.length, 2);
      expect(channel.channelMessages[0] is ChatMessage, true);
      expect(channel.channelMessages[1] is ParticipationMessage, true);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
