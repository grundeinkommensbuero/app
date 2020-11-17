import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/shared/user_data.dart';

class ChatMessageService implements PushNotificationListener {

  ChatMessageService(StorageService storageService, AbstractPushNotificationManager manager) {
    manager.register_message_callback(PushDataTypes.SimpleChatMessage, this);
    this.storage_service = storageService;
  ***REMOVED***


  Map<String, SimpleMessageChannel> channels = Map<String, SimpleMessageChannel>();
  StorageService storage_service;



  @override
  void receive_message(Map<dynamic, dynamic> data) {
    // TODO: implement receive_message
    MessagePushData mpd = MessagePushData.fromJson(data);
    SimpleMessageChannel receiver = channels[mpd.channel_name];
    Message message = mpd.message;
    if (receiver != null) {
      receiver.channelCallback(message);
      this.storage_service.saveMessageChannel(receiver);
    ***REMOVED***
  ***REMOVED***

  Channel get_simple_message_channel(String id) {
    if (!channels.containsKey(id)) {
      channels[id] = SimpleMessageChannel(id);
        Future<SimpleMessageChannel> stored_data = this.storage_service.loadMessageChannel(id);
        if(stored_data != null) {
          stored_data.then((channel) { return channels[id].restore_channel(channel); ***REMOVED***);
        ***REMOVED***
    ***REMOVED***
    return channels[id];
  ***REMOVED***

  void register_channel(Channel channel) {
    channels[channel.id] = channel;
  ***REMOVED***
***REMOVED***
