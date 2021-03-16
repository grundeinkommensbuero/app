import 'package:collection/collection.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/routes/ChatWindow.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

class ChatChannel {
  String? id;
  List<Message> channelMessages = List<Message>.empty(growable: true);

  ChannelChangeListener? ccl;

  ChatChannel(this.id);

  pushMessages(List<Message?> messages) {
    messages
        .where((message) => message != null && message is ChatMessage)
        .forEach((message) => pushChatMessage(message!));
    messages.where((message) => message is ParticipationMessage).forEach(
        (message) => pushParticipationMessage(message as ParticipationMessage));

    channelMessages.sort((a, b) => compareTimestamp(a.timestamp, b.timestamp));
    ccl?.channelChanged(this);
  ***REMOVED***

  pushChatMessage(Message message) {
    Message? ownMessage =
        channelMessages.firstWhereOrNull((e) => message.isMessageEqual(e));
    if (ownMessage == null)
      channelMessages.add(message);
    else
      ownMessage.obtainedFromServer = true;
  ***REMOVED***

  pushParticipationMessage(ParticipationMessage message) {
    if (channelMessages.any((m) => message.isMessageEqual(m))) return;
    channelMessages.add(message);
  ***REMOVED***

  void registerChannelChangeListener(ChannelChangeListener c) {
    if (ccl == null) {
      ccl = c;
    ***REMOVED*** else if (c != ccl) {
      ccl = c;
    ***REMOVED***
  ***REMOVED***

  void disposeListener() => ccl = null;

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'messages': this.channelMessages,
      ***REMOVED***

  ChatChannel.fromJSON(Map<dynamic, dynamic> json) {
    this.id = json['id'];
    channelMessages = json['messages'].map<Message>((jsonMsg) {
      var type = Message.determineType(jsonMsg);
      if (type == PushDataTypes.participationMessage)
        return ParticipationMessage.fromJson(jsonMsg);
      if (type == PushDataTypes.simpleChatMessage)
        return ChatMessage.fromJson(jsonMsg);
      ErrorService.handleError(
          throw UnkownMessageTypeError(
              'Unbekannter Nachrichtentyp abgespeichert'),
          StackTrace.current); // TODO
    ***REMOVED***).toList();
    this
        .channelMessages
        .sort((a, b) => compareTimestamp(a.timestamp, b.timestamp));
  ***REMOVED***
***REMOVED***

class UnkownMessageTypeError implements Exception {
  String message;

  UnkownMessageTypeError([this.message = ""]);
***REMOVED***
