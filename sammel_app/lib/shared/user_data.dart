import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/shared/ChatWindow.dart';

abstract class Channel {
  String id;
  List<Message> channel_messages;
  List<String> member_names;

  Channel(this.id, {this.channel_messages, this.member_names***REMOVED***);

  Future<void> channelCallback(Message message);

  getAllMessages() {
    return channel_messages;
  ***REMOVED***

  List<String> get_member_names() {
    return member_names;
  ***REMOVED***
***REMOVED***

class SimpleMessageChannel extends Channel {
  ChannelChangeListener ccl;

  SimpleMessageChannel(String id) : super(id) {
    this.channel_messages = List<Message>();
  ***REMOVED***

  @override
  Future<void> channelCallback(Message message) {
    // TODO: implement channelCallback

    add_message_or_mark_as_received(message);
    channel_messages.sort((a, b) => a.sending_time.compareTo(b.sending_time));

    ccl?.channelChanged(this);
  ***REMOVED***

  void add_message_or_mark_as_received(Message message) {
    Message ownMessage = channel_messages
        .firstWhere((e) => message.isMessageEqual(e), orElse: () => null);
    if (ownMessage == null)
      channel_messages.add(message);
    else
      ownMessage.obtained_from_server = true;
  ***REMOVED***

  void restore_channel(SimpleMessageChannel channel) {
    if (channel == null) {
      return;
    ***REMOVED***

    for (Message message in channel.channel_messages) {
      add_message_or_mark_as_received(message);
    ***REMOVED***

    channel_messages
        .sort((a, b) => a.sending_time.isBefore(b.sending_time) ? -1 : 1);

    ccl?.channelChanged(this);
  ***REMOVED***

  void register_widget(ChannelChangeListener c) {
    if (ccl == null)
      ccl = c;
    else
      print('The Channel is already associated to a widget');
  ***REMOVED***

  void dispose_widget() {
    ccl = null;
  ***REMOVED***

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'member_names': this.member_names != null ? this.member_names : [''],
        'messages': this.channel_messages != null
            ? this.channel_messages.map((e) => e.toJson()).toList()
            : []
      ***REMOVED***

  SimpleMessageChannel.fromJSON(Map<dynamic, dynamic> json)
      : super(json['id'],
            channel_messages: json['messages']
                .map<Message>((e) => Message.fromJSON(e))
                .toList(),
            member_names: json['member_names'].cast<String>().toList()) {
    this
        .channel_messages
        ?.sort((a, b) => a.sending_time.isBefore(b.sending_time) ? -1 : 1);
  ***REMOVED***
***REMOVED***
