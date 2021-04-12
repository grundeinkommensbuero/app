import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/FAQService.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';

import '../model/Termin_test.dart';
import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.trainer.dart';
import 'ActionEditor_test.dart';

final _stammdatenService = MockStammdatenService();
final _termineService = MockTermineService();
final _listLocationService = MockListLocationService();
final _storageService = MockStorageService();
final _pushService = MockPushSendService();
final _userService = MockUserService();
final _chatService = MockChatMessageService();
final _pushManager = MockPushNotificationManager();
final _faqService = MockFAQService();

void main() {
  trainTranslation(MockTranslations());
  trainUserService(_userService);
  trainStammdatenService(_stammdatenService);
  trainChatMessageService(_chatService);
  trainStorageService(_storageService);
  initializeDateFormatting('de');

  setUp(() => HttpOverrides.global = MapHttpOverrides());

  group('Navigation', () {
    late Navigation navigation;
    var actionPage = GlobalKey(debugLabel: 'action page');

    setUpUI((WidgetTester tester) async {
      navigation = Navigation(actionPage);
      when(_storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => []);
      when(_storageService.loadMyKiez()).thenAnswer((_) async => []);
      when(_storageService.loadNotificationInterval())
          .thenAnswer((_) async => 'nie');
      when(_listLocationService.getActiveListLocations())
          .thenAnswer((_) async => []);
      when(_storageService.loadFilter())
          .thenAnswer((_) async => TermineFilter.leererFilter());
      when(_termineService.loadActions(any)).thenAnswer((_) async => []);
      when(_pushManager.pushToken).thenAnswer((_) async => 'Token');
      trainFAQService(_faqService);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<StammdatenService>.value(value: _stammdatenService),
        Provider<AbstractTermineService>.value(value: _termineService),
        Provider<AbstractListLocationService>.value(
            value: _listLocationService),
        Provider<StorageService>.value(value: _storageService),
        Provider<AbstractPushSendService>.value(value: _pushService),
        Provider<AbstractUserService>.value(value: _userService),
        Provider<ChatMessageService>.value(value: _chatService),
        Provider<AbstractPushNotificationManager>.value(value: _pushManager),
        Provider<AbstractFAQService>.value(value: _faqService),
      ], child: MaterialApp(home: navigation)));
    ***REMOVED***);

    testUI('starts and shows correct Titel', (WidgetTester tester) async {
      expect(find.text('Aktionen'), findsOneWidget);
    ***REMOVED***);

    testUI('shows all items', (WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action page navigation button')), findsOneWidget);
      expect(
          find.byKey(Key('action creator navigation button')), findsOneWidget);
      expect(find.byKey(Key('faq navigation button')), findsOneWidget);
    ***REMOVED***);

    testUI('starts with ActionPage ', (WidgetTester tester) async {
      NavigationState state = tester.state(find.byWidget(navigation));
      expect(state.navigation, 0);
      expect(find.byKey(actionPage), findsOneWidget);
    ***REMOVED***);

    testUI('creates ActionPage and ActionCreator', (WidgetTester tester) async {
      expect(find.byKey(actionPage), findsOneWidget);
      expect(find.byKey(Key('action creator')), findsOneWidget);
    ***REMOVED***);

    testUI('switches to Action Creator with tap on Create Action Button',
        (WidgetTester tester) async {
      NavigationState state = tester.state(find.byWidget(navigation));
      expect(state.navigation, isNot(1));

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('action creator navigation button')));
      await tester.pumpAndSettle();

      expect(state.navigation, 1);
      expect(find.byKey(Key('action creator')), findsOneWidget);
      expect(find.text('Zum Sammeln einladen'), findsOneWidget);
    ***REMOVED***);

    testUI('switches to FAQ page with tap on FAQ Button',
        (WidgetTester tester) async {
      NavigationState state = tester.state(find.byWidget(navigation));
      expect(state.navigation, isNot(2));

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('faq navigation button')));
      await tester.pumpAndSettle();

      expect(state.navigation, 2);
      expect(find.byKey(Key('faq page')), findsOneWidget);
      expect(find.text('Tipps und Argumente'), findsOneWidget);
    ***REMOVED***);

    testUI('returns to same ActionPage page with tap on Actions-Button',
        (WidgetTester tester) async {
      NavigationState state = tester.state(find.byWidget(navigation));
      state.navigation = 1;
      await tester.pump();

      expect(state.navigation, isNot(0));

      await openActionPage(tester);

      expect(state.navigation, 0);
      expect(find.byKey(actionPage), findsOneWidget);
    ***REMOVED***);

    testUI('stores navigation history', (WidgetTester tester) async {
      await openActionCreator(tester);
      await openActionPage(tester);

      NavigationState state = tester.state(find.byWidget(navigation));
      expect(state.history, [0, 1]);
    ***REMOVED***);

    testUI('returns to last page and pops history with back button',
        (WidgetTester tester) async {
      await openActionCreator(tester);
      await openActionPage(tester);

      NavigationState state = tester.state(find.byWidget(navigation));
      expect(state.history, [0, 1]);

      await maybePop(state, tester);

      expect(state.navigation, 1);
      expect(state.history, [0]);

      await maybePop(state, tester);

      expect(state.navigation, 0);
      expect(state.history, isEmpty);

      await maybePop(state, tester);

      // Test auf Schließen der App scheint nicht möglich
      expect(state.navigation, 0);
      expect(state.history, isEmpty);
    ***REMOVED***);

    testUI('returns action page after action creation',
        (WidgetTester tester) async {
      when(_termineService.createAction(any, any))
          .thenAnswer((_) async => TerminTestDaten.einTermin());
      await openActionCreator(tester);

      ActionEditorState editor =
          tester.state(find.byKey(Key('action creator')));
      editor.action = testActionData();

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      NavigationState navigation = tester.state(find.byKey(Key('navigation')));
      expect(navigation.navigation, 0);
    ***REMOVED***);
  ***REMOVED***);

  group('menuEntry', () {
    final title = 'Title';
    final subtitle = 'Subtitle';

    setUpUI((WidgetTester tester) async {
      var navigationState = NavigationState();
      var menuEntry = navigationState.menuEntry(
        key: Key('menu entry'),
        title: title,
        subtitle: subtitle,
      );
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: menuEntry)));
    ***REMOVED***);

    testUI('shows title and subtitle', (WidgetTester _) async {
      expect(find.byKey(Key('menu entry')), findsOneWidget);
      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

Future openActionCreator(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('action creator navigation button')));
  await tester.pumpAndSettle();
***REMOVED***

Future openActionPage(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('action page navigation button')));
  await tester.pumpAndSettle();
***REMOVED***

Future maybePop(NavigationState state, WidgetTester tester) async {
  Navigator.of(state.context).maybePop();
  await tester.pumpAndSettle();
***REMOVED***
