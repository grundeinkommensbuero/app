import 'package:sammel_app/shared/ServerException.dart';

import 'Message.dart';

class PushMessage {
  List<String> recipients;
  PushData data;
  PushNotification notification;

  PushMessage(this.data, this.notification, {this.recipients***REMOVED***);

  toJson() => {
        'recipients': recipients,
        'data': data,
        'notification': notification,
      ***REMOVED***
***REMOVED***

class PushNotification {
  String title;
  String body;

  PushNotification(this.title, this.body);

  toJson() => {
        'title': title,
        'body': body,
      ***REMOVED***
***REMOVED***

class PushDataTypes {
  static final SimpleChatMessage = 'SimpleChatMessage';
  static String ParticipationMessage = 'ParticipationMessage';
***REMOVED***

// Alle Data-Objekte müssen in eine flache Map<String, String> serialisiert werden können
class PushData {
  String type;

  PushData();

  PushData.fromJson(Map<dynamic, dynamic> json);

  toJson() => {'type': type***REMOVED***
***REMOVED***

class ChatPushData extends PushData {
  String channel;

  ChatPushData(this.channel);

  static ChatPushData fromJson(Map<String, dynamic> data) =>
      ChatPushData(data['channel']);
***REMOVED***

class ChatMessagePushData extends ChatPushData {
  ChatMessage message;
  final String type = PushDataTypes.SimpleChatMessage;

  ChatMessagePushData(this.message, channel) : super(channel);

  toJson() {
    var json_message = message.toJson();
    json_message['type'] = type;
    json_message['channel'] = this.channel;
    return json_message;
  ***REMOVED***

  ChatMessagePushData.fromJson(Map<String, dynamic> json)
      : super(json['channel']) {
    try {
      this.message = ChatMessage.fromJson(json);
    ***REMOVED*** on AssertionError catch (e) {
      throw UnreadablePushMessage(
          'Unlesbare Teilnahme-Push-Nachricht (Teilnahme) empfangen: ${e.message***REMOVED***');
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class ParticipationPushData extends ChatPushData {
  ParticipationMessage message;
  final String type = PushDataTypes.ParticipationMessage;

  ParticipationPushData(this.message, channel) : super(channel);

  toJson() {
    var json_message = message.toJson();
    json_message['type'] = type;
    json_message['channel'] = this.channel;
    return json_message;
  ***REMOVED***

  ParticipationPushData.fromJson(Map<String, dynamic> json)
      : super(json['channel']) {
    try {
      this.message = ParticipationMessage.fromJson(json);
    ***REMOVED*** on AssertionError catch (e) {
      throw UnreadablePushMessage(
          'Unlesbare Push-Nachricht (Teilnahme) empfangen: ${e.message***REMOVED***');
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class ExampleData extends PushData {
  String type = "Example";
  String payload;

  ExampleData.fromJson(Map<dynamic, dynamic> json) : payload = json['payload'] {
    if (type != json['type'])
      throw WrongDataTypeKeyError(expected: type, found: json['type']);
  ***REMOVED***

  ExampleData(this.payload);

  toJson() => {
        'type': type,
        'payload': payload,
      ***REMOVED***
***REMOVED***

class WrongDataTypeKeyError {
  String expected;
  String found;

  WrongDataTypeKeyError({this.expected, this.found***REMOVED***);

  String getMessage() =>
      'Der Typ "$found" entspricht nicht dem erwarteten Typ "$expected"';
***REMOVED***

class UnreadablePushMessage implements ServerException {
  String message;

  UnreadablePushMessage([this.message = 'Unlesbare Push-Nachricht empfangen']);
***REMOVED***
