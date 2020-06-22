
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/shared/ChatWindow.dart';

abstract class Channel
{
  String id = null;
  List<Message> channel_messages = null;
  List<String> member_names = null;

  Channel(this.id, {this.channel_messages, this.member_names***REMOVED***);

  Future<void> channelCallback(Message message);

  getAllMessages() {
    return channel_messages;
  ***REMOVED***

  List<String> get_member_names() {
    return member_names;
  ***REMOVED***
***REMOVED***

class SimpleMessageChannel extends Channel
{

  List<Message> channel_messages = null;
  ChannelChangeListener ccl = null;

  SimpleMessageChannel(String id) : super(id){
    this.channel_messages = List<Message>();
  ***REMOVED***

  @override
  Future<void> channelCallback(Message message) {
    // TODO: implement channelCallback
      if(!channel_messages.contains(message))
        {
          channel_messages.add(message);
        ***REMOVED***

      if(ccl != null)
        {
          ccl.channelChanged(this);
        ***REMOVED***
  ***REMOVED***

  void register_widget(ChannelChangeListener c)
  {
    if(ccl == null)
      {
        ccl = c;
      ***REMOVED***
    else
      {
        print('The Channel is already associated toa widget');
      ***REMOVED***
  ***REMOVED***

  void dispose_widget()
  {
    ccl = null;
  ***REMOVED***

***REMOVED***