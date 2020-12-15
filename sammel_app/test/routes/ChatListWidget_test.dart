import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/user_data.dart';
import 'package:sammel_app/routes/ChatListWidget.dart';
import 'package:sammel_app/services/UserService.dart';

import '../shared/Mocks.dart';

void main() {
  Widget widget;
  UserService _userService;
  ChatChannel channel;

  setUpUI((tester) async {
    _userService = ConfiguredUserServiceMock();
    channel = ChatChannel('action:1');
    widget = Provider<AbstractUserService>(
        create: (context) => _userService,
        child: MaterialApp(home: Scaffold(body: ChatListWidget(channel))));
  });

  group('ParticipationMessages', () {
    testUI('shows join message', (tester) async {
      await tester.pumpWidget(widget, Duration(minutes: 5));
      expect(find.byKey(Key('Participation Message Karl Marx')), findsNothing);

      channel.pushParticipationMessage(ParticipationMessage(
          true, DateTime(2020, 12, 13, 11, 22), 'Karl Marx', true));
      await tester.pump(Duration(minutes: 5));

      expect(
          find.byKey(Key('Participation Message Karl Marx')), findsOneWidget);
    });
  });
}
