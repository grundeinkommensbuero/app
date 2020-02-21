import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/routes/ActionList.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';

import '../model/Termin_test.dart';

class TermineServiceMock extends Mock implements TermineService {***REMOVED***

final terminService = TermineServiceMock();

class StorageServiceMock extends Mock implements StorageService {***REMOVED***

final storageService = StorageServiceMock();

void main() {
  testWidgets('TermineSeite shows all actions', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionList([
      TerminTestDaten.einTermin(),
      TerminTestDaten.einTermin(),
      TerminTestDaten.einTermin(),
    ], (_) => false, () {***REMOVED***))));

    expect(find.byType(TerminCard), findsNWidgets(3));
  ***REMOVED***);

  testWidgets('marks own actions for highlighting',
      (WidgetTester tester) async {
    var isMyAction = (id) => id == 2;

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionList([
      TerminTestDaten.einTermin()..id = 1,
      TerminTestDaten.einTermin()..id = 2,
      TerminTestDaten.einTermin()..id = 3,
    ], isMyAction, () {***REMOVED***))));

    List<TerminCard> actionCards = tester
        .widgetList(find.byKey(Key('action card')))
        .map((widget) => widget as TerminCard)
        .toList();

    expect(actionCards.length, 3);

    expect(actionCards[0].myAction, false);
    expect(actionCards[1].myAction, true);
    expect(actionCards[2].myAction, false);
  ***REMOVED***);
***REMOVED***
