import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';

import '../shared/Mocks.dart';

main() {
  late PushNotificationManager manager;
  StorageService storageService = StorageServiceMock();
  FirebaseReceiveService firebaseMock = FirebaseReceiveServiceMock();
  Backend backend = BackendMock();
  UserService userService = ConfiguredUserServiceMock();

  setUp(() {
    reset(backend);
    reset(storageService);
    reset(firebaseMock);
    when(firebaseMock.token).thenAnswer((_) async => "firebase-token");
    when(storageService.isPullMode()).thenAnswer((_) async => false);
    manager = PushNotificationManager(
        storageService, userService, firebaseMock, backend);
  });

  group('createPushListener', () {
    test('erzeugt PullService, wenn bereits im Pull-Modus', () async {
      when(storageService.isPullMode()).thenAnswer((_) async => true);

      await manager.createPushListener(firebaseMock, backend);

      expect(true, manager.listener is PullService);
    });

    test('hinterlegt Firebase-Service, wenn Token nicht null ist', () async {
      await manager.createPushListener(firebaseMock, backend);

      expect(true, manager.listener is FirebaseReceiveService);
    });

    test('erzeugt PullService, wenn Token null ist', () async {
      when(firebaseMock.token).thenAnswer((_) async => null);
      await manager.createPushListener(firebaseMock, backend);

      expect(true, manager.listener is PullService);
    });

    test('speichert als Pull-Modus, wenn Token null ist', () async {
      when(firebaseMock.token).thenAnswer((_) async => null);
      await manager.createPushListener(firebaseMock, backend);

      verify(storageService.markPullMode()).called(1);
    });
  });

  group('DemoPushNotificationManager', () {
    DemoPushSendService pushSendService = DemoPushSendServiceMock();
    DemoPushNotificationManager service =
        DemoPushNotificationManager(pushSendService);
    late StreamController<PushData> controller;

    setUp(() {
      reset(pushSendService);
      controller = StreamController<PushData>.broadcast(sync: true);
      when(pushSendService.stream).thenAnswer((_) => controller.stream);
    });

    test('serves push messages to correct listener', () async {
      var listener1 = TestListener();
      var listener2 = TestListener();
      service.registerMessageCallback('type1', listener1);
      service.registerMessageCallback('type2', listener2);

      var data1 = TestPushData('type1');
      var data2 = TestPushData('type1');
      var data3 = TestPushData('type2');
      controller.add(data1);
      controller.add(data2);
      controller.add(data3);

      expect(listener1.nachrichten.length, 2);
      expect(listener1.nachrichten[0]['type'], 'type1');
      expect(listener1.nachrichten[1]['type'], 'type1');
      expect(listener2.nachrichten.length, 1);
      expect(listener2.nachrichten[0]['type'], 'type2');
    });

    test('works without listeners', () async {
      controller.add(TestPushData('type1'));
    });

    tearDown(() {
      controller.close();
    });
  });
}

class TestListener implements PushNotificationListener {
  List<Map<String, dynamic>> nachrichten = [];

  @override
  void receiveMessage(Map<String, dynamic> data) {
    nachrichten.add(data);
  }

  @override
  void handleNotificationTap(Map<dynamic, dynamic> data) {
  }

  @override
  void updateMessages(List<Map<String, dynamic>> data) {}
}

class TestPushData extends PushData {
  String type;

  TestPushData(this.type);
}
