import 'dart:ui';

import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

abstract class Message {
  abstract String type;
  bool obtainedFromServer = false;
  abstract DateTime? timestamp;

  static String? determineType(Map<String, dynamic> data) =>
      data['type'] ?? null;

  Map<String, dynamic> toJson();

  bool isMessageEqual(Message msg);
***REMOVED***

class ChatMessage implements Message {
  @override
  String type = PushDataTypes.simpleChatMessage;
  @override
  late bool obtainedFromServer;
  @override
  DateTime? timestamp;
  String? text;
  String? senderName;
  Color? messageColor;
  int? userId = -1;

  ChatMessage(
      {this.text,
      this.senderName,
      this.timestamp,
      this.messageColor,
      this.obtainedFromServer = false,
      this.userId***REMOVED***);

  @override
  ChatMessage.fromJson(Map<dynamic, dynamic> jsonMessageData) {
    text = jsonMessageData['text'];
    senderName = jsonMessageData['sender_name'];
    timestamp = DateTime.parse(jsonMessageData['timestamp']);
    messageColor = Color(int.parse(jsonMessageData['color'].toString()));
    obtainedFromServer = jsonMessageData['from_server'];
    userId = jsonMessageData['user_id'] == null
        ? null
        : int.tryParse(jsonMessageData['user_id'].toString());
  ***REMOVED***

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'text': text,
        'sender_name': senderName,
        'user_id': userId,
        'timestamp': timestamp.toString(),
        'color': messageColor?.value,
        'from_server': obtainedFromServer,
      ***REMOVED***

  @override
  bool isMessageEqual(Message msg) {
    if (!(msg is ChatMessage)) return false;
    return msg is ChatMessage &&
        msg.text == text &&
        msg.senderName == msg.senderName &&
        equalTimestamps(timestamp, msg.timestamp) &&
        messageColor?.value == msg.messageColor?.value;
  ***REMOVED***
***REMOVED***

class ParticipationMessage implements Message {
  @override
  String type = PushDataTypes.participationMessage;
  @override
  bool obtainedFromServer;
  @override
  DateTime? timestamp;
  String? username;
  bool joins;

  ParticipationMessage(this.timestamp, this.username, this.joins,
      [this.obtainedFromServer = false]);

  factory ParticipationMessage.fromJson(Map<dynamic, dynamic> json) {
    final bool joins = json['joins'];
    return ParticipationMessage(DateTime.parse(json['timestamp']),
        json['username'], joins, json['obtained_from_server'] ?? false);
  ***REMOVED***

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'obtained_from_server': obtainedFromServer,
        'timestamp': timestamp != null ? timestamp.toString() : null,
        'username': username,
        'joins': joins
      ***REMOVED***

  @override
  bool isMessageEqual(Message msg) {
    return msg is ParticipationMessage &&
        type == msg.type &&
        equalTimestamps(timestamp, msg.timestamp) &&
        username == msg.username &&
        joins == msg.joins;
  ***REMOVED***
***REMOVED***
