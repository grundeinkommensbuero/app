
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_server/http_server.dart';
import 'package:mockito/annotations.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/LocalNotificationService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:easy_localization/src/translations.dart';

@GenerateMocks([
  StammdatenService,
  TermineService,
  ListLocationService,
  StorageService,
  PushSendService,
  UserService,
  ChatMessageService,
  PushNotificationManager,
  GeoService,
  FirebaseMessaging,
  Backend,
  LocalNotificationService,
  FirebaseReceiveService,
  Translations,
  HttpClientResponse,
  HttpClientResponseBody,
  DemoPushSendService,
])
// run `flutter pub run build_runner build` to generate Mocks
void main() {}