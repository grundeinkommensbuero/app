import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/shared/push_notification_manager.dart';
import 'package:sammel_app/shared/user_data.dart';

class ChatMessageService implements PushNotificationListener {

  Map<String, Channel> channels = Map<String, Channel>();

  @override
  void receive_message(Map<dynamic, dynamic> data) {
    // TODO: implement receive_message
    MessagePushData mpd = MessagePushData.fromJson(data);
    Channel receiver = channels[mpd.channel_name];
    Message message = mpd.message;
    if(receiver != null) {
      receiver.channelCallback(message);
    ***REMOVED***
  ***REMOVED***

  void register_channel(Channel channel)
  {
    channels[channel.name] = channel;
  ***REMOVED***
***REMOVED***