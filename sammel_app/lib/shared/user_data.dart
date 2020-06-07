
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

class Message
{
  String text = null;
  String sender_name = null;
  Timestamp sending_time = null;
  Color message_color = null;
}

abstract class Channel
{
  String name = null;
  List<Message> channel_messages = null;
  List<String> member_names = null;
  void channelCallback(Map<String, dynamic> message);

  getAllMessages() {
    return channel_messages;
  }

  List<String> get_member_names() {
    return member_names;
  }
}

class User
{
  String nick_name = null;
  String user_id = null;
  Color user_color = null;


  User.fromJSON(Map<dynamic, dynamic> json) {
    this.nick_name = json['nick_name'];
    this.user_id = json['user_id'];
    this.user_color = json['user_color'];
  }

  Map<String, dynamic> toJson() => {
    'nick_name': nick_name,
    'user_id': user_id,
    'user_color': user_color.toString(),
  };
}