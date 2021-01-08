import 'package:flutter/widgets.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/routes/ChatListWidget.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/routes/ChatWindow.dart';

class ChatChannel {
  String id;
  List<Message> channel_messages;

  ChannelChangeListener ccl;

  ChatChannel(this.id) {
    this.channel_messages = List<Message>();
  }

  getAllMessages() {
    return channel_messages;
  }

  @override
  Future<void> pushChatMessage(ChatMessage message) {
    add_message_or_mark_as_received(message);
    channel_messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    ccl?.channelChanged(this);
  }

  @override
  Future<void> pushParticipationMessage(ParticipationMessage message) {
    channel_messages.add(message);
    ccl?.channelChanged(this);
  }

  void add_message_or_mark_as_received(ChatMessage message) {
    ChatMessage ownMessage = channel_messages
        .firstWhere((e) => message.isMessageEqual(e), orElse: () => null);
    if (ownMessage == null)
      channel_messages.add(message);
    else
      ownMessage.obtained_from_server = true;
  }

  void register_channel_change_listener(ChannelChangeListener c) {
    if (ccl == null)
      ccl = c;
    else if(c != ccl)
      {
        print('The Channel is already associated to a widget');
        ChatListState cls = ccl;
        Navigator.pop(cls.context);
        ccl = c;
      }
  }

  void dispose_widget() {
    ccl = null;
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'messages': this.channel_messages != null ? this.channel_messages : []
      };

  ChatChannel.fromJSON(Map<dynamic, dynamic> json) {
    this.id = json['id'];
    channel_messages = json['messages'].map<Message>((jsonMsg) {
      var type = Message.determineType(jsonMsg);
      if (type == PushDataTypes.ParticipationMessage)
        return ParticipationMessage.fromJson(jsonMsg);
      if (type == PushDataTypes.SimpleChatMessage)
        return ChatMessage.fromJson(jsonMsg);
      ErrorService.handleError(
          throw UnkownMessageTypeError(
              'Unbekannter Nachrichtentyp abgespeichert'),
          StackTrace.current);
    }).toList();
    this.channel_messages?.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }
}

class UnkownMessageTypeError implements Exception {
  String message;

  UnkownMessageTypeError([this.message = ""]);
}
