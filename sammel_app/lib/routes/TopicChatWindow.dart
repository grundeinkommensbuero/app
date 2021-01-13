import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/routes/ChatWindow.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/showUsernameDialog.dart';
import 'package:easy_localization/easy_localization.dart';

import 'ChatListWidget.dart';
import 'ChatInput.dart';

class TopicChatWindow extends StatefulWidget{
  ChatChannel channel;
  bool build_header = false;

  TopicChatWindow(this.channel, this.build_header, {Key key***REMOVED***) : super(key: key);

  @override
  TopicChatWindowState createState() => TopicChatWindowState(channel);
***REMOVED***

class TopicChatWindowState extends State<TopicChatWindow>  implements ChannelChangeListener{

  String title = "News".tr();
  TopicChatWindowState(this.channel);

  ChatChannel channel;

  AbstractPushSendService pushService;
  
  @override
  Widget build(BuildContext context) {
    this.channel.register_channel_change_listener(this);
    print("global message count ${channel.channel_messages.length***REMOVED***");
    var messages_window = ListView(children: channel.channel_messages.reversed.map((message) => buildMessageWidget(message)).toList(),reverse: true,);
    var header_widget = buildHeader(title);
    Scaffold page = Scaffold(
        appBar: widget.build_header ? header_widget : null,
        body: Container(decoration: DweTheme.happyHouseBackground, child: Padding(
            child: messages_window, padding: EdgeInsets.only(bottom: 40))));
    return page;
  ***REMOVED***

  buildHeader(String title) {
    return AppBar(
        title: Text(title));
  ***REMOVED***

  Widget buildMessageWidget(TopicChatMessage message)
  {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            child: Card(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                color: message.message_color,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, top: 8.0, right: 10.0, bottom: 8.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(
                            message.sender_name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 3.0, bottom: 5.0),
                              child: Text(
                                message.text,
                                textScaleFactor: 1.2,
                              )),
                                Text(
                                  ChronoHelfer.formatDateTime(message.timestamp),
                                  textScaleFactor: 0.8,
                                ),
                        ])))));
  ***REMOVED***

  @override
  void channelChanged(ChatChannel channel) {
    // TODO: implement channelChanged
    setState(() {
      widget.channel = channel;
    ***REMOVED***);
  ***REMOVED***

  @override
  void dispose() {
    this.channel.dispose_widget();
    super.dispose();
  ***REMOVED***

***REMOVED***
