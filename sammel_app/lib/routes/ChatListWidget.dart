import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';

import 'ChatWindow.dart';

class ChatListWidget extends StatefulWidget {
  final ChatChannel channel;

  ChatListWidget(this.channel, {Key? key***REMOVED***) : super(key: key);

  @override
  ChatListState createState() => ChatListState(this.channel);
***REMOVED***

class ChatListState extends State<ChatListWidget>
    implements ChannelChangeListener {
  ChatChannel channel;
  User? user;
  late bool forceScrolling = false;

  ChatListState(this.channel) {
    this.channel.registerChannelChangeListener(this);
    // widget.scroll_controller.addListener(() {widget.position = widget.scroll_controller.hasClients ? widget.scroll_controller.position.extentBefore : 0; ***REMOVED***);
  ***REMOVED***

  Widget build(context) {
    if (user == null) {
      user = User(0, null, null);
      Provider.of<AbstractUserService>(context)
          .user
          .listen((user) => setState(() => this.user = user));
    ***REMOVED***

    var itemList = buildListMessage();
    var listView = Container(
        decoration: DweTheme.happyHouseBackground,
        child: ListView(
          children: itemList.reversed.toList(),
          reverse: true,
        ));

    /*
    Timer(
        Duration(milliseconds: 500),
            () => widget.scroll_controller
            .jumpTo(widget.scroll_controller.position.maxScrollExtent));*/
    return listView;
  ***REMOVED***

  @override
  void channelChanged(ChatChannel channel) {
    forceScrolling = true;
    setState(() {
      this.channel = channel;
    ***REMOVED***);
    //we need this hack to enable scrolling to the end of the list on message received
    /*
    Timer(
        Duration(milliseconds: 500),
        () => widget.scroll_controller
            .jumpTo(widget.scroll_controller.position.maxScrollExtent));*/
  ***REMOVED***

  List<Widget> buildListMessage() {
    List<Message> messageList = widget.channel.channelMessages;
    List<Widget> messageListWidgets = [];
    for (Message message in messageList) {
      if (message is ChatMessage)
        messageListWidgets.add(createChatMessageWidget(message));
      if (message is ParticipationMessage)
        messageListWidgets.add(createParticipationMessageWidget(message));
    ***REMOVED***
    return messageListWidgets;
  ***REMOVED***

  Widget createChatMessageWidget(ChatMessage message) {
    final own = message.userId == user?.id;
    return Align(
        alignment: own ? Alignment.topRight : Alignment.topLeft,
        child: Container(
            child: Card(
                margin: own
                    ? EdgeInsets.fromLTRB(80, 5, 8, 5)
                    : EdgeInsets.fromLTRB(5, 5, 80, 5),
                color: message.messageColor,
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
                                  message.senderName ?? '',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          Padding(
                              padding: EdgeInsets.only(top: 3.0, bottom: 5.0),
                              child: SelectableText(
                                message.text ?? '',
                                textScaleFactor: 1.2,
                              )),
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  ChronoHelfer.formatDateTime(
                                          message.timestamp) ??
                                      '',
                                  textScaleFactor: 0.8,
                                ),
                                SizedBox(
                                  height: 0,
                                  width: 3,
                                )
                              ]..addAll(own
                                  ? [
                                      message.obtainedFromServer
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
    var title = message.joins == true
        ? ' ist der Aktion beigetreten'
        : ' hat die Aktion verlassen';
    var subtitle = message.joins == true
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
