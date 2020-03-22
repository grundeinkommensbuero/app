import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/routes/ActionMap.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/DweTheme.dart';

import '../TestdataStorage.dart';
import '../model/Termin_test.dart';

class TermineServiceMock extends Mock implements TermineService {***REMOVED***

final terminService = TermineServiceMock();

class StorageServiceMock extends Mock implements StorageService {***REMOVED***

final storageService = StorageServiceMock();

void main() {
  testWidgets('TermineSeite uses default values', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ActionMap())));

    ActionMap actionMap = await tester.widget(find.byType(ActionMap));
    expect(actionMap.termine, []);
    expect(actionMap.listLocations, []);
    expect(actionMap.isMyAction(), isFalse);
  ***REMOVED***);

  testWidgets('TermineSeite shows all actions', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionMap(
                termine: [
          TerminTestDaten.einTermin(),
          TerminTestDaten.einTermin(),
          TerminTestDaten.einTermin(),
        ],
                listLocations: [],
                isMyAction: (_) => false,
                openActionDetails: () {***REMOVED***))));

    expect(find.byKey(Key('action marker')), findsNWidgets(3));
  ***REMOVED***);

  testWidgets('marks own actions', (WidgetTester tester) async {
    var isMyAction = (id) => id == 2;

    var morgen = DateTime.now()..add(Duration(days: 1));
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionMap(termine: [
      TerminTestDaten.anActionFrom(morgen)..id = 1,
      TerminTestDaten.anActionFrom(morgen)..id = 2,
      TerminTestDaten.anActionFrom(morgen)..id = 3,
    ], listLocations: [], isMyAction: isMyAction, openActionDetails: () {***REMOVED***))));

    List<FlatButton> actionMarker = tester
        .widgetList(find.byKey(Key('action marker')))
        .map((widget) => widget as FlatButton)
        .toList();

    expect(actionMarker.length, 3);

    expect(actionMarker[0].color, DweTheme.yellowLight);
    expect(actionMarker[1].color, DweTheme.green);
    expect(actionMarker[2].color, DweTheme.yellowLight);
  ***REMOVED***);

  testWidgets('marks past actions', (WidgetTester tester) async {
    var isMyAction = (id) => id == 2;

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionMap(termine: [
      TerminTestDaten.einTermin()..id = 1,
      TerminTestDaten.einTermin()..id = 2,
      TerminTestDaten.einTermin()..id = 3,
    ], listLocations: [], isMyAction: isMyAction, openActionDetails: () {***REMOVED***))));

    List<FlatButton> actionMarker = tester
        .widgetList(find.byKey(Key('action marker')))
        .map((widget) => widget as FlatButton)
        .toList();

    expect(actionMarker.length, 3);

    expect(actionMarker[0].color, DweTheme.yellowBright);
    expect(actionMarker[1].color, DweTheme.greenLight);
    expect(actionMarker[2].color, DweTheme.yellowBright);
  ***REMOVED***);

  testWidgets('TermineSeite shows all list locations',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionMap(
                termine: [],
                listLocations: [curry36(), cafeKotti(), zukunft()],
                isMyAction: (_) => false,
                openActionDetails: () {***REMOVED***))));

    expect(find.byKey(Key('list location marker')), findsNWidgets(3));
  ***REMOVED***);
***REMOVED***
