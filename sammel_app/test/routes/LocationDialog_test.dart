import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/LocationDialog.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/StammdatenService.dart';

import '../services/StammdatenService_test.dart';
import '../shared/Mocks.dart';

late StammdatenService _stammdatenService;
final GeoService _geoService = GeoServiceMock();

void main() {
  setUp(() async {
    Localization.load(Locale('en'), translations: TranslationsMock());
    reset(_geoService);
    when(_geoService.getDescriptionToPoint(any))
        .thenAnswer((_) async => GeoData('name', 'street', '12'));
    StammdatenService.fileReader = TestFileReader();
    _stammdatenService = StammdatenService();
    await _stammdatenService.kieze;
  ***REMOVED***);

  testWidgets('opens dialog', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
        providers: [
          Provider<StammdatenService>.value(value: _stammdatenService),
          Provider<GeoService>.value(value: _geoService)
        ],
        child: MaterialApp(
            home: LocationDialogTester('description', null, null))));

    expect(find.byType(LocationDialog), findsNothing);

    await tester.tap(find.byKey(Key('open location dialog')));
    await tester.pump();

    expect(find.byType(LocationDialog), findsOneWidget);
  ***REMOVED***);

  group('presentation', () {
    testWidgets('shows map', (WidgetTester tester) async {
      var initCoordinates;
      var center;
      await pumpLocationDialogTester(
          tester, 'description', initCoordinates, center);

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      expect(find.byKey(Key('venue map')), findsOneWidget);
    ***REMOVED***);

    testWidgets('shows description input field', (WidgetTester tester) async {
      var initCoordinates;
      var center;
      await pumpLocationDialogTester(
          tester, 'description', initCoordinates, center);

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      expect(find.byKey(Key('venue description input')), findsOneWidget);
    ***REMOVED***);
  ***REMOVED***);

  group('initially shows', () {
    testWidgets('no marker, if no initial coordinates given',
        (WidgetTester tester) async {
      var initCoordinates;
      var center;
      await pumpLocationDialogTester(
          tester, 'description', initCoordinates, center);

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      expect(find.byType(LocationMarker), findsNothing);
    ***REMOVED***);

    testWidgets('marker, if initial coordinates given',
        (WidgetTester tester) async {
      var initCoordinates = LatLng(52.51579, 13.45399);
      var center;
      await pumpLocationDialogTester(
          tester, 'description', initCoordinates, center);

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      var state =
          tester.state(find.byType(LocationDialog)) as LocationDialogState;
      expect(state.marker?.point, initCoordinates);
      expect(find.byKey(Key('location marker')), findsOneWidget);
    ***REMOVED***);

    testWidgets('description', (WidgetTester tester) async {
      var initCoordinates = LatLng(52.51579, 13.45399);
      var center;
      await pumpLocationDialogTester(
          tester, 'description', initCoordinates, center);

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      expect(find.text('description'), findsOneWidget);
    ***REMOVED***);
  ***REMOVED***);

  group('centers map', () {
    testWidgets('at given coordinates', (tester) async {
      await pumpLocationDialogTester(
          tester, null, null, LatLng(52.49653, 13.43762));
      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      FlutterMap map = tester.widget(find.byKey(Key('venue map')));
      expect(map.options.center, LatLng(52.49653, 13.43762));
      expect(map.options.zoom, 14.0);
    ***REMOVED***);

    testWidgets('at Berlin with no coordinates given', (tester) async {
      await tester.pumpWidget(
          MaterialApp(home: LocationDialogTester(null, null, null)));
      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      FlutterMap map = tester.widget(find.byKey(Key('venue map')));
      expect(map.options.center, LatLng(52.5170365, 13.3888599));
      expect(map.options.zoom, 10.0);
    ***REMOVED***);
  ***REMOVED***);

  group('reads input', () {
    testWidgets('with tap on map and creates marker',
        (WidgetTester tester) async {
      // WTF
      await tester.runAsync(() async {
        await _pumpLocationDialogTester(
            tester, LocationDialogTester('description', null, null));
        await tester.tap(find.byKey(Key('open location dialog')));

        await tester.pump();
        expect(find.byKey(Key('location marker')), findsNothing);

        await tester.tap(find.byKey(Key('venue map')));
        await Future.delayed(Duration(seconds: 1));

        await tester.pump();
        expect(find.byKey(Key('location marker')), findsOneWidget);
      ***REMOVED***);
    ***REMOVED***);

    testWidgets('with tap on map and moves marker',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        var initCoordinates = LatLng(52.51579, 13.45399);
        await _pumpLocationDialogTester(
            tester, LocationDialogTester('description', initCoordinates, null));

        await tester.tap(find.byKey(Key('open location dialog')));
        LocationDialogState state;

        await tester.pump();
        state = tester.state(find.byType(LocationDialog));

        expect(state.marker?.point == initCoordinates, true);

        await tester.tap(find.byKey(Key('venue map')));
        await Future.delayed(Duration(seconds: 1));

        await tester.pumpAndSettle();

        expect(find.byKey(Key('location marker')), findsOneWidget);
        expect(state.marker?.point != initCoordinates, true);
      ***REMOVED***);
    ***REMOVED***);
  ***REMOVED***);

  group('returns', () {
    testWidgets('coordinates', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await _pumpLocationDialogTester(
            tester, LocationDialogTester('description', null, null));

        await tester.tap(find.byKey(Key('open location dialog')));
        await tester.pump();
        LocationDialogState state = tester.state(find.byType(LocationDialog));

        await tester.tap(find.byKey(Key('venue map')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(Key('venue dialog finish button')));
        await tester.pump();
        await Future.delayed(Duration(seconds: 1));

        LocationDialogTester venueTester =
            tester.widget(find.byType(LocationDialogTester));
        expect(venueTester.result?.coordinates, state.marker?.point);
      ***REMOVED***);
    ***REMOVED***);

    testWidgets('new coordinates', (WidgetTester tester) async {
      await _pumpLocationDialogTester(
          tester,
          LocationDialogTester(
              'description', LatLng(52.51579, 13.45399), null));

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();
      LocationDialogState state = tester.state(find.byType(LocationDialog));

      await tester.tap(find.byKey(Key('venue map')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('venue dialog finish button')));
      await tester.pump();

      LocationDialogTester venueTester =
          tester.widget(find.byType(LocationDialogTester));
      expect(venueTester.result!.coordinates, state.marker!.point);
    ***REMOVED***);

    testWidgets('description', (WidgetTester tester) async {
      await _pumpLocationDialogTester(
          tester, LocationDialogTester(null, null, null));

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      await tester.enterText(
          find.byKey(Key('venue description input')), 'description');

      await tester.tap(find.byKey(Key('venue dialog finish button')));
      await tester.pump();

      LocationDialogTester venueTester =
          tester.widget(find.byType(LocationDialogTester));
      expect(venueTester.result!.description, 'description');
    ***REMOVED***);

    testWidgets('new description', (WidgetTester tester) async {
      await pumpLocationDialogTester(tester, 'description', null, null);

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      await tester.enterText(
          find.byKey(Key('venue description input')), 'new description');

      await tester.tap(find.byKey(Key('venue dialog finish button')));
      await tester.pump();

      LocationDialogTester venueTester =
          tester.widget(find.byType(LocationDialogTester));
      expect(venueTester.result!.description, 'new description');
    ***REMOVED***);

    testWidgets('old values, with no input', (WidgetTester tester) async {
      await pumpLocationDialogTester(
          tester, 'description', LatLng(52.51579, 13.45399), null);

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      await tester.tap(find.byKey(Key('venue dialog finish button')));
      await tester.pump();

      LocationDialogTester venueTester =
          tester.widget(find.byType(LocationDialogTester));
      expect(venueTester.result!.description, 'description');
      expect(venueTester.result!.coordinates, LatLng(52.51579, 13.45399));
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

Future pumpLocationDialogTester(
    WidgetTester tester, description, initCoordinates, center) async {
  await tester.pumpWidget(MaterialApp(
      home: LocationDialogTester(description, initCoordinates, center)));
***REMOVED***

_pumpLocationDialogTester(
    WidgetTester tester, LocationDialogTester locationDialogTester) async {
  await tester.pumpWidget(MultiProvider(providers: [
    Provider<StammdatenService>.value(value: _stammdatenService),
    Provider<GeoService>.value(value: _geoService)
  ], child: MaterialApp(home: locationDialogTester)));
***REMOVED***

// nur eine Testklasse
// ignore: must_be_immutable
class LocationDialogTester extends StatelessWidget {
  final String? initDescription;
  final LatLng? initCoordinates;
  final LatLng? center;

  Location? result;

  LocationDialogTester(this.initDescription, this.initCoordinates, this.center);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        key: Key('open location dialog'),
        child: Text('Klick mich'),
        onPressed: () => showLocationDialog(
                context: context,
                initDescription: initDescription,
                initCoordinates: initCoordinates,
                center: center)
            .then((result) => this.result = result));
  ***REMOVED***
***REMOVED***
