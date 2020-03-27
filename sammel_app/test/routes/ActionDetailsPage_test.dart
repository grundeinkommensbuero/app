import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ActionDetailsPage.dart';

import '../model/Termin_test.dart';

main() {
  Widget widget;

  setUp(() {
    Termin termin = TerminTestDaten.einTerminMitDetails();
    widget = MaterialApp(home: Dialog(child: ActionDetailsPage(termin)));
  ***REMOVED***);

  testWidgets('opens', (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    expect(find.byKey(Key('action details page')), findsOneWidget);
  ***REMOVED***);

  testWidgets('shows action values', (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    expect(find.text('Friedrichshain-Kreuzberg'), findsOneWidget);
    expect(find.text('Friedrichshain Nordkiez'), findsOneWidget);
    expect(find.text('Treffpunkt: Weltzeituhr'), findsOneWidget);
    expect(find.text('Bringe Westen und Klämmbretter mit'), findsOneWidget);
    expect(find.text('Ruft an unter 012345678'), findsOneWidget);
  ***REMOVED***);

  group('map', () {
    testWidgets('shows', (WidgetTester tester) async {
      await tester.pumpWidget(widget);

      expect(find.byKey(Key('action details map')), findsOneWidget);
    ***REMOVED***);

    testWidgets('shows marker for action', (WidgetTester tester) async {
      await tester.pumpWidget(widget);

      expect(find.byKey(Key('action marker')), findsOneWidget);
    ***REMOVED***);

    testWidgets('does not react to tap on marker', (WidgetTester tester) async {
      await tester.pumpWidget(widget);

      await tester.tap(find.byKey(Key('action marker')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action details page')), findsOneWidget);
      expect(find.byKey(Key('action details map')), findsOneWidget);
      expect(find.byKey(Key('action marker')), findsOneWidget);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
