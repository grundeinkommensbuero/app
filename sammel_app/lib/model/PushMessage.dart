class PushMessage {
  List<String> recipients;
  String topic;
  PushData data;
  PushNotification notification;

  PushMessage(this.data, this.notification, {this.recipients, this.topic});

  toJson() =>
      {
        'recipients': recipients,
        'data': data,
        'notification': notification,
      };
}

class PushNotification {
  String title;
  String body;

  PushNotification(this.title, this.body);

  toJson() =>
      {
        'title': title,
        'body': body,
      };
}

// Alle Data-Objekte müssen in eine flache Map<String, String> serialisiert werden können
class PushData {
  String type;

  PushData();

  PushData.fromJson(Map<dynamic, dynamic> json) {}

  toJson() => {'type': type};
}

class ExampleData extends PushData {
  String type = "Example";
  String payload;

  ExampleData.fromJson(Map<dynamic, dynamic> json)
      : payload = json['payload'] {
    if (type != json['type'])
      throw WrongDataTypeKeyError(expected: type, found: json['type']);
  }

  ExampleData(this.payload);

  toJson() =>
      {
        'type': type,
        'payload': payload,
      };
}

class WrongDataTypeKeyError {
  String expected;
  String found;

  WrongDataTypeKeyError({this.expected, this.found});

  String getMessage() =>
      'Der Typ "$found" entspricht nicht dem erwarteten Typ "$expected"';
}
