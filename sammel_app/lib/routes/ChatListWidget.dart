import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  ScrollController scroll_controller = ScrollController();

  ChatListWidget(this.channel, {Key key***REMOVED***) : super(key: key);

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
  ***REMOVED***

  Widget build(context) {
    if (user == null) {
      user = User(0, null, null);
      Provider.of<AbstractUserService>(context)
          .user
          .listen((user) => setState(() => this.user = user));
    ***REMOVED***

    this.channel.register_widget(this);
    var list_view = ListView(
        padding: EdgeInsets.all(8.0),
        controller: widget.scroll_controller,
        children: buildListMessage());

    return list_view;
  ***REMOVED***

  @override
  void channelChanged(ChatChannel channel) {
    force_scrolling = true;
    setState(() {
      widget.channel = channel;
    ***REMOVED***);
    //we need this hack to enable scrolling to the end of the list on message received
    Timer(
        Duration(milliseconds: 500),
        () => widget.scroll_controller
            .jumpTo(widget.scroll_controller.position.maxScrollExtent));
  ***REMOVED***

  List<Widget> buildListMessage() {
    List<Message> message_list = widget.channel.getAllMessages();
    if (message_list == null) {
      return <Widget>[Text('Send the first Message to this Channel')];
    ***REMOVED***
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
  ***REMOVED***

  Widget createParticipationMessageWidget(ParticipationMessage message) {
    var title = message.joins
        ? ' ist der Aktion beigetreten'
        : ' hat die Aktion verlassen';
    var subtitle = message.joins
        ? '\nNeue Teilnehmer*innen können ältere Nachrichten nicht lesen'
        : '';
    return RichText(
        key: Key('Participation Message'),
        textAlign: TextAlign.center,
        text: TextSpan(
            text: message.username ?? 'Jemand',
            style: TextStyle(color: DweTheme.purple),
            children: [
              TextSpan(text: title, style: TextStyle(color: Colors.black)),
              TextSpan(
                  text: subtitle,
                  style: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic))
            ]));
  ***REMOVED***

  String formatDateTime(DateTime date) {
    Duration message_sent = DateTime.now().difference(date);
    if (message_sent < Duration(minutes: 1)) {
      return 'gerade eben';
    ***REMOVED*** else if (message_sent < Duration(hours: 1)) {
      if (message_sent.inMinutes < 2) {
        return '${message_sent.inMinutes***REMOVED*** Minute';
      ***REMOVED*** else {
        return '${message_sent.inMinutes***REMOVED*** Minuten';
      ***REMOVED***
    ***REMOVED*** else if (message_sent < Duration(hours: 12)) {
      if (message_sent.inHours < 2) {
        return '${message_sent.inHours***REMOVED*** Stunde';
      ***REMOVED*** else {
        return '${message_sent.inHours***REMOVED*** Stunden';
      ***REMOVED***
    ***REMOVED*** else if (DateTime.now().difference(date) < Duration(days: 1)) {
      return ChronoHelfer.dateTimeToStringHHmm(date);
    ***REMOVED*** else if (DateTime.now().difference(date) < Duration(days: 7)) {
      return DateFormat('EEE, hh:mm').format(date);
    ***REMOVED***

    return DateFormat('MMM d, hh:mm').format(date);
  ***REMOVED***
***REMOVED***
