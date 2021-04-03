import 'package:collection/collection.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/routes/ChatWindow.dart';
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
  }

  pushChatMessage(Message message) {
    Message? ownMessage =
        channelMessages.firstWhereOrNull((e) => message.isMessageEqual(e));
    if (ownMessage == null)
      channelMessages.add(message);
    else
      ownMessage.obtainedFromServer = true;
  }

  pushParticipationMessage(ParticipationMessage message) {
    if (channelMessages.any((m) => message.isMessageEqual(m))) return;
    channelMessages.add(message);
  }

  void registerChannelChangeListener(ChannelChangeListener c) {
    if (ccl == null) {
      ccl = c;
    } else if (c != ccl) {
      ccl = c;
    }
  }

  void disposeListener() => ccl = null;

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'messages': this.channelMessages,
      };

  ChatChannel.fromJSON(Map<dynamic, dynamic> json) {
    this.id = json['id'];
    channelMessages = json['messages'].map<Message>((jsonMsg) {
      var type = Message.determineType(jsonMsg);
      if (type == PushDataTypes.participationMessage)
        return ParticipationMessage.fromJson(jsonMsg);
      if (type == PushDataTypes.simpleChatMessage)
        return ChatMessage.fromJson(jsonMsg);
      throw UnkownMessageTypeError('Unbekannter Nachrichtentyp abgespeichert');
    }).toList();
    this
        .channelMessages
        .sort((a, b) => compareTimestamp(a.timestamp, b.timestamp));
  }
}

class UnkownMessageTypeError implements Exception {
  String message;

  UnkownMessageTypeError([this.message = ""]);
}
