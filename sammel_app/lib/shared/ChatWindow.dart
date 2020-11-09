import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/routes/CreateUserDialog.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/user_data.dart';

import 'ChatInput.dart';
import 'ChatListWidget.dart';
import 'ChronoHelfer.dart';

class ChatWindow extends StatefulWidget {
  Channel channel;
  Termin termin;

  ChatWindow(this.channel, this.termin, {Key key***REMOVED***) : super(key: key);

  @override
  ChatWindowState createState() => ChatWindowState(channel, termin);
***REMOVED***

abstract class ChannelChangeListener {
  void channelChanged(Channel channel);
***REMOVED***

class ChatWindowState extends State<ChatWindow> {
  FocusNode myFocusNode;

  bool textFieldHasFocus = false;

  ChatWindowState(this.channel, this.termin);

  SimpleMessageChannel channel;
  Termin termin;
  User user;
  AbstractPushSendService pushService;

  // ignore: non_constant_identifier_names
  ChatListWidget widget_list;
  ScrollController scroll_controller;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      Provider.of<AbstractUserService>(context)
          .user_stream
          .stream
          .listen((user) => setState(() => this.user = user));
      pushService = Provider.of<AbstractPushSendService>(context);
      this.user =
          Provider.of<AbstractUserService>(context).internal_user_object;
    ***REMOVED***

    var inputWidget = ChatInputWidget(onSendMessage);
    this.widget_list = ChatListWidget(this.user, this.channel);
    var header_widget = buildHeader(widget.termin);
    Scaffold page = Scaffold(
        appBar: header_widget,
        body: Padding(
            child: this.widget_list, padding: EdgeInsets.only(bottom: 40)),
        bottomSheet: inputWidget);
    return page;
  ***REMOVED***

  buildHeader(Termin termin) {
    return AppBar(
        title: Column(children: [
          RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: termin.typ,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: ' in ',
                    style: TextStyle(
                        fontSize: 13.0, fontWeight: FontWeight.normal)),
                TextSpan(
                    text: termin.ort.ort,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ], style: TextStyle(color: DweTheme.purple, fontSize: 13.0)),
              softWrap: false,
              overflow: TextOverflow.fade),
          Text(
              'am ${ChronoHelfer.formatDateOfDateTime(termin.beginn)***REMOVED***, um ${ChronoHelfer.dateTimeToStringHHmm(termin.beginn)***REMOVED*** Uhr',
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal),
              overflow: TextOverflow.fade)
        ]),
        /*Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  termin.typ,
                  style: TextStyle(fontSize: 13.0),
                  overflow: TextOverflow.fade,
                ),
                Text(' in ',
                    style: TextStyle(
                        fontSize: 13.0, fontWeight: FontWeight.normal),
                    overflow: TextOverflow.fade),
                Text(termin.ort.ort,
                    style: TextStyle(fontSize: 13.0),
                    overflow: TextOverflow.fade),
              ],
            ),
            Text(
                'am ${ChronoHelfer.formatDateOfDateTime(termin.beginn)***REMOVED***, um ${ChronoHelfer.dateTimeToStringHHmm(termin.beginn)***REMOVED*** Uhr',
                style:
                    TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal)),
          ]),*/
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Show Chat Member',
            onPressed: () {
              openMemberPage(context, termin.participants);
            ***REMOVED***,
          ),
          /* IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () {
          backArrowPressed(context);
        ***REMOVED***,
      )*/
        ]);
  ***REMOVED***

  void openMemberPage(BuildContext context, List<User> participants) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Members'),
          ),
          body: create_member_list_widget(participants),
        );
      ***REMOVED***,
    ));
  ***REMOVED***

  Widget create_member_list_widget(List<User> participants) {
    if (participants.length == 0) {
      return Text('Keine Teilnehmer');
    ***REMOVED*** else {
      List<Widget> users = participants
          .where((user) => user.name != null && user.name != '')
          .map((user) => create_user_widget(user.name, user.color))
          .toList();
      int a_count = participants
          .where((user) => user.name == null || user.name == '')
          .length;
      users.insert(
          0,
          Padding(
              padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
              child: Text('${users.length + a_count***REMOVED*** Teilnehmer im Chat',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal))));
      if (a_count > 0) {
        users.add(
            create_user_widget('+ $a_count weitere Teilnehmer', Colors.black));
      ***REMOVED***
      return Column(children: users);
    ***REMOVED***
  ***REMOVED***

  Padding create_user_widget(String user_name, Color user_color) => Padding(
      padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
      child: Row(children: [
        Icon(
          Icons.person,
          color: user_color,
          size: 55,
        ),
        SizedBox(
          width: 10,
        ),
        Text(user_name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal))
      ]));

  onSendMessage(String text) async {
    if (text == "") {
      return;
    ***REMOVED***

    if (user.name == "" || user.name == null) {
      user = await showCreateUserDialog(context: context, user: user);
      if (user.name == "" || user.name == null) {
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Please enter valid user name to chat.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    ***REMOVED***,
                  ),
                ],
              );
            ***REMOVED***);
        return;
      ***REMOVED*** else {
        Provider.of<AbstractUserService>(context).updateUsername(user.name);
      ***REMOVED***
    ***REMOVED***
    Message message = Message(
        text: text,
        sending_time: DateTime.now(),
        message_color: user.color,
        sender_name: user.name,
        user_id: user.id);
    MessagePushData mpd = MessagePushData(message, channel.id);
    pushService.pushToAction(widget.termin.id, mpd,
        PushNotification("New Chat Message", "Open App to view Message"));
    //textEditingController.clear();
    // myFocusNode.unfocus();
    channel.channelCallback(message);
  ***REMOVED***

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.addListener(onFocusChange);
  ***REMOVED***

  @override
  void dispose() {
    this.channel.dispose_widget();
    myFocusNode.dispose();
    super.dispose();
    //this method not called when user press android back button or quit
    print('dispose');
  ***REMOVED***

  void onFocusChange() {
    if (myFocusNode.hasFocus) {
      textFieldHasFocus = true;
    ***REMOVED***
  ***REMOVED***

  void backArrowPressed(BuildContext context) {
    if (textFieldHasFocus) {
      textFieldHasFocus = false;
      FocusScope.of(context).requestFocus(FocusNode());
    ***REMOVED*** else {
      Navigator.pop(context);
    ***REMOVED***
  ***REMOVED***
***REMOVED***
