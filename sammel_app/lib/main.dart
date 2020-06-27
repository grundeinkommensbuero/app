import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/PushService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChatMessageService.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/push_notification_manager.dart';
import 'package:sammel_app/shared/user_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

const Mode mode = Mode.LOCAL;

class MyApp extends StatelessWidget {
  PushNotificationsManager pnm = PushNotificationsManager();
  static var termineService =
      demoMode ? DemoTermineService() : TermineService();
  static var stammdatenService =
      demoMode ? DemoStammdatenService() : StammdatenService();
  static var listLocationService =
      demoMode ? DemoListLocationService() : ListLocationService();
  static var storageService = StorageService();
  static var pushService = demoMode ? DemoPushService() : PushService();
  static var chatMessageService = ChatMessageService();
  static var userService = UserService(storageService);

  MyApp() {
    pnm.init();
    pnm.register_message_callback(
        PushDataTypes.SimpleChatMessage, chatMessageService);
  }

  @override
  Widget build(BuildContext context) {
    SimpleMessageChannel smc = SimpleMessageChannel('SimpleMessageChannel');
    chatMessageService.register_channel(smc);

    return MultiProvider(
        providers: [
          Provider<AbstractTermineService>.value(value: termineService),
          Provider<AbstractStammdatenService>.value(value: stammdatenService),
          Provider<AbstractListLocationService>.value(
              value: listLocationService),
          Provider<StorageService>.value(value: storageService),
          Provider<PushService>.value(value: pushService),
          Provider<PushNotificationsManager>.value(value: pnm),
          Provider<ChatMessageService>.value(value: chatMessageService)
        ],
        child: MaterialApp(
            title: 'DW & Co. Enteignen',
            theme: DweTheme.themeData,
            home: Navigation()));
  }
}

enum Mode { LOCAL, DEMO, TEST }

get demoMode => mode == Mode.DEMO;

get testMode => mode == Mode.TEST;
