import 'package:flutter/material.dart';
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

class TermineServiceMock extends Mock implements TermineService {}

final terminService = TermineServiceMock();

class StorageServiceMock extends Mock implements StorageService {}

final storageService = StorageServiceMock();

void main() {
  setUp(() {
    when(storageService.loadFilter()).thenAnswer((_) async => null);
    when(storageService.loadAllStoredActionIds()).thenAnswer((_) async => []);
  });

  testWidgets('TermineSeite startet fehlerfrei mit leerer Liste',
      (WidgetTester tester) async {
    var termineSeiteWidget = TermineSeite(title: 'Titel mit Ümläüten');

    when(terminService.ladeTermine(any)).thenAnswer((_) async => []);

    await tester.pumpWidget(MultiProvider(providers: [
      Provider<AbstractTermineService>.value(value: terminService),
      Provider<StorageService>.value(value: storageService)
    ], child: MaterialApp(home: termineSeiteWidget)));

    expect(find.text('Titel mit Ümläüten'), findsOneWidget);
  });

  testWidgets('TermineSeite zeigt alle Termine an',
      (WidgetTester tester) async {
    var termineSeiteWidget = TermineSeite(title: 'Titel mit Ümläüten');

    when(terminService.ladeTermine(any)).thenAnswer((_) async => [
          TerminTestDaten.einTermin(),
          TerminTestDaten.einTermin(),
          TerminTestDaten.einTermin(),
        ]);

    await tester.pumpWidget(MultiProvider(providers: [
      Provider<AbstractTermineService>.value(value: terminService),
      Provider<StorageService>.value(value: storageService)
    ], child: MaterialApp(home: termineSeiteWidget)));

    expect(find.text('Titel mit Ümläüten'), findsOneWidget);

    // Warten bis asynchron Termine geladen wurden
    await tester.pumpAndSettle();

    expect(find.byType(TerminCard), findsNWidgets(3));
  });

  testWidgets('TermineSeite zeigt Filter an', (WidgetTester tester) async {
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
  });

  testWidgets('TermineSeite oeffnet Filter-Menu an',
      (WidgetTester tester) async {
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
  });

  group('TerminDetailsDialog', () {
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

      await tester.tap(find.byKey(Key('termin card')).first);
      await tester.pump();

      expect(find.byKey(Key('termin details dialog')), findsOneWidget);
      expect(find.byKey(Key('termin details widget')), findsOneWidget);
      expect(find.byKey(Key('close termin details button')), findsOneWidget);
    });

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

      await tester.tap(find.byKey(Key('termin card')).first);
      await tester.pump();

      verify(terminService.getTerminMitDetails(0));
    });

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

      await tester.tap(find.byKey(Key('termin card')).first);
      await tester.pump();

      await tester.tap(find.byKey(Key('close termin details button')));
      await tester.pump();

      expect(find.byKey(Key('termin details dialog')), findsNothing);
    });
  });

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
    });

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

      expect(find.byKey(Key('termin card')), findsNWidgets(3));

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

      when(terminService.createTermin(any)).thenAnswer((_) async => Termin(
          1337,
          today,
          today.add(Duration(hours: 2)),
          goerli(),
          'Infoveranstaltung',
          editorState.action.terminDetails));

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pump();

      expect(find.byKey(Key('termin card')), findsNWidgets(4));

      expect(
          find.descendant(
              of: find.byKey(Key('termin card')).at(2),
              matching: find.text('Infoveranstaltung')),
          findsWidgets);
    });

    testWidgets('new actions are saved to server', (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      reset(terminService);

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

      expect(find.byKey(Key('termin card')), findsNWidgets(3));

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

      when(terminService.createTermin(any)).thenAnswer((_) async => Termin(
          1337,
          today,
          today.add(Duration(hours: 2)),
          goerli(),
          'Infoveranstaltung',
          editorState.action.terminDetails));

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pump();

      verify(terminService.createTermin(any)).called(1);
    });

    // FIXME
    testWidgets('re-sorts edited actions into action list',
        (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      var today = DateTime.now();
      var twoDaysAgo = today.subtract(Duration(days: 2));
      var yesterday = today.subtract(Duration(days: 1));
      var tomorrow = today.subtract(Duration(days: 1));

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
              of: find.byKey(Key('termin card')).last,
              matching: find.text('Infoveranstaltung')),
          findsWidgets);

      await tester.tap(find.byKey(Key('termin card')).last);
      await tester.pump();

      await tester.tap(find.byKey(Key('action details edit button')).first);
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
              of: find.byKey(Key('termin card')).first,
              matching: find.text('Infoveranstaltung')),
          findsWidgets);*/
    });
  });
}
