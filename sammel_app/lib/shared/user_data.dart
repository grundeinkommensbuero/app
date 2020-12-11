import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/shared/ChatWindow.dart';

abstract class Channel {
  String id;
  List<Message> channel_messages;
  List<String> member_names;

  Channel(this.id, {this.channel_messages, this.member_names***REMOVED***);

  getAllMessages() {
    return channel_messages;
  ***REMOVED***

  List<String> get_member_names() {
    return member_names;
  ***REMOVED***
***REMOVED***

class ActionChannel extends Channel {
  ChannelChangeListener ccl;

  ActionChannel(int id) : super('action:$id') {
    this.channel_messages = List<Message>();
  ***REMOVED***

  @override
  Future<void> pushChatMessage(ChatMessage message) {
    add_message_or_mark_as_received(message);
    channel_messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    ccl?.channelChanged(this);
  ***REMOVED***

  @override
  Future<void> pushParticipationMessage(ParticipationMessage message) {
    channel_messages.add(message);

    ccl?.channelChanged(this);
  ***REMOVED***

  void add_message_or_mark_as_received(ChatMessage message) {
    ChatMessage ownMessage = channel_messages
        .firstWhere((e) => message.isMessageEqual(e), orElse: () => null);
    if (ownMessage == null)
      channel_messages.add(message);
    else
      ownMessage.obtained_from_server = true;
  ***REMOVED***

  //FIXME wozu brauchen wir das?
  void restore_channel(ActionChannel channel) {
    if (channel == null) {
      return;
    ***REMOVED***

    for (Message message in channel.channel_messages) {
      add_message_or_mark_as_received(message);
    ***REMOVED***

    channel_messages.sort((a, b) => a.timestamp.isBefore(b.timestamp) ? -1 : 1);

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
        'messages': this.channel_messages != null ? this.channel_messages : []
      ***REMOVED***

  ActionChannel.fromJSON(Map<dynamic, dynamic> json)
      : super(json['id'],
            channel_messages: json['messages'].map<Message>((jsonMsg) {
              var type = Message.determineType(jsonMsg);
              if (type == PushDataTypes.ParticipationMessage)
                return ParticipationMessage.fromJson(jsonMsg);
              if (type == PushDataTypes.SimpleChatMessage)
                return ChatMessage.fromJson(jsonMsg);
              ErrorService.handleError(
                  throw UnkownMessageTypeError(
                      "Unbekannter Nachrichtentyp abgespeichert"),
                  StackTrace.current);
            ***REMOVED***).toList(),
            member_names: json['member_names'].cast<String>().toList()) {
    this
        .channel_messages
        ?.sort((a, b) => a.timestamp.isBefore(b.timestamp) ? -1 : 1);
  ***REMOVED***
***REMOVED***

class UnkownMessageTypeError implements Exception {
  String message;

  UnkownMessageTypeError([this.message = ""]);
***REMOVED***
