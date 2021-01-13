import 'dart:ui';

import 'package:sammel_app/model/PushMessage.dart';

abstract class Message {
  String type;
  bool obtained_from_server = false;
  DateTime timestamp;

  Message.fromJson();

  static String determineType(Map<String, dynamic> data) =>
      data['type'] ?? null;

  Map<String, dynamic> toJson();

  bool isMessageEqual(Message msg);
}

class ChatMessage implements Message {
  @override
  String type = PushDataTypes.SimpleChatMessage;
  @override
  bool obtained_from_server;
  @override
  DateTime timestamp;
  String text;
  String sender_name;
  Color message_color;
  int user_id = -1;
  int termin_id = -1;

  ChatMessage(
      {this.text,
      this.sender_name,
      this.timestamp,
      this.message_color,
      this.obtained_from_server = false,
      this.user_id,
      this.termin_id});

  @override
  ChatMessage.fromJson(Map<dynamic, dynamic> json_message_data) {
    text = json_message_data['text'];
    sender_name = json_message_data['sender_name'];
    timestamp = DateTime.parse(json_message_data['timestamp']);
    message_color = Color(int.parse(json_message_data['color'].toString()));
    obtained_from_server = json_message_data['from_server'];
    user_id = int.parse(json_message_data['user_id'].toString());
    termin_id = int.parse(json_message_data['termin_id']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'text': text,
        'sender_name': sender_name,
        'user_id': user_id,
        'timestamp': timestamp.toString(),
        'color': message_color.value,
        'from_server': obtained_from_server,
        'termin_id': termin_id.toString()
      };

  @override
  bool isMessageEqual(Message msg) {
    return msg is ChatMessage &&
        msg.text == text &&
        msg.sender_name == msg.sender_name &&
        timestamp.isAtSameMomentAs(msg.timestamp) &&
        message_color.value == msg.message_color.value &&
        user_id == msg.user_id;
    // &&
       // obtained_from_server == msg.obtained_from_server;
  }
}

class ParticipationMessage implements Message {
  @override
  String type = PushDataTypes.ParticipationMessage;
  @override
  bool obtained_from_server;
  @override
  DateTime timestamp;
  String username;
  bool joins;

  ParticipationMessage(
      this.obtained_from_server, this.timestamp, this.username, this.joins);

  ParticipationMessage.fromJson(Map<dynamic, dynamic> json) {
    obtained_from_server = json['obtained_from_server'];
    timestamp =
        json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null;
    username = json['username'];
    joins = json['joins'];

    assert(timestamp != null, 'Zeistempel fehlt');
    assert(joins != null, 'joins fehlt');
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'obtained_from_server': obtained_from_server,
        'timestamp': timestamp != null ? timestamp.toString() : null,
        'username': username,
        'joins': joins
      };

  @override
  bool isMessageEqual(Message msg) {
    return msg is ParticipationMessage &&
        type == msg.type &&
        timestamp.isAtSameMomentAs(msg.timestamp) &&
        username == msg.username &&
        joins == msg.joins;
  }
}


class TopicChatMessage implements Message {
  @override
  String type = PushDataTypes.TopicChatMessage;
  @override
  DateTime timestamp;
  String text;
  String sender_name;
  Color message_color;
  @override
  bool obtained_from_server;

  TopicChatMessage(
      {this.text,
        this.sender_name,
        this.timestamp,
        this.message_color,
        this.obtained_from_server=true});

  @override
  TopicChatMessage.fromJson(Map<dynamic, dynamic> json_message_data) {
    text = json_message_data['text'];
    sender_name = json_message_data['sender_name'];
    timestamp = DateTime.parse(json_message_data['timestamp']);
    message_color = Color(int.parse(json_message_data['color'].toString()));
    obtained_from_server = json_message_data['from_server'] ?? true;
  }

  @override
  Map<String, dynamic> toJson()
  {
    print("obtained from server $obtained_from_server");
    return {
    'type': type,
    'text': text,
    'sender_name': sender_name,
    'timestamp': timestamp.toString(),
    'color': message_color.value,
    'from_server': obtained_from_server};
  }

  @override
  bool isMessageEqual(Message msg) {
    return msg is TopicChatMessage &&
        msg.text == text &&
        msg.sender_name == msg.sender_name &&
        timestamp.isAtSameMomentAs(msg.timestamp) &&
        message_color.value == msg.message_color.value;
  }
}