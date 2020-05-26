class PushMessage {
  List<String> recipients;
  String topic;
  PushData data;
  PushNotification notification;

  PushMessage(this.data, this.notification, {this.recipients, this.topic***REMOVED***);

  toJson() =>
      {
        'recipients': recipients,
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

// Alle Data-Objekte müssen in eine flache Map<String, String> serialisiert werden können
class PushData {
  String type;

  PushData();

  PushData.fromJson(Map<dynamic, dynamic> json) {***REMOVED***

  toJson() => {'type': type***REMOVED***
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
