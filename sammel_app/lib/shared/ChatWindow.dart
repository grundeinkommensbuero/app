
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/PushService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/shared/user_data.dart';

import 'DweTheme.dart';

class ChatWindow extends StatefulWidget {

  Channel channel = null;

  ChatWindow(Channel c, {Key key***REMOVED***) : super(key: key)
  {
    channel = c;
  ***REMOVED***

  @override
  ChatWindowState createState() => ChatWindowState(channel);
***REMOVED***


class ChatWindowState extends State<ChatWindow> {

  ChatWindowState(Channel c)
  {
    channel = c;
  ***REMOVED***

  Channel channel = null;
  User user = null;
  PushService pushService = null;

  @override
  Widget build(BuildContext context) {
    if(user == null)
      {
        StorageService storageService = Provider.of<StorageService>(context);
        user = User('test_name', 'test_id', Color.fromRGBO(255, 0, 0, 1.0));
        storageService.saveUser(user);
        storageService.loadUser().then((value) => setState((){this.user = value;***REMOVED***));
        pushService = Provider.of<PushService>(context);

      ***REMOVED***
    var widget_list = <Widget>[buildHeader(channel.name)]+ buildListMessage()+ <Widget>[buildInput()];
    return Column(
      children: widget_list,
    );
  ***REMOVED***


  Widget buildInput() {
    TextEditingController textEditingController = TextEditingController();
    return Container(
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: DweTheme.purple, fontSize: 15.0),
                controller: textEditingController,
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
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.blueGrey, width: 0.5)), color: Colors.white),
    );
  ***REMOVED***


  List<Widget> buildListMessage() {
    List<Message> message_list = channel.getAllMessages();
    if(message_list == null)
      {
        return <Widget>[Text('Send the first Message to this Channel')];
      ***REMOVED***
    List<Widget> message_list_widgets = List();
    for(Message message in message_list)
      {
          message_list_widgets.add(create_widget_for_message(message));
      ***REMOVED***
    return message_list_widgets;
  ***REMOVED***

  Widget create_widget_for_message(Message message) {
    Align alignment = null;
    Card card = Card(color: message.message_color,child: Column(children: [Text(message.sender_name), Text(message.text), Text(message.sending_time.toString())]));
    if(message.sender_name == user.nick_name)
    {
      alignment = Align(child: card, alignment: Alignment.topRight);
    ***REMOVED***else
      {
        alignment = Align(child: card, alignment: Alignment.topLeft,);
      ***REMOVED***
    return alignment;
  ***REMOVED***

  buildHeader(String channel_name) {
    return AppBar(title: Text(channel_name), actions: <Widget>[IconButton(
                            icon: const Icon(Icons.people),
                            tooltip: 'Show Chat Member',
                            onPressed: () {
                            openMemberPage(context);
    ***REMOVED***,
    )]);
  ***REMOVED***

  void openMemberPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Members'),
          ),
          body:  Center(
            child: create_member_list_widget(),
          ),
        );
      ***REMOVED***,
    ));
  ***REMOVED***

  Widget create_member_list_widget() {
    List<String> member_names = channel.get_member_names();
    if(member_names == null)
      {
        return Text('no members yet in the channel');
      ***REMOVED***
    else{
      return Column(children: member_names.map((name) => Text(name)).toList());
    ***REMOVED***
  ***REMOVED***

  onSendMessage(String text) {
    Message message = Message(text: text, sending_time: DateTime.now(), message_color: user.user_color, sender_name: user.nick_name );
    MessagePushData mpd = MessagePushData(message, channel.name);
    pushService.pushToDevices([
      'c1IT42MZGJM:APA91bEh1qV_idNeKrusB1Ccl6BeBUB6iSV3e_W4BIOi3BjZTMhMlL5DqvGwOlCCdVa7V6J0nA4PdYeB7jVFhJIQhbedu0w3WqcdBsKiC3q_eoISKQHilBFpaIwuy1cMUzH3bCxWUUpp'
    ], mpd, PushNotification("New Chat Message", "Open App to view Message"));
  ***REMOVED***




***REMOVED***
