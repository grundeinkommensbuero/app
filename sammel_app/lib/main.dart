import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/PushService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/ChatMessageService.dart';
import 'package:sammel_app/shared/ChatWindow.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/push_notification_manager.dart';
import 'package:sammel_app/shared/user_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
***REMOVED***


const Mode mode = Mode.LOCAL;

class MyApp extends StatelessWidget {

  PushNotificationsManager pnm = PushNotificationsManager();
  ChatMessageService cms = ChatMessageService();

  MyApp() {
    pnm.init();
    pnm.register_message_callback(PushDataTypes.SimpleChatMessage, cms);
  ***REMOVED***

  @override
  Widget build(BuildContext context) {
    SimpleMessageChannel smc = SimpleMessageChannel('SimpleMessageChannel');
    cms.register_channel(smc);

    return MultiProvider(
        providers: [
          Provider<AbstractTermineService>.value(
              value: demoMode ? DemoTermineService() : TermineService()),
          Provider<AbstractStammdatenService>.value(
              value: demoMode ? DemoStammdatenService() : StammdatenService()),
          Provider<AbstractListLocationService>.value(
              value:
                  demoMode ? DemoListLocationService() : ListLocationService()),
          Provider<StorageService>.value(value: StorageService()),
          Provider<PushService>.value(
              value: demoMode ? DemoPushService() : PushService()),
         Provider<PushNotificationsManager>.value(value: pnm),
         Provider<ChatMessageService>.value(value: cms)],
        child: MaterialApp(
          title: 'DW & Co. Enteignen',
          theme: DweTheme.themeData,
          home: Navigation()
        ));
  ***REMOVED***
***REMOVED***

enum Mode { LOCAL, DEMO, TEST ***REMOVED***

***REMOVED***

get testMode => mode == Mode.TEST;
