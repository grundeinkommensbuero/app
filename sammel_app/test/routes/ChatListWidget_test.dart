import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/routes/ChatListWidget.dart';
import 'package:sammel_app/services/UserService.dart';

import '../shared/Trainer.dart';
import '../shared/generated.mocks.dart';

void main() {
  trainTranslation(MockTranslations());
  late Widget widget;
  UserService _userService;
  late ChatChannel channel;

  setUpUI((tester) async {
    _userService = MockUserService();
    channel = ChatChannel('action:1');
    widget = Provider<AbstractUserService>(
        create: (context) => _userService,
        child: MaterialApp(home: Scaffold(body: ChatListWidget(channel))));
  ***REMOVED***);

  group('ParticipationMessages', () {
    testUI('shows join message', (tester) async {
      await tester.pumpWidget(widget, Duration(minutes: 5));
      expect(find.byType(RichText), findsNothing);

      channel.pushParticipationMessage(ParticipationMessage(
          DateTime(2020, 12, 13, 11, 22), 'Karl Marx', true, true));
      await tester.pump(Duration(minutes: 5));

      expect(
          find.byWidgetPredicate((widget) =>
              widget is RichText &&
              widget.text.toPlainText() ==
                  'Karl Marx ist der Aktion beigetreten\nNeue Teilnehmer*innen können ältere Nachrichten nicht lesen'),
          findsOneWidget);
    ***REMOVED***);

    testUI('shows join message with unknown username', (tester) async {
      await tester.pumpWidget(widget, Duration(minutes: 5));
      expect(find.byType(RichText), findsNothing);

      channel.pushParticipationMessage(ParticipationMessage(
          DateTime(2020, 12, 13, 11, 22), null, true, true));
      await tester.pump(Duration(minutes: 5));

      expect(
          find.byWidgetPredicate((widget) =>
              widget is RichText &&
              widget.text.toPlainText() ==
                  'Jemand ist der Aktion beigetreten\nNeue Teilnehmer*innen können ältere Nachrichten nicht lesen'),
          findsOneWidget);
    ***REMOVED***);

    testUI('shows leave message', (tester) async {
      await tester.pumpWidget(widget, Duration(minutes: 5));
      expect(find.byType(RichText), findsNothing);

      channel.pushParticipationMessage(ParticipationMessage(
          DateTime(2020, 12, 13, 11, 22), 'Karl Marx', false, true));
      await tester.pump(Duration(minutes: 5));

      expect(
          find.byWidgetPredicate((widget) =>
              widget is RichText &&
              widget.text.toPlainText() ==
                  'Karl Marx hat die Aktion verlassen'),
          findsOneWidget);
    ***REMOVED***);

    testUI('shows leave message with unknown username', (tester) async {
      await tester.pumpWidget(widget, Duration(minutes: 5));
      expect(find.byType(RichText), findsNothing);

      channel.pushParticipationMessage(ParticipationMessage(
          DateTime(2020, 12, 13, 11, 22), null, false, true));
      await tester.pump(Duration(minutes: 5));

      expect(
          find.byWidgetPredicate((widget) =>
              widget is RichText &&
              widget.text.toPlainText() == 'Jemand hat die Aktion verlassen'),
          findsOneWidget);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
