import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChatMessageService.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/user_data.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

const Mode mode = Mode.DEMO;
const bool pullMode = false;

class MyApp extends StatelessWidget {
  static var firebaseService = FirebaseReceiveService();
  static var storageService = StorageService();
  static final userService = demoMode
      ? DemoUserService()
      : UserService(storageService, firebaseService);
  static var pushService = demoMode
      ? DemoPushSendService(userService)
      : PushSendService(userService);
  static var pushNotificationManager = demoMode
      ? PushNotificationManager(storageService, userService, firebaseService)
      : DemoPushNotificationManager(pushService);
  var termineService =
      demoMode ? DemoTermineService(userService) : TermineService(userService);
  static var stammdatenService = demoMode
      ? DemoStammdatenService(userService)
      : StammdatenService(userService);
  static var listLocationService = demoMode
      ? DemoListLocationService(userService)
      : ListLocationService(userService);
  static var chatMessageService = ChatMessageService(pushNotificationManager);

  MyApp() {}

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
          Provider<AbstractPushSendService>.value(value: pushService),
          Provider<PushNotificationManager>.value(
              value: pushNotificationManager),
          Provider<ChatMessageService>.value(value: chatMessageService),
          Provider<AbstractUserService>.value(value: userService),
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
