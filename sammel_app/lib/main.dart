import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';

import 'services/BackendService.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

const Mode mode = Mode.LOCAL;
const version = '0.3.4+12';

// Debug
const bool pullMode = false;
const bool clearButton = false;

class MyApp extends StatelessWidget {
  static var firebaseService = FirebaseReceiveService();
  static var storageService = StorageService();
  static final backend = Backend(version);
  static final userService = demoMode
      ? DemoUserService()
      : UserService(storageService, firebaseService, backend);
  static var pushService = demoMode
      ? DemoPushSendService(userService)
      : PushSendService(userService, backend);
  static var pushNotificationManager = demoMode
      ? DemoPushNotificationManager(pushService)
      : PushNotificationManager(
          storageService, userService, firebaseService, backend);
  static var stammdatenService = StammdatenService();
  var termineService = demoMode
      ? DemoTermineService(userService, stammdatenService)
      : TermineService(userService, stammdatenService, backend);
  static var listLocationService = demoMode
      ? DemoListLocationService(userService)
      : ListLocationService(userService, backend);
  static var chatMessageService =
      ChatMessageService(storageService, pushNotificationManager);
  static var geoService = GeoService();

  @override
  Widget build(BuildContext context) {
    //FIXME kann das weg? >
    // ChatChannel smc = ChatChannel('SimpleMessageChannel');
    // chatMessageService.register_channel(smc);
    // <

    return MultiProvider(
        providers: [
          Provider<AbstractTermineService>.value(value: termineService),
          Provider<StammdatenService>.value(value: stammdatenService),
          Provider<AbstractListLocationService>.value(
              value: listLocationService),
          Provider<StorageService>.value(value: storageService),
          Provider<AbstractPushSendService>.value(value: pushService),
          Provider<AbstractPushNotificationManager>.value(
              value: pushNotificationManager),
          Provider<ChatMessageService>.value(value: chatMessageService),
          Provider<AbstractUserService>.value(value: userService),
          Provider<GeoService>.value(value: geoService),
        ],
        child: MaterialApp(
            title: 'DW & Co. Enteignen',
            theme: DweTheme.themeData,
            home: Navigation(clearButton)));
  }
}

enum Mode { LOCAL, DEMO, TEST }

get demoMode => mode == Mode.DEMO;

get testMode => mode == Mode.TEST;
