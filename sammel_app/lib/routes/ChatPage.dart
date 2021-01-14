import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/routes/TopicChatWindow.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';

class ChatPage extends StatefulWidget {

  bool isActive = false;

  @override
  State<StatefulWidget> createState() => ChatPageState(this, isActive);
}

class ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  AbstractPushNotificationManager pushManager;
  ChatMessageService chatMessageService;
  TopicChatWindow chat_window = null;
  bool isActive;
  ChatPage parentPage;

  ChatPageState(parentPage, isActive)
  {
    print("isActive $isActive");
    this.isActive = isActive;
    this.parentPage = parentPage;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this); // for didChangeAppLifecycleState

  }

  @override
  Widget build(BuildContext context) {
    if (chatMessageService == null) {
      chatMessageService = Provider.of<ChatMessageService>(context);
      pushManager = Provider.of<AbstractPushNotificationManager>(context);
    }

    if(chat_window == null && parentPage.isActive) {
      print("triggering future");
      Future<ChatChannel> globalChatChannel = Provider.of<ChatMessageService>(
          context).getTopicChannel("global");
      globalChatChannel.then((value) => setState(() => chat_window = TopicChatWindow(value, false)));
      return Center(child: Container(height: 100, width: 100,child: LoadingIndicator(
          indicatorType: Indicator.ballRotateChase, color: Color.fromARGB(100, 128, 128, 128))));
    }
    else if(!parentPage.isActive)
      {
        print("returning sized box");
        return SizedBox(width: 10, height: 10);
      }
    else{
      return chat_window;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // for didChangeAppLifecycleState
    super.dispose();
  }

  // Lädt Speicher neu nach, falls sich im Schlaf etwas geändert hat
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      chatMessageService.reload();
      pushManager.updateMessages();
    }
  }
}
