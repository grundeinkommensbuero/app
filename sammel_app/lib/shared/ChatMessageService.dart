import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/shared/user_data.dart';

class ChatMessageService implements PushNotificationListener {
  ChatMessageService(
      StorageService storageService, AbstractPushNotificationManager manager) {
    manager.register_message_callback(PushDataTypes.SimpleChatMessage, this);
    manager.register_message_callback(PushDataTypes.ParticipationMessage, this);
    this.storage_service = storageService;
  }

  Map<String, ActionChannel> channels = Map<String, ActionChannel>();
  StorageService storage_service;

  @override
  void receive_message(String type, Map<dynamic, dynamic> data) {
    ChatPushData mpd = ChatPushData.fromJson(data);
    ActionChannel channel = channels[mpd.channel];
    if (channel != null) {
      if (type == PushDataTypes.SimpleChatMessage)
        channel.pushChatMessage(ChatMessage.fromJson(data));
      if (type == PushDataTypes.ParticipationMessage)
        channel.pushParticipationMessage(ParticipationMessage.fromJson(data));
      this.storage_service.saveActionChannel(channel);
    }
  }

  Future<Channel> getActionChannel(int idNr) async {
    String id = 'action:$idNr';
    if (!channels.containsKey(idNr)) {
      ActionChannel storedChannel =
          await this.storage_service.loadActionChannel(id);
      if (storedChannel != null)
        channels[id] = storedChannel;
      else {
        createActionChannel(idNr);
      }
    }
    return channels[id];
  }

  void createActionChannel(int id) {
    var newChannel = ActionChannel(id);
    this.storage_service.saveActionChannel(newChannel);
    channels[newChannel.id] = newChannel;
  }

  void register_channel(Channel channel) {
    channels[channel.id] = channel;
  }
}
