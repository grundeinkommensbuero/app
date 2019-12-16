import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/TermineService.dart';

import '../model/Termin_test.dart';

class TermineServiceMock extends Mock implements TermineService {***REMOVED***

final terminService = TermineServiceMock();

void main() {
  testWidgets('TermineSeite startet fehlerfrei mit leerer Liste',
      (WidgetTester tester) async {
    var termineSeiteWidget = TermineSeite(title: 'Titel mit Ümläüten');

    when(terminService.ladeTermine(any)).thenAnswer((_) async => []);

    await tester.pumpWidget(Provider<TermineService>(
        builder: (context) => terminService,
        child: MaterialApp(home: termineSeiteWidget)));

    expect(find.text('Titel mit Ümläüten'), findsOneWidget);
  ***REMOVED***);

  testWidgets('TermineSeite zeigt alle Termine an',
      (WidgetTester tester) async {
    var termineSeiteWidget = TermineSeite(title: 'Titel mit Ümläüten');

    when(terminService.ladeTermine(any)).thenAnswer((_) async => [
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
  ***REMOVED***);

  testWidgets('TermineSeite zeigt Filter an', (WidgetTester tester) async {
    var termineSeiteWidget = TermineSeite(title: 'Titel');

    when(terminService.ladeTermine(any)).thenAnswer((_) async => [
          TerminTestDaten.terminOhneTeilnehmer(),
          TerminTestDaten.terminOhneTeilnehmer(),
          TerminTestDaten.terminOhneTeilnehmer(),
        ]);

    await tester.pumpWidget(Provider<TermineService>(
        builder: (context) => terminService,
        child: MaterialApp(home: termineSeiteWidget)));

    expect(find.text('Filter'), findsOneWidget);
  ***REMOVED***);

  testWidgets('TermineSeite oeffnet Filter-Menu an',
      (WidgetTester tester) async {
    var termineSeiteWidget = TermineSeite(title: 'Titel');

    when(terminService.ladeTermine(any)).thenAnswer((_) async => [
          TerminTestDaten.terminOhneTeilnehmer(),
          TerminTestDaten.terminOhneTeilnehmer(),
          TerminTestDaten.terminOhneTeilnehmer(),
        ]);

    await tester.pumpWidget(Provider<TermineService>(
        builder: (context) => terminService,
        child: MaterialApp(home: termineSeiteWidget)));

    await tester.tap(find.text('Filter'));

    await tester.pump();

    expect(find.text('Anwenden'), findsOneWidget);
  ***REMOVED***);
***REMOVED***
