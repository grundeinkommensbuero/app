import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/shared/user_data.dart';

class ChatMessageService implements PushNotificationListener {
  ChatMessageService(PushNotificationManager manager) {
    manager.register_message_callback(PushDataTypes.SimpleChatMessage, this);
  ***REMOVED***

  Map<String, Channel> channels = Map<String, Channel>();

  @override
  void receive_message(Map<dynamic, dynamic> data) {
    // TODO: implement receive_message
    MessagePushData mpd = MessagePushData.fromJson(data);
    Channel receiver = channels[mpd.channel_name];
    Message message = mpd.message;
    if (receiver != null) {
      receiver.channelCallback(message);
    ***REMOVED***
  ***REMOVED***

  Channel get_simple_message_channel(String id) {
    if (!channels.containsKey(id)) {
      channels[id] = SimpleMessageChannel(id);
    ***REMOVED***
    return channels[id];
  ***REMOVED***

  void register_channel(Channel channel) {
    channels[channel.id] = channel;
  ***REMOVED***
***REMOVED***
