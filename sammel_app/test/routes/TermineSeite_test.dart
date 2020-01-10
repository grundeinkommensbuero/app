import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';

import '../model/Termin_test.dart';

class TermineServiceMock extends Mock implements TermineService {}

final terminService = TermineServiceMock();

class StorageServiceMock extends Mock implements StorageService {}

final storageService = StorageServiceMock();

void main() {
  setUp(() {
    when(storageService.loadFilterTypes()).thenAnswer((_) async => null);
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
}
