
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

class Message
{
  String text = null;
  String sender_name = null;
  DateTime sending_time = null;
  Color message_color = null;

  Message({this.text, this.sender_name, this.sending_time, this.message_color});

  Message.fromJSON(Map<dynamic, dynamic> json_message_data)
  {
    text = json_message_data['text'];
    sender_name = json_message_data['sender_name'];
    sending_time = json_message_data['sending_time'];
    message_color = json_message_data['color'];
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'sender_name': sender_name,
    'sending_time': sending_time.toString(),
    'color': message_color.toString()
  };
}

abstract class Channel
{
  String name = null;
  List<Message> channel_messages = null;
  List<String> member_names = null;

  Channel(this.name, {this.channel_messages, this.member_names});

  void channelCallback(Message message);

  getAllMessages() {
    return channel_messages;
  }

  List<String> get_member_names() {
    return member_names;
  }
}

class SimpleMessageChannel extends Channel
{
  SimpleMessageChannel(String name) : super(name);

  @override
  void channelCallback(Message message) {
    // TODO: implement channelCallback
      channel_messages.add(message);
  }
}

class User
{
  String nick_name = null;
  String user_id = null;
  Color user_color = null;

  User(this.nick_name, this.user_id, this.user_color);


  User.fromJSON(Map<dynamic, dynamic> json) {
    this.nick_name = json['nick_name'];
    this.user_id = json['user_id'];
    this.user_color = Color(json['user_color']);
  }

  Map<String, dynamic> toJson() => {
    'nick_name': nick_name,
    'user_id': user_id,
    'user_color': user_color.value,
  };
}