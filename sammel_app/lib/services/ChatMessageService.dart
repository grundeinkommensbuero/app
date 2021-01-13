import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ChatListWidget.dart';
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
  receive_message(Map<String, dynamic> data) async {
    try {
      print("receive_message called $data");
      ChatChannel channel = await storeMessage(data);
      if (channel == null) return;

      // check if chat window is open
      State<StatefulWidget> cls = channel.ccl as State<StatefulWidget>;
      if (cls == null || ModalRoute.of(cls.context)?.isActive == false) {
        // chat window is not open: push local message
        print('non active window');
        var notifier =
            Provider.of<LocalNotificationService>(navigatorKey.currentContext);
        if (data['type'] == PushDataTypes.SimpleChatMessage)
          notifier.sendChatNotification(ChatMessagePushData.fromJson(data));
        if (data['type'] == PushDataTypes.TopicChatMessage) {
          print('topicchatmessage ${TopicChatMessagePushData.fromJson(data)}');
          notifier.sendTopicChatNotification(
              TopicChatMessagePushData.fromJson(data));
        }
        if (data['type'] == PushDataTypes.ParticipationMessage)
          notifier.sendChatNotification(
              ChatMessagePushData.fromJson(data));
      }
    } on UnreadablePushMessage catch (e, s) {
      ErrorService.handleError(e, s);
    }
  }

  Future<ChatChannel> storeMessage(Map<String, dynamic> data) async {
    ChatPushData mpd = ChatPushData.fromJson(data);
    ChatChannel channel = await getChannel(mpd.channel);
    if (channel == null) return null;

    if (data['type'] == PushDataTypes.SimpleChatMessage)
      channel.pushChatMessage(ChatMessage.fromJson(data));
    if (data['type'] == PushDataTypes.ParticipationMessage)
      channel.pushParticipationMessage(ParticipationMessage.fromJson(data));
    if (data['type'] == PushDataTypes.TopicChatMessage) {
      print("pushing msg to topic channel");
      channel.pushChatMessage(TopicChatMessage.fromJson(data));

    }
    this.storage_service.saveChatChannel(channel);
    return channel;
  }

  @override
  Future<void> handleNotificationTap(Map<dynamic, dynamic> data) async {
    print('handleNotificationTap mit Data: $data');
    var chat_push_data = ChatPushData.fromJson(data);
    final channel = await getChannel(chat_push_data.channel);
    State<StatefulWidget> cls = channel.ccl as State<StatefulWidget>;
    if(Message.determineType(data) == PushDataTypes.TopicChatMessage)
      {
        print("create or recreate topic chat channel");
        create_or_recreate_topic_chat_page(cls, channel);
      }else if(Message.determineType(data) == PushDataTypes.SimpleChatMessage)
        {
          ChatMessage msg = chat_push_data.message as ChatMessage;
          create_or_recreat_chat_page(cls, channel, msg.termin_id);
        }
  }

  void create_or_recreat_chat_page(State<StatefulWidget> cls, ChatChannel channel, int termin_id) {
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


  void create_or_recreate_topic_chat_page(State<StatefulWidget> cls, ChatChannel channel) {
    //print("is active ${ModalRoute.of(cls?.context)?.settings.name}");
    if (cls == null || ModalRoute.of(cls?.context)?.isActive == false ) {
      if (cls != null) {
        Navigator.pop(cls.context);
      }
      print("pushing new topic window");
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) => TopicChatWindow(channel, true)));
    }
  }


  Future<ChatChannel> getActionChannel(int idNr) async =>
      await getChannel('action:$idNr');

  Future<ChatChannel> getChannel(String id) async {
    if (!channels.containsKey(id)) {
      ChatChannel storedChannel =
          await this.storage_service.loadChatChannel(id);
      if (storedChannel != null)
        channels[id] = storedChannel;
      else {
        final newChannel = ChatChannel(id);
        await this.storage_service.saveChatChannel(newChannel);
        channels[newChannel.id] = newChannel;
      }
    }
    return channels[id];
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
      print("reloading channels");
      ChatChannel currentChannel = null;
      if(channels[id] is TopicChatChannel) {
        currentChannel = await storage_service.loadTopicChatChannel(id);
      }
      else
        {
          currentChannel = await storage_service.loadChatChannel(id);
        }
      if (channels[id].channel_messages.length !=
          currentChannel.channel_messages.length) {
        channels[id].channel_messages = currentChannel.channel_messages;
        channels[id].ccl?.channelChanged(channels[id]);
      }
    });
  }

  Future<TopicChatChannel> getTopicChannel(String id) async{
    if (!channels.containsKey(id)) {
      ChatChannel storedChannel =
          await this.storage_service.loadTopicChatChannel(id);
      if (storedChannel != null)
        channels[id] = storedChannel;
      else {
        final newChannel = TopicChatChannel(id);
        await this.storage_service.saveChatChannel(newChannel);
        channels[newChannel.id] = newChannel;
      }
    }
    return channels[id];
  }
  }

handleBackgroundChatMessage(ChatPushData data) async {
  var storageService = StorageService();
  ChatChannel channel = await storageService.loadChatChannel(data.channel) ??
      ChatChannel(data.channel);

  if (data.type == PushDataTypes.SimpleChatMessage)
    channel.pushChatMessage(data.message);
  if (data.type == PushDataTypes.ParticipationMessage)
    channel.pushParticipationMessage(data.message);
  storageService.saveChatChannel(channel);
}
