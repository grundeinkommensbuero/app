import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/Provisioning.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/ArgumentsService.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/FAQService.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/PlacardsService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/services/VisitedHousesService.dart';
import 'package:sammel_app/shared/ConstJsonAssetLoader.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';

import 'services/BackendService.dart';
import 'services/LocalNotificationService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('de'),
        Locale('ru'),
        Locale('fr')
      ],
      path: 'none',
      assetLoader: ConstJsonAssetLoader(),
      fallbackLocale: Locale('en'),
      child: MyApp()));
***REMOVED***

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<TermineSeiteState> actionPageKey =
    GlobalKey<TermineSeiteState>();

class MyApp extends StatelessWidget {
  static var stammdatenService = StammdatenService();
  static var firebaseService = FirebaseReceiveService(pullMode);
  static var storageService = StorageService();
  static final backend = Backend();
  static final userService = demoMode
      ? DemoUserService()
      : UserService(storageService, firebaseService, backend);
  static var pushService = demoMode
      ? DemoPushSendService(userService)
      : PushSendService(userService, backend);
  static var pushNotificationManager = demoMode
      ? DemoPushNotificationManager(pushService as DemoPushSendService)
      : PushNotificationManager(
          storageService, userService, firebaseService, backend);
  static var localNotificationService =
      LocalNotificationService(pushNotificationManager);
  static var termineService = demoMode
      ? DemoTermineService(stammdatenService, userService, actionPageKey)
      : TermineService(
          stammdatenService,
          userService,
          backend,
          pushNotificationManager as PushNotificationManager,
          localNotificationService,
          actionPageKey);
  static var listLocationService = demoMode
      ? DemoListLocationService(userService)
      : ListLocationService(userService, backend);
  static var chatMessageService =
      ChatMessageService(storageService, pushNotificationManager, navigatorKey);
  static var geoService = GeoService();
  static AbstractFAQService faqService = demoMode
      ? DemoFAQService() as AbstractFAQService
      : FAQService(storageService, userService, backend);
  static var placardService = demoMode
      ? DemoPlacardsService(userService)
      : PlacardsService(userService, backend);
  static var argumentsService = demoMode
      ? DemoArgumentsService(userService)
      : ArgumentsService(userService, backend);
  static var visitedHouseService = demoMode
      ? DemoVisitedHousesService(userService, geoService)
      : VisitedHousesService(geoService, userService, backend);

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
          Provider<AbstractFAQService>.value(value: faqService),
          Provider<AbstractVisitedHousesService>.value(
              value: visitedHouseService),
          Provider(create: (_) => placardService),
          Provider<AbstractPlacardsService>(create: (_) => placardService),
          Provider<AbstractArgumentsService>(create: (_) => argumentsService)
        ],
        child: MaterialApp(
          title: 'Expedition Grundeinkommen',
          theme: CampaignTheme.themeData,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: Navigation(actionPageKey, GlobalKey(), clearButton),
          navigatorKey: navigatorKey,
        ));
  ***REMOVED***
***REMOVED***
