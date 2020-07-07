
import 'Message.dart';

class PushMessage {
  List<String> recipients;
  PushData data;
  PushNotification notification;

  PushMessage(this.data, this.notification, {this.recipients***REMOVED***);

  toJson() =>
      {
        'recipients': recipients,
        'topic': topic,
        'data': data,
        'notification': notification,
      ***REMOVED***
***REMOVED***

class PushNotification {
  String title;
  String body;

  PushNotification(this.title, this.body);

  toJson() =>
      {
        'title': title,
        'body': body,
      ***REMOVED***
***REMOVED***

class PushDataTypes
{
  static final SimpleChatMessage = 'SimpleChatMessage';
***REMOVED***

// Alle Data-Objekte müssen in eine flache Map<String, String> serialisiert werden können
class PushData {
  String type;

  PushData();

  PushData.fromJson(Map<dynamic, dynamic> json) {***REMOVED***

  toJson() => {'type': type***REMOVED***
***REMOVED***

class MessagePushData extends PushData {

  Message message = null;
  String channel_name = null;
  final String type = PushDataTypes.SimpleChatMessage;

  MessagePushData(this.message, this.channel_name);


  toJson()
  {
    var json_message = message.toJson();
    json_message['type'] = type;
    json_message['channel_name'] = this.channel_name;
    return json_message;
  ***REMOVED***

  MessagePushData.fromJson(Map <dynamic, dynamic> json)
  {
    this.message = Message.fromJSON(json);// Message(text: json['text'], sender_name: json['sender_name'], message_color: Color(json['color']));
    this.channel_name = json['channel_name'];
  ***REMOVED***
***REMOVED***

class ExampleData extends PushData {
  String type = "Example";
  String payload;

  ExampleData.fromJson(Map<dynamic, dynamic> json)
      : payload = json['payload'] {
    if (type != json['type'])
      throw WrongDataTypeKeyError(expected: type, found: json['type']);
  ***REMOVED***

  ExampleData(this.payload);

  toJson() =>
      {
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
