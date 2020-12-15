import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/model/user_data.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/StorageService.dart';

class ChatMessageService implements PushNotificationListener {
  ChatMessageService(
      StorageService storageService, AbstractPushNotificationManager manager) {
    manager.register_message_callback(PushDataTypes.SimpleChatMessage, this);
    manager.register_message_callback(PushDataTypes.ParticipationMessage, this);
    this.storage_service = storageService;
  }

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
        this.storage_service.saveActionChannel(channel);
      }
    } on UnreadablePushMessage catch (e, s) {
      ErrorService.handleError(e, s);
    }
  }

  Future<ChatChannel> getActionChannel(int idNr) async =>
      await getChannel('action:$idNr');

  Future<ChatChannel> getChannel(String id) async {
    if (!channels.containsKey(id)) {
      ChatChannel storedChannel =
          await this.storage_service.loadActionChannel(id);
      if (storedChannel != null)
        channels[id] = storedChannel;
      else {
        this.storage_service.saveActionChannel(ChatChannel(id));
        channels[ChatChannel(id).id] = ChatChannel(id);
      }
    }
    return channels[id];
  }

  void createChannel(String id) {
    var newChannel = ChatChannel(id);
    this.storage_service.saveActionChannel(newChannel);
    channels[newChannel.id] = newChannel;
  }

  void register_channel(ChatChannel channel) {
    channels[channel.id] = channel;
  }
}
