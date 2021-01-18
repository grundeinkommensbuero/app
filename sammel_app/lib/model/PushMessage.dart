import 'package:easy_localization/easy_localization.dart';
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
  static final ParticipationMessage = 'ParticipationMessage';
  static final NewKiezActions = 'NewKiezActions';
  static final ActionChanged = 'ActionChanged';
  static final ActionDeleted = 'ActionDeleted';
  static final TopicChatMessage = 'TopicChatMessage';
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
  String type;

  ChatPushData(this.channel);

  Message get message =>
      throw UnimplementedError("Das hier soll abstrakt sein");

  ChatPushData.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        channel = json['channel'];
***REMOVED***

class ActionChatMessagePushData extends ChatPushData {
  @override
  ChatMessage message;
  int action;
  final String type = PushDataTypes.SimpleChatMessage;

  ActionChatMessagePushData(this.message, this.action, channel) : super(channel);

  toJson() {
    var json_message = message.toJson();
    json_message['type'] = type;
    json_message['action'] = action;
    json_message['channel'] = this.channel;
    return json_message;
  ***REMOVED***

  ActionChatMessagePushData.fromJson(Map<String, dynamic> json)
      : super(json['channel']) {
    try {
      var action = json['action'] ?? null;
      this.action = action == null ? -1 : int.parse("$action");
      this.message = ChatMessage.fromJson(json);
    ***REMOVED*** on AssertionError catch (e) {
      throw UnreadablePushMessage(tr(
          'Unlesbare Chat-Nachricht empfangen: {message***REMOVED***',
          namedArgs: {'named': e.message***REMOVED***));
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class TopicChatMessagePushData extends ChatPushData
{
  final String type = PushDataTypes.TopicChatMessage;
  ChatMessage message;
  TopicChatMessagePushData(this.message, channel) : super(channel);

  TopicChatMessagePushData.fromJson(Map<String, dynamic> json)
      : super(json['channel']) {
    try {
      this.message = ChatMessage.fromJson(json);
    ***REMOVED*** on AssertionError catch (e) {
      throw UnreadablePushMessage(tr(
          'Unlesbare Topic-Nachricht empfangen: {message***REMOVED***',
          namedArgs: {'named': e.message***REMOVED***));
    ***REMOVED***
  ***REMOVED***

  toJson() {
    var json_message = message.toJson();
    json_message['type'] = type;
    json_message['channel'] = this.channel;
    return json_message;
  ***REMOVED***

***REMOVED***

class ParticipationPushData extends ChatPushData {
  @override
  ParticipationMessage message;
  int action;
  final String type = PushDataTypes.ParticipationMessage;

  ParticipationPushData(this.message, this.action, channel) : super(channel);

  toJson() {
    var json_message = message.toJson();
    json_message['type'] = type;
    json_message["action"] = action;
    json_message['channel'] = this.channel;
    return json_message;
  ***REMOVED***

  ParticipationPushData.fromJson(Map<String, dynamic> json)
      : super(json['channel']) {
    try {
      var action = json['action'] ?? null;
      this.action = action == null ? -1 : action;
      this.message = ParticipationMessage.fromJson(json);
    ***REMOVED*** on AssertionError catch (e) {
      throw UnreadablePushMessage(
          'Unlesbare Teilnahme-Nachricht empfangen: ${e.message***REMOVED***');
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

ChatPushData chatPushDataFromJson(Map<String, dynamic> data) {
  var pushData = ChatPushData.fromJson(data);
  if (pushData.type == PushDataTypes.SimpleChatMessage)
    pushData = ActionChatMessagePushData.fromJson(data);
  if (pushData.type == PushDataTypes.ParticipationMessage)
    pushData = ParticipationPushData.fromJson(data);
  if (pushData.type == PushDataTypes.TopicChatMessage)
    pushData = TopicChatMessagePushData.fromJson(data);

  return pushData;
***REMOVED***
