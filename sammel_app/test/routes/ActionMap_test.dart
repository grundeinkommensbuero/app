import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ActionMap.dart';
import 'package:sammel_app/shared/DweTheme.dart';

import '../TestdataStorage.dart';
import '../model/Termin_test.dart';
import '../shared/TestdatenVorrat.dart';
import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.trainer.dart';

void main() {
  trainTranslation(MockTranslations());

  setUpAll(() {
    HttpOverrides.global = MapHttpOverrides();
  ***REMOVED***);

  testWidgets('uses default values', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ActionMap())));

    ActionMap actionMap = tester.widget(find.byType(ActionMap));
    expect(actionMap.termine, []);
    expect(actionMap.listLocations, []);
  ***REMOVED***);

  group('action marker', () {
    late Widget actionMap;
    setUp(() {
      actionMap = MaterialApp(
          home: Scaffold(
              body: ActionMap(
                  termine: [
            TerminTestDaten.einTermin()
              ..longitude =
                  13.46336 // Abstand halten, um clustern zu verhindern
              ..latitude = 52.48756
              ..id = 1,
            TerminTestDaten.einTermin()
              ..longitude =
                  13.47192 // Abstand halten, um clustern zu verhindern
              ..latitude = 52.40000
              ..id = 2,
            TerminTestDaten.einTermin()..id = 3,
          ],
                  listLocations: [],
                  isMyAction: (_) => false,
                  iAmParticipant: (_) => false,
                  openActionDetails: (_) {***REMOVED***)));
    ***REMOVED***);

    testWidgets('show all actions', (WidgetTester tester) async {
      await tester.pumpWidget(actionMap);

      expect(find.byKey(Key('action marker')), findsNWidgets(3));
    ***REMOVED***);

    testWidgets('are hightlighted for own actions',
        (WidgetTester tester) async {
      var isMyAction = (Termin action) => action.id == 2;

      var morgen = DateTime.now()..add(Duration(days: 1));
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: ActionMap(
                  termine: [
            TerminTestDaten.anActionFrom(morgen)
              ..longitude =
                  13.46336 // Abstand halten, um clustern zu verhindern
              ..latitude = 52.48756
              ..id = 1,
            TerminTestDaten.anActionFrom(morgen)
              ..longitude =
                  13.47192 // Abstand halten, um clustern zu verhindern
              ..latitude = 52.40000
              ..id = 2,
            TerminTestDaten.anActionFrom(morgen)..id = 3,
          ],
                  listLocations: [],
                  isMyAction: isMyAction,
                  iAmParticipant: (_) => false,
                  openActionDetails: (_) {***REMOVED***))));

      List<FlatButton> actionMarker = tester
          .widgetList(find.byKey(Key('action marker')))
          .map((widget) => widget as FlatButton)
          .toList();

      expect(actionMarker.length, 3);

      expect(actionMarker[0].color, DweTheme.yellowLight);
      expect(actionMarker[1].color, DweTheme.blueLight);
      expect(actionMarker[2].color, DweTheme.yellowLight);
    ***REMOVED***);

    testWidgets('are higlighted for past actions', (WidgetTester tester) async {
      var isMyAction = (Termin action) => action.id == 2;
      var iAmParticipant = (Termin action) => action.participants!.isNotEmpty;

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: ActionMap(
                  termine: [
            TerminTestDaten.einTermin()
              ..longitude =
                  13.46336 // Abstand halten, um clustern zu verhindern
              ..latitude = 52.48756
              ..id = 1,
            TerminTestDaten.einTermin()
              ..longitude =
                  13.47192 // Abstand halten, um clustern zu verhindern
              ..latitude = 52.40000
              ..id = 2,
            TerminTestDaten.einTermin()
              ..id = 3
              ..participants = [karl()],
          ],
                  listLocations: [],
                  isMyAction: isMyAction,
                  iAmParticipant: iAmParticipant,
                  openActionDetails: (_) {***REMOVED***))));

      List<FlatButton> actionMarker = tester
          .widgetList(find.byKey(Key('action marker')))
          .map((widget) => widget as FlatButton)
          .toList();

      expect(actionMarker.length, 3);

      expect(actionMarker[0].color, DweTheme.greenLight);
      expect(actionMarker[2].color, DweTheme.yellowBright);
      expect(actionMarker[1].color, DweTheme.blueBright);
    ***REMOVED***);

    testWidgets('are higlighted for joined actions',
        (WidgetTester tester) async {
      var iAmParticipant = (Termin action) => action.participants!.isNotEmpty;

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: ActionMap(
                  termine: [
            TerminTestDaten.einTermin()
              ..longitude =
                  13.46336 // Abstand halten, um clustern zu verhindern
              ..latitude = 52.48756
              ..id = 1,
            TerminTestDaten.einTermin()
              ..longitude =
                  13.47192 // Abstand halten, um clustern zu verhindern
              ..latitude = 52.40000
              ..id = 2
              ..participants = [karl()],
            TerminTestDaten.einTermin()
          ],
                  listLocations: [],
                  isMyAction: (_) => false,
                  iAmParticipant: iAmParticipant,
                  openActionDetails: (_) {***REMOVED***))));

      List<FlatButton> actionMarker = tester
          .widgetList(find.byKey(Key('action marker')))
          .map((widget) => widget as FlatButton)
          .toList();

      expect(actionMarker.length, 3);

      expect(actionMarker[0].color, DweTheme.yellowBright);
      expect(actionMarker[1].color, DweTheme.greenLight);
      expect(actionMarker[2].color, DweTheme.yellowBright);
    ***REMOVED***);

    testWidgets('react to tap', (WidgetTester tester) async {
      bool iHaveBeenCalled = false;

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: ActionMap(
                  termine: [
            TerminTestDaten.einTermin()
              ..longitude =
                  13.46336 // Abstand halten, um clustern zu verhindern
              ..latitude = 52.48756
              ..id = 1,
            TerminTestDaten.einTermin()
              ..longitude =
                  13.47192 // Abstand halten, um clustern zu verhindern
              ..latitude = 52.40000
              ..id = 2,
            TerminTestDaten.einTermin()..id = 3,
          ],
                  listLocations: [],
                  isMyAction: (_) => false,
                  iAmParticipant: (_) => false,
                  openActionDetails: (_) => iHaveBeenCalled = true))));

      expect(iHaveBeenCalled, false);

      await tester.tap(find.byKey(Key('action marker')).first);
      await tester.pump();

      expect(iHaveBeenCalled, true);
    ***REMOVED***);
  ***REMOVED***);

  testWidgets('shows all list locations', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionMap(
                key: Key('action map'),
                termine: [],
                listLocations: [
                  curry36(),
                  // müssen in der Nähe sein, weil nur nah rangezoomt sichtbar
                  curry36()..id = '2',
                  curry36()..id = '3'
                ],
                isMyAction: (_) => false,
                openActionDetails: (_) {***REMOVED***))));

    ActionMap map = tester.widget<ActionMap>(find.byKey(Key('action map')));
    map.mapController.move(LatLng(curry36().latitude, curry36().longitude), 14);
    await tester.pumpAndSettle();

    expect(find.byKey(Key('list location marker')), findsNWidgets(3));
  ***REMOVED***);

  testWidgets('hides list locations when far away',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionMap(
                key: Key('action map'),
                termine: [],
                listLocations: [
                  curry36(),
                  curry36()..id = '2',
                  curry36()..id = '3'
                ],
                isMyAction: (_) => false,
                openActionDetails: (_) {***REMOVED***))));

    expect(find.byKey(Key('list location marker')), findsNothing);
  ***REMOVED***);

  testWidgets('opens list location info on tap', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ActionMap(
                key: Key('action map'),
                termine: [],
                listLocations: [curry36()],
                isMyAction: (_) => false,
                openActionDetails: (_) {***REMOVED***))));

    ActionMap map = tester.widget<ActionMap>(find.byKey(Key('action map')));
    map.mapController.move(LatLng(curry36().latitude, curry36().longitude), 14);
    await tester.pumpAndSettle();

    expect(find.byKey(Key('list location marker')), findsOneWidget);
    await tester.tap(find.byKey(Key('list location marker')));
    await tester.pump();

    expect(find.byKey(Key('list location info dialog')), findsOneWidget);
    expect(find.text(curry36().name!), findsOneWidget);
  ***REMOVED***);

//  Funktioniert nicht wegen null-Exception im dispose vom User-Location-Plugin
//  testWidgets('enables user location plugin when permission granted',
//      (WidgetTester tester) async {
//    await tester.pumpWidget(MaterialApp(
//        home: Scaffold(
//            body: ActionMap(
//                termine: [],
//                listLocations: [],
//                isMyAction: (_) => false,
//                openActionDetails: () {***REMOVED***))));
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
//  ***REMOVED***);
***REMOVED***
