
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/user_data.dart';

import 'ChatWindow.dart';
import 'ChronoHelfer.dart';

class ChatListWidget extends StatefulWidget {

  var user;
  var channel;
  ScrollController scroll_controller = ScrollController();

  ChatListWidget(this.user, this.channel, {Key key}) : super(key: key) {
  }

  @override
  ChatListState createState() => ChatListState(this.channel);


}

class ChatListState extends State<ChatListWidget>   implements ChannelChangeListener
{

  SimpleMessageChannel channel;

  ChatListState(SimpleMessageChannel channel)
  {
    this.channel = channel;
  }

  Widget build(context) {
    if (widget.user == null)
      {
        Provider.of<AbstractUserService>(context).user_stream.stream.listen((user) => setState(() => widget.user = user));
      }

    this.channel.register_widget(this);
    var message_list = buildListMessage();
    var list_view = ListView(controller: widget.scroll_controller, children: message_list);
    if (widget.scroll_controller.hasClients)
      widget.scroll_controller.jumpTo(widget.scroll_controller.position.maxScrollExtent);

    return list_view;
  }

  @override
  void channelChanged(Channel channel) {
    setState(() {
      widget.channel = channel;
    });
  }

  List<Widget> buildListMessage() {
    List<Message> message_list = widget.channel.getAllMessages();
    if (message_list == null) {
      return <Widget>[Text('Send the first Message to this Channel')];
    }
    List<Widget> message_list_widgets = List();
    for (Message message in message_list) {
      message_list_widgets.add(create_widget_for_message(message));
    }
    return message_list_widgets;
  }

  Widget create_widget_for_message(Message message) {
    Align alignment = null;
    Container card = null;
    if (message.sender_name == widget.user.name) {
      card = Container(
        /* constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width*0.8), //00 * 0.8,
              //maxHeight: /*MediaQuery.of(context).size.height*/200 * 0.8),*/
          child: Card(
              color: message.message_color,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 10.0, top: 8.0, right: 10.0, bottom: 8.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.sender_name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 3.0, bottom: 5.0),
                            child: Text(
                              message.text,
                              textScaleFactor: 1.2,
                            )),
                        Row( mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text(
                              formatDateTime(message.sending_time),
                              textScaleFactor: 0.8,
                            ), SizedBox(height: 0, width: 3,),
                              message.obtained_from_server ? Icon(Icons.check_circle, size: 12,) : Icon(Icons.check_circle_outline, size: 12)])
                      ]))));
      alignment = Align(child: card, alignment: Alignment.topRight);
    } else {
      card = Container(
          constraints: BoxConstraints(
              maxWidth: /*MediaQuery.of(context).size.width*/200 * 0.8,
              maxHeight: /*MediaQuery.of(context).size.height*/200 * 0.8),
          child: Card(
              color: message.message_color,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 10.0, top: 8.0, right: 10.0, bottom: 8.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.sender_name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 3.0, bottom: 5.0),
                            child: Text(
                              message.text,
                              textScaleFactor: 1.2,
                            )),
                        Row(children: [Text(
                          formatDateTime(message.sending_time),
                          textScaleFactor: 0.8,
                        ), message.obtained_from_server ? Icon(Icons.check_circle_outline) : Icon(Icons.check_circle)])
                      ]))));
      alignment = Align(child: card, alignment: Alignment.topLeft);
    }
    return alignment;
  }

  String formatDateTime(DateTime date) {
    Duration message_sent = DateTime.now().difference(date);
    if (message_sent < Duration(minutes: 1)) {
      return 'gerade eben';
    } else if (message_sent < Duration(hours: 1)) {
      if(message_sent.inMinutes < 2)
      {
        return '${message_sent.inMinutes} Minute';
      }
      else{
        return '${message_sent.inMinutes} Minuten';
      }
    } else if (message_sent < Duration(hours: 12)) {
      if(message_sent.inHours < 2)
      {
        return '${message_sent.inHours} Stunde';
      }
      else
      {
        return '${message_sent.inHours} Stunden';
      }
    } else if (DateTime.now().difference(date) < Duration(days: 1)) {
      return ChronoHelfer.dateTimeToStringHHmm(date);
    } else if (DateTime.now().difference(date) < Duration(days: 7)) {
      return DateFormat('EEE, hh:mm').format(date);
    }

    return DateFormat('MMM d, hh:mm').format(date);
  }


}

