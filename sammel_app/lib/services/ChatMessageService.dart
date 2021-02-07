import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/routes/ChatWindow.dart';
import 'package:sammel_app/routes/TopicChatWindow.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';

import 'LocalNotificationService.dart';

class ChatMessageService implements PushNotificationListener {
  GlobalKey<NavigatorState> navigatorKey;

  ChatMessageService(StorageService storageService,
      AbstractPushNotificationManager manager, this.navigatorKey) {
    manager.register_message_callback(PushDataTypes.SimpleChatMessage, this);
    manager.register_message_callback(PushDataTypes.ParticipationMessage, this);
    manager.register_message_callback(PushDataTypes.TopicChatMessage, this);
    this.storage_service = storageService;
  }

  Map<String, ChatChannel> channels = Map<String, ChatChannel>();
  StorageService storage_service;

  @override
  receive_message(Map<String, dynamic> json) async {
    try {
      var pushData = chatPushDataFromJson(json);
      ChatChannel channel = await storeMessage(pushData);
      if (channel == null) return;

      // check if chat window is open
      State<StatefulWidget> cls = channel.ccl as State<StatefulWidget>;
      if (cls == null || ModalRoute.of(cls.context)?.isActive == false) {
        // chat window is not open: push local message
        var notifier =
            Provider.of<LocalNotificationService>(navigatorKey.currentContext);
        if (json['type'] == PushDataTypes.SimpleChatMessage)
          notifier.sendChatNotification(ActionChatMessagePushData.fromJson(json));
        if (json['type'] == PushDataTypes.ParticipationMessage)
          notifier.sendParticipationNotification(
              ParticipationPushData.fromJson(json));
        if (json['type'] == PushDataTypes.TopicChatMessage) {
          notifier.sendTopicChatNotification(
              TopicChatMessagePushData.fromJson(json));
        }
      }
    } on UnreadablePushMessage catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Fehler beim Empfang von Push-Nachricht');
    }
  }

  Future<ChatChannel> storeMessage(ChatPushData pushData) async =>
      storeMessages([pushData]).then((list) => list.first);

  Future<List<ChatChannel>> storeMessages(List<ChatPushData> pushData) async {
    final channelIds = pushData.map((data) => data.channel).toSet();
    List<ChatChannel> channels = [];
    for (var channelId in channelIds) {
      ChatChannel channel = await getChannel(channelId);
      final messages = pushData
          .where((data) => data.channel == channelId)
          .map((data) => data.message)
          .toList();

      channel.pushMessages(messages);

      this.storage_service.saveChatChannel(channel);
      channels.add(channel);
    }
    return channels;
  }

  @override
  Future<void> handleNotificationTap(Map<dynamic, dynamic> data) async {
    if (Message.determineType(data) == PushDataTypes.TopicChatMessage) {
      var chat_push_data = TopicChatMessagePushData.fromJson(data);
      final channel = await getChannel(chat_push_data.channel);
      State<StatefulWidget> cls = channel.ccl as State<StatefulWidget>;
      create_or_recreate_topic_chat_page(cls, channel);
    } else if (Message.determineType(data) == PushDataTypes.SimpleChatMessage) {
      var chat_push_data = ActionChatMessagePushData.fromJson(data);
      final channel = await getChannel(chat_push_data.channel);
      State<StatefulWidget> cls = channel.ccl as State<StatefulWidget>;
      create_or_recreat_chat_page(cls, channel, chat_push_data.action);
    } else if (Message.determineType(data) == PushDataTypes.ParticipationMessage) {
      var participation_push_data = ParticipationPushData.fromJson(data);
      final channel = await getChannel(participation_push_data.channel);
      State<StatefulWidget> cls = channel.ccl as State<StatefulWidget>;
      create_or_recreat_chat_page(cls, channel, participation_push_data.action);
    }
  }

  void create_or_recreat_chat_page(
      State<StatefulWidget> cls, ChatChannel channel, int termin_id) {
    if (cls == null || ModalRoute.of(cls?.context)?.isActive == false) {
      if (cls != null) {
        Navigator.pop(cls.context);
      }
      Provider.of<AbstractTermineService>(navigatorKey.currentContext)
          .getActionWithDetails(termin_id)
          .then((value) => navigatorKey.currentState.push(MaterialPageRoute(
              builder: (context) => ChatWindow(channel, value, true))));
    }
  }

  void create_or_recreate_topic_chat_page(
      State<StatefulWidget> cls, ChatChannel channel) {
    if (cls == null || ModalRoute.of(cls?.context)?.isActive == false) {
      if (cls != null) {
        Navigator.pop(cls.context);
      }
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) => TopicChatWindow(channel, true)));
    }
  }

  Future<ChatChannel> getTopicChannel(String topic) async =>
      await getChannel('topic:$topic');

  Future<ChatChannel> getActionChannel(int idNr) async =>
      await getChannel('action:$idNr');

  Future<ChatChannel> getChannel(String id) async {
    if (channels.containsKey(id)) return channels[id];

    ChatChannel channel = await this.storage_service.loadChatChannel(id);

    if (channel == null) {
      channel = ChatChannel(id);
      await this.storage_service.saveChatChannel(channel);
    }
    channels[channel.id] = channel;
    return channel;
  }

  void createChannel(String id) {
    var newChannel = ChatChannel(id);
    this.storage_service.saveChatChannel(newChannel);
    channels[newChannel.id] = newChannel;
  }

  @override
  updateMessages(List<Map<String, dynamic>> messages) =>
      storeMessages(messages.map((m) => chatPushDataFromJson(m)).toList());
}
