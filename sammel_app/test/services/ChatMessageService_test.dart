import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/services/ChatMessageService.dart';

import '../shared/generated.mocks.dart';

void main() {
  late ChatMessageService service;
  MockStorageService storageService = MockStorageService();
  MockPushNotificationManager manager = MockPushNotificationManager();

  setUp(() {
    reset(storageService);
    service = ChatMessageService(storageService, manager, null);
  ***REMOVED***);

  group('getChannel', () {
    test('getChatChannel generates ActionChannel id', () {
      service.getActionChannel(5);

      verify(storageService.loadChatChannel('action:5')).called(1);
    ***REMOVED***);

    test('getChannel returns channel from storage if found', () async {
      var chatChannel = ChatChannel('action:5');
      when(storageService.loadChatChannel('action:5'))
          .thenAnswer((_) async => chatChannel);
      var result = await service.getChannel('action:5');

      expect(result, chatChannel);
    ***REMOVED***);

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
    ***REMOVED***);

    test('getChannel creates and returns new Channel if none found', () async {
      var result = await service.getChannel('action:5');

      expect(verify(storageService.saveChatChannel(captureAny)).captured.single,
          result);
      expect(result.id, 'action:5');
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
