import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ChatWindow.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';

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
  Future<void> receive_message(
      Map<dynamic, dynamic> data, NotificationType notificationType) async {
    try {
      ChatPushData mpd = ChatPushData.fromJson(data);
      ChatChannel channel = await getChannel(mpd.channel);
      if (channel != null) {
        if (data['type'] == PushDataTypes.SimpleChatMessage)
          channel.pushChatMessage(ChatMessage.fromJson(data));
        if (data['type'] == PushDataTypes.ParticipationMessage)
          channel.pushParticipationMessage(ParticipationMessage.fromJson(data));
        this.storage_service.saveChatChannel(channel);
        if (notificationType == NotificationType.RESUME) {
          //we need to put the message channel in the foreground

          int termin_id = int.parse(channel.id.split(':')[1]);
          Future<Termin> termin =
              Provider.of<AbstractTermineService>(navigatorKey.currentContext)
                  .getActionWithDetails(termin_id);
          termin.then((value) => navigatorKey.currentState.push(
              MaterialPageRoute(
                  builder: (context) => ChatWindow(channel, value))));
        }
      }
    } on UnreadablePushMessage catch (e, s) {
      ErrorService.handleError(e, s);
    }
  }

  Future<ChatChannel> getChatChannel(int idNr) async =>
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
      var currentChannel = await storage_service.loadChatChannel(id);
      if (channels[id].channel_messages.length !=
          currentChannel.channel_messages.length) {
        channels[id].channel_messages = currentChannel.channel_messages;
        channels[id].ccl?.channelChanged(channels[id]);
      }
    });
  }
}
