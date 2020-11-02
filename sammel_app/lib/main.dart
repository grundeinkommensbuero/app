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
import 'package:sammel_app/shared/user_data.dart';
import 'package:sammel_app/shared/PushNotificationManager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
***REMOVED***

const Mode mode = Mode.DEMO;

class MyApp extends StatelessWidget {
  static var storageService = StorageService();
  static var pushNotificationManager = PushNotificationManager(storageService);
  static final userService = demoMode
      ? DemoUserService()
      : UserService(storageService, pushNotificationManager);
  var termineService =
      demoMode ? DemoTermineService(userService) : TermineService(userService);
  static var stammdatenService = demoMode
      ? DemoStammdatenService(userService)
      : StammdatenService(userService);
  static var listLocationService = demoMode
      ? DemoListLocationService(userService)
      : ListLocationService(userService);
  static var pushService =
      demoMode ? DemoPushService(userService) : PushService(userService);
  static var chatMessageService = ChatMessageService();

  MyApp() {
    pushNotificationManager.init();
    pushNotificationManager.register_message_callback(
        PushDataTypes.SimpleChatMessage, chatMessageService);
  ***REMOVED***

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
          Provider<AbstractPushService>.value(value: pushService),
          Provider<PushNotificationManager>.value(
              value: pushNotificationManager),
          Provider<ChatMessageService>.value(value: chatMessageService),
          Provider<AbstractUserService>.value(value: userService),
        ],
        child: MaterialApp(
            title: 'DW & Co. Enteignen',
            theme: DweTheme.themeData,
            home: Navigation()));
  ***REMOVED***
***REMOVED***

enum Mode { LOCAL, DEMO, TEST ***REMOVED***

***REMOVED***

get testMode => mode == Mode.TEST;
