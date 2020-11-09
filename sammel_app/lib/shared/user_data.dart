
import 'dart:convert';

import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/shared/ChatWindow.dart';

abstract class Channel
{
  String id;
  List<Message> channel_messages;
  List<String> member_names;

  Channel(this.id, {channel_messages, member_names}) : channel_messages = channel_messages, member_names = member_names
  {}

  Future<void> channelCallback(Message message);

  getAllMessages() {
    return channel_messages;
  }

  List<String> get_member_names() {
    return member_names;
  }
}

class SimpleMessageChannel extends Channel
{

  ChannelChangeListener ccl;

  SimpleMessageChannel(String id) : super(id){
    this.channel_messages = List<Message>();
  }

  @override
  Future<void> channelCallback(Message message) {
    // TODO: implement channelCallback

      add_message_or_mark_as_received(message);
      channel_messages.sort((a,b) => a.sending_time.isBefore(b.sending_time) ? -1 : 1);

      ccl?.channelChanged(this);
  }

  void add_message_or_mark_as_received(Message message) {
    List<Message> contains_message = channel_messages.map((e) => message.isMessageEqual(e) ? e : null).where((element) => element != null).toList();
    if(contains_message.isEmpty) {
      channel_messages.add(message);
    }
    else{
      contains_message[0].obtained_from_server = true;
    }
  }

  void restore_channel(SimpleMessageChannel channel)
  {
    if(channel == null)
      {
        return;
      }

    for(Message message in channel.channel_messages)
      {
        add_message_or_mark_as_received(message);
      }

    channel_messages.sort((a,b) => a.sending_time.isBefore(b.sending_time) ? -1 : 1);

    ccl?.channelChanged(this);

  }

  void register_widget(ChannelChangeListener c)
  {
    if(ccl == null)
      {
        ccl = c;
      }
    else
      {
        print('The Channel is already associated to a widget');
      }
  }

  void dispose_widget()
  {
    ccl = null;
  }

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'member_names': this.member_names != null ? this.member_names : [''],
    'messages': this.channel_messages != null ? this.channel_messages.map((e) => e.toJson()).toList() : []
  };

  SimpleMessageChannel.fromJSON(Map<dynamic, dynamic> json) : super(json['id'],
              channel_messages: json['messages'].map<Message>((e) => Message.fromJSON(e)).toList() ,
      member_names: json['member_names'].cast<String>().toList())
  {
      this.channel_messages?.sort((a,b) => a.sending_time.isBefore(b.sending_time) ? -1 : 1);
  }

}