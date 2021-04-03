import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/routes/ChatWindow.dart';
import 'package:sammel_app/routes/TopicChatWindow.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';

import 'LocalNotificationService.dart';

class ChatMessageService implements PushNotificationListener {
  GlobalKey<NavigatorState>? navigatorKey;

  Map<String, ChatChannel> channels = Map<String, ChatChannel>();
  StorageService? storageService;

  ChatMessageService(StorageService storageService,
      AbstractPushNotificationManager manager, this.navigatorKey) {
    manager.registerMessageCallback(PushDataTypes.simpleChatMessage, this);
    manager.registerMessageCallback(PushDataTypes.participationMessage, this);
    manager.registerMessageCallback(PushDataTypes.topicChatMessage, this);
    this.storageService = storageService;
  ***REMOVED***

  @override
  receiveMessage(Map<String, dynamic> json) async {
    try {
      var pushData = chatPushDataFromJson(json);
      ChatChannel channel = await storeMessage(pushData);

      // check if chat window is open
      final cls = channel.ccl as State<StatefulWidget>?;
      if (cls == null || ModalRoute.of(cls.context)?.isActive == false) {
        // chat window is not open: push local message
        var notifier = Provider.of<LocalNotificationService>(
            navigatorKey!.currentContext!,
            listen: false);
        if (json['type'] == PushDataTypes.simpleChatMessage)
          notifier
              .sendChatNotification(ActionChatMessagePushData.fromJson(json));
        if (json['type'] == PushDataTypes.participationMessage)
          notifier.sendParticipationNotification(
              ParticipationPushData.fromJson(json));
        if (json['type'] == PushDataTypes.topicChatMessage) {
          notifier.sendTopicChatNotification(
              TopicChatMessagePushData.fromJson(json));
        ***REMOVED***
      ***REMOVED***
    ***REMOVED*** on UnreadablePushMessage catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Fehler beim Empfang von Push-Nachricht');
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

      this.storageService?.saveChatChannel(channel);
      channels.add(channel);
    ***REMOVED***
    return channels;
  ***REMOVED***

  @override
  Future<void> handleNotificationTap(Map<String, dynamic> data) async {
    if (Message.determineType(data) == PushDataTypes.topicChatMessage) {
      var chatPushData = TopicChatMessagePushData.fromJson(data);
      final channel = await getChannel(chatPushData.channel);
      State<StatefulWidget>? cls = channel.ccl as State<StatefulWidget>?;
      createOrRecreateTpoicPage(cls, channel);
    ***REMOVED*** else if (Message.determineType(data) == PushDataTypes.simpleChatMessage) {
      var chatPushData = ActionChatMessagePushData.fromJson(data);
      final channel = await getChannel(chatPushData.channel);
      State<StatefulWidget>? cls = channel.ccl as State<StatefulWidget>?;
      createOrRecreateChatPage(cls, channel, chatPushData.action);
    ***REMOVED*** else if (Message.determineType(data) ==
        PushDataTypes.participationMessage) {
      var participationPushData = ParticipationPushData.fromJson(data);
      final channel = await getChannel(participationPushData.channel);
      State<StatefulWidget>? cls = channel.ccl as State<StatefulWidget>?;
      createOrRecreateChatPage(cls, channel, participationPushData.action);
    ***REMOVED***
  ***REMOVED***

  void createOrRecreateChatPage(
      State<StatefulWidget>? cls, ChatChannel channel, int terminId) {
    if (cls == null || ModalRoute.of(cls.context)?.isActive == false) {
      if (cls != null) {
        Navigator.pop(cls.context);
      ***REMOVED***
      Provider.of<AbstractTermineService>(navigatorKey!.currentContext!)
          .getActionWithDetails(terminId)
          .then((value) => navigatorKey!.currentState!.push(MaterialPageRoute(
              builder: (context) => ChatWindow(channel, value, true))));
    ***REMOVED***
  ***REMOVED***

  void createOrRecreateTpoicPage(
      State<StatefulWidget>? cls, ChatChannel channel) {
    if (cls == null || ModalRoute.of(cls.context)?.isActive == false) {
      if (cls != null) {
        Navigator.pop(cls.context);
      ***REMOVED***
      navigatorKey!.currentState!.push(MaterialPageRoute(
          builder: (context) => TopicChatWindow(channel, true)));
    ***REMOVED***
  ***REMOVED***

  Future<ChatChannel> getTopicChannel(String topic) async =>
      await getChannel('topic:$topic');

  Future<ChatChannel> getActionChannel(int idNr) async =>
      await getChannel('action:$idNr');

  Future<ChatChannel> getChannel(String id) async {
    if (channels.containsKey(id)) return channels[id]!;

    ChatChannel? channel = await this.storageService?.loadChatChannel(id);

    if (channel == null) {
      channel = ChatChannel(id);
      await this.storageService?.saveChatChannel(channel);
    ***REMOVED***
    channels[channel.id!] = channel;
    return channel;
  ***REMOVED***

  void createChannel(String id) {
    var newChannel = ChatChannel(id);
    this.storageService?.saveChatChannel(newChannel);
    channels[newChannel.id!] = newChannel;
  ***REMOVED***

  @override
  updateMessages(List<Map<String, dynamic>> messages) =>
      storeMessages(messages.map((m) => chatPushDataFromJson(m)).toList());
***REMOVED***
