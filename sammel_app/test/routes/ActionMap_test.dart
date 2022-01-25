import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ActionMap.dart';
import 'package:sammel_app/services/PlacardsService.dart';
import 'package:sammel_app/services/VisitedHouseView.dart';
import 'package:sammel_app/services/VisitedHousesService.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';

import '../shared/TestdatenVorrat.dart';
import '../model/Termin_test.dart';
import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.trainer.dart';

late MockVisitedHousesService _visitedHousesService =
    MockVisitedHousesService();
late MockPlacardsService _placardsService = MockPlacardsService();

void main() {
  trainTranslation(MockTranslations());

  setUpAll(() {
    HttpOverrides.global = MapHttpOverrides();
    reset(_visitedHousesService);
    reset(_placardsService);
    when(_placardsService.loadPlacards()).thenAnswer((_) => Future.value([]));
    when(_visitedHousesService.loadVisitedHouses())
        .thenAnswer((_) => Future.value([]));
    when(_visitedHousesService.getVisitedHousesInArea(any))
        .thenReturn(VisitedHouseView(BoundingBox(0, 0, 0, 0), []));
  });

  testWidgets('uses default values', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: Scaffold(body: _mock(ActionMap()))));

    ActionMap actionMap = tester.widget(find.byType(ActionMap));
    expect(actionMap.termine, []);
    expect(actionMap.listLocations, []);
  });

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
                  openActionDetails: (_) {})));
    });

    testWidgets('show all actions', (WidgetTester tester) async {
      await tester.pumpWidget(_mock(actionMap));

      expect(find.byKey(Key('action marker')), findsNWidgets(3));
    });

    testWidgets('are hightlighted for own actions',
        (WidgetTester tester) async {
      var isMyAction = (Termin action) => action.id == 2;

      var morgen = DateTime.now()..add(Duration(days: 1));
      await tester.pumpWidget(_mock(MaterialApp(
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
                  openActionDetails: (_) {})))));

      List<TextButton> actionMarker = tester
          .widgetList(find.byKey(Key('action marker')))
          .map((widget) => widget as TextButton)
          .toList();

      expect(actionMarker.length, 3);

      expect(
          actionMarker[0]
              .style!
              .backgroundColor!
              .resolve({MaterialState.hovered}),
          CampaignTheme.primaryLight);
      expect(
          actionMarker[1]
              .style!
              .backgroundColor!
              .resolve({MaterialState.hovered}),
          CampaignTheme.altSecondaryLight);
      expect(
          actionMarker[2]
              .style!
              .backgroundColor!
              .resolve({MaterialState.hovered}),
          CampaignTheme.primaryLight);
    });

    testWidgets('are higlighted for past actions', (WidgetTester tester) async {
      var isMyAction = (Termin action) => action.id == 2;
      var iAmParticipant = (Termin action) => action.participants!.isNotEmpty;

      await tester.pumpWidget(_mock(MaterialApp(
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
                  openActionDetails: (_) {})))));

      List<TextButton> actionMarker = tester
          .widgetList(find.byKey(Key('action marker')))
          .map((widget) => widget as TextButton)
          .toList();

      expect(actionMarker.length, 3);

      expect(
          actionMarker[0]
              .style!
              .backgroundColor!
              .resolve({MaterialState.hovered}),
          CampaignTheme.altPrimaryLight);
      expect(
          actionMarker[2]
              .style!
              .backgroundColor!
              .resolve({MaterialState.hovered}),
          CampaignTheme.primaryBright);
      expect(
          actionMarker[1]
              .style!
              .backgroundColor!
              .resolve({MaterialState.hovered}),
          CampaignTheme.altSecondaryBright);
    });

    testWidgets('are higlighted for joined actions',
        (WidgetTester tester) async {
      var iAmParticipant = (Termin action) => action.participants!.isNotEmpty;

      await tester.pumpWidget(_mock(MaterialApp(
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
                  openActionDetails: (_) {})))));

      List<TextButton> actionMarker = tester
          .widgetList(find.byKey(Key('action marker')))
          .map((widget) => widget as TextButton)
          .toList();

      expect(actionMarker.length, 3);

      expect(
          actionMarker[0]
              .style!
              .backgroundColor!
              .resolve({MaterialState.hovered}),
          CampaignTheme.primaryBright);
      expect(
          actionMarker[1]
              .style!
              .backgroundColor!
              .resolve({MaterialState.hovered}),
          CampaignTheme.altPrimaryLight);
      expect(
          actionMarker[2]
              .style!
              .backgroundColor!
              .resolve({MaterialState.hovered}),
          CampaignTheme.primaryBright);
    });

    testWidgets('react to tap', (WidgetTester tester) async {
      bool iHaveBeenCalled = false;

      await tester.pumpWidget(_mock(MaterialApp(
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
                  openActionDetails: (_) => iHaveBeenCalled = true)))));

      expect(iHaveBeenCalled, false);

      await tester.tap(find.byKey(Key('action marker')).first);
      await tester.pump();

      expect(iHaveBeenCalled, true);
    });
  });

  testWidgets('shows all list locations', (WidgetTester tester) async {
    await tester.pumpWidget(_mock(MaterialApp(
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
                openActionDetails: (_) {})))));

    ActionMap map = tester.widget<ActionMap>(find.byKey(Key('action map')));
    map.mapController.move(LatLng(curry36().latitude, curry36().longitude), 14);
    await tester.pumpAndSettle();

    expect(find.byKey(Key('list location marker')), findsNWidgets(3));
  });

  testWidgets('shows all placards', (WidgetTester tester) async {
    reset(_placardsService);
    when(_placardsService.loadPlacards())
        .thenAnswer((_) => Future.value([placard1(), placard2(), placard3()]));

    await tester.pumpWidget(_mock(MaterialApp(
        home: Scaffold(
            body: ActionMap(
                key: Key('action map'),
                termine: [],
                isMyAction: (_) => false,
                openActionDetails: (_) {})))));

    ActionMap map = tester.widget<ActionMap>(find.byKey(Key('action map')));
    map.mapController
        .move(LatLng(placard1().latitude, placard1().longitude), 15);
    await tester.pumpAndSettle();

    expect(find.byKey(Key('placard marker')), findsNWidgets(3));
  });

  testWidgets('hides list locations when far away',
      (WidgetTester tester) async {
    await tester.pumpWidget(_mock(MaterialApp(
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
                openActionDetails: (_) {})))));

    expect(find.byKey(Key('list location marker')), findsNothing);
  });

  testWidgets('opens list location info on tap', (WidgetTester tester) async {
    await tester.pumpWidget(_mock(MaterialApp(
        home: Scaffold(
            body: ActionMap(
                key: Key('action map'),
                termine: [],
                listLocations: [curry36()],
                isMyAction: (_) => false,
                openActionDetails: (_) {})))));

    ActionMap map = tester.widget<ActionMap>(find.byKey(Key('action map')));
    map.mapController.move(LatLng(curry36().latitude, curry36().longitude), 14);
    await tester.pumpAndSettle();

    expect(find.byKey(Key('list location marker')), findsOneWidget);
    await tester.tap(find.byKey(Key('list location marker')));
    await tester.pump();

    expect(find.byKey(Key('list location info dialog')), findsOneWidget);
    expect(find.text(curry36().name!), findsOneWidget);
  });

  testWidgets('shows mapAction dialog on LongPress',
      (WidgetTester tester) async {
    await tester.pumpWidget(_mock(MaterialApp(
        home: Scaffold(
            body: ActionMap(
                key: Key('action map'),
                termine: [],
                listLocations: [],
                switchToActionCreator: (_) {},
                openActionDetails: (_) {})))));

    await tester.longPress(find.byKey(Key('action map')));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('map action dialog')), findsOneWidget);
  });

  testWidgets('calls switchToActionCreator for new action',
      (WidgetTester tester) async {
    LatLng? mapActionParameter;
    Function(LatLng) mapAction =
        (LatLng parameter) => mapActionParameter = parameter;
    await tester.pumpWidget(_mock(MaterialApp(
        home: Scaffold(
            body: ActionMap(
                key: Key('action map'),
                termine: [],
                listLocations: [],
                switchToActionCreator: mapAction,
                openActionDetails: (_) {})))));

    await tester.longPress(find.byKey(Key('action map')));
    await tester.pump();

    await tester.tap(find.byKey(Key('map action dialog action button')));
    await tester.pumpAndSettle();

    expect(mapActionParameter?.latitude.floor(), 52);
    expect(mapActionParameter?.longitude.floor(), 13);
  });

//  Funktioniert nicht wegen null-Exception im dispose vom User-Location-Plugin
//  testWidgets('enables user location plugin when permission granted',
//      (WidgetTester tester) async {
//    await tester.pumpWidget(_mock(MaterialApp(
//        home: Scaffold(
//            body: ActionMap(
//                termine: [],
//                listLocations: [],
//                isMyAction: (_) => false,
//                openActionDetails: () {})))));
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

_mock(Widget actionMap) => MultiProvider(providers: [
      Provider<AbstractVisitedHousesService>.value(
          value: _visitedHousesService),
      Provider<AbstractPlacardsService>.value(value: _placardsService),
    ], child: actionMap);
