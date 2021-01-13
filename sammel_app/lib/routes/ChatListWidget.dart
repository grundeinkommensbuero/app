import 'package:easy_localization/easy_localization.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

import 'ChatWindow.dart';

class ChatListWidget extends StatefulWidget {
  ChatChannel channel;


  ChatListWidget(this.channel, {Key key***REMOVED***) : super(key: key)
  {

  ***REMOVED***

  @override
  ChatListState createState() => ChatListState(this.channel);
***REMOVED***

class ChatListState extends State<ChatListWidget>
    implements ChannelChangeListener {
  ChatChannel channel;
  User user;
  bool force_scrolling = false;

  ChatListState(ChatChannel channel) {
    this.channel = channel;
    this.channel.register_channel_change_listener(this);
   // widget.scroll_controller.addListener(() {widget.position = widget.scroll_controller.hasClients ? widget.scroll_controller.position.extentBefore : 0; ***REMOVED***);

  ***REMOVED***

  Widget build(context) {
    if (user == null) {
      user = User(0, null, null);
      Provider.of<AbstractUserService>(context)
          .user
          .listen((user) => setState(() => this.user = user));
    ***REMOVED***

    var item_list = buildListMessage();
    var list_view = Container(
        decoration: DweTheme.happyHouseBackground,
        child: ListView(children: item_list.reversed.toList(),reverse: true,));

    /*
    Timer(
        Duration(milliseconds: 500),
            () => widget.scroll_controller
            .jumpTo(widget.scroll_controller.position.maxScrollExtent));*/
    return list_view;
  ***REMOVED***

  @override
  void channelChanged(ChatChannel channel) {
    force_scrolling = true;
    setState(() {
      widget.channel = channel;
    ***REMOVED***);
    //we need this hack to enable scrolling to the end of the list on message received
    /*
    Timer(
        Duration(milliseconds: 500),
        () => widget.scroll_controller
            .jumpTo(widget.scroll_controller.position.maxScrollExtent));*/
  ***REMOVED***

  List<Widget> buildListMessage() {
    List<Message> message_list = widget.channel.channel_messages;
    if (message_list == null) return <Widget>[];
    List<Widget> message_list_widgets = List();
    for (Message message in message_list) {
      if (message is ChatMessage)
        message_list_widgets.add(createChatMessageWidget(message));
      if (message is ParticipationMessage)
        message_list_widgets.add(createParticipationMessageWidget(message));
    ***REMOVED***
    return message_list_widgets;
  ***REMOVED***

  Widget createChatMessageWidget(ChatMessage message) {
    final own = message.user_id == user?.id;
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
                              child: SelectableText(
                                message.text,
                                textScaleFactor: 1.2,
                              )),
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  ChronoHelfer.formatDateTime(message.timestamp),
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
  ***REMOVED***

  Widget createParticipationMessageWidget(ParticipationMessage message) {
    var title = message.joins
        ? ' ist der Aktion beigetreten'.tr()
        : ' hat die Aktion verlassen'.tr();
    var subtitle = message.joins
        ? '\nNeue Teilnehmer*innen können ältere Nachrichten nicht lesen'.tr()
        : '';
    return RichText(
        //   key: Key('Participation Message'),
        textAlign: TextAlign.center,
        text: TextSpan(
            text: message.username ?? 'Jemand'.tr(),
            style: TextStyle(color: DweTheme.purple),
            children: [
              TextSpan(text: title, style: TextStyle(color: Colors.black)),
              TextSpan(
                  text: subtitle,
                  style: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic))
            ]));
  ***REMOVED***

  dispose() {
    super.dispose();
  ***REMOVED***
***REMOVED***
