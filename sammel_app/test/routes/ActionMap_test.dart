import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/routes/ActionMap.dart';
import 'package:sammel_app/shared/DweTheme.dart';

import '../TestdataStorage.dart';
import '../model/Termin_test.dart';
import '../shared/Mocks.dart';

final terminService = TermineServiceMock();
final storageService = StorageServiceMock();

void main() {
  testWidgets('uses default values', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ActionMap())));

    ActionMap actionMap = tester.widget(find.byType(ActionMap));
    expect(actionMap.termine, []);
    expect(actionMap.listLocations, []);
    expect(actionMap.isMyAction(), isFalse);
  });

  group('action marker', () {
    Widget actionMap;
    setUp(() {
      actionMap = MaterialApp(
          home: Scaffold(
              body: ActionMap(
                  termine: [
            TerminTestDaten.einTermin()..id = 1,
            TerminTestDaten.einTermin()..id = 2,
            TerminTestDaten.einTermin()..id = 3,
          ],
                  listLocations: [],
                  isMyAction: (_) => false,
                  openActionDetails: () {})));
    });

    testWidgets('show all actions', (WidgetTester tester) async {
      await tester.pumpWidget(actionMap);

      expect(find.byKey(Key('action marker')), findsNWidgets(3));
    });

    testWidgets('are hightlighted for own actions',
        (WidgetTester tester) async {
      var isMyAction = (id) => id == 2;

      var morgen = DateTime.now()..add(Duration(days: 1));
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: ActionMap(
                  termine: [
            TerminTestDaten.anActionFrom(morgen)..id = 1,
            TerminTestDaten.anActionFrom(morgen)..id = 2,
            TerminTestDaten.anActionFrom(morgen)..id = 3,
          ],
                  listLocations: [],
                  isMyAction: isMyAction,
                  openActionDetails: () {}))));

      List<FlatButton> actionMarker = tester
          .widgetList(find.byKey(Key('action marker')))
          .map((widget) => widget as FlatButton)
          .toList();

      expect(actionMarker.length, 3);

      expect(actionMarker[0].color, DweTheme.yellowLight);
      expect(actionMarker[1].color, DweTheme.green);
      expect(actionMarker[2].color, DweTheme.yellowLight);
    });

    testWidgets('are higlighted for past actions', (WidgetTester tester) async {
      var isMyAction = (id) => id == 2;

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: ActionMap(
                  termine: [
            TerminTestDaten.einTermin()..id = 1,
            TerminTestDaten.einTermin()..id = 2,
            TerminTestDaten.einTermin()..id = 3,
          ],
                  listLocations: [],
                  isMyAction: isMyAction,
                  openActionDetails: () {}))));

      List<FlatButton> actionMarker = tester
          .widgetList(find.byKey(Key('action marker')))
          .map((widget) => widget as FlatButton)
          .toList();

      expect(actionMarker.length, 3);

      expect(actionMarker[0].color, DweTheme.yellowBright);
      expect(actionMarker[1].color, DweTheme.greenLight);
      expect(actionMarker[2].color, DweTheme.yellowBright);
    });

    testWidgets('react to tap', (WidgetTester tester) async {
      bool iHaveBeenCalled = false;

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: ActionMap(
                  termine: [
            TerminTestDaten.einTermin()..id = 1,
            TerminTestDaten.einTermin()..id = 2,
            TerminTestDaten.einTermin()..id = 3,
          ],
                  listLocations: [],
                  isMyAction: (_) => false,
                  openActionDetails: (_1, _2) => iHaveBeenCalled = true))));

      expect(iHaveBeenCalled, false);

      await tester.tap(find.byKey(Key('action marker')).first);
      await tester.pump();

      expect(iHaveBeenCalled, true);
    });
  });

  testWidgets('shows all list locations', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionMap(
                termine: [],
                listLocations: [curry36(), cafeKotti(), zukunft()],
                isMyAction: (_) => false,
                openActionDetails: () {}))));

    expect(find.byKey(Key('list location marker')), findsNWidgets(3));
  });

  testWidgets('opens list location info on tap', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionMap(
                termine: [],
                listLocations: [curry36()],
                isMyAction: (_) => false,
                openActionDetails: () {}))));

    expect(find.byKey(Key('list location marker')), findsOneWidget);
    await tester.tap(find.byKey(Key('list location marker')));
    await tester.pump();

    expect(find.byKey(Key('list location info dialog')), findsOneWidget);
    expect(find.text(curry36().name), findsOneWidget);
  });

//  Funktioniert nicht wegen null-Exception im dispose vom User-Location-Plugin
//  testWidgets('enables user location plugin when permission granted',
//      (WidgetTester tester) async {
//    await tester.pumpWidget(MaterialApp(
//        home: Scaffold(
//            body: ActionMap(
//                termine: [],
//                listLocations: [],
//                isMyAction: (_) => false,
//                openActionDetails: () {}))));
//
//    var state = tester.state<ActionMapState>(find.byType(ActionMap));
//
//    var map = tester.widget<FlutterMap>(find.byType(FlutterMap));
//
//    // before permission
//    expect(
//        map.layers
//            .map((layer) => layer.runtimeType)
//            .contains(UserLocationOptions),
//        isFalse);
//    expect(
//        map.options.plugins
//            .map((layer) => layer.runtimeType)
//            .contains(UserLocationPlugin),
//        isFalse);
//
//    state.setState(() => state.locationPermissionGranted = true);
//    await tester.pumpAndSettle(Duration(milliseconds: 300));
//
//
//    // after permission
//    expect(
//        map.layers
//            .map((layer) => layer.runtimeType)
//            .contains(UserLocationOptions),
//        isTrue);
//    expect(
//        map.options.plugins
//            .map((layer) => layer.runtimeType)
//            .contains(UserLocationPlugin),
//        isTrue);
//  });
}
