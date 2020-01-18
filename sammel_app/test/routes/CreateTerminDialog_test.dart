import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';

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
    expect(find.byKey(Key('action editor')), findsNothing);

    // Termine-Erstellen-Button finden und klicken
    await tester.tap(find.byKey(Key('create termin button')));
    // App neu zeichnen
    await tester.pump();

    // Prüfen ob der Termine-Erstellen-Dialog aufgegangen ist
    expect(find.byKey(Key('action editor')), findsOneWidget);
  });
}
