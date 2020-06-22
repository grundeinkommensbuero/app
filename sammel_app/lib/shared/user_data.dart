
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/shared/ChatWindow.dart';

abstract class Channel
{
  String name = null;
  List<Message> channel_messages = null;
  List<String> member_names = null;

  Channel(this.name, {this.channel_messages, this.member_names});

  Future<void> channelCallback(Message message);

  getAllMessages() {
    return channel_messages;
  }

  List<String> get_member_names() {
    return member_names;
  }
}

class SimpleMessageChannel extends Channel
{

  List<Message> channel_messages = null;
  ChannelChangeListener ccl = null;

  SimpleMessageChannel(String name) : super(name){
    this.channel_messages = List<Message>();
  }

  @override
  Future<void> channelCallback(Message message) {
    // TODO: implement channelCallback
      if(!channel_messages.contains(message))
        {
          channel_messages.add(message);
        }

      if(ccl != null)
        {
          ccl.channelChanged(this);
        }
  }

  void register_widget(ChannelChangeListener c)
  {
    if(ccl == null)
      {
        ccl = c;
      }
    else
      {
        print('The Channel is already associated toa widget');
      }
  }

  void dispose_widget()
  {
    ccl = null;
  }

}