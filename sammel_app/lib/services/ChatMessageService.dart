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
  ***REMOVED***

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
        print('non active window');
        var notifier =
            Provider.of<LocalNotificationService>(navigatorKey.currentContext);
        if (json['type'] == PushDataTypes.SimpleChatMessage)
          notifier.sendChatNotification(ChatMessagePushData.fromJson(json));
        if (json['type'] == PushDataTypes.ParticipationMessage)
          notifier.sendParticipationNotification(
              ParticipationPushData.fromJson(json));
        if (json['type'] == PushDataTypes.TopicChatMessage) {
          print('topicchatmessage ${TopicChatMessagePushData.fromJson(json)***REMOVED***');
          notifier.sendTopicChatNotification(
              TopicChatMessagePushData.fromJson(json));
        ***REMOVED***

      ***REMOVED***
    ***REMOVED*** on UnreadablePushMessage catch (e, s) {
      ErrorService.handleError(e, s);
    ***REMOVED***
  ***REMOVED***

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
    ***REMOVED***
    return channels;
  ***REMOVED***

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
      ***REMOVED***else if(Message.determineType(data) == PushDataTypes.SimpleChatMessage)
        {
          ChatMessage msg = chat_push_data.message as ChatMessage;
          create_or_recreat_chat_page(cls, channel, msg.termin_id);
        ***REMOVED***
  ***REMOVED***

  void create_or_recreat_chat_page(State<StatefulWidget> cls, ChatChannel channel, int termin_id) {
    if (cls == null || ModalRoute.of(cls?.context)?.isActive == false) {
      if (cls != null) {
        Navigator.pop(cls.context);
      ***REMOVED***
      Provider.of<AbstractTermineService>(navigatorKey.currentContext)
          .getActionWithDetails(termin_id)
          .then((value) => navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) => ChatWindow(channel, value, true))));
    ***REMOVED***
  ***REMOVED***


  void create_or_recreate_topic_chat_page(State<StatefulWidget> cls, ChatChannel channel) {
    if (cls == null || ModalRoute.of(cls?.context)?.isActive == false ) {
      if (cls != null) {
        Navigator.pop(cls.context);
      ***REMOVED***
      print("pushing new topic window");
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) => TopicChatWindow(channel, true)));
    ***REMOVED***
  ***REMOVED***


  Future<ChatChannel> getActionChannel(int idNr) async =>
      await getChannel('action:$idNr');

  Future<ChatChannel> getChannel(String id) async {
    if (channels.containsKey(id)) return channels[id];

    ChatChannel channel = await this.storage_service.loadChatChannel(id);

    if (channel == null) {
      channel = ChatChannel(id);
      await this.storage_service.saveChatChannel(channel);
    ***REMOVED***
    channels[channel.id] = channel;
    return channel;
  ***REMOVED***

  void createChannel(String id) {
    var newChannel = ChatChannel(id);
    this.storage_service.saveChatChannel(newChannel);
    channels[newChannel.id] = newChannel;
  ***REMOVED***

  Future<void> reload() async {
    await storage_service.reload();
    channels.keys.toList().forEach((id) async {
      print("reloading channels");
      ChatChannel currentChannel = null;
      if(channels[id] is TopicChatChannel) {
        currentChannel = await storage_service.loadTopicChatChannel(id);
      ***REMOVED***
      else
        {
          currentChannel = await storage_service.loadChatChannel(id);
        ***REMOVED***
      if (channels[id].channel_messages.length !=
          currentChannel.channel_messages.length) {
        channels[id].channel_messages = currentChannel.channel_messages;
        channels[id].ccl?.channelChanged(channels[id]);
      ***REMOVED***
    ***REMOVED***);
  ***REMOVED***

  @override
  updateMessages(List<Map<String, dynamic>> messages) =>
      storeMessages(messages.map((m) => chatPushDataFromJson(m)).toList());

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
      ***REMOVED***
    ***REMOVED***
    return channels[id];
  ***REMOVED***
  ***REMOVED***

handleBackgroundChatMessage(ChatPushData data) async {
  ChatChannel channel = await StorageService().loadChatChannel(data.channel);
  if (channel == null) channel = ChatChannel(data.channel);
  channel.pushMessages([data.message]);
  StorageService().saveChatChannel(channel);
***REMOVED***
