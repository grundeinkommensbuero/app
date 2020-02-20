import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/AuthFehler.dart';
import 'package:sammel_app/services/RestFehler.dart';
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
    });

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
    });

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
    });

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
    });
  });

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
    });

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
    });
  });

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

      await tester.tap(find.byKey(Key('action card')).first);
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

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      await tester.tap(find.byKey(Key('action details close button')));
      await tester.pump();

      expect(find.byKey(Key('termin details dialog')), findsNothing);
    });
  });

  group('ActionCreator', () {
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

    testWidgets('new actions from server are added and sorted into action list',
        (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      var today = DateTime.now();
      var yesterday = today.subtract(Duration(days: 1));
      var tomorrow = today.add(Duration(days: 1));
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
          'Infoveranstaltung',
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

      expect(find.text('Infoveranstaltung'), findsOneWidget);

      expect(
          find.descendant(
              of: find.byKey(Key('action card')).at(1),
              matching: find.text('Infoveranstaltung')),
          findsWidgets);
    });

    testWidgets('uses created action from server with id',
        (WidgetTester tester) async {
      var termineSeiteWidget = TermineSeite(title: 'Titel');

      var today = DateTime.now();
      var yesterday = today.subtract(Duration(days: 1));
      var tomorrow = today.add(Duration(days: 1));
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
          'not this one',
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

      TerminCard newCard = tester.widget(find.ancestor(
          of: find.text('Infoveranstaltung'),
          matching: find.byKey(Key('action card'))));

      expect(newCard.termin.id, 1337);
    });

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
          'Infoveranstaltung',
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
    });

    testWidgets('shows alert popup on RestFehler from create request',
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

      await tester.tap(find.byKey(Key('create termin button')));
      await tester.pump();

      ActionEditorState editorState =
          tester.state(find.byKey(Key('action creator')));

      editorState.action = ActionData(
          TimeOfDay.fromDateTime(today),
          TimeOfDay.fromDateTime(today.add(Duration(hours: 2))),
          goerli(),
          'Infoveranstaltung',
          [today],
          TerminDetails('', '', ''));

      when(terminService.createTermin(any, any))
          .thenThrow(RestFehler('message'));

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pump();

      expect(find.byKey(Key('delete request failed dialog')), findsOneWidget);
    });
  });

  group('ActionEditor', () {
    testWidgets('re-sorts edited actions into action list',
        (WidgetTester tester) async {
      var myAction = TerminTestDaten.einTermin()
        ..id = 3
        ..beginn = DateTime.now().add(Duration(days: 1));

      when(terminService.ladeTermine(any)).thenAnswer((_) async {
        return [
          TerminTestDaten.einTermin()
            ..id = 1
            ..beginn = DateTime.now().subtract(Duration(days: 2)),
          TerminTestDaten.einTermin()
            ..id = 2
            ..beginn = DateTime.now(),
          myAction
        ];
      });
      when(terminService.getTerminMitDetails(any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());
      when(storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [0]);

      await tester.pumpWidget(MultiProvider(
          providers: [
            Provider<AbstractTermineService>.value(value: terminService),
            Provider<StorageService>.value(value: storageService)
          ],
          child: MaterialApp(
              home: TermineSeite(title: 'Titel', key: Key('action page')))));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      TermineSeiteState termineSeite =
          await tester.state(find.byKey(Key('action page')));

      expect(termineSeite.termine.map((action) => action.id),
          containsAllInOrder([1, 2, 3]));

      termineSeite.saveAction(TerminTestDaten.einTermin()
        ..id = 3
        ..beginn = DateTime.now().subtract(Duration(days: 1)));
      await tester.pump();

      expect(termineSeite.termine.map((action) => action.id),
          containsAllInOrder([1, 3, 2]));
    });

    testWidgets('shows alert popup on AuthFehler from save request',
        (WidgetTester tester) async {
      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin()
              ..id = 3
              ..beginn = DateTime.now().subtract(Duration(days: 1)),
          ]);
      when(terminService.getTerminMitDetails(any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());
      when(storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [0]);

      await tester.pumpWidget(MultiProvider(
          providers: [
            Provider<AbstractTermineService>.value(value: terminService),
            Provider<StorageService>.value(value: storageService)
          ],
          child: MaterialApp(
              home: TermineSeite(title: 'Titel', key: Key('action page')))));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      TermineSeiteState termineSeite =
          await tester.state(find.byKey(Key('action page')));

      when(terminService.saveAction(any, any)).thenThrow(AuthFehler('message'));

      termineSeite
          .saveAction(TerminTestDaten.einTermin()..typ = 'Infoveranstaltung');

      expect(
          find.byKey(Key('edit authentication failed dialog')), findsNothing);
      expect(termineSeite.termine[0].typ, 'Sammeln');
    });

    testWidgets('shows alert popup on RestFehler from save request',
        (WidgetTester tester) async {
      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin()..id = 1,
          ]);
      when(terminService.getTerminMitDetails(any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());
      when(storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [0]);

      await tester.pumpWidget(MultiProvider(
          providers: [
            Provider<AbstractTermineService>.value(value: terminService),
            Provider<StorageService>.value(value: storageService)
          ],
          child: MaterialApp(
              home: TermineSeite(title: 'Titel', key: Key('action page')))));

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      TermineSeiteState termineSeite =
          await tester.state(find.byKey(Key('action page')));

      when(terminService.saveAction(any, any)).thenThrow(RestFehler('message'));

      termineSeite
          .saveAction(TerminTestDaten.einTermin()..typ = 'Infoveranstaltung');

      expect(find.byKey(Key('edit request failed dialog')), findsNothing);
      expect(termineSeite.termine[0].typ, 'Sammeln');
    });
  });

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
    });

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
    });

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
    });

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
    });

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
    });
  });

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
    });

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
    });

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
    });

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
      });

      testWidgets('deletes action in backend', (WidgetTester tester) async {
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
      });

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
      });

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
      });

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
      });

      testWidgets('shows alert popup on RestFehler',
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

        when(terminService.deleteAction(any, any))
            .thenThrow(RestFehler('message'));

        await tester.tap(find.byKey(Key('delete confirmation yes button')));
        await tester.pump();

        expect(find.byKey(Key('delete request failed dialog')), findsOneWidget);
      });

      testWidgets('shows alert popup on AuthFehler',
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

        when(terminService.deleteAction(any, any))
            .thenThrow(AuthFehler('message'));

        await tester.tap(find.byKey(Key('delete confirmation yes button')));
        await tester.pump();

        expect(find.byKey(Key('delete request failed dialog')), findsOneWidget);
      });
    });
  });

  group('action token', () {
    TermineSeiteState actionPage;
    setUp(() {
      actionPage = TermineSeiteState();
      TermineSeiteState.storageService = storageService;
      TermineSeiteState.termineService = terminService;
    });

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
    });

    testWidgets('is passed to server when action is edited',
        (WidgetTester tester) async {
      Termin action1 = TerminTestDaten.einTermin()..id = 1;
      Termin action2 = TerminTestDaten.einTermin()..id = 2;
      when(terminService.ladeTermine(any))
          .thenAnswer((_) async => [action1, action2]);

      await tester.pumpWidget(MultiProvider(
          providers: [
            Provider<AbstractTermineService>.value(value: terminService),
            Provider<StorageService>.value(value: storageService)
          ],
          child: MaterialApp(
              home: TermineSeite(key: Key('action page'), title: 'Titel'))));
      actionPage = tester.state(find.byKey(Key('action page')));

      when(storageService.loadActionToken(1))
          .thenAnswer((_) async => 'storedToken1');
      when(storageService.loadActionToken(2))
          .thenAnswer((_) async => 'storedToken2');
      when(terminService.saveAction(any, any)).thenAnswer((_) => null);

      await actionPage.saveAction(action1);
      await actionPage.saveAction(action2);

      verify(terminService.saveAction(action1, 'storedToken1')).called(1);
      verify(terminService.saveAction(action2, 'storedToken2')).called(1);
    });

    testWidgets('is passed to server when action is deleted',
        (WidgetTester tester) async {
      Termin action1 = TerminTestDaten.einTermin()..id = 1;
      Termin action2 = TerminTestDaten.einTermin()..id = 2;
      when(terminService.ladeTermine(any))
          .thenAnswer((_) async => [action1, action2]);

      await tester.pumpWidget(MultiProvider(
          providers: [
            Provider<AbstractTermineService>.value(value: terminService),
            Provider<StorageService>.value(value: storageService)
          ],
          child: MaterialApp(
              home: TermineSeite(key: Key('action page'), title: 'Titel'))));
      actionPage = tester.state(find.byKey(Key('action page')));

      when(storageService.loadActionToken(1))
          .thenAnswer((_) async => 'storedToken1');
      when(storageService.loadActionToken(2))
          .thenAnswer((_) async => 'storedToken2');

      await actionPage.deleteAction(action1);
      await actionPage.deleteAction(action2);

      verify(terminService.deleteAction(action1, 'storedToken1')).called(1);
      verify(terminService.deleteAction(action2, 'storedToken2')).called(1);
    });
  });

  group('updateAction', () {
    var termineSeite = TermineSeiteState();
    setUp(() {
      termineSeite.termine = [
        TerminTestDaten.einTermin()..id = 1,
        TerminTestDaten.einTermin()..id = 2,
        TerminTestDaten.einTermin()..id = 3,
      ];
      termineSeite.myActions = [2, 3];
    });

    test('removes action w/ remove flag', () {
      termineSeite.updateAction(TerminTestDaten.einTermin()..id = 2, true);
      expect(
          termineSeite.termine.map((action) => action.id), containsAll([1, 3]));
    });

    test('removes action from myAction list w/ remove flag', () {
      termineSeite.updateAction(TerminTestDaten.einTermin()..id = 2, true);
      expect(termineSeite.myActions, containsAll([3]));
    });

    test('only updates action w/o remove flag', () {
      var newAction = TerminTestDaten.einTermin()
        ..id = 2
        ..ort = goerli();

      termineSeite.updateAction(newAction, false);

      expect(termineSeite.termine.map((action) => action.id),
          containsAll([1, 2, 3]));
      expect(
          termineSeite.termine
              .where((action) => action.id == 2)
              .toList()[0]
              .ort
              .id,
          goerli().id);
    });

    test('sorts new list by date', () {
      var newAction = TerminTestDaten.einTermin()
        ..id = 2
        ..beginn = DateTime.now().subtract(Duration(days: 1));
      termineSeite.updateAction(newAction, false);
      expect(termineSeite.termine.map((action) => action.id),
          containsAll([3, 1, 2]));
    });

    test('does nothing with unknown actions', () {
      termineSeite.updateAction(TerminTestDaten.einTermin()..id = 4, true);
      expect(termineSeite.termine.map((action) => action.id),
          containsAll([1, 2, 3]));
      expect(termineSeite.myActions, containsAll([2, 3]));
    });
  });

  group('addAction', () {
    var termineSeite = TermineSeiteState();
    setUp(() {
      termineSeite.termine = [
        TerminTestDaten.einTermin()..id = 1,
        TerminTestDaten.einTermin()..id = 2,
        TerminTestDaten.einTermin()..id = 3,
      ];
    });

    test('adds new action to list', () {
      termineSeite.addAction(TerminTestDaten.einTermin()..id = 4);
      expect(termineSeite.termine.map((action) => action.id),
          containsAll([1, 2, 3, 4]));
    });

    test('sorts list', () {
      termineSeite.addAction(TerminTestDaten.einTermin()
        ..id = 4
        ..beginn = DateTime.now().subtract(Duration(days: 1)));
      expect(termineSeite.termine.map((action) => action.id),
          containsAll([4, 1, 2, 3]));
    });
  });
  group('navgation button', () {
    testWidgets('for list view is active on start',
        (WidgetTester tester) async {
      when(terminService.ladeTermine(any))
          .thenAnswer((_) async => [(TerminTestDaten.einTermin())]);

      await tester.pumpWidget(MultiProvider(
          providers: [
            Provider<AbstractTermineService>.value(value: terminService),
            Provider<StorageService>.value(value: storageService)
          ],
          child: MaterialApp(
              home: TermineSeite(key: Key('action page'), title: 'Titel'))));

      TermineSeiteState state = tester.state(find.byKey(Key('action page')));
      expect(state.navigation, 0);
      expect(find.byKey(Key('action list')), findsOneWidget);
      expect(find.byKey(Key('action map')), findsNothing);
    });

    testWidgets('for map view switches to map view',
        (WidgetTester tester) async {
      when(terminService.ladeTermine(any))
          .thenAnswer((_) async => [(TerminTestDaten.einTermin())]);

      await tester.pumpWidget(MultiProvider(
          providers: [
            Provider<AbstractTermineService>.value(value: terminService),
            Provider<StorageService>.value(value: storageService)
          ],
          child: MaterialApp(
              home: TermineSeite(key: Key('action page'), title: 'Titel'))));

      await tester.tap(find.byKey(Key('map view navigation button')));
      await tester.pump();

      TermineSeiteState state = tester.state(find.byKey(Key('action page')));
      expect(state.navigation, 1);
      expect(find.byKey(Key('action map')), findsOneWidget);
      expect(find.byKey(Key('action list')), findsNothing);
    });

    testWidgets('for list view switches to list view',
        (WidgetTester tester) async {
      when(terminService.ladeTermine(any))
          .thenAnswer((_) async => [(TerminTestDaten.einTermin())]);

      await tester.pumpWidget(MultiProvider(
          providers: [
            Provider<AbstractTermineService>.value(value: terminService),
            Provider<StorageService>.value(value: storageService)
          ],
          child: MaterialApp(
              home: TermineSeite(key: Key('action page'), title: 'Titel'))));

      await tester.tap(find.byKey(Key('map view navigation button')));
      await tester.pump();

      TermineSeiteState state = tester.state(find.byKey(Key('action page')));
      expect(state.navigation, 1);

      await tester.tap(find.byKey(Key('list view navigation button')));
      await tester.pump();

      expect(state.navigation, 0);
      expect(find.byKey(Key('action list')), findsOneWidget);
      expect(find.byKey(Key('action map')), findsNothing);
        });
  });
}
