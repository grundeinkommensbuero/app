import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:sammel_app/routes/PlacardDialog.dart';

main() {
  PlacardDialogAction? returnValue;

  setUpUI((tester) async {
    returnValue = null;
    await tester
        .pumpWidget(MaterialApp(home: Builder(builder: (BuildContext context) {
      return Center(
          child: ElevatedButton(
              key: Key('starter'),
              child: const Text('Starter'),
              onPressed: () async =>
                  returnValue = await showPlacardDialog(context, true)));
    ***REMOVED***)));

    await tester.tap(find.byKey(Key('starter')));
    await tester.pump();
  ***REMOVED***);

  testUI('showPlacardDialog shows dialog', (tester) async {
    expect(find.byKey(Key('placard dialog')), findsOneWidget);
  ***REMOVED***);

  testUI('showPlacardDialog shows dialog and closes on Cancel', (tester) async {
    await tester.tap(find.byKey(Key('delete placard dialog abort button')));
    await tester.pump();

    expect(returnValue, PlacardDialogAction.CANCEL);
    expect(find.byKey(Key('placard dialog')), findsNothing);
  ***REMOVED***);

  testUI('showPlacardDialog shows dialog and returns DELETE on delete button',
      (tester) async {
    await tester.tap(find.byKey(Key('delete placard button')));
    await tester.pump();

    expect(returnValue, PlacardDialogAction.DELETE);
    expect(find.byKey(Key('placard dialog')), findsNothing);
  ***REMOVED***);

  testUI('showPlacardDialog shows dialog and returns TAKE_DOWN on delete button',
      (tester) async {
    await tester.tap(find.byKey(Key('take down placard button')));
    await tester.pump();

    expect(returnValue, PlacardDialogAction.TAKE_DOWN);
    expect(find.byKey(Key('placard dialog')), findsNothing);
  ***REMOVED***);
***REMOVED***
