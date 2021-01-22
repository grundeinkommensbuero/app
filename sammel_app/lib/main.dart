import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/shared/ConstJsonAssetLoader.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';

import 'services/BackendService.dart';
import 'services/LocalNotificationService.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(EasyLocalization(
      preloaderWidget: Container(
          color: DweTheme.yellow, child: Image.asset('assets/images/logo.png')),
      supportedLocales: [Locale('en'), Locale('de')],
      path: 'none',
      assetLoader: ConstJsonAssetLoader(),
      fallbackLocale: Locale('en'),
      child: MyApp()));
***REMOVED***

const Mode mode = Mode.DEMO;
const version = '0.5.3+25';

***REMOVED***
***REMOVED***
***REMOVED***

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<TermineSeiteState> actionPageKey =
    GlobalKey<TermineSeiteState>();

class MyApp extends StatelessWidget {
  static var stammdatenService = StammdatenService();
  static var firebaseService = FirebaseReceiveService(pullMode);
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
  static var localNotificationService =
  LocalNotificationService(pushNotificationManager);
  var termineService = demoMode
      ? DemoTermineService(stammdatenService, userService)
      : TermineService(stammdatenService, userService, backend,
          pushNotificationManager, localNotificationService, actionPageKey);
  static var listLocationService = demoMode
      ? DemoListLocationService(userService)
      : ListLocationService(userService, backend);
  static var chatMessageService =
      ChatMessageService(storageService, pushNotificationManager, navigatorKey);
  static var geoService = GeoService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<StammdatenService>.value(value: stammdatenService),
          Provider<AbstractTermineService>.value(value: termineService),
          Provider<AbstractListLocationService>.value(
              value: listLocationService),
          Provider<StorageService>.value(value: storageService),
          Provider<AbstractPushSendService>.value(value: pushService),
          Provider<AbstractPushNotificationManager>.value(
              value: pushNotificationManager),
          Provider<ChatMessageService>.value(value: chatMessageService),
          Provider<AbstractUserService>.value(value: userService),
          Provider<GeoService>.value(value: geoService),
          Provider<LocalNotificationService>.value(
              value: localNotificationService),
        ],
        child: MaterialApp(
          title: 'DW & Co. Enteignen',
          theme: DweTheme.themeData,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: Navigation(actionPageKey, clearButton),
          navigatorKey: navigatorKey,
        ));
  ***REMOVED***
***REMOVED***

enum Mode { LOCAL, DEMO, TEST ***REMOVED***

***REMOVED***

get testMode => mode == Mode.TEST;
