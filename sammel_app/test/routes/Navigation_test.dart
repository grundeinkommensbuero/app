import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';

import '../model/Termin_test.dart';
import '../shared/Mocks.dart';

final termineService = TermineServiceMock();
final listLocationService = ListLocationServiceMock();
final storageService = StorageServiceMock();

void main() {
  Navigation navigation;

  setUpUI((WidgetTester tester) async {
    navigation = Navigation();
    when(storageService.loadAllStoredActionIds()).thenAnswer((_) async => []);
    when(listLocationService.getActiveListLocations())
        .thenAnswer((_) async => []);
    when(storageService.loadFilter())
        .thenAnswer((_) async => TermineFilter.leererFilter());
    when(termineService.ladeTermine(any)).thenAnswer((_) async => []);

    await tester.pumpWidget(MultiProvider(providers: [
      Provider<AbstractTermineService>.value(value: termineService),
      Provider<AbstractListLocationService>.value(value: listLocationService),
      Provider<StorageService>.value(value: storageService),
    ], child: MaterialApp(home: navigation)));
  ***REMOVED***);

  testUI('Navigation starts and shows correct Titel',
      (WidgetTester tester) async {
    expect(find.text('Aktionen'), findsOneWidget);
  ***REMOVED***);

  testUI('starts with ActionPage ', (WidgetTester tester) async {
    NavigationState state = tester.state(find.byWidget(navigation));
    expect(state.navigation, 0);
    expect(find.byKey(state.actionPage), findsOneWidget);
  ***REMOVED***);

  testUI('creates ActionPage and ActionCreator', (WidgetTester tester) async {
    NavigationState state = tester.state(find.byWidget(navigation));
    expect(find.byKey(state.actionPage), findsOneWidget);
    expect(find.byKey(Key('action creator')), findsOneWidget);
  ***REMOVED***);

  testUI('switches to Action Creator with tap on Create Action Button',
      (WidgetTester tester) async {
    NavigationState state = tester.state(find.byWidget(navigation));
    expect(state.navigation, isNot(1));

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('action creator button')));
    await tester.pumpAndSettle();

    expect(state.navigation, 1);
    expect(find.byKey(Key('action creator')), findsOneWidget);
    expect(find.text('Zum Sammeln aufrufen'), findsOneWidget);
  ***REMOVED***);

  testUI('returns to same ActionPage page with tap on Actions-Button',
      (WidgetTester tester) async {
    NavigationState state = tester.state(find.byWidget(navigation));
    state.navigation = 1;
    await tester.pump();

    expect(state.navigation, isNot(0));

    await openActionPage(tester);

    expect(state.navigation, 0);
    expect(find.byKey(state.actionPage), findsOneWidget);
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
    when(termineService.createTermin(any, any))
        .thenAnswer((_) async => TerminTestDaten.einTermin());
    await openActionCreator(tester);

    ActionEditorState editor = tester.state(find.byKey(Key('action creator')));
    editor.action = ActionData.testDaten();

    await tester.tap(find.byKey(Key('action editor finish button')));
    await tester.pumpAndSettle();

    NavigationState navigation = tester.state(find.byKey(Key('navigation')));
    expect(navigation.navigation, 0);
  ***REMOVED***);
***REMOVED***

Future openActionCreator(WidgetTester tester) async {
  await tester.tap(find.byType(IconButton));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('action creator button')));
  await tester.pumpAndSettle();
***REMOVED***

Future openActionPage(WidgetTester tester) async {
  await tester.tap(find.byType(IconButton));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('action page button')));
  await tester.pumpAndSettle();
***REMOVED***

Future maybePop(NavigationState state, WidgetTester tester) async {
  Navigator.of(state.context).maybePop();
  await tester.pumpAndSettle();
***REMOVED***
