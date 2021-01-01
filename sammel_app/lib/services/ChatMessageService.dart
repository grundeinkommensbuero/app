import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ChatListWidget.dart';
import 'package:sammel_app/routes/ChatWindow.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';

import '../main.dart';
import 'LocalNotificationService.dart';

class ChatMessageService implements PushNotificationListener {
  ChatMessageService(
      StorageService storageService, AbstractPushNotificationManager manager) {
    manager.register_message_callback(PushDataTypes.SimpleChatMessage, this);
    manager.register_message_callback(PushDataTypes.ParticipationMessage, this);
    this.storage_service = storageService;
  ***REMOVED***

  Map<String, ChatChannel> channels = Map<String, ChatChannel>();
  StorageService storage_service;


  @override
  Future<void> receive_message(Map<dynamic, dynamic> data, NotificationType notificationType) async {
    try {
      ChatPushData mpd = ChatPushData.fromJson(data);
      ChatChannel channel = await getChannel(mpd.channel);
      if (channel != null) {
        if (data['type'] == PushDataTypes.SimpleChatMessage)
          channel.pushChatMessage(ChatMessage.fromJson(data));
        if (data['type'] == PushDataTypes.ParticipationMessage)
          channel.pushParticipationMessage(ParticipationMessage.fromJson(data));
        this.storage_service.saveChatChannel(channel);
        if (notificationType == NotificationType.DEFAULT)
          {
            //app is open. chat if chat window is open
            ChatListState cls = channel.ccl;
            if (cls == null || ModalRoute.of(cls.context)?.isActive == false)
              {
                //chat window is not opened. push local message
                print('non active window');
                Provider.of<LocalNotificationService>(navigatorKey.currentContext).sendChatNotification(ChatMessagePushData.fromJson(data));
              ***REMOVED***

          ***REMOVED***
        else if (notificationType == NotificationType.RESUME)
          {
            //we need to put the message channel in the foreground
            ChatListState cls = channel.ccl;

            create_or_recreat_chat_page(cls, channel);
          ***REMOVED***
        else if  (notificationType == NotificationType.LOCAL_MESSAGE)
          {
            receive_message(data, NotificationType.RESUME);
          ***REMOVED***
      ***REMOVED***
    ***REMOVED*** on UnreadablePushMessage catch (e, s) {
      ErrorService.handleError(e, s);
    ***REMOVED***
  ***REMOVED***

  void create_or_recreat_chat_page(ChatListState cls, ChatChannel channel) {
    if (cls == null || ModalRoute.of(cls?.context)?.isActive == false)
      {
        if (cls != null) {
          Navigator.pop(cls.context);
        ***REMOVED***
        int termin_id = int.parse(channel.id.split(':')[1]);
        Future<Termin> termin = Provider.of<AbstractTermineService>(navigatorKey.currentContext).getActionWithDetails(termin_id);
        termin.then((value) =>  navigatorKey.currentState.push( MaterialPageRoute(
            builder: (context) => ChatWindow(channel, value))));
      ***REMOVED***
  ***REMOVED***

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
      ***REMOVED***
    ***REMOVED***
    return channels[id];
  ***REMOVED***

  void createChannel(String id) {
    var newChannel = ChatChannel(id);
    this.storage_service.saveChatChannel(newChannel);
    channels[newChannel.id] = newChannel;
  ***REMOVED***

  void register_channel(ChatChannel channel) {
    channels[channel.id] = channel;
  ***REMOVED***

  Future<void> reload() async {
    await storage_service.reload();
    channels.keys.toList().forEach((id) async {
      var currentChannel = await storage_service.loadChatChannel(id);
      if (channels[id].channel_messages.length !=
          currentChannel.channel_messages.length) {
        channels[id].channel_messages = currentChannel.channel_messages;
        channels[id].ccl?.channelChanged(channels[id]);
      ***REMOVED***
    ***REMOVED***);
  ***REMOVED***
***REMOVED***
