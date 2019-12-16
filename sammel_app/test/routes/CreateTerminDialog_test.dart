import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/TermineService.dart';

// erzeugt einen beliebig konfigurierbaren Mock für den TermineService
class TermineServiceMock extends Mock implements AbstractTermineService {***REMOVED***
final terminService = TermineServiceMock();

void main() {
  testWidgets('TermineSeite opens CreateTerminDialog on click at create button',
      (WidgetTester tester) async {
    // Provider liefert den Mock für den TermineService rein
    var termineSeiteWidget = Provider<AbstractTermineService>(
        builder: (context) => terminService,
        child: TermineSeite(title: 'Titel'));
    // konfiguriert den Termine-Service-Mock so dass er eine leere List von Terminen liefert
    when(terminService.ladeTermine(any)).thenAnswer((_) async => []);

    // TermineSeite-Widget wird als eigene App gestartet
    await tester.pumpWidget(MaterialApp(home: termineSeiteWidget));

    // sicherstellen, dass am Anfang noch kein Erstellen-Dialog auffindbar ist
    expect(find.byKey(Key('create termin dialog')), findsNothing);

    // Termine-Erstellen-Button finden und klicken
    await tester.tap(find.byKey(Key('create termin button')));
    // App neu zeichnen
    await tester.pump();

    // Prüfen ob der Termine-Erstellen-Dialog aufgegangen ist
    expect(find.byKey(Key('create termin dialog')), findsOneWidget);
  ***REMOVED***);
***REMOVED***
