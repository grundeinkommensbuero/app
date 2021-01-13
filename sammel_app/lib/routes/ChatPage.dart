import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  ChatMessageService chatMessageService;
  PushNotificationManager pushManager;

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
    return Container();
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
