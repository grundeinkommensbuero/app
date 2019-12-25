import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/routes/TerminDetailsWidget.dart';

main() {
  testWidgets('shows Termin values', (WidgetTester tester) async {
    Termin termin = Termin(
        1,
        DateTime(2019, 12, 22, 12, 36, 0),
        DateTime(2019, 12, 22, 15, 37, 0),
        Ort(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain-Nordkiez'),
        'Sammel-Termin',
        TerminDetails(
            'Ubhf Samariterstr.',
            'Wir machen die Frankfurter Allee runter',
            'Ihr erkennt mich an der lila Weste'));
    var widget = TerminDetailsWidget(termin);

    await tester.pumpWidget(MaterialApp(home: Dialog(child: widget)));

    expect(find.text('Friedrichshain-Kreuzberg'), findsOneWidget);
    expect(find.text('Friedrichshain-Nordkiez'), findsOneWidget);
    expect(find.text('Treffpunkt: Ubhf Samariterstr.'), findsOneWidget);
    expect(
        find.text('Wir machen die Frankfurter Allee runter'), findsOneWidget);
    expect(find.text('Ihr erkennt mich an der lila Weste'), findsOneWidget);
  ***REMOVED***);
***REMOVED***
