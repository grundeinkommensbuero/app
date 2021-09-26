import 'package:easy_localization/easy_localization.dart';
import 'package:sammel_app/shared/DeserialisationException.dart';
import 'package:sammel_app/shared/ServerException.dart';

import 'Message.dart';

class PushMessage {
  List<String> recipients = List.empty();
  PushData data;
  PushNotification notification;

  PushMessage(this.data, this.notification, {recipients***REMOVED***) {
    this.recipients = recipients ?? List.empty();
  ***REMOVED***

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
  static final chatMessage = 'ChatMessage';
  static final simpleChatMessage = 'SimpleChatMessage';
  static final participationMessage = 'ParticipationMessage';
  static final newKiezActions = 'NewKiezActions';
  static final actionChanged = 'ActionChanged';
  static final actionDeleted = 'ActionDeleted';
  static final topicChatMessage = 'TopicChatMessage';
***REMOVED***

// Alle Data-Objekte müssen in eine flache Map<String, String> serialisiert werden können
class PushData {
  String type = 'general';

  PushData();

  PushData.fromJson(Map<dynamic, dynamic> json);

  toJson() => {'type': type***REMOVED***
***REMOVED***

class ChatPushData extends PushData {
  late String channel;
  String type = PushDataTypes.chatMessage;

  ChatPushData(String? channel) {
    if (channel == null)
      throw DeserialisationException(
          'Fehlender Kanal für Beteiligungs-Benachrichtigung');
    this.channel = channel;
  ***REMOVED***

  Message? get message =>
      throw UnimplementedError("Das hier soll abstrakt sein");

  ChatPushData.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        channel = json['channel'];
***REMOVED***

class ActionChatMessagePushData extends ChatPushData {
  @override
  late ChatMessage message;
  late int action;
  final String type = PushDataTypes.simpleChatMessage;

  ActionChatMessagePushData(this.message, this.action, channel)
      : super(channel);

  toJson() {
    var jsonMessage = message.toJson();
    jsonMessage['type'] = type;
    jsonMessage['action'] = action;
    jsonMessage['channel'] = this.channel;
    return jsonMessage;
  ***REMOVED***

  ActionChatMessagePushData.fromJson(Map<String, dynamic> json)
      : super(json['channel']) {
    try {
      this.action = json['action'];
      this.message = ChatMessage.fromJson(json);
    ***REMOVED*** on AssertionError catch (e) {
      throw UnreadablePushMessage(tr(
          'Unlesbare Chat-Nachricht empfangen: {message***REMOVED***',
          namedArgs: {'named': e.message as String***REMOVED***));
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class TopicChatMessagePushData extends ChatPushData {
  final String type = PushDataTypes.topicChatMessage;
  ChatMessage? message;

  TopicChatMessagePushData(this.message, channel) : super(channel);

  TopicChatMessagePushData.fromJson(Map<String, dynamic> json)
      : super(json['channel']) {
    try {
      this.message = ChatMessage.fromJson(json);
    ***REMOVED*** on AssertionError catch (e) {
      throw UnreadablePushMessage(tr(
          'Unlesbare Topic-Nachricht empfangen: {message***REMOVED***',
          namedArgs: {'named': e.message as String***REMOVED***));
    ***REMOVED***
  ***REMOVED***

  toJson() {
    var jsonMessage = message?.toJson() ?? {***REMOVED***
    jsonMessage['type'] = type;
    jsonMessage['channel'] = this.channel;
    return jsonMessage;
  ***REMOVED***
***REMOVED***

class ParticipationPushData extends ChatPushData {
  @override
  ParticipationMessage? message;
  late int action;
  final String type = PushDataTypes.participationMessage;

  ParticipationPushData(this.message, this.action, String? channel)
      : super(channel);

  toJson() {
    var jsonMessage = message?.toJson() ?? {***REMOVED***
    jsonMessage['type'] = type;
    jsonMessage["action"] = action;
    jsonMessage['channel'] = this.channel;
    return jsonMessage;
  ***REMOVED***

  ParticipationPushData.fromJson(Map<String, dynamic> json)
      : super(json['channel']) {
    if (json['action'] == null)
      throw UnreadablePushMessage(
          'Unlesbare Teilnahme-Nachricht empfangen: Fehlende Aktions-ID');
    else
      this.action = json['action'];
    this.message = ParticipationMessage.fromJson(json);
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

  WrongDataTypeKeyError({required this.expected, required this.found***REMOVED***);

  String getMessage() =>
      'Der Typ "$found" entspricht nicht dem erwarteten Typ "$expected"';
***REMOVED***

class UnreadablePushMessage implements ServerException {
  String message;

  UnreadablePushMessage([this.message = 'Unlesbare Push-Nachricht empfangen']);
***REMOVED***

ChatPushData chatPushDataFromJson(Map<String, dynamic> data) {
  var pushData = ChatPushData.fromJson(data);
  if (pushData.type == PushDataTypes.simpleChatMessage)
    pushData = ActionChatMessagePushData.fromJson(data);
  if (pushData.type == PushDataTypes.participationMessage)
    pushData = ParticipationPushData.fromJson(data);
  if (pushData.type == PushDataTypes.topicChatMessage)
    pushData = TopicChatMessagePushData.fromJson(data);

  return pushData;
***REMOVED***
