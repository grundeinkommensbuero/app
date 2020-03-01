import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';

import '../model/Ort_test.dart';
import '../model/Termin_test.dart';

class StammdatenServiceMock extends Mock implements StammdatenService {}

final stammdatenService = StammdatenServiceMock();

// erzeugt einen beliebig konfigurierbaren Mock für den TermineService
class TermineServiceMock extends Mock implements AbstractTermineService {}

final terminService = TermineServiceMock();

class StorageServiceMock extends Mock implements StorageService {}

final storageService = StorageServiceMock();

void main() {
  setUp(() {
    when(storageService.loadFilter()).thenAnswer((_) async => null);
    when(storageService.loadAllStoredActionIds()).thenAnswer((_) async => []);
  });

  testWidgets('TermineSeite opens CreateTerminDialog on click at create button',
      (WidgetTester tester) async {
    // Provider liefert den Mock für den TermineService rein
    var termineSeiteWidget = MultiProvider(providers: [
      Provider<AbstractTermineService>(create: (context) => terminService),
      Provider<StorageService>(create: (context) => storageService)
    ], child: TermineSeite(title: 'Titel'));

    // konfiguriert den Termine-Service-Mock so dass er eine leere List von Terminen liefert
    when(terminService.ladeTermine(any)).thenAnswer((_) async => []);

    // TermineSeite-Widget wird als eigene App gestartet
    await tester.pumpWidget(MaterialApp(home: termineSeiteWidget));

    // sicherstellen, dass am Anfang noch kein Erstellen-Dialog auffindbar ist
    expect(find.byKey(Key('action creator')), findsNothing);

    // Termine-Erstellen-Button finden und klicken
    await tester.tap(find.byKey(Key('create termin button')));
    // App neu zeichnen
    await tester.pump();

    // Prüfen ob der Termine-Erstellen-Dialog aufgegangen ist
    expect(find.byKey(Key('action creator')), findsOneWidget);
  });

  group('shows all data', () {
    var termineSeiteWidget;
    setUp(() async {
      termineSeiteWidget = TermineSeite(title: 'Titel');

      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
          ]);
      when(terminService.getTerminMitDetails(any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());

      when(storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [0]);
    });

    testWidgets('Type dialog opens correctly', (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      expect(find.byKey(Key('type selection dialog')), findsNothing);
      await tester.tap(find.byKey(Key('open type selection dialog')));
      await tester.pump();
      expect(find.byKey(Key('type selection dialog')), findsOneWidget);
    });

    testWidgets('Type dialog shows correct typ', (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action editor')));
      action_data.setState(() {
        action_data.action.typ = TerminTestDaten.einTermin().typ;
        action_data.validateInput();
      });
      await tester.pump();
      expect(
          find.descendant(
              of: find.byType(ActionEditor), matching: find.text("Sammeln")),
          findsOneWidget);
    });

    testWidgets('Type dialog shows correct no typ',
        (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action editor')));
      action_data.setState(() {
        action_data.action.typ = '';
        action_data.validateInput();
      });
      await tester.pump();
      expect(
          find.descendant(
              of: find.byType(ActionEditor),
              matching: find.text("Wähle die Art der Aktion")),
          findsOneWidget);
    });

    testWidgets('Zeitraum dialog opens correctly', (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      expect(find.byKey(Key('from time picker')), findsNothing);
      await tester.tap(find.byKey(Key('open time span dialog')));
      await tester.pump();
      expect(find.byKey(Key('from time picker')), findsOneWidget);
    });

    testWidgets('Zeitraum is correctly shown', (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action editor')));
      expect(find.text('von 12:05 bis 13:09'), findsNothing);
      TimeOfDay von = TimeOfDay(hour: 12, minute: 5);
      TimeOfDay bis = TimeOfDay(hour: 13, minute: 9);
      action_data.setState(() {
        action_data.action.von = von;
        action_data.action.bis = bis;
        action_data.validateInput();
      });
      await tester.pump();
      expect(find.text('von 12:05 bis 13:09'), findsOneWidget);
    });

    testWidgets('No Zeitraum is correctly shown', (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action editor')));
      action_data.setState(() {
        action_data.action.von = null;
        action_data.action.bis = null;
        action_data.validateInput();
      });
      await tester.pump();
      expect(find.text('Wähle eine Uhrzeit'), findsOneWidget);
    });

    testWidgets('Location dialog opens correctly', (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      when(stammdatenService.ladeOrte()).thenAnswer((_) async => [goerli()]);
      expect(find.byKey(Key('Location Picker')), findsNothing);
      await tester.tap(find.byKey(Key('Open location dialog')));
      await tester.pump();
      expect(find.byKey(Key('Location Picker')), findsOneWidget);
    });

    testWidgets('Location dialog are correctly shown',
        (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action editor')));
      expect(find.text("in Görlitzer Park und Umgebung"), findsNothing);
      when(stammdatenService.ladeOrte()).thenAnswer((_) async => [goerli()]);
      action_data.setState(() {
        action_data.action.ort = goerli();
      });
      await tester.pump();
      expect(find.text("in Görlitzer Park und Umgebung"), findsOneWidget);
    });

    testWidgets('changing kontakt is correctly shown',
        (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action editor')));
      action_data.setState(() {
        action_data.action.terminDetails.kontakt = 'test1';
      });
      await tester.pump();
      expect(find.text('test1'), findsOneWidget);
    });

    testWidgets('changing treffpunkt is correctly shown',
        (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action editor')));
      action_data.setState(() {
        action_data.action.terminDetails.treffpunkt = 'test1';
      });
      await tester.pump();
      expect(find.text('Treffpunkt: test1'), findsOneWidget);
    });

    testWidgets('changing beschreibung is correctly shown',
        (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action editor')));
      action_data.setState(() {
        action_data.action.terminDetails.kommentar = 'test1';
      });
      await tester.pump();
      expect(find.text('Beschreibung: test1'), findsOneWidget);
    });

    testWidgets('changing tage is correctly shown',
        (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action editor')));
      action_data.setState(() {
        action_data.action.tage = [DateTime(2019, 12, 1)];
      });
      await tester.pump();
      expect(find.text('am 01.12.,'), findsOneWidget);
    });

    testWidgets('no tage selection is correctly shown',
        (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action editor')));

      action_data.setState(() {
        action_data.action.tage = List<DateTime>();
        action_data.validateInput();
      });
      await tester.pump();
      expect(find.text("Wähle einen Tag"), findsOneWidget);
    });

    testWidgets('All widgets show the correct action data',
        (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);

      expect(find.text('Ruft an unter 012345678'), findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(ActionEditor), matching: find.text('Sammeln')),
          findsOneWidget);
      expect(find.text('in Friedrichshain Nordkiez'), findsOneWidget);
      expect(find.text('Beschreibung: Bringe Westen und Klämmbretter mit'),
          findsOneWidget);
      expect(find.text('am 04.11.,'), findsOneWidget);
    });

    testWidgets('Cancel button closes correctly', (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      await tester.tap(find.byKey(Key('action editor cancel button')));
      await tester.pump();
      verifyNever(terminService.createTermin(any, any));
    });

    testWidgets('Termin adds a day if bis before von',
        (WidgetTester tester) async {
      await show_action_editor(tester, termineSeiteWidget);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action editor')));
      action_data.setState(() {
        action_data.action.tage = [DateTime(2019, 12, 1)];
        action_data.action.von = TimeOfDay(hour: 10, minute: 32);
        action_data.action.bis = TimeOfDay(hour: 10, minute: 31);
        action_data.validateInput();
      });
      List<Termin> new_termine = action_data.generateActions();
      expect(new_termine[0].ende.day, 2);
    });
  });
}

Future show_action_editor(WidgetTester tester, termineSeiteWidget) async {
  await tester.pumpWidget(MultiProvider(providers: [
    Provider<AbstractTermineService>.value(value: terminService),
    Provider<StorageService>.value(value: storageService),
    Provider<AbstractStammdatenService>.value(value: stammdatenService)
  ], child: MaterialApp(home: termineSeiteWidget)));

  // Warten bis asynchron Termine geladen wurden
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(Key('action card')).first);
  await tester.pump();
  await tester.tap(find.byKey(Key('action edit button')));
  await tester.pump();
}
