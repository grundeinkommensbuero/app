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
import 'package:sammel_app/shared/ChronoHelfer.dart';

int numberOfTimesCalled = 0;
TermineFilter iWasCalledResult;

Function iWasCalled(TermineFilter result) {
  numberOfTimesCalled++;
  iWasCalledResult = result;
***REMOVED***

class StammdatenServiceMock extends Mock implements StammdatenService {***REMOVED***

final stammdatenService = StammdatenServiceMock();

void main() {
  testWidgets('Filter starts successfully', (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(
      iWasCalled,
      key: Key("filter"),
    );

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    expect(find.byKey(Key("filter")), findsOneWidget);
    expect(find.text('Filter'), findsOneWidget);
  ***REMOVED***);

  testWidgets('Filter opens with click', (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.text("Filter"));

    await tester.pump();

    expect(find.byKey(Key("type button")), findsOneWidget);
    expect(find.byKey(Key("days button")), findsOneWidget);
    expect(find.byKey(Key("time button")), findsOneWidget);
    expect(find.byKey(Key("locations button")), findsOneWidget);
  ***REMOVED***);

  testWidgets('Filter closes with click', (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.text("Filter"));

    await tester.pump();

    await tester.tap(find.text('Anwenden'));

    await tester.pump();

    expect(find.byKey(Key("type button")), findsNothing);
    expect(find.byKey(Key("days button")), findsNothing);
    expect(find.byKey(Key("time button")), findsNothing);
    expect(find.byKey(Key("locations button")), findsNothing);
  ***REMOVED***);

  testWidgets('Filter changes caption of filter button with click',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

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
  ***REMOVED***);

  testWidgets('Filter opens Type selection with click at type button',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('type button')));
    await tester.pump();

    expect(find.byKey(Key('type selection dialog')), findsOneWidget);
  ***REMOVED***);

  testWidgets('Type Selection shows all types', (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('type button')));
    await tester.pump();

    // currently hardcoded
    expect(find.text('Sammel-Termin'), findsOneWidget);
    expect(find.text('Info-Veranstaltung'), findsOneWidget);
  ***REMOVED***);

  testWidgets('Type Selection selects initially types from filter',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    filterWidget.filter.typen = ['Sammel-Termin'];

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('type button')));
    await tester.pump();

    var checkboxTiles =
        tester.widgetList<CheckboxListTile>(find.byType(CheckboxListTile));
    var sammelTermin = checkboxTiles
        .firstWhere((ct) => (ct.title as Text).data == 'Sammel-Termin');
    var andere = checkboxTiles.where((ct) => ct != sammelTermin);

    expect(sammelTermin.value, isTrue);
    expect(andere.every((ct) => ct.value == false), true);
  ***REMOVED***);

  testWidgets('Type Selection selects initially nothing if filter is empty',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('type button')));
    await tester.pump();

    var checkboxTiles =
        tester.widgetList<CheckboxListTile>(find.byType(CheckboxListTile));

    expect(checkboxTiles.every((ct) => ct.value == false), true);
  ***REMOVED***);

  testWidgets('Type Selection saves selected types to filter',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('type button')));
    await tester.pump();

    await tester.tap(find.text('Sammel-Termin'));
    await tester.pump();

    await tester.tap(find.text('Fertig'));
    await tester.pump();

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    expect(filterWidget.filter.typen, containsAll(['Sammel-Termin']));
  ***REMOVED***);

  testWidgets('Filter opens Days selection with click at days button',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('days button')));
    await tester.pump();

    expect(find.byKey(Key('days selection dialog')), findsOneWidget);
  ***REMOVED***);

  testWidgets('Filter opens Locations selection with click at locations button',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    when(stammdatenService.ladeOrte()).thenAnswer((_) async => []);

    await tester.pumpWidget(Provider<StammdatenService>(
        builder: (context) => stammdatenService,
        child: MaterialApp(home: filterWidget)));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('locations button')));
    await tester.pump();

    expect(find.byKey(Key('locations selection dialog')), findsOneWidget);
  ***REMOVED***);

  testWidgets('Filter passes locations ot Locations selection',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    when(stammdatenService.ladeOrte()).thenAnswer((_) async =>
        [Ort(0, 'district1', 'place1'), Ort(1, 'district2', 'place2')]);

    await tester.pumpWidget(Provider<StammdatenService>(
        builder: (context) => stammdatenService,
        child: MaterialApp(home: filterWidget)));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('locations button')));
    await tester.pump();

    expect(find.text('district1'), findsOneWidget);
    expect(find.text('district2'), findsOneWidget);
  ***REMOVED***);

  testWidgets('Filter opens From Time selection with click at Zeit button',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('time button')));
    await tester.pump();

    expect(find.text('von'), findsOneWidget);
    expect(find.byKey(Key('from time picker')), findsOneWidget);
  ***REMOVED***);

  testWidgets(
      'Filter opens To Time selection when From Time selection is closed',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('time button')));
    await tester.pump();

    await tester.tap(find.text('OK'));
    await tester.pump();

    expect(find.text('bis'), findsOneWidget);
    expect(find.byKey(Key('to time picker')), findsOneWidget);
  ***REMOVED***);

  testWidgets('Filter intially shows time from filter in from time selection',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));
    filterWidget.filter.von = TimeOfDay(hour: 19, minute: 15);
    filterWidget.filter.bis = TimeOfDay(hour: 20, minute: 21);

    await tester.pumpWidget(MaterialApp(home: filterWidget));

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
  ***REMOVED***);

  testWidgets('Filter intially shows default time if filter is empty',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

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
  ***REMOVED***);

  testWidgets('Filter saves selected time to filter',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

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

    expect(ChronoHelfer.timeToStringHHmm(filterWidget.filter.von), '12:00');
    expect(ChronoHelfer.timeToStringHHmm(filterWidget.filter.von), '12:00');
  ***REMOVED***);

  testWidgets('Filter is applied on Anwendn button',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));
    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    filterWidget.filter = TermineFilter(
        ['Sammel-Termin'],
        [DateTime(2019, 12, 16)],
        TimeOfDay(hour: 19, minute: 15),
        TimeOfDay(hour: 20, minute: 21),
        [Ort(1, 'district', 'place')]);

    numberOfTimesCalled = 0;
    iWasCalledResult = null;

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    expect(numberOfTimesCalled, 1);
    expect(iWasCalledResult.typen, containsAll(['Sammel-Termin']));
    expect(ChronoHelfer.timeToStringHHmm(iWasCalledResult.von), '19:15');
    expect(ChronoHelfer.timeToStringHHmm(iWasCalledResult.bis), '20:21');
    expect(iWasCalledResult.tage.map((t) => DateFormat.yMd().format(t)),
        containsAll(['12/16/2019']));
    expect(iWasCalledResult.orte.map((o) => o.id), containsAll([1]));
  ***REMOVED***);
***REMOVED***
