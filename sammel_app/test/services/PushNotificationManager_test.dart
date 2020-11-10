import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';

import '../shared/Mocks.dart';

main() {
  PushNotificationManager manager;
  StorageService storageService = StorageServiceMock();
  FirebaseReceiveService firebaseMock = FirebaseReceiveServiceMock();
  Backend backend = BackendMock();
  UserService userService = ConfiguredUserServiceMock();

  setUp(() {
    reset(backend);
    reset(storageService);
    reset(firebaseMock);
    when(firebaseMock.token).thenAnswer((_) async => "firebase-token");
    manager = PushNotificationManager(
        storageService, userService, firebaseMock, backend);
  ***REMOVED***);

  group('createPushListener', () {
    test('hinterlegt Firebase-Service, wenn Token nicht null ist', () async {
      await manager.createPushListener(firebaseMock, backend);

      expect(true, manager.listener is FirebaseReceiveService);
    ***REMOVED***);

    test('erzeugt PullService, wenn Token null ist', () async {
      when(firebaseMock.token).thenAnswer((_) async => null);
      await manager.createPushListener(firebaseMock, backend);

      expect(true, manager.listener is PullReceiveService);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
