import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ActionDetailsPage.dart';

import '../model/Termin_test.dart';

main() {
  Widget widget;

  setUp(() {
    Termin termin = TerminTestDaten.einTerminMitTeilisUndDetails();
    widget = MaterialApp(home: Dialog(child: ActionDetailsPage(termin)));
  });

  testWidgets('opens', (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    expect(find.byKey(Key('action details page')), findsOneWidget);
  });

  testWidgets('shows action values', (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    expect(find.text('Friedrichshain-Kreuzberg'), findsOneWidget);
    expect(find.text('Frankfurter Allee Nord'), findsOneWidget);
    expect(find.text('Treffpunkt: Weltzeituhr'), findsOneWidget);
    expect(find.text('Bringe Westen und Klämmbretter mit'), findsOneWidget);
    expect(find.text('Ruft an unter 012345678'), findsOneWidget);
  });

    testWidgets('shows map with marker', (WidgetTester tester) async {
      await tester.pumpWidget(widget);

      expect(find.byKey(Key('action details map')), findsOneWidget);
      expect(find.byKey(Key('action details map marker')), findsOneWidget);
    });
}
