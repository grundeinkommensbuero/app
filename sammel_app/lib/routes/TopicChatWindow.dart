import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/routes/ChatWindow.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';

class TopicChatWindow extends StatefulWidget {
  final ChatChannel channel;
  final bool buildHeader;

  TopicChatWindow(this.channel, this.buildHeader, {Key? key})
      : super(key: key);

  @override
  TopicChatWindowState createState() => TopicChatWindowState(channel);
}

class TopicChatWindowState extends State<TopicChatWindow>
    implements ChannelChangeListener {
  String title = "News".tr();
  late List<ChatMessage> messages;

  AbstractPushSendService? pushService;

  TopicChatWindowState(ChatChannel channel) {
    channel.registerChannelChangeListener(this);
    messages = channel.channelMessages.map((e) => e as ChatMessage).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.buildHeader ? AppBar(title: Text(title)) : null,
        body: Container(
            decoration: DweTheme.happyHouseBackground,
            child: Padding(
                child: ListView(
                  children: messages.reversed
                      .map((message) => buildMessageWidget(message))
                      .toList(),
                  reverse: true,
                ),
                padding: EdgeInsets.only(bottom: 40))));
  }

  Widget buildMessageWidget(ChatMessage message) {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            child: Card(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                color: message.messageColor,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, top: 8.0, right: 10.0, bottom: 8.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.senderName ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 3.0, bottom: 5.0),
                              child: SelectableText(
                                message.text ?? '',
                                textScaleFactor: 1.2,
                              )),
                          Text(
                            ChronoHelfer.formatDateTime(message.timestamp) ??
                                '',
                            textScaleFactor: 0.8,
                          ),
                        ])))));
  }

  @override
  void channelChanged(ChatChannel channel) =>
      setState(() => messages = channel.channelMessages as List<ChatMessage>);

  @override
  void dispose() {
    widget.channel.disposeListener();
    super.dispose();
  }
}
