import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/LocationDialog.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/StammdatenService.dart';

import '../shared/Mocks.dart';

final GeoService geoService = GeoServiceMock();
final stammdatenService = StammdatenServiceMock();

void main() {
  setUp(() {
    reset(geoService);
    reset(stammdatenService);
    when(geoService.getDescriptionToPoint(any))
        .thenAnswer((_) async => GeoData('name', 'street', '12'));
  });

  testWidgets('opens dialog', (WidgetTester tester) async {
    await tester.pumpWidget(Provider<GeoService>.value(
        value: geoService,
        child: MaterialApp(
            home: LocationDialogTester('description', null, null))));

    expect(find.byType(LocationDialog), findsNothing);

    await tester.tap(find.byKey(Key('open location dialog')));
    await tester.pump();

    expect(find.byType(LocationDialog), findsOneWidget);
  });

  group('presentation', () {
    testWidgets('shows map', (WidgetTester tester) async {
      var initCoordinates;
      var center;
      await tester.pumpWidget(MaterialApp(
          home: LocationDialogTester('description', initCoordinates, center)));

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      expect(find.byKey(Key('venue map')), findsOneWidget);
    });

    testWidgets('shows description input field', (WidgetTester tester) async {
      var initCoordinates;
      var center;
      await tester.pumpWidget(MaterialApp(
          home: LocationDialogTester('description', initCoordinates, center)));

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      expect(find.byKey(Key('venue description input')), findsOneWidget);
    });
  });

  group('initially shows', () {
    testWidgets('no marker, if no initial coordinates given',
        (WidgetTester tester) async {
      var initCoordinates;
      var center;
      await tester.pumpWidget(MaterialApp(
          home: LocationDialogTester('description', initCoordinates, center)));

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      expect(find.byType(LocationMarker), findsNothing);
    });

    testWidgets('marker, if initial coordinates given',
        (WidgetTester tester) async {
      var initCoordinates = LatLng(52.51579, 13.45399);
      var center;
      await tester.pumpWidget(MaterialApp(
          home: LocationDialogTester('description', initCoordinates, center)));

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      var state =
          tester.state(find.byType(LocationDialog)) as LocationDialogState;
      expect(state.marker.point, initCoordinates);
      expect(find.byKey(Key('location marker')), findsOneWidget);
    });

    testWidgets('description', (WidgetTester tester) async {
      var initCoordinates = LatLng(52.51579, 13.45399);
      var center;
      await tester.pumpWidget(MaterialApp(
          home: LocationDialogTester('description', initCoordinates, center)));

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      expect(find.text('description'), findsOneWidget);
    });
  });

  group('centers map', () {
    testWidgets('at given coordinates', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: LocationDialogTester(null, null, LatLng(52.49653, 13.43762))));
      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      FlutterMap map = tester.widget(find.byKey(Key('venue map')));
      expect(map.options.center, LatLng(52.49653, 13.43762));
      expect(map.options.zoom, 14.0);
    });

    testWidgets('at Berlin with no coordinates given',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          MaterialApp(home: LocationDialogTester(null, null, null)));
      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      FlutterMap map = tester.widget(find.byKey(Key('venue map')));
      expect(map.options.center, LatLng(52.5170365, 13.3888599));
      expect(map.options.zoom, 10.0);
    });
  });

  group('reads input', () {
    testWidgets('with tap on map and creates marker',
        (WidgetTester tester) async {
      await _pumpLocationTester(
          tester, LocationDialogTester('description', null, null));

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();
      expect(find.byKey(Key('location marker')), findsNothing);

      await tester.tap(find.byKey(Key('venue map')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('location marker')), findsOneWidget);
    });

    testWidgets('with tap on map and moves marker',
        (WidgetTester tester) async {
      var initCoordinates = LatLng(52.51579, 13.45399);
      await _pumpLocationTester(
          tester, LocationDialogTester('description', initCoordinates, null));

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      LocationDialogState state = tester.state(find.byType(LocationDialog));
      expect(state.marker.point == initCoordinates, true);

      await tester.tap(find.byKey(Key('venue map')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('location marker')), findsOneWidget);
      expect(state.marker.point != initCoordinates, true);
    });
  });

  group('returns', () {
    testWidgets('coordinates', (WidgetTester tester) async {
      await _pumpLocationTester(
          tester, LocationDialogTester('description', null, null));

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();
      LocationDialogState state = tester.state(find.byType(LocationDialog));

      await tester.tap(find.byKey(Key('venue map')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('venue dialog finish button')));
      await tester.pump();

      LocationDialogTester venueTester =
          tester.widget(find.byType(LocationDialogTester));
      expect(venueTester.result.coordinates, state.marker.point);
    });

    testWidgets('new coordinates', (WidgetTester tester) async {
      await _pumpLocationTester(
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
      expect(venueTester.result.coordinates, state.marker.point);
    });

    testWidgets('description', (WidgetTester tester) async {
      await _pumpLocationTester(tester, LocationDialogTester(null, null, null));

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      await tester.enterText(
          find.byKey(Key('venue description input')), 'description');

      await tester.tap(find.byKey(Key('venue dialog finish button')));
      await tester.pump();

      LocationDialogTester venueTester =
          tester.widget(find.byType(LocationDialogTester));
      expect(venueTester.result.description, 'description');
    });

    testWidgets('new description', (WidgetTester tester) async {
      await tester.pumpWidget(
          MaterialApp(home: LocationDialogTester('description', null, null)));

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      await tester.enterText(
          find.byKey(Key('venue description input')), 'new description');

      await tester.tap(find.byKey(Key('venue dialog finish button')));
      await tester.pump();

      LocationDialogTester venueTester =
          tester.widget(find.byType(LocationDialogTester));
      expect(venueTester.result.description, 'new description');
    });

    testWidgets('old values, with no input', (WidgetTester tester) async {
      await _pumpLocationTester(
          tester,
          LocationDialogTester(
              'description', LatLng(52.51579, 13.45399), null));

      await tester.tap(find.byKey(Key('open location dialog')));
      await tester.pump();

      await tester.tap(find.byKey(Key('venue dialog finish button')));
      await tester.pump();

      LocationDialogTester venueTester =
          tester.widget(find.byType(LocationDialogTester));
      expect(venueTester.result.description, 'description');
      expect(venueTester.result.coordinates, LatLng(52.51579, 13.45399));
    });
  });
}

_pumpLocationTester(
    WidgetTester tester, LocationDialogTester locationDialogTester) async {
  await tester.pumpWidget(MultiProvider(providers: [
    Provider<GeoService>.value(value: geoService),
    Provider<StammdatenService>.value(value: stammdatenService)
  ], child: MaterialApp(home: locationDialogTester)));
}

// nur eine Testklasse
// ignore: must_be_immutable
class LocationDialogTester extends StatelessWidget {
  final String initDescription;
  final LatLng initCoordinates;
  final LatLng center;

  Location result;

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
  }
}
