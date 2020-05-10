import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/FilterWidget.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

import '../shared/Mocks.dart';

int numberOfTimesCalled = 0;
TermineFilter iWasCalledResult;

iWasCalled(TermineFilter result) {
  numberOfTimesCalled++;
  iWasCalledResult = result;
}

final _stammdatenService = StammdatenServiceMock();
final _storageService = StorageServiceMock();

void main() {
  setUp(() {
    when(_storageService.loadFilter()).thenAnswer((_) async => null);
  });

  testWidgets('Filter starts successfully', (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(
      iWasCalled,
      key: Key("filter"),
    );

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    expect(find.byKey(Key("filter")), findsOneWidget);
    expect(find.text('Filter'), findsOneWidget);
  });

  testWidgets('Filter opens with click', (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    await tester.tap(find.text("Filter"));

    await tester.pump();

    expect(find.byKey(Key("type button")), findsOneWidget);
    expect(find.byKey(Key("days button")), findsOneWidget);
    expect(find.byKey(Key("time button")), findsOneWidget);
    expect(find.byKey(Key("locations button")), findsOneWidget);
  });

  testWidgets('Filter closes with click', (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    await tester.tap(find.text("Filter"));

    await tester.pump();

    await tester.tap(find.text('Anwenden'));

    await tester.pump();

    expect(find.byKey(Key("type button")), findsNothing);
    expect(find.byKey(Key("days button")), findsNothing);
    expect(find.byKey(Key("time button")), findsNothing);
    expect(find.byKey(Key("locations button")), findsNothing);
  });

  testWidgets('Filter changes caption of filter button with click',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    expect(find.text('Anwenden'), findsNothing);
    expect(find.text('Filter'), findsOneWidget);

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    expect(find.text('Filter'), findsNothing);
    expect(find.text('Anwenden'), findsOneWidget);

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    expect(find.text('Anwenden'), findsNothing);
    expect(find.text('Filter'), findsOneWidget);
  });

  testWidgets('Filter opens Type selection with click at type button',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('type button')));
    await tester.pump();

    expect(find.byKey(Key('type selection dialog')), findsOneWidget);
  });

  testWidgets('Type Selection shows all types', (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('type button')));
    await tester.pump();

    // currently hardcoded
    expect(find.text('Sammeln'), findsOneWidget);
    expect(find.text('Infoveranstaltung'), findsOneWidget);
  });

  testWidgets('Type Selection selects initially types from filter',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    FilterWidgetState filterState = tester.state(find.byWidget(filterWidget));

    filterState.filter.typen = ['Sammeln'];

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('type button')));
    await tester.pump();

    var checkboxTiles =
        tester.widgetList<CheckboxListTile>(find.byType(CheckboxListTile));
    var sammelTermin =
        checkboxTiles.firstWhere((ct) => (ct.title as Text).data == 'Sammeln');
    var andere = checkboxTiles.where((ct) => ct != sammelTermin);

    expect(sammelTermin.value, isTrue);
    expect(andere.every((ct) => ct.value == false), true);
  });

  testWidgets('Type Selection selects initially nothing if filter is empty',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('type button')));
    await tester.pump();

    var checkboxTiles =
        tester.widgetList<CheckboxListTile>(find.byType(CheckboxListTile));

    expect(checkboxTiles.every((ct) => ct.value == false), true);
  });

  testWidgets('Type Selection saves selected types to filter',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    FilterWidgetState filterState = tester.state(find.byWidget(filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('type button')));
    await tester.pump();

    await tester.tap(find.text('Sammeln'));
    await tester.pump();

    await tester.tap(find.text('Fertig'));
    await tester.pump();

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    expect(filterState.filter.typen, containsAll(['Sammeln']));
  });

  testWidgets('Filter opens Days selection with click at days button',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('days button')));
    await tester.pump();

    expect(find.byKey(Key('days selection dialog')), findsOneWidget);
  });

  testWidgets('Filter opens Locations selection with click at locations button',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    when(_stammdatenService.ladeOrte()).thenAnswer((_) async => []);

    await tester.pumpWidget(MultiProvider(providers: [
      Provider<AbstractStammdatenService>.value(value: _stammdatenService),
      Provider<StorageService>.value(value: _storageService)
    ], child: MaterialApp(home: filterWidget)));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('locations button')));
    await tester.pump();

    expect(find.byKey(Key('locations selection dialog')), findsOneWidget);
  });

  testWidgets('Filter passes locations ot Locations selection',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    when(_stammdatenService.ladeOrte()).thenAnswer((_) async => [
          Ort(0, 'district1', 'place1', 52.49653, 13.43762),
          Ort(1, 'district2', 'place2', 52.49653, 13.43762)
        ]);

    await tester.pumpWidget(MultiProvider(providers: [
      Provider<AbstractStammdatenService>.value(value: _stammdatenService),
      Provider<StorageService>.value(value: _storageService)
    ], child: MaterialApp(home: filterWidget)));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('locations button')));
    await tester.pump();

    expect(find.text('district1'), findsOneWidget);
    expect(find.text('district2'), findsOneWidget);
  });

  testWidgets('Filter opens From Time selection with click at Zeit button',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('time button')));
    await tester.pump();

    expect(find.text('von'), findsOneWidget);
    expect(find.byKey(Key('from time picker')), findsOneWidget);
  });

  testWidgets(
      'Filter opens To Time selection when From Time selection is closed',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('time button')));
    await tester.pump();

    await tester.tap(find.text('OK'));
    await tester.pump();

    expect(find.text('bis'), findsOneWidget);
    expect(find.byKey(Key('to time picker')), findsOneWidget);
  });

  testWidgets('Filter intially shows time from filter in from time selection',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    FilterWidgetState filterState = tester.state(find.byWidget(filterWidget));

    filterState.filter.von = TimeOfDay(hour: 19, minute: 15);
    filterState.filter.bis = TimeOfDay(hour: 20, minute: 21);

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('time button')));
    await tester.pump();

    expect(find.text('19'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pump();

    expect(find.text('20'), findsOneWidget);
    expect(find.text('21'), findsOneWidget);
  });

  testWidgets('Filter intially shows default time if filter is empty',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('time button')));
    await tester.pump();

    expect(find.text('12'), findsOneWidget);
    expect(find.text('00'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pump();

    expect(find.text('12'), findsOneWidget);
    expect(find.text('00'), findsOneWidget);
  });

  testWidgets('Filter saves selected time to filter',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    FilterWidgetState filterState = tester.state(find.byWidget(filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('time button')));
    await tester.pump();

    expect(find.byKey(Key('from time picker')), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pump();

    expect(find.byKey(Key('to time picker')), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pump();

    expect(ChronoHelfer.timeToStringHHmm(filterState.filter.von), '12:00');
    expect(ChronoHelfer.timeToStringHHmm(filterState.filter.von), '12:00');
  });

  testWidgets('Filter is applied on Anwenden button',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(
        home: Provider<StorageService>(
            create: (context) => _storageService, child: filterWidget)));

    FilterWidgetState filterState = tester.state(find.byWidget(filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    filterState.filter = TermineFilter(
        ['Sammeln'],
        [DateTime(2019, 12, 16)],
        TimeOfDay(hour: 19, minute: 15),
        TimeOfDay(hour: 20, minute: 21),
        [Ort(1, 'district', 'place', 52.49653, 13.43762)]);

    numberOfTimesCalled = 0;
    iWasCalledResult = null;

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    expect(numberOfTimesCalled, 1);
    expect(iWasCalledResult.typen, containsAll(['Sammeln']));
    expect(ChronoHelfer.timeToStringHHmm(iWasCalledResult.von), '19:15');
    expect(ChronoHelfer.timeToStringHHmm(iWasCalledResult.bis), '20:21');
    expect(iWasCalledResult.tage.map((t) => DateFormat.yMd().format(t)),
        containsAll(['12/16/2019']));
    expect(iWasCalledResult.orte.map((o) => o.id), containsAll([1]));
  });

  group('storage function', () {
    testWidgets('initializes filter with default values if no storage is found',
        (WidgetTester tester) async {
      FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

      await tester.pumpWidget(MaterialApp(
          home: Provider<StorageService>(
              create: (context) => _storageService, child: filterWidget)));
      FilterWidgetState filterState = tester.state(find.byWidget(filterWidget));

      expect(filterState.filter.typen, []);
      expect(filterState.filter.tage, []);
      expect(filterState.filter.von, null);
      expect(filterState.filter.bis, null);
      expect(filterState.filter.orte, []);
    });

    testWidgets('loads initially filter from storage if found',
        (WidgetTester tester) async {
      when(_storageService.loadFilter()).thenAnswer((_) async => TermineFilter(
          ['Sammeln', 'Infoveranstaltung'],
          [DateTime(2020, 1, 14), DateTime(2020, 1, 16)],
          TimeOfDay(hour: 12, minute: 30),
          TimeOfDay(hour: 15, minute: 0),
          [
            Ort(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez',
                52.49653, 13.43762),
            Ort(2, 'Friedrichshain-Kreuzberg', 'Görlitzer Park und Umgebung',
                52.49653, 13.43762)
          ]));

      FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

      await tester.pumpWidget(MaterialApp(
          home: Provider<StorageService>(
              create: (context) => _storageService, child: filterWidget)));

      FilterWidgetState filterState = tester.state(find.byWidget(filterWidget));
      var filter = filterState.filter;

      expect(filter.typen, containsAll(['Sammeln', 'Infoveranstaltung']));
      expect(filter.tage.length, 2);
      expect(filter.tage,
          containsAll([DateTime(2020, 1, 14), DateTime(2020, 1, 16)]));
      expect(filter.von, TimeOfDay(hour: 12, minute: 30));
      expect(filter.bis, TimeOfDay(hour: 15, minute: 0));
      expect(
          filter.orte.map((ort) => ort.toJson()),
          containsAll([
            {
              'id': 1,
              'bezirk': 'Friedrichshain-Kreuzberg',
              'ort': 'Friedrichshain Nordkiez',
              'lattitude': 52.49653,
              'longitude': 13.43762
            },
            {
              'id': 2,
              'bezirk': 'Friedrichshain-Kreuzberg',
              'ort': 'Görlitzer Park und Umgebung',
              'lattitude': 52.49653,
              'longitude': 13.43762
            }
          ]));
    });
  });
}
