
import 'package:cloud_firestore/cloud_firestore.dart';

class Message
{
  String text = null;
  String sender_name = null;
  Timestamp sending_time = null;
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
  Map channel = new Map();

  bool isSubscribedToChannel(String name) {
    return channel.containsKey(name);
  }
}