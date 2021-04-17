import 'package:easy_localization/src/translations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mockito/annotations.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/LocalNotificationService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';

@GenerateMocks([
  TermineService,
  ListLocationService,
  PushSendService,
  UserService,
  ChatMessageService,
  PushNotificationManager,
  Backend,
  LocalNotificationService,
  Translations,
  DemoPushSendService,
  StammdatenService,
  FlutterLocalNotificationsPlugin,
], customMocks: [
  MockSpec<StorageService>(returnNullOnMissingStub: true),
  MockSpec<FirebaseReceiveService>(returnNullOnMissingStub: true)
])
// run `flutter pub run build_runner build` to generate Mocks
void main() {***REMOVED***
