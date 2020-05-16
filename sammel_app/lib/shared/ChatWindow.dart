
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/shared/user_data.dart';

class ChatWindow extends StatefulWidget {

  Channel channel = null;

  ChatWindow(Channel c, {Key key}) : super(key: key)
  {
    channel = c;
  }

  @override
  ChatWindowState createState() => ChatWindowState(channel);
}


class ChatWindowState extends State<ChatWindow> {

  ChatWindowState(Channel c)
  {
    channel = c;
  }

  Channel channel = null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // List of messages
        buildHeader(),
        buildListMessage(),

      ],
    );
  }

  buildListMessage() {
    List<Message> message_list = channel.getAllMessages();
    List<Widget> message_list_widgets = List();
    for(Message message in message_list)
      {
          message_list_widgets.add(create_widget_for_message(message));
      }
  }

  Widget create_widget_for_message(Message message) {
    return Card(child: Column(children: [Text(message.sender_name), Text(message.text), Text(message.sending_time)]);
  }

  buildHeader(String channel_name) {
    return AppBar(title: Text(channel_name), actions: <Widget>[IconButton(
                            icon: const Icon(Icons.people),
                            tooltip: 'Show Chat Member',
                            onPressed: () {
                            openMemberPage(context);
    },
    ));
  }

  void openMemberPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Members'),
          ),
          body: const Center(
            child: create_member_list_widget(),
          ),
        );
      },
    ));
  }

  create_member_list_widget() {
    List<String> member_names = channel.get_member_names();
    return Column(children: member_names.map((name) => Text(name)).toList());
  }




}
