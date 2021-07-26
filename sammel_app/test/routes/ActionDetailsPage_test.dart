import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ActionDetailsPage.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';

import '../model/Termin_test.dart';
import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.trainer.dart';

final storageServiceMock = MockStorageService();

main() {
  late Widget widget;

  Function(Termin) joinAction = (_) {***REMOVED***
  Function(Termin) leaveAction = (_) {***REMOVED***

  trainTranslation(MockTranslations());

  setUp(() async {
    HttpOverrides.global = MapHttpOverrides();
    reset(storageServiceMock);
    when(storageServiceMock.loadAllStoredEvaluations())
        .thenAnswer((_) async => []);

    Termin termin = TerminTestDaten.einTerminMitTeilisUndDetails();
    termin.beginn = Jiffy(DateTime.now()).add(days: 1).dateTime;
    termin.ende = Jiffy(DateTime.now()).add(days: 1, hours: 1).dateTime;

    widget = createActionDetailsPage(termin, joinAction, leaveAction);
  ***REMOVED***);

  testWidgets('opens', (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    expect(find.byKey(Key('action details page')), findsOneWidget);
  ***REMOVED***);

  testWidgets('shows action values', (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    expect(
        find.text(
            'Frankfurter Allee Nord in Friedrichshain\n Treffpunkt: Weltzeituhr'),
        findsOneWidget);
    expect(find.text('Bringe Westen und Klämmbretter mit'), findsOneWidget);
    expect(find.text('Ruft an unter 012345678'), findsOneWidget);
  ***REMOVED***);

  testWidgets('shows map with marker', (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    expect(find.byKey(Key('action details map')), findsOneWidget);
    expect(find.byKey(Key('action details map marker')), findsOneWidget);
  ***REMOVED***);

  testWidgets('shows no menu with past unparticiating actions',
      (WidgetTester tester) async {
    Termin termin = TerminTestDaten.einTerminOhneTeilisMitDetails();
    termin.beginn = Jiffy(DateTime.now()).subtract(days: 1).dateTime;
    termin.ende = Jiffy(DateTime.now()).subtract(days: 1, hours: 1).dateTime;
    widget = createActionDetailsPage(termin, joinAction, leaveAction);

    await tester.pumpWidget(widget);

    expect(find.byKey(Key('action details menu button')), findsNothing);
  ***REMOVED***);

  testWidgets('shows calender menu button only if participating',
      (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    await tester.tap(find.byKey(Key('action details menu button')));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('action details calendar menu item')), findsNothing);

    await tester.tap(find.byKey(Key('action details join menu item')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('action details menu button')));
    await tester.pumpAndSettle();

    expect(
        find.byKey(Key('action details calendar menu item')), findsOneWidget);
  ***REMOVED***);

  testWidgets('shows share menu button only if participating',
      (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    await tester.tap(find.byKey(Key('action details menu button')));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('action details share menu item')), findsNothing);

    await tester.tap(find.byKey(Key('action details join menu item')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('action details menu button')));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('action details share menu item')), findsOneWidget);
  ***REMOVED***);
***REMOVED***

MultiProvider createActionDetailsPage(
    Termin termin, Function(Termin) joinAction, Function(Termin) leaveAction) {
  return MultiProvider(
      providers: [
        Provider<AbstractTermineService>.value(value: MockTermineService()),
        Provider<ChatMessageService>.value(value: MockChatMessageService()),
        Provider<StorageService>.value(value: storageServiceMock),
        Provider<AbstractUserService>.value(
            value: trainUserService(MockUserService())),
      ],
      child: MaterialApp(
          home: Dialog(
              child: ActionDetailsPage(
                  termin, false, false, joinAction, leaveAction))));
***REMOVED***
