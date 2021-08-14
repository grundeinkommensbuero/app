import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:sammel_app/routes/MapActionDialog.dart';

main() {
  MapActionType? returnValue;

  setUpUI((tester) async {
    returnValue = null;

    await tester
        .pumpWidget(MaterialApp(home: Builder(builder: (BuildContext context) {
      return Center(
          child: ElevatedButton(
              key: Key('starter'),
              child: const Text('Starter'),
              onPressed: () async =>
                  returnValue = await showMapActionDialog(context)));
    ***REMOVED***)));

    await tester.tap(find.byKey(Key('starter')));
    await tester.pump();
  ***REMOVED***);

  testUI('showMapActionDialog opens MapActionDialog', (tester) async {
    expect(find.byType(AlertDialog), findsOneWidget);
  ***REMOVED***);

  testUI('MapActionDialog shows buttons', (tester) async {
    expect(find.byKey(Key('map action dialog action button')), findsOneWidget);
    expect(find.byKey(Key('map action dialog placard button')), findsOneWidget);
    expect(find.byKey(Key('map action dialog visited house button')),
        findsOneWidget);
    expect(find.byKey(Key('map action dialog abort button')), findsOneWidget);
  ***REMOVED***);

  testUI('action button closes dialog with NewAction value', (tester) async {
    await tester.tap(find.byKey(Key('map action dialog action button')));
    await tester.pump();

    expect(returnValue, MapActionType.NewAction);
  ***REMOVED***);

  testUI('placard button closes dialog with NewAction value', (tester) async {
    await tester.tap(find.byKey(Key('map action dialog placard button')));
    await tester.pump();

    expect(returnValue, MapActionType.NewPlacard);
  ***REMOVED***);

  testUI('visited house button closes dialog with NewAction value', (tester) async {
    await tester.tap(find.byKey(Key('map action dialog visited house button')));
    await tester.pump();

    expect(returnValue, MapActionType.NewVisitedHouse);
  ***REMOVED***);

  testUI('abort button closes dialog withn null value', (tester) async {
    await tester.tap(find.byKey(Key('map action dialog abort button')));
    await tester.pump();

    expect(returnValue, isNull);
  ***REMOVED***);
***REMOVED***
