import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/PushService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/shared/user_data.dart';

import 'DweTheme.dart';

class ChatWindow extends StatefulWidget {

  Channel channel = null;

  ChatWindow(Channel c, {Key key***REMOVED***) : super(key: key) {
    channel = c;
  ***REMOVED***

  @override
  ChatWindowState createState() => ChatWindowState(channel);
***REMOVED***

abstract class ChannelChangeListener {

  void channelChanged(Channel channel);

***REMOVED***


class ChatWindowState extends State<ChatWindow>
    implements ChannelChangeListener {


  FocusNode myFocusNode;

  bool textFieldHasFocus = false;


  ChatWindowState(SimpleMessageChannel c) {
    channel = c;
  ***REMOVED***

  SimpleMessageChannel channel = null;
  User user = null;
  PushService pushService = null;
  TextEditingController textEditingController = TextEditingController();
  GlobalKey _formKey = new GlobalKey(debugLabel:'TextField');



  @override
  Widget build(BuildContext context) {
    if (user == null) {
      StorageService storageService = Provider.of<StorageService>(context);
      user = User(1, 'test_name1312', Color.fromRGBO(255, 255, 0, 1.0));
      storageService.saveUser(user);
      storageService.loadUser().then((value) =>
          setState(() {
            this.user = value;
          ***REMOVED***));
      pushService = Provider.of<PushService>(context);
      channel.register_widget(this);
    ***REMOVED***

    var widget_list = ListView(children: buildListMessage());
    var inputWidget = buildInput();
    var header_widget = buildHeader(channel.name);
    Scaffold page = Scaffold( appBar: header_widget,
        body: Padding(child: widget_list, padding: EdgeInsets.only(bottom: 40)),
        bottomSheet: SizedBox(child: inputWidget, height: 40));
    if (textFieldHasFocus) {
    //  myFocusNode.unfocus();
    //  print('has functions 1 ' + myFocusNode.hasFocus.toString());
    //  FocusScope.of(context).requestFocus(FocusNode());
   //   print('has functions 2 ' + myFocusNode.hasFocus.toString());

        FocusScope.of(context).requestFocus(myFocusNode);
    //  print('has functions 3 ' + myFocusNode.hasFocus.toString());
    //  myFocusNode.requestFocus();
    ***REMOVED***
    print(textFieldHasFocus.toString());
    print('has functions' + myFocusNode.hasFocus.toString());
    return page;
  ***REMOVED***


  Widget buildInput() {
    return Container(key: Key('InputWidgetContainer'),
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              child: TextField(key:_formKey,
                style: TextStyle(color: DweTheme.purple, fontSize: 15.0),
                controller: textEditingController,
                focusNode: myFocusNode,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text),
                color: DweTheme.purple,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.blueGrey, width: 0.5)),
          color: Colors.white),
    );
  ***REMOVED***


  List<Widget> buildListMessage() {
    List<Message> message_list = channel.getAllMessages();
    if (message_list == null) {
      return <Widget>[Text('Send the first Message to this Channel')];
    ***REMOVED***
    List<Widget> message_list_widgets = List();
    for (Message message in message_list) {
      message_list_widgets.add(create_widget_for_message(message));
    ***REMOVED***
    return message_list_widgets;
  ***REMOVED***

  Widget create_widget_for_message(Message message) {
    Align alignment = null;
    Container card = null;
    if (message.sender_name == user.name) {
      card = Container(constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8, maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: Card(color: message.message_color, child: Padding(
              padding: EdgeInsets.only(left:5.0, top: 5.0, right: 5.0, bottom: 5.0), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children:
      [
        Text(
          message.sender_name, style: TextStyle(fontWeight: FontWeight.bold),),
        Text(message.text, textScaleFactor: 1.2,),
        Text(formatDateTime(message.sending_time), textScaleFactor: 0.8,)
      ]))));
          alignment = Align(child: card, alignment: Alignment.topRight);
    ***REMOVED*** else {
      card = Container(constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8, maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: Card(color: message.message_color, child: Padding(
              padding: EdgeInsets.only(left:5.0, top: 5.0, right: 5.0, bottom: 5.0), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children:
      [
        Text(
          message.sender_name, style: TextStyle(fontWeight: FontWeight.bold),),
        Text(message.text, textScaleFactor: 1.2,),
        Text(formatDateTime(message.sending_time), textScaleFactor: 0.8,)
      ]))));
          alignment = Align(child: card, alignment: Alignment.topLeft);
    ***REMOVED***
    return alignment;
  ***REMOVED***

  buildHeader(String channel_name) {
    return AppBar(title: Text(channel_name), actions: <Widget>[IconButton(
      icon: const Icon(Icons.people),
      tooltip: 'Show Chat Member',
      onPressed: () {
        openMemberPage(context);
      ***REMOVED***,),
      IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () {
          backArrowPressed(context);
        ***REMOVED***,
      )
    ]);
  ***REMOVED***

  void openMemberPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Members'),
          ),
          body: Center(
            child: create_member_list_widget(),
          ),
        );
      ***REMOVED***,
    ));
  ***REMOVED***

  Widget create_member_list_widget() {
    List<String> member_names = channel.get_member_names();
    if (member_names == null) {
      return Text('no members yet in the channel');
    ***REMOVED***
    else {
      return Column(children: member_names.map((name) => Text(name)).toList());
    ***REMOVED***
  ***REMOVED***

  onSendMessage(String text) {
    Message message = Message(text: text,
        sending_time: DateTime.now(),
        message_color: user.color,
        sender_name: user.name);
    MessagePushData mpd = MessagePushData(message, channel.name);
    pushService.pushToDevices([
      'c1IT42MZGJM:APA91bEh1qV_idNeKrusB1Ccl6BeBUB6iSV3e_W4BIOi3BjZTMhMlL5DqvGwOlCCdVa7V6J0nA4PdYeB7jVFhJIQhbedu0w3WqcdBsKiC3q_eoISKQHilBFpaIwuy1cMUzH3bCxWUUpp'
    ], mpd, PushNotification("New Chat Message", "Open App to view Message"));
    textEditingController.clear();
    myFocusNode.unfocus();
  ***REMOVED***

  @override
  void channelChanged(Channel channel) {
    setState(() {
      this.channel = channel;
    ***REMOVED***);
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

  String formatDateTime(DateTime date)
  {
    Duration message_sent = DateTime.now().difference(date);
    if(message_sent<Duration(minutes: 1)){
      return 'now';
    ***REMOVED***
    else if(message_sent<Duration(hours: 1))
    {
      return '${message_sent.inMinutes***REMOVED***m';
    ***REMOVED***
    else if(message_sent<Duration(hours: 12))
      {
        return '${message_sent.inHours***REMOVED***h';
      ***REMOVED***
    else if(DateTime.now().difference(date)<Duration(days: 1)){
      return DateFormat('hh:mm').format(date);
    ***REMOVED***
    return date.toString();
  ***REMOVED***

  void backArrowPressed(BuildContext context) {
    if (textFieldHasFocus) {
      textFieldHasFocus = false;
      FocusScope.of(context).requestFocus(FocusNode());
    ***REMOVED***
    else {
      Navigator.pop(context);
    ***REMOVED***
  ***REMOVED***
***REMOVED***
