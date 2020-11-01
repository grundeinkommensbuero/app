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

import 'ChatInput.dart';
import 'ChatListWidget.dart';
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

class ChatWindowState extends State<ChatWindow> {
  FocusNode myFocusNode;

  bool textFieldHasFocus = false;

  ChatWindowState(this.channel, this.termin) {}

  SimpleMessageChannel channel = null;
  Termin termin = null;
  User user = null;
  AbstractPushService pushService = null;
  ChatListWidget widget_list;
  ScrollController scroll_controller;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      Provider.of<AbstractUserService>(context).user_stream.stream.listen((user) => setState(() => this.user = user));
      pushService = Provider.of<AbstractPushService>(context);
      this.user = Provider.of<AbstractUserService>(context).internal_user_object;

    }

    var inputWidget = ChatInputWidget(onSendMessage);
    this.widget_list = ChatListWidget(this.user, this.channel);
    var header_widget = buildHeader(widget.termin);
    Scaffold page = Scaffold(
        appBar: header_widget,
        body: Padding(child: this.widget_list, padding: EdgeInsets.only(bottom: 40)),
        bottomSheet: inputWidget);
    return page;
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
      users.insert(0, Padding(padding: EdgeInsets.only(left: 15, top: 5, bottom: 5), child: Text('${users.length+a_count} Teilnehmer im Chat', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))));
      if(a_count > 0)
        {
          users.add(create_user_widget('+ $a_count weitere Teilnehmer', Colors.black));
        }
      return Column(children: users);
    }
  }

  Padding create_user_widget(String user_name, Color user_color) => Padding(padding: EdgeInsets.only(left: 15, top: 5, bottom: 5), child: Row(children: [Icon(Icons.person, color: user_color,size: 55,),SizedBox(width: 10,),Text(user_name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal))]));

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
    //textEditingController.clear();
    // myFocusNode.unfocus();
    channel.channelCallback(message);
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

  void backArrowPressed(BuildContext context) {
    if (textFieldHasFocus) {
      textFieldHasFocus = false;
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      Navigator.pop(context);
    }
  }
}
