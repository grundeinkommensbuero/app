import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/StorageService.dart';

import '../shared/Mocks.dart';

void main() {
  late ChatMessageService service;
  StorageService storageService = StorageServiceMock();
  PushNotificationManager manager = PushNotificationManagerMock();

  setUp(() {
    reset(storageService);
    service = ChatMessageService(storageService, manager, null);
  });

  group('getChannel', () {
    test('getChatChannel generates ActionChannel id', () {
      service.getActionChannel(5);

      verify(storageService.loadChatChannel('action:5')).called(1);
    });

    test('getChannel returns channel from storage if found', () async {
      var chatChannel = ChatChannel('action:5');
      when(storageService.loadChatChannel('action:5'))
          .thenAnswer((_) async => chatChannel);
      var result = await service.getChannel('action:5');

      expect(result, chatChannel);
    });

    test('getChannel stores channel in internal list and returns that later',
        () async {
      var chatChannel = ChatChannel('action:5');
      when(storageService.loadChatChannel('action:5'))
          .thenAnswer((_) async => chatChannel);
      await service.getChannel('action:5');

      when(storageService.loadChatChannel('action:5'))
          .thenAnswer((_) async => null);
      var result = await service.getChannel('action:5');

      expect(result, chatChannel);
    });

    test('getChannel creates and returns new Channel if none found', () async {
      var result = await service.getChannel('action:5');

      expect(verify(storageService.saveChatChannel(captureAny)).captured.single,
          result);
      expect(result.id, 'action:5');
    });
  });
}
