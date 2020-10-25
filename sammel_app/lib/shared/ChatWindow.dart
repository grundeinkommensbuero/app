import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/routes/CreateUserDialog.dart';
import 'package:sammel_app/services/PushService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/user_data.dart';

import 'ChronoHelfer.dart';
import 'DweTheme.dart';

class ChatWindow extends StatefulWidget {
  Channel channel;
  Termin termin;

  ChatWindow(this.channel, this.termin, {Key key}) : super(key: key) {}

  @override
  ChatWindowState createState() => ChatWindowState(channel, termin);
}

abstract class ChannelChangeListener {
  void channelChanged(Channel channel);
}

class ChatWindowState extends State<ChatWindow>
    implements ChannelChangeListener {
  FocusNode myFocusNode;

  bool textFieldHasFocus = false;

  ChatWindowState(this.channel, this.termin) {}

  SimpleMessageChannel channel = null;
  Termin termin = null;
  User user = null;
  AbstractPushService pushService = null;
  TextEditingController textEditingController = TextEditingController();
  GlobalKey _formKey = new GlobalKey(debugLabel: 'TextField');

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      Provider.of<AbstractUserService>(context)
          .user
          .then((user) => setState(() => this.user = user));
      pushService = Provider.of<AbstractPushService>(context);
      channel.register_widget(this);
    }

    var widget_list = ListView(children: buildListMessage());
    var inputWidget = buildInput();
    var header_widget = buildHeader(widget.termin);
    Scaffold page = Scaffold(
        appBar: header_widget,
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
    }
    print(textFieldHasFocus.toString());
    print('has functions' + myFocusNode.hasFocus.toString());
    return page;
  }

  Widget buildInput() {
    return Container(
      key: Key('InputWidgetContainer'),
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                key: _formKey,
                style: TextStyle(color: DweTheme.purple, fontSize: 15.0),
                controller: textEditingController,
                focusNode: myFocusNode,
                decoration: InputDecoration.collapsed(
                  hintText: 'Nachricht eingeben...',
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
  }

  List<Widget> buildListMessage() {
    List<Message> message_list = channel.getAllMessages();
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
    if (message.sender_name == user.name) {
      card = Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
              maxHeight: MediaQuery.of(context).size.height * 0.8),
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
              maxWidth: MediaQuery.of(context).size.width * 0.8,
              maxHeight: MediaQuery.of(context).size.height * 0.8),
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

  buildHeader(Termin termin) {
    return AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(termin.typ, style: TextStyle(fontSize: 13.0)),
                Text(' in ',
                    style: TextStyle(
                        fontSize: 13.0, fontWeight: FontWeight.normal)),
                Text(termin.ort.ort, style: TextStyle(fontSize: 13.0)),
              ],
            ),
            Text(
                'am ${ChronoHelfer.formatDateOfDateTime(termin.beginn)}, um ${ChronoHelfer.dateTimeToStringHHmm(termin.beginn)} Uhr',
                style:
                    TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal)),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Show Chat Member',
            onPressed: () {
              openMemberPage(context, termin.participants);
            },
          ),
          /* IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () {
          backArrowPressed(context);
        },
      )*/
        ]);
  }

  void openMemberPage(BuildContext context, List<User> participants) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Members'),
          ),
          body: create_member_list_widget(participants),
        );
      },
    ));
  }

  Widget create_member_list_widget(List<User> participants) {

    if (participants.length == 0) {
      return Text('Keine Teilnehmer');
    } else {
      List<Widget> users = participants.where((user) => user.name != null && user.name != '').map((user) =>
          create_user_widget(user.name, user.color)).toList();
      int a_count = participants.where((user) => user.name == null || user.name == '').length;
      users.insert(0, Padding(padding: EdgeInsets.only(left: 5, top: 5, bottom: 5), child: Text('${users.length+a_count} Teilnehmer im Chat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))));
      if(a_count > 0)
        {
          users.add(create_user_widget('+ $a_count weitere Teilnehmer', Colors.black));
        }
      return Column(children: users);
    }
  }

  Padding create_user_widget(String user_name, Color user_color) => Padding(padding: EdgeInsets.only(left: 5, top: 5, bottom: 5), child: Row(children: [Icon(Icons.person, color: user_color,),Text(user_name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]));

   onSendMessage(String text) async {

    if(text == "")
      {
        return;
      }

    if(user.name == "" || user.name == null)
    {
      user = await showCreateUserDialog(context: context, user: user);
      if(user.name == "" || user.name == null)
      {
        showDialog<void>(context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog( title: Text('Error'),
                content: Text('Please enter valid user name to chat.'),
                actions: <Widget>[FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },),],
              );
            });
        return;
      }
      else
        {
          Provider.of<AbstractUserService>(context).updateUser(user);
        }

    }
    Message message = Message(
        text: text,
        sending_time: DateTime.now(),
        message_color: user.color,
        sender_name: user.name);
    MessagePushData mpd = MessagePushData(message, channel.id);
    pushService.pushToAction(widget.termin.id, mpd, PushNotification("New Chat Message", "Open App to view Message"));
    textEditingController.clear();
    myFocusNode.unfocus();
    channel.channelCallback(message);
  }

  @override
  void channelChanged(Channel channel) {
    setState(() {
      this.channel = channel;
    });
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    this.channel.dispose_widget();
    myFocusNode.dispose();
    super.dispose();
    //this method not called when user press android back button or quit
    print('dispose');
  }

  void onFocusChange() {
    if (myFocusNode.hasFocus) {
      textFieldHasFocus = true;
    }
  }

  String formatDateTime(DateTime date) {
    Duration message_sent = DateTime.now().difference(date);
    if (message_sent < Duration(minutes: 1)) {
      return 'gerade eben';
    } else if (message_sent < Duration(hours: 1)) {
      return '${message_sent.inMinutes} Minuten';
    } else if (message_sent < Duration(hours: 12)) {
      return '${message_sent.inHours} Stunden';
    } else if (DateTime.now().difference(date) < Duration(days: 1)) {
      return ChronoHelfer.dateTimeToStringHHmm(date);
    } else if (DateTime.now().difference(date) < Duration(days: 7)) {
      return DateFormat('EEE, hh:mm').format(date);
    }

    return DateFormat('MMM d, hh:mm').format(date);
  }

  void backArrowPressed(BuildContext context) {
    if (textFieldHasFocus) {
      textFieldHasFocus = false;
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      Navigator.pop(context);
    }
  }
}
