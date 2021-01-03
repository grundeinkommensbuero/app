import 'package:sammel_app/shared/ServerException.dart';

import 'Message.dart';

class PushMessage {
  List<String> recipients;
  PushData data;
  PushNotification notification;

  PushMessage(this.data, this.notification, {this.recipients});

  toJson() => {
        'recipients': recipients,
        'data': data,
        'notification': notification,
      };
}

class PushNotification {
  String title;
  String body;

  PushNotification(this.title, this.body);

  toJson() => {
        'title': title,
        'body': body,
      };
}

class PushDataTypes {
  static final SimpleChatMessage = 'SimpleChatMessage';
  static final ParticipationMessage = 'ParticipationMessage';
  static final NewKiezActions = 'NewKiezActions';
  static final ActionChanged = 'ActionChanged';
  static final ActionDeleted = 'ActionDeleted';
}

// Alle Data-Objekte müssen in eine flache Map<String, String> serialisiert werden können
class PushData {
  String type;

  PushData();

  PushData.fromJson(Map<dynamic, dynamic> json);

  toJson() => {'type': type};
}

class ChatPushData extends PushData {
  String channel;

  ChatPushData(this.channel);

  static ChatPushData fromJson(Map<String, dynamic> data) =>
      ChatPushData(data['channel']);
}

class ChatMessagePushData extends ChatPushData {
  ChatMessage message;
  final String type = PushDataTypes.SimpleChatMessage;

  ChatMessagePushData(this.message, channel) : super(channel);

  toJson() {
    var json_message = message.toJson();
    json_message['type'] = type;
    json_message['channel'] = this.channel;
    return json_message;
  }

  ChatMessagePushData.fromJson(Map<String, dynamic> json)
      : super(json['channel']) {
    try {
      this.message = ChatMessage.fromJson(json);
    } on AssertionError catch (e) {
      throw UnreadablePushMessage(
          'Unlesbare Teilnahme-Push-Nachricht (Teilnahme) empfangen: ${e.message}');
    }
  }
}

class ParticipationPushData extends ChatPushData {
  ParticipationMessage message;
  final String type = PushDataTypes.ParticipationMessage;

  ParticipationPushData(this.message, channel) : super(channel);

  toJson() {
    var json_message = message.toJson();
    json_message['type'] = type;
    json_message['channel'] = this.channel;
    return json_message;
  }

  ParticipationPushData.fromJson(Map<String, dynamic> json)
      : super(json['channel']) {
    try {
      this.message = ParticipationMessage.fromJson(json);
    } on AssertionError catch (e) {
      throw UnreadablePushMessage(
          'Unlesbare Push-Nachricht (Teilnahme) empfangen: ${e.message}');
    }
  }
}

class ExampleData extends PushData {
  String type = "Example";
  String payload;

  ExampleData.fromJson(Map<dynamic, dynamic> json) : payload = json['payload'] {
    if (type != json['type'])
      throw WrongDataTypeKeyError(expected: type, found: json['type']);
  }

  ExampleData(this.payload);

  toJson() => {
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

class UnreadablePushMessage implements ServerException {
  String message;

  UnreadablePushMessage([this.message = 'Unlesbare Push-Nachricht empfangen']);
}
