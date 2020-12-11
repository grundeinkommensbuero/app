
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/user_data.dart';

import 'ChatWindow.dart';
import 'ChronoHelfer.dart';

class ChatListWidget extends StatefulWidget {
  Channel channel;
  ScrollController scroll_controller = ScrollController();

  ChatListWidget(this.channel, {Key key}) : super(key: key);

  @override
  ChatListState createState() => ChatListState(this.channel);
}

class ChatListState extends State<ChatListWidget>
    implements ChannelChangeListener {
  ActionChannel channel;
  User user;

  ActionChannel channel;
  bool force_scrolling = false;
  ChatListState(ActionChannel channel)
  {
    this.channel = channel;
  }

  Widget build(context) {
    if (user == null) {
      user = User(0, null, null);
      Provider.of<AbstractUserService>(context)
          .user
          .listen((user) => setState(() => this.user = user));
    }

    this.channel.register_widget(this);
    var message_list = buildListMessage();
    var list_view = ListView(controller: widget.scroll_controller, children: message_list);
    //we need this hack to enable scrolling to the end of the list on message received
    Timer(Duration(milliseconds: 500),
            () => widget.scroll_controller.jumpTo(widget.scroll_controller.position.maxScrollExtent));

    return list_view;
  }

  @override
  void channelChanged(Channel channel) {
    force_scrolling = true;
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
      if (message is ChatMessage)
        message_list_widgets.add(createChatMessageWidget(message));
      if (message is ParticipationMessage)
        message_list_widgets.add(createParticipationMessageWidget(message));
    }
    return message_list_widgets;
  }

  Widget createChatMessageWidget(ChatMessage message) {
    final own = message.user_id == user.id;
    return Align(
        alignment: own ? Alignment.topRight : Alignment.topLeft,
        child: Container(
            child: Card(
                margin: own
                    ? EdgeInsets.fromLTRB(80, 5, 8, 5)
                    : EdgeInsets.fromLTRB(5, 5, 80, 5),
                color: message.message_color,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, top: 8.0, right: 10.0, bottom: 8.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: own
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          own
                              ? SizedBox()
                              : Text(
                                  message.sender_name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          Padding(
                              padding: EdgeInsets.only(top: 3.0, bottom: 5.0),
                              child: Text(
                                message.text,
                                textScaleFactor: 1.2,
                              )),
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  formatDateTime(message.timestamp),
                                  textScaleFactor: 0.8,
                                ),
                                SizedBox(
                                  height: 0,
                                  width: 3,
                                )
                              ]..addAll(own
                                  ? [
                                      message.obtained_from_server
                                          ? Icon(
                                              Icons.check_circle,
                                              size: 12,
                                            )
                                          : Icon(Icons.check_circle_outline,
                                              size: 12)
                                    ]
                                  : []))
                        ])))));
  }

  Widget createParticipationMessageWidget(ParticipationMessage message) {
    var title = message.joins
        ? ' ist der Aktion beigetreten'
        : ' hat die Aktion verlassen';
    var subtitle = message.joins
        ? '\nNeue Teilnehmer*innen können ältere Nachrichten nicht lesen'
        : '';
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: message.username,
            style: TextStyle(color: DweTheme.purple),
            children: [
              TextSpan(text: title, style: TextStyle(color: Colors.black)),
              TextSpan(
                  text: subtitle,
                  style: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic))
            ]));
  }

  String formatDateTime(DateTime date) {
    Duration message_sent = DateTime.now().difference(date);
    if (message_sent < Duration(minutes: 1)) {
      return 'gerade eben';
    } else if (message_sent < Duration(hours: 1)) {
      if (message_sent.inMinutes < 2) {
        return '${message_sent.inMinutes} Minute';
      } else {
        return '${message_sent.inMinutes} Minuten';
      }
    } else if (message_sent < Duration(hours: 12)) {
      if (message_sent.inHours < 2) {
        return '${message_sent.inHours} Stunde';
      } else {
        return '${message_sent.inHours} Stunden';
      }
    } else if (DateTime.now().difference(date) < Duration(days: 1)) {
      return ChronoHelfer.dateTimeToStringHHmm(date);
    } else if (DateTime.now().difference(date) < Duration(days: 7)) {
      return DateFormat('EEE, hh:mm').format(date);
    }

    return DateFormat('MMM d, hh:mm').format(date);
  }

  scrollList(BuildContext context) {
    if(force_scrolling) {
      print("scroll list called");
      if (widget.scroll_controller.hasClients) {
        widget.scroll_controller.jumpTo(
            widget.scroll_controller.position.maxScrollExtent);
      }
      force_scrolling = false;
    }
  }

}
