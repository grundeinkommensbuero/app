import 'package:easy_localization/easy_localization.dart';
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
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/showUsernameDialog.dart';

import 'ChatInput.dart';
import 'ChatListWidget.dart';

class ChatWindow extends StatefulWidget {
  final ChatChannel channel;
  final Termin termin;
  final bool writable;

  ChatWindow(this.channel, this.termin, this.writable, {Key? key})
      : super(key: key);

  @override
  ChatWindowState createState() => ChatWindowState(channel, termin);
}

abstract class ChannelChangeListener {
  void channelChanged(ChatChannel channel);
}

class ChatWindowState extends State<ChatWindow> {
  FocusNode? focusNode;
  bool initialized = false;
  bool textFieldHasFocus = false;

  ChatChannel channel;
  Termin termin;
  User? user;
  AbstractPushSendService? pushService;
  late ChatListWidget widgetList;
  ScrollController? scrollController;

  ChatWindowState(this.channel, this.termin) {
    this.widgetList = ChatListWidget(this.channel);
  }

  @override
  Widget build(BuildContext context) {
    if (initialized == false) {
      Provider.of<AbstractUserService>(context)
          .user
          .listen((user) => setState(() => this.user = user));
      pushService = Provider.of<AbstractPushSendService>(context);
      initialized = true;
    }

    var inputWidget;
    if (widget.writable) {
      inputWidget = ChatInputWidget(onSendMessage);
    }
    var headerWidget = buildHeader(widget.termin);
    Scaffold page = Scaffold(
        appBar: headerWidget,
        body: Column(children: [
          Expanded(child: this.widgetList),
          widget.writable ? inputWidget : null
        ]));
    return page;
  }

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
                    text: termin.ort.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ], style: TextStyle(color: DweTheme.purple, fontSize: 13.0)),
              softWrap: false,
              overflow: TextOverflow.fade),
          Text(
              'am ${ChronoHelfer.formatDateOfDateTime(termin.beginn)}, um ${ChronoHelfer.dateTimeToStringHHmm(termin.beginn)} Uhr',
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal),
              overflow: TextOverflow.fade)
        ]),
        actions: <Widget>[
          termin.participants != null
              ? IconButton(
                  icon: const Icon(Icons.people),
                  tooltip: 'Show Chat Member',
                  onPressed: () {
                    openMemberPage(context, termin.participants!);
                  },
                )
              : Container(),
        ]);
  }

  void openMemberPage(BuildContext context, List<User> participants) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Teilnehmer*innen').tr(),
          ),
          body: createMemberListWidget(participants),
        );
      },
    ));
  }

  Widget createMemberListWidget(List<User> participants) {
    if (participants.length == 0) {
      return Text('Keine Teilnehmer*innen').tr();
    } else {
      List<Widget> users = participants
          .where((user) => user.name != null && user.name!.isEmpty)
          .where((user) => user.color != null)
          .map((user) => createUserWidget(user.name!, user.color!))
          .toList();
      int aCount = participants
          .where((user) => user.name == null || user.name == '')
          .length;
      users.insert(
          0,
          Padding(
              padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
              child: Text('{count} Teilnehmer*innen im Chat',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal))
                  .tr(namedArgs: {
                'count': (users.length + aCount).toString()
              })));
      if (aCount > 0) {
        users.add(createUserWidget(
            '+ {count} weitere Teilnehmer*innen'
                .tr(namedArgs: {'count': aCount.toString()}),
            Colors.black));
      }
      return SingleChildScrollView(child: Column(children: users));
    }
  }

  Padding createUserWidget(String name, Color color) => Padding(
      padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
      child: Row(children: [
        Icon(
          Icons.person,
          color: color,
          size: 55,
        ),
        SizedBox(
          width: 10,
        ),
        Text(name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal))
      ]));

  onSendMessage(TextEditingController controller) async {
    if (pushService == null) return;
    if (controller.text == "") return;
    if (termin.id == null) return;

    var name = user?.name;
    if (isBlank(name)) {
      name = await showUsernameDialog(context: context);
      if (name == null) return;
    }

    ChatMessage message = ChatMessage(
        text: controller.text,
        timestamp: DateTime.now(),
        messageColor: user?.color,
        senderName: name,
        userId: user?.id);
    ChatPushData mpd =
        ActionChatMessagePushData(message, termin.id!, channel.id);
    pushService!.pushToAction(
        widget.termin.id!,
        mpd,
        PushNotification(
            'Neue Chat-Nachricht',
            "Zu ${termin.typ} "
                'am ${ChronoHelfer.formatDateOfDateTime(termin.beginn)}, '
                'um ${ChronoHelfer.dateTimeToStringHHmm(termin.beginn)} '
                ', ${termin.ort.ortsteil}'));
    channel.pushMessages([message]);
    Provider.of<StorageService>(context, listen: false)
        .saveChatChannel(channel);
    controller.clear();
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode!.addListener(onFocusChange);
  }

  @override
  void dispose() {
    this.channel.disposeListener();
    focusNode?.dispose();
    super.dispose();
  }

  void onFocusChange() {
    if (focusNode?.hasFocus ?? false) {
      textFieldHasFocus = true;
    }
  }

  void backArrowPressed(BuildContext context) {
    if (textFieldHasFocus) {
      textFieldHasFocus = false;
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      this.channel.disposeListener();
      focusNode?.dispose();
      Navigator.pop(context);
    }
  }
}
