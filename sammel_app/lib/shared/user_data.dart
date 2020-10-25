
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/shared/ChatWindow.dart';

abstract class Channel
{
  String id = null;
  List<Message> channel_messages = null;
  List<String> member_names = null;

  Channel(this.id, {this.channel_messages, this.member_names});

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

  SimpleMessageChannel(String id) : super(id){
    this.channel_messages = List<Message>();
  }

  @override
  Future<void> channelCallback(Message message) {
    // TODO: implement channelCallback

      List<Message> contains_message = channel_messages.map((e) => message.isMessageEqual(e) ? e : null).where((element) => element != null).toList();
      if(contains_message.isEmpty) {
        channel_messages.add(message);
      }
      else{
        contains_message[0].obtained_from_server = true;
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