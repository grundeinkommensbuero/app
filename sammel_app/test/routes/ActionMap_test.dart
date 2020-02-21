import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/routes/ActionList.dart';
import 'package:sammel_app/routes/ActionMap.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/DweTheme.dart';

import '../model/Termin_test.dart';
import 'ActionList_test.dart';

class TermineServiceMock extends Mock implements TermineService {***REMOVED***

final terminService = TermineServiceMock();

class StorageServiceMock extends Mock implements StorageService {***REMOVED***

final storageService = StorageServiceMock();

void main() {
  testWidgets('TermineSeite shows all actions', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionMap([
      TerminTestDaten.einTermin(),
      TerminTestDaten.einTermin(),
      TerminTestDaten.einTermin(),
    ], (_) => false, () {***REMOVED***))));

    expect(find.byKey(Key('action marker')), findsNWidgets(3));
  ***REMOVED***);

  testWidgets('marks own actions',
      (WidgetTester tester) async {

    var isMyAction = (id) => id == 2;

    var morgen = DateTime.now()..add(Duration(days: 1));
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionMap([
      TerminTestDaten.anActionFrom(morgen)..id = 1,
      TerminTestDaten.anActionFrom(morgen)..id = 2,
      TerminTestDaten.anActionFrom(morgen)..id = 3,
    ], isMyAction, () {***REMOVED***))));

    List<FlatButton> actionMarker = tester
        .widgetList(find.byKey(Key('action marker')))
        .map((widget) => widget as FlatButton)
        .toList();

    expect(actionMarker.length, 3);

    expect(actionMarker[0].color, DweTheme.yellowLight);
    expect(actionMarker[1].color, DweTheme.green);
    expect(actionMarker[2].color, DweTheme.yellowLight);
  ***REMOVED***);

  testWidgets('marks past actions',
      (WidgetTester tester) async {
    var isMyAction = (id) => id == 2;

    var gestern = DateTime.now()..subtract(Duration(days: 1));

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionMap([
      TerminTestDaten.einTermin()..id = 1,
      TerminTestDaten.einTermin()..id = 2,
      TerminTestDaten.einTermin()..id = 3,
    ], isMyAction, () {***REMOVED***))));

    List<FlatButton> actionMarker = tester
        .widgetList(find.byKey(Key('action marker')))
        .map((widget) => widget as FlatButton)
        .toList();

    expect(actionMarker.length, 3);

    expect(actionMarker[0].color, DweTheme.yellowBright);
    expect(actionMarker[1].color, DweTheme.greenLight);
    expect(actionMarker[2].color, DweTheme.yellowBright);
  ***REMOVED***);
***REMOVED***
