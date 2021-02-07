import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/routes/TopicChatWindow.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/shared/DweTheme.dart';

class ChatPage extends StatefulWidget {
  bool active = false;

  ChatPage({this.active***REMOVED***);

  @override
  State<StatefulWidget> createState() => ChatPageState();
***REMOVED***

class ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  AbstractPushNotificationManager pushManager;
  ChatMessageService chatMessageService;
  TopicChatWindow chat_window;
  ChatChannel topicChannel;

  ChatPageState();

  @override
  Widget build(BuildContext context) {
    if (topicChannel == null) {
      pushManager = Provider.of<AbstractPushNotificationManager>(context);
      chatMessageService = Provider.of<ChatMessageService>(context);
      Provider.of<ChatMessageService>(context)
          .getTopicChannel("global")
          .then((channel) => setState(() => topicChannel = channel));
    ***REMOVED***
    if (!widget.active) {
      // navigiert weg
      chat_window = null;
      topicChannel?.disposeListener();
    ***REMOVED*** else if (topicChannel != null) {
      // ist bereit
      if (chat_window == null)
        chat_window = TopicChatWindow(topicChannel, false);
      return chat_window;
    ***REMOVED***
    // navigiert hin, ist aber noch nicht bereit
    return Center(
        child: Container(
            decoration: DweTheme.happyHouseBackground,
            height: 100,
            width: 100,
            child: LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                color: Color.fromARGB(100, 128, 128, 128))));
  ***REMOVED***

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this); // for didChangeAppLifecycleState
  ***REMOVED***

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // for didChangeAppLifecycleState
    super.dispose();
  ***REMOVED***

// Lade verpasste Push-Nachrichten vom Server nach
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) pushManager.updateMessages();
  ***REMOVED***
***REMOVED***
