import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/routes/TopicChatWindow.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';

class ChatPage extends StatefulWidget {
  final bool active;

  ChatPage({this.active = false***REMOVED***);

  @override
  State<StatefulWidget> createState() => ChatPageState();
***REMOVED***

class ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  AbstractPushNotificationManager? pushManager;
  ChatMessageService? chatMessageService;
  TopicChatWindow? chatWindow;
  ChatChannel? topicChannel;

  ChatPageState();

  @override
  Widget build(BuildContext context) {
    if (topicChannel == null) {
      pushManager = Provider.of<AbstractPushNotificationManager>(context);
      chatMessageService = Provider.of<ChatMessageService>(context);
      Provider.of<ChatMessageService>(context)
          .getTopicChannel('global')
          .then((channel) => setState(() => topicChannel = channel));
    ***REMOVED***
    if (!widget.active) {
      // navigiert weg
      chatWindow = null;
      topicChannel?.disposeListener();
    ***REMOVED*** else if (topicChannel != null) {
      // ist bereit
      if (chatWindow == null)
        chatWindow = TopicChatWindow(topicChannel!, false);
      return chatWindow!;
    ***REMOVED***
    // navigiert hin, ist aber noch nicht bereit
    return Center(
        child: Container(
            decoration: CampaignTheme.background,
            height: 100,
            width: 100,
            child: Container(color: Colors.white)));
  ***REMOVED***

  @override
  void initState() {
    // for didChangeAppLifecycleState
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  ***REMOVED***

  @override
  void dispose() {
    // for didChangeAppLifecycleState
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  ***REMOVED***

// Lade verpasste Push-Nachrichten vom Server nach
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) pushManager?.updateMessages();
  ***REMOVED***
***REMOVED***
