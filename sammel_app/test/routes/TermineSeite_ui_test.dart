import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/TermineService.dart';

import '../model/Termin_test.dart';

class TermineServiceMock extends Mock implements TermineService {}

final terminService = TermineServiceMock();

void main() {
  testWidgets('TermineSeite startet fehlerfrei mit leerer Liste',
      (WidgetTester tester) async {
    var termineSeiteWidget = TermineSeite(title: 'Titel mit Ümläüten');

    when(terminService.ladeTermine()).thenAnswer((_) async => []);

    await tester.pumpWidget(Provider<TermineService>(
        builder: (context) => terminService,
        child: MaterialApp(home: termineSeiteWidget)));

    expect(find.text('Titel mit Ümläüten'), findsOneWidget);
  });

  testWidgets('TermineSeite zeigt alle Termine an',
      (WidgetTester tester) async {
    var termineSeiteWidget = TermineSeite(title: 'Titel mit Ümläüten');

    when(terminService.ladeTermine()).thenAnswer((_) async => [
          TerminTestDaten.terminOhneTeilnehmer(),
          TerminTestDaten.terminOhneTeilnehmer(),
          TerminTestDaten.terminOhneTeilnehmer(),
        ]);

    await tester.pumpWidget(Provider<TermineService>(
        builder: (context) => terminService,
        child: MaterialApp(home: termineSeiteWidget)));

    expect(find.text('Titel mit Ümläüten'), findsOneWidget);

    // Warten bis asynchron Termine geladen wurden
    await tester.pumpAndSettle();

    expect(find.byType(TerminCard), findsNWidgets(3));
  });
}
