import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/StorageService.dart';

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
  Future<void> receive_message(Map<dynamic, dynamic> data) async {
    try {
      ChatPushData mpd = ChatPushData.fromJson(data);
      ChatChannel channel = await getChannel(mpd.channel);
      if (channel != null) {
        if (data['type'] == PushDataTypes.SimpleChatMessage)
          channel.pushChatMessage(ChatMessage.fromJson(data));
        if (data['type'] == PushDataTypes.ParticipationMessage)
          channel.pushParticipationMessage(ParticipationMessage.fromJson(data));
        this.storage_service.saveChatChannel(channel);
      ***REMOVED***
    ***REMOVED*** on UnreadablePushMessage catch (e, s) {
      ErrorService.handleError(e, s);
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
