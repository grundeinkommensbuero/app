import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ActionList.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/services/StorageService.dart';

import '../model/Termin_test.dart';
import '../shared/mocks.trainer.dart';
import '../shared/mocks.mocks.dart';
import '../shared/TestdatenVorrat.dart';

final _storageService = trainStorageService(MockStorageService());


void main() {
  trainTranslation(MockTranslations());
  initializeDateFormatting('de');

  testWidgets('TermineSeite shows all actions', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
        providers: [
          Provider<StorageService>.value(value: _storageService),
        ],
        child: MaterialApp(
            home: Scaffold(
                body: ActionList([
                  TerminTestDaten.einTermin(),
                  TerminTestDaten.einTermin(),
                  TerminTestDaten.einTermin(),
                ], (_) => false, (_) => false, (_) => false, (_) {})))));

    expect(find.byType(TerminCard), findsNWidgets(3));
  });

  testWidgets('marks own actions for highlighting',
      (WidgetTester tester) async {
    var isMyAction = (Termin action) => action.id == 2;

    await tester.pumpWidget(MultiProvider(
        providers: [
          Provider<StorageService>.value(value: _storageService),
        ],
        child: MaterialApp(
        home: Scaffold(
            body: ActionList([
      TerminTestDaten.einTermin()..id = 1,
      TerminTestDaten.einTermin()..id = 2,
      TerminTestDaten.einTermin()..id = 3,
    ], isMyAction, (_) => false, (_) => true, (_) {})))));

    List<TerminCard> actionCards = tester
        .widgetList(find.byKey(Key('action card')))
        .map((widget) => widget as TerminCard)
        .toList();

    expect(actionCards.length, 3);

    expect(actionCards[0].myAction, false);
    expect(actionCards[1].myAction, true);
    expect(actionCards[2].myAction, false);
  });

  testWidgets('marks participating actions for highlighting',
      (WidgetTester tester) async {
    var participating = (Termin action) => action.participants![0].id == 11;

    await tester.pumpWidget(MultiProvider(
        providers: [
          Provider<StorageService>.value(value: _storageService),
        ],
        child: MaterialApp(
        home: Scaffold(
            body: ActionList([
      TerminTestDaten.einTermin()..participants = [rosa()],
      TerminTestDaten.einTermin()..participants = [karl()],
      TerminTestDaten.einTermin()..participants = [rosa()],
    ], (_) => false, (_) => false, participating, (_) {})))));

    List<TerminCard> actionCards = tester
        .widgetList(find.byKey(Key('action card')))
        .map((widget) => widget as TerminCard)
        .toList();

    expect(actionCards.length, 3);

    expect(actionCards[0].participant, false);
    expect(actionCards[1].participant, true);
    expect(actionCards[2].participant, false);
  });
}
