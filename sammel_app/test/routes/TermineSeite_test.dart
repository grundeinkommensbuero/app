import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';

import '../model/Ort_test.dart';
import '../model/Termin_test.dart';

class TermineServiceMock extends Mock implements TermineService {***REMOVED***

final terminService = TermineServiceMock();

class StorageServiceMock extends Mock implements StorageService {***REMOVED***

final storageService = StorageServiceMock();

void main() {
  setUp(() {
    when(storageService.loadFilter()).thenAnswer((_) async => null);
    when(storageService.loadAllStoredActionIds()).thenAnswer((_) async => []);
  ***REMOVED***);

  testWidgets('TermineSeite startet fehlerfrei mit leerer Liste',
      (WidgetTester tester) async {
    var termineSeiteWidget = TermineSeite(title: 'Titel mit Ümläüten');

    when(terminService.ladeTermine(any)).thenAnswer((_) async => []);

    await tester.pumpWidget(MultiProvider(providers: [
      Provider<AbstractTermineService>.value(value: terminService),
      Provider<StorageService>.value(value: storageService)
    ], child: MaterialApp(home: termineSeiteWidget)));

    expect(find.text('Titel mit Ümläüten'), findsOneWidget);
  ***REMOVED***);

  group('presentation', () {
    testWidgets('TermineSeite shows all actions', (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
          ]);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(find.byType(TerminCard), findsNWidgets(3));
    ***REMOVED***);

    testWidgets('TermineSeite sorts actions by From Date',
        (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      var today = DateTime.now();
      var tomorrow = today.add(Duration(days: 1));
      var yesterday = today.subtract(Duration(days: 1));

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(today)..ort = goerli(),
            TerminTestDaten.anActionFrom(tomorrow)..ort = nordkiez(),
            TerminTestDaten.anActionFrom(yesterday)..ort = treptowerPark(),
          ]);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byType(TerminCard).first,
              matching: find.text(TerminCard.erzeugeOrtText(treptowerPark()))),
          findsOneWidget);

      expect(
          find.descendant(
              of: find.byType(TerminCard).at(1),
              matching: find.text(TerminCard.erzeugeOrtText(goerli()))),
          findsOneWidget);

      expect(
          find.descendant(
              of: find.byType(TerminCard).last,
              matching: find.text(TerminCard.erzeugeOrtText(nordkiez()))),
          findsOneWidget);
    ***REMOVED***);

    testWidgets('marks own actions for highlighting',
        (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin()..id = 1,
            TerminTestDaten.einTermin()..id = 2,
            TerminTestDaten.einTermin()..id = 3,
          ]);

      when(storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [2]);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      List<TerminCard> actionCards = tester
          .widgetList(find.byKey(Key('action card')))
          .map((widget) => widget as TerminCard)
          .toList();

      expect(actionCards.length, 3);

      expect(actionCards[0].myAction, false);
      expect(actionCards[1].myAction, true);
      expect(actionCards[2].myAction, false);
    ***REMOVED***);

    testWidgets('shows edit and delete button only at own actions',
        (WidgetTester tester) async {
      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin()..id = 1,
            TerminTestDaten.einTermin()..id = 2,
            TerminTestDaten.einTermin()..id = 3,
          ]);
      when(terminService.getTerminMitDetails(any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());

      when(storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [2]);

      var termineSeiteWidget = TermineSeite(title: 'Titel');

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).at(0));
      await tester.pump();

      // no buttons at first action
      expect(find.byKey(Key('action delete button')), findsNothing);
      expect(find.byKey(Key('action edit button')), findsNothing);

      await tester.tap(find.byKey(Key('action details close button')));
      await tester.pump();

      // buttons at second action
      await tester.tap(find.byKey(Key('action card')).at(1));
      await tester.pump();

      expect(find.byKey(Key('action delete button')), findsOneWidget);
      expect(find.byKey(Key('action edit button')), findsOneWidget);

      await tester.tap(find.byKey(Key('action details close button')));
      await tester.pump();

      // no buttons at third action
      await tester.tap(find.byKey(Key('action card')).at(2));
      await tester.pump();

      expect(find.byKey(Key('action delete button')), findsNothing);
      expect(find.byKey(Key('action edit button')), findsNothing);
    ***REMOVED***);
  ***REMOVED***);

  group('Filter', () {
    testWidgets('is displayed', (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
          ]);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      expect(find.text('Filter'), findsOneWidget);
    ***REMOVED***);

    testWidgets('opens on tap', (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
          ]);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      await tester.tap(find.text('Filter'));

      await tester.pump();

      expect(find.text('Anwenden'), findsOneWidget);
    ***REMOVED***);
  ***REMOVED***);

  group('ActionDetailsDialog', () {
    testWidgets('opens with tap on TermineCard', (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
          ]);
      when(terminService.getTerminMitDetails(any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      expect(find.byKey(Key('termin details dialog')), findsOneWidget);
      expect(find.byKey(Key('action details page')), findsOneWidget);
      expect(find.byKey(Key('action details close button')), findsOneWidget);
    ***REMOVED***);

    testWidgets('closes TerminDetails dialog with tap on Schliessen button',
        (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
          ]);
      when(terminService.getTerminMitDetails(any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      verify(terminService.getTerminMitDetails(0));
    ***REMOVED***);

    testWidgets('loads Termin with details with tap on TermineCard',
        (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
          ]);
      when(terminService.getTerminMitDetails(any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      await tester.tap(find.byKey(Key('action details close button')));
      await tester.pump();

      expect(find.byKey(Key('termin details dialog')), findsNothing);
    ***REMOVED***);
  ***REMOVED***);

  group('ActionEditor', () {
    testWidgets('opens with tap on Create-Button', (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      when(terminService.ladeTermine(any)).thenAnswer((_) async => []);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      expect(find.byKey(Key('action creator')), findsNothing);

      await tester.tap(find.byKey(Key('create termin button')));
      await tester.pump();

      expect(find.byKey(Key('action creator')), findsOneWidget);
    ***REMOVED***);

    testWidgets('new actions are added and sorted into action list',
        (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      var today = DateTime.now();
      var yesterday = today.subtract(Duration(days: 1));
      var tomorrow = today.subtract(Duration(days: 1));
      var dayAfterTomorrow = today.add(Duration(days: 2));

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(yesterday),
            TerminTestDaten.anActionFrom(tomorrow),
            TerminTestDaten.anActionFrom(dayAfterTomorrow),
          ]);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action card')), findsNWidgets(3));

      await tester.tap(find.byKey(Key('create termin button')));
      await tester.pump();

      ActionEditorState editorState =
          tester.state(find.byKey(Key('action creator')));

      editorState.action = ActionData(
          TimeOfDay.fromDateTime(today),
          TimeOfDay.fromDateTime(today.add(Duration(hours: 2))),
          goerli(),
          'Sammeln',
          [today],
          TerminDetails('', '', ''));

      when(terminService.createTermin(any, any)).thenAnswer((_) async => Termin(
          1337,
          today,
          today.add(Duration(hours: 2)),
          goerli(),
          'Infoveranstaltung',
          editorState.action.terminDetails));

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pump();

      expect(find.byKey(Key('action card')), findsNWidgets(4));

      expect(
          find.descendant(
              of: find.byKey(Key('action card')).at(2),
              matching: find.text('Infoveranstaltung')),
          findsWidgets);
    ***REMOVED***);

    testWidgets('new actions are saved to server', (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      reset(terminService);

      var today = DateTime.now();
      var yesterday = today.subtract(Duration(days: 1));
      var tomorrow = today.subtract(Duration(days: 1));
      var dayAfterTomorrow = today.add(Duration(days: 2));

      when(terminService.createTermin(any, any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(yesterday),
            TerminTestDaten.anActionFrom(tomorrow),
            TerminTestDaten.anActionFrom(dayAfterTomorrow),
          ]);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action card')), findsNWidgets(3));

      await tester.tap(find.byKey(Key('create termin button')));
      await tester.pump();

      ActionEditorState editorState =
          tester.state(find.byKey(Key('action creator')));

      editorState.action = ActionData(
          TimeOfDay.fromDateTime(today),
          TimeOfDay.fromDateTime(today.add(Duration(hours: 2))),
          goerli(),
          'Neue Aktion',
          [today],
          TerminDetails('', '', ''));

      when(terminService.createTermin(any, any)).thenAnswer((_) async => Termin(
          1337,
          today,
          today.add(Duration(hours: 2)),
          goerli(),
          'Infoveranstaltung',
          editorState.action.terminDetails));

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pump();

      verify(terminService.createTermin(any, any)).called(1);
    ***REMOVED***);

    // FIXME
    testWidgets('re-sorts edited actions into action list',
        (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      var today = DateTime.now();
      var twoDaysAgo = today.subtract(Duration(days: 2));
      var yesterday = today.subtract(Duration(days: 1));
      var tomorrow = today.add(Duration(days: 1));

      when(terminService.createTermin(any, any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(yesterday),
            TerminTestDaten.anActionFrom(today),
            TerminTestDaten.anActionFrom(tomorrow)
              ..id = 1337
              ..typ = 'Infoveranstaltung',
          ]);

      when(terminService.getTerminMitDetails(any)).thenAnswer(
        (_) async => TerminTestDaten.einTerminMitDetails()
          ..id = 1337
          ..typ = 'Infoveranstaltung',
      );

      when(storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [1337]);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byKey(Key('action card')).last,
              matching: find.text('Infoveranstaltung')),
          findsWidgets);

      await tester.tap(find.byKey(Key('action card')).last);
      await tester.pump();

      await tester.tap(find.byKey(Key('action edit button')).first);
      await tester.pump();

      expect(find.byKey(Key('action editor finish button')), findsOneWidget);

      ActionEditorState editorState =
          tester.state(find.byKey(Key('action editor')));
      editorState.action.tage = [twoDaysAgo];

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pump();

      // Der Tap auf den Finish-Button löst den Button einfach nicht aus... :/
      /*expect(
          find.descendant(
              of: find.byKey(Key('action card')).first,
              matching: find.text('Infoveranstaltung')),
          findsWidgets);*/
    ***REMOVED***);
  ***REMOVED***);

  group('now-line', () {
    testWidgets('lies between past and future actions',
        (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      DateTime today = DateTime.now();
      DateTime twoDaysAgo = today.subtract(Duration(days: 2));
      DateTime yesterday = today.subtract(Duration(days: 1));
      DateTime tomorrow = today.add(Duration(days: 1));

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(yesterday),
            TerminTestDaten.anActionFrom(tomorrow),
            TerminTestDaten.anActionFrom(twoDaysAgo),
          ]);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      var listView = find.byType(ListView);

      List<String> keys = tester
          .widgetList(
              find.descendant(of: listView, matching: find.byType(Text)))
          .map((widget) => (widget as Text).data)
          .where((key) => key == 'Sammeln' || key == 'Jetzt')
          .toList();

      expect(
          keys,
          containsAll([
            'Sammeln',
            'Sammeln',
            'Jetzt',
            'Sammeln',
          ]));
    ***REMOVED***);

    testWidgets('hides if no past actions present',
        (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      DateTime today = DateTime.now();
      DateTime nextHour = today.add(Duration(hours: 1));
      DateTime nextDay = today.add(Duration(days: 1));
      DateTime nextWeek = today.add(Duration(days: 7));

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(nextDay),
            TerminTestDaten.anActionFrom(nextHour),
            TerminTestDaten.anActionFrom(nextWeek),
          ]);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action card')), findsNWidgets(3));

      expect(find.byKey(Key('action list now line')), findsNothing);
    ***REMOVED***);

    testWidgets('is at end if no future actions present',
        (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      DateTime today = DateTime.now();
      DateTime threeHoursAgo = today.subtract(Duration(hours: 3));
      DateTime lastDay = today.subtract(Duration(days: 1));
      DateTime lastWeek = today.subtract(Duration(days: 7));

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(lastDay),
            TerminTestDaten.anActionFrom(threeHoursAgo),
            TerminTestDaten.anActionFrom(lastWeek),
          ]);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      var listView = find.byType(ListView);

      List<String> keys = tester
          .widgetList(
              find.descendant(of: listView, matching: find.byType(Text)))
          .map((widget) => (widget as Text).data)
          .where((key) => key == 'Sammeln' || key == 'Jetzt')
          .toList();

      expect(
          keys,
          containsAll([
            'Sammeln',
            'Sammeln',
            'Sammeln',
            'Jetzt',
          ]));
    ***REMOVED***);

    testWidgets('hides if no actions are present', (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      when(terminService.ladeTermine(any)).thenAnswer((_) async => []);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action list now line')), findsNothing);
    ***REMOVED***);

    testWidgets(
        'lies behind actions that started in the past but end in the future',
        (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      DateTime today = DateTime.now();
      DateTime oneMinuteAgo = today.subtract(Duration(minutes: 1));
      DateTime twentyMinutesAgo = today.subtract(Duration(minutes: 20));
      DateTime inTwentyMinutes = today.add(Duration(minutes: 20));

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(inTwentyMinutes),
            TerminTestDaten.anActionFrom(twentyMinutesAgo),
            TerminTestDaten.anActionFrom(oneMinuteAgo),
          ]);

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      var listView = find.byType(ListView);

      List<String> keys = tester
          .widgetList(
              find.descendant(of: listView, matching: find.byType(Text)))
          .map((widget) => (widget as Text).data)
          .where((key) => key == 'Sammeln' || key == 'Jetzt')
          .toList();

      expect(
          keys,
          containsAll([
            'Sammeln',
            'Sammeln',
            'Jetzt',
            'Sammeln',
          ]));
    ***REMOVED***);
  ***REMOVED***);

  group('delete button', () {
    testWidgets('opens confirmation dialog', (WidgetTester tester) async {
      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
          ]);
      when(terminService.getTerminMitDetails(any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());

      when(storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [0]);

      var termineSeiteWidget = TermineSeite(title: 'Titel');

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      await tester.tap(find.byKey(Key('action delete button')));
      await tester.pump();

      expect(find.byKey(Key('deletion confirmation dialog')), findsOneWidget);
    ***REMOVED***);

    testWidgets('closes confirmation dialog on tap at No button',
        (WidgetTester tester) async {
      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
          ]);
      when(terminService.getTerminMitDetails(any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());
      when(storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [0]);

      var termineSeiteWidget = TermineSeite(title: 'Titel');

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      await tester.tap(find.byKey(Key('action delete button')));
      await tester.pump();

      await tester.tap(find.byKey(Key('delete confirmation no button')));
      await tester.pump();

      expect(find.byKey(Key('deletion confirmation dialog')), findsNothing);
    ***REMOVED***);

    testWidgets('does not trigger deletion on tap at No button',
        (WidgetTester tester) async {
      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
          ]);
      when(terminService.getTerminMitDetails(any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());

      when(storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [0]);

      var termineSeiteWidget = TermineSeite(title: 'Titel');

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService)
      ], child: MaterialApp(home: termineSeiteWidget)));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action card')), findsOneWidget);

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      expect(find.byKey(Key('action details page')), findsOneWidget);

      await tester.tap(find.byKey(Key('action delete button')));
      await tester.pump();

      expect(find.byKey(Key('deletion confirmation dialog')), findsOneWidget);

      await tester.tap(find.byKey(Key('delete confirmation no button')));
      await tester.pump();

      expect(find.byKey(Key('action details page')), findsOneWidget);
      verifyNever(terminService.deleteAction(any, any));
      expect(find.byKey(Key('action card')), findsOneWidget);
    ***REMOVED***);

    group('on confirmed', () {
      var termineSeiteWidget;
      var myAction;

      setUp(() {
        DateTime today = DateTime.now();
        DateTime yesterday = today.subtract(Duration(days: 1));
        DateTime tomorrow = today.add(Duration(days: 1));

        when(terminService.ladeTermine(any)).thenAnswer((_) async => [
              TerminTestDaten.einTermin()
                ..id = 1
                ..beginn = yesterday,
              TerminTestDaten.einTermin()
                ..id = 2
                ..beginn = today
                ..typ = 'Infoveranstaltung',
              TerminTestDaten.einTermin()
                ..id = 3
                ..beginn = tomorrow,
            ]);

        // mittlere Aktion um sicherzustellen, dass nicht einfach immer die erste oder letzte Aktion gelöscht wird
        myAction = TerminTestDaten.einTerminMitDetails()..id = 2;
        when(terminService.getTerminMitDetails(any))
            .thenAnswer((_) async => myAction);

        clearInteractions(storageService);
        when(storageService.loadAllStoredActionIds())
            .thenAnswer((_) async => [2]);

        termineSeiteWidget = TermineSeite(title: 'Titel');
      ***REMOVED***);

      testWidgets('deletes action in backend',
          (WidgetTester tester) async {
        await tester.pumpWidget(MultiProvider(providers: [
          Provider<AbstractTermineService>.value(value: terminService),
          Provider<StorageService>.value(value: storageService)
        ], child: MaterialApp(home: termineSeiteWidget)));

        // Warten bis asynchron Termine geladen wurden
        await tester.pumpAndSettle();

        await tester.tap(find.text('Infoveranstaltung'));
        await tester.pump();

        await tester.tap(find.byKey(Key('action delete button')));
        await tester.pump();

        expect(find.byKey(Key('deletion confirmation dialog')), findsOneWidget);

        await tester.tap(find.byKey(Key('delete confirmation yes button')));
        await tester.pump();

        verify(terminService.deleteAction(myAction, any)).called(1);
      ***REMOVED***);

      testWidgets('deletes action in action list', (WidgetTester tester) async {
        await tester.pumpWidget(MultiProvider(providers: [
          Provider<AbstractTermineService>.value(value: terminService),
          Provider<StorageService>.value(value: storageService)
        ], child: MaterialApp(home: termineSeiteWidget)));

        // Warten bis asynchron Termine geladen wurden
        await tester.pumpAndSettle();

        // mittleren Dialog um sicherzustellen, dass nicht einfach immer die erste Aktion gelöscht wird
        await tester.tap(find.byKey(Key('action card')).at(1));
        await tester.pump();

        await tester.tap(find.byKey(Key('action delete button')));
        await tester.pump();

        expect(find.byKey(Key('deletion confirmation dialog')), findsOneWidget);

        await tester.tap(find.byKey(Key('delete confirmation yes button')));
        await tester.pump();

        expect(find.byKey(Key('action card')), findsNWidgets(2));
        expect(find.text('Infoveranstaltung'), findsNothing);
      ***REMOVED***);

      testWidgets('deletes action id storage', (WidgetTester tester) async {
        await tester.pumpWidget(MultiProvider(providers: [
          Provider<AbstractTermineService>.value(value: terminService),
          Provider<StorageService>.value(value: storageService)
        ], child: MaterialApp(home: termineSeiteWidget)));

        // Warten bis asynchron Termine geladen wurden
        await tester.pumpAndSettle();

        // mittleren Dialog um sicherzustellen, dass nicht einfach immer die erste Aktion gelöscht wird
        await tester.tap(find.byKey(Key('action card')).at(1));
        await tester.pump();

        await tester.tap(find.byKey(Key('action delete button')));
        await tester.pump();

        expect(find.byKey(Key('deletion confirmation dialog')), findsOneWidget);

        await tester.tap(find.byKey(Key('delete confirmation yes button')));
        await tester.pump();

        verify(storageService.deleteActionToken(2)).called(1);
      ***REMOVED***);

      testWidgets('closes confirmation dialog and action details',
          (WidgetTester tester) async {
        await tester.pumpWidget(MultiProvider(providers: [
          Provider<AbstractTermineService>.value(value: terminService),
          Provider<StorageService>.value(value: storageService)
        ], child: MaterialApp(home: termineSeiteWidget)));

        // Warten bis asynchron Termine geladen wurden
        await tester.pumpAndSettle();

        // mittleren Dialog um sicherzustellen, dass nicht einfach immer die erste Aktion gelöscht wird
        await tester.tap(find.byKey(Key('action card')).at(1));
        await tester.pump();

        await tester.tap(find.byKey(Key('action delete button')));
        await tester.pump();

        expect(find.byKey(Key('deletion confirmation dialog')), findsOneWidget);

        await tester.tap(find.byKey(Key('delete confirmation yes button')));
        await tester.pump();

        expect(find.byKey(Key('deletion confirmation dialog')), findsNothing);
        expect(find.byKey(Key('action details page')), findsNothing);
      ***REMOVED***);
    ***REMOVED***);
  ***REMOVED***);

  group('action token', () {
    TermineSeiteState actionPage;
    setUp(() {
      actionPage = TermineSeiteState();
      TermineSeiteState.storageService = storageService;
      TermineSeiteState.termineService = terminService;
    ***REMOVED***);

    test('is uniquely generated at action creation and sent to server', () {
      when(terminService.createTermin(any, any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());

      actionPage.createNewAction(TerminTestDaten.einTermin());
      actionPage.createNewAction(TerminTestDaten.einTermin());

      List<dynamic> uuids =
          verify(terminService.createTermin(any, captureAny)).captured;

      expect(uuids[0], isNotEmpty);
      expect(uuids[1], isNotEmpty);
      expect(uuids[0], isNot(uuids[1]));
    ***REMOVED***);

    test('is passed to server when action is edited', () async {
      Termin action1 = TerminTestDaten.einTermin()..id = 1;
      Termin action2 = TerminTestDaten.einTermin()..id = 2;
      actionPage.termine = [action1, action2];

      when(storageService.loadActionToken(1))
          .thenAnswer((_) async => 'storedToken1');
      when(storageService.loadActionToken(2))
          .thenAnswer((_) async => 'storedToken2');

      await actionPage.saveAction(action1);
      await actionPage.saveAction(action2);

      verify(terminService.saveAction(action1, 'storedToken1')).called(1);
      verify(terminService.saveAction(action2, 'storedToken2')).called(1);
    ***REMOVED***);

    test('is passed to server when action is deleted', () async {
      Termin action1 = TerminTestDaten.einTermin()..id = 1;
      Termin action2 = TerminTestDaten.einTermin()..id = 2;
      actionPage.termine = [action1, action2];

      when(storageService.loadActionToken(1))
          .thenAnswer((_) async => 'storedToken1');
      when(storageService.loadActionToken(2))
          .thenAnswer((_) async => 'storedToken2');

      await actionPage.deleteAction(action1);
      await actionPage.deleteAction(action2);

      verify(terminService.deleteAction(action1, 'storedToken1')).called(1);
      verify(terminService.deleteAction(action2, 'storedToken2')).called(1);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
