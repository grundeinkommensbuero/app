import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/routes/ActionList.dart';
import 'package:sammel_app/routes/TerminCard.dart';

import '../model/Termin_test.dart';

void main() {
  testWidgets('TermineSeite shows all actions', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionList([
      TerminTestDaten.einTermin(),
      TerminTestDaten.einTermin(),
      TerminTestDaten.einTermin(),
    ], (_) => false, (_) => false, () {***REMOVED***))));

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
    ], isMyAction, (_) => true, () {***REMOVED***))));

    List<TerminCard> actionCards = tester
        .widgetList(find.byKey(Key('action card')))
        .map((widget) => widget as TerminCard)
        .toList();

    expect(actionCards.length, 3);

    expect(actionCards[0].myAction, false);
    expect(actionCards[1].myAction, true);
    expect(actionCards[2].myAction, false);
  ***REMOVED***);

  testWidgets('marks participating actions for highlighting',
      (WidgetTester tester) async {
    var participating = (List<User> user) => user[0].id == 1;

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionList([
      TerminTestDaten.einTermin()..participants = [rosa()],
      TerminTestDaten.einTermin()..participants = [karl()],
      TerminTestDaten.einTermin()..participants = [rosa()],
    ], (_) => false, participating, () {***REMOVED***))));

    List<TerminCard> actionCards = tester
        .widgetList(find.byKey(Key('action card')))
        .map((widget) => widget as TerminCard)
        .toList();

    expect(actionCards.length, 3);

    expect(actionCards[0].participant, false);
    expect(actionCards[1].participant, true);
    expect(actionCards[2].participant, false);
  ***REMOVED***);
***REMOVED***
