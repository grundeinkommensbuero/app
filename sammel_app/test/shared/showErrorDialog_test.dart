import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/shared/showErrorDialog.dart';

main() {
  setUpUI((WidgetTester tester) async {
    final error = RestFehler('there is a reason for everything');
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: Builder(builder: (BuildContext context) {
          return Center(
            child: RaisedButton(
                key: Key('starter'),
                child: const Text('Starter'),
                onPressed: () async => await showErrorDialog(
                    context, 'Titel', error,
                    key: Key('error dialog'))),
          );
        ***REMOVED***),
      ),
    ));

    await tester.tap(find.byKey(Key('starter')));
    await tester.pumpAndSettle();
  ***REMOVED***);

  testUI('starts and shows data', (WidgetTester tester) async {
    expect(find.byKey(Key('error dialog')), findsOneWidget);
    expect(find.text('Titel'), findsOneWidget);
    expect(
        find.text(
            'there is a reason for everything\n\nWenn du Hilfe brauchst, schreib uns doch einfach per Mail an e@mail.com'),
        findsOneWidget);
  ***REMOVED***);

  testUI('closes on close button', (WidgetTester tester) async {
    await tester.tap(find.byKey(Key('error dialog close button')));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('error dialog')), findsNothing);
  ***REMOVED***);
***REMOVED***
