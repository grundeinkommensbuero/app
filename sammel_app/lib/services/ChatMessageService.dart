import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ChatListWidget.dart';
import 'package:sammel_app/routes/ChatWindow.dart';
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

      // chat if chat window is open
      ChatListState cls = channel.ccl;
      if (cls == null || ModalRoute.of(cls.context)?.isActive == false) {
        // chat window is not open: push local message
        print('non active window');
        var notifier =
            Provider.of<LocalNotificationService>(navigatorKey.currentContext);
        if (json['type'] == PushDataTypes.SimpleChatMessage)
          notifier.sendChatNotification(ChatMessagePushData.fromJson(json));
        if (json['type'] == PushDataTypes.ParticipationMessage)
          notifier.sendParticipationNotification(
              ParticipationPushData.fromJson(json));
      }
    } on UnreadablePushMessage catch (e, s) {
      ErrorService.handleError(e, s);
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

      print('ChatMessageService: Pushe Nachricht: ${pushData[0].message.toJson()}');
      channel.pushMessages(messages);

      this.storage_service.saveChatChannel(channel);
      channels.add(channel);
    }
    return channels;
  }

  @override
  Future<void> handleNotificationTap(Map<dynamic, dynamic> data) async {
    print('handleNotificationTap mit Data: $data');
    final channel = await getChannel(ChatPushData.fromJson(data).channel);
    int termin_id = int.parse(channel.id.split(':')[1]);
    Provider.of<AbstractTermineService>(navigatorKey.currentContext)
        .getActionWithDetails(termin_id)
        .then((value) => navigatorKey.currentState.push(MaterialPageRoute(
            builder: (context) => ChatWindow(channel, value))));
  }

  void create_or_recreat_chat_page(ChatListState cls, ChatChannel channel) {
    if (cls == null || ModalRoute.of(cls?.context)?.isActive == false) {
      if (cls != null) {
        Navigator.pop(cls.context);
      }
      int termin_id = int.parse(channel.id.split(':')[1]);
      Future<Termin> termin =
          Provider.of<AbstractTermineService>(navigatorKey.currentContext)
              .getActionWithDetails(termin_id);
      termin.then((value) => navigatorKey.currentState.push(
          MaterialPageRoute(builder: (context) => ChatWindow(channel, value))));
    }
  }

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

  void register_channel(ChatChannel channel) {
    channels[channel.id] = channel;
  }

  Future<void> reload() async {
    await storage_service.reload();
    channels.keys.toList().forEach((id) async {
      var currentChannel = await storage_service.loadChatChannel(id);
      if (channels[id].channel_messages.length !=
          currentChannel.channel_messages.length) {
        channels[id].channel_messages = currentChannel.channel_messages;
        channels[id].ccl?.channelChanged(channels[id]);
      }
    });
  }

  @override
  updateMessages(List<Map<String, dynamic>> messages) =>
      storeMessages(messages.map((m) => chatPushDataFromJson(m)).toList());
}

handleBackgroundChatMessage(ChatPushData data) async {
  ChatChannel channel = await StorageService().loadChatChannel(data.channel);
  if (channel == null) channel = ChatChannel(data.channel);
  channel.pushMessages([data.message]);
  StorageService().saveChatChannel(channel);
}
