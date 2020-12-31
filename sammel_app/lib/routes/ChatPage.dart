import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/services/ChatMessageService.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatPageState();
***REMOVED***

class ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  ChatMessageService chatMessageService;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this); // for didChangeAppLifecycleState
  ***REMOVED***

  @override
  Widget build(BuildContext context) {
    if (chatMessageService == null)
      chatMessageService = Provider.of<ChatMessageService>(context);
    return Container();
  ***REMOVED***

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // for didChangeAppLifecycleState
    super.dispose();
  ***REMOVED***

  // Lädt Speicher neu nach, falls sich im Schlaf etwas geändert hat
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) chatMessageService.reload();
  ***REMOVED***
***REMOVED***
