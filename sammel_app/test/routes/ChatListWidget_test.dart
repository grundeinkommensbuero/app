import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/ChatChannel.dart';
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
      expect(find.byType(RichText), findsNothing);

      channel.pushParticipationMessage(ParticipationMessage(
          true, DateTime(2020, 12, 13, 11, 22), 'Karl Marx', true));
      await tester.pump(Duration(minutes: 5));

      expect(find.byKey(Key('Participation Message')), findsOneWidget);
      expect(
          find.byWidgetPredicate((widget) =>
              widget is RichText &&
              widget.text.toPlainText() ==
                  'Karl Marx ist der Aktion beigetreten\nNeue Teilnehmer*innen können ältere Nachrichten nicht lesen'),
          findsOneWidget);
    });

    testUI('shows join message with unknown username', (tester) async {
      await tester.pumpWidget(widget, Duration(minutes: 5));
      expect(find.byType(RichText), findsNothing);

      channel.pushParticipationMessage(ParticipationMessage(
          true, DateTime(2020, 12, 13, 11, 22), null, true));
      await tester.pump(Duration(minutes: 5));

      expect(find.byKey(Key('Participation Message')), findsOneWidget);
      expect(
          find.byWidgetPredicate((widget) =>
              widget is RichText &&
              widget.text.toPlainText() ==
                  'Jemand ist der Aktion beigetreten\nNeue Teilnehmer*innen können ältere Nachrichten nicht lesen'),
          findsOneWidget);
    });

    testUI('shows leave message', (tester) async {
      await tester.pumpWidget(widget, Duration(minutes: 5));
      expect(find.byType(RichText), findsNothing);

      channel.pushParticipationMessage(ParticipationMessage(
          true, DateTime(2020, 12, 13, 11, 22), 'Karl Marx', false));
      await tester.pump(Duration(minutes: 5));

      expect(find.byKey(Key('Participation Message')), findsOneWidget);
      expect(
          find.byWidgetPredicate((widget) =>
              widget is RichText &&
              widget.text.toPlainText() ==
                  'Karl Marx hat die Aktion verlassen'),
          findsOneWidget);
    });

    testUI('shows leave message with unknown username', (tester) async {
      await tester.pumpWidget(widget, Duration(minutes: 5));
      expect(find.byType(RichText), findsNothing);

      channel.pushParticipationMessage(ParticipationMessage(
          true, DateTime(2020, 12, 13, 11, 22), null, false));
      await tester.pump(Duration(minutes: 5));

      expect(find.byKey(Key('Participation Message')), findsOneWidget);
      expect(
          find.byWidgetPredicate((widget) =>
              widget is RichText &&
              widget.text.toPlainText() == 'Jemand hat die Aktion verlassen'),
          findsOneWidget);
    });
  });
}
