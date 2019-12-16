import 'package:calendarro/calendarro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/FilterWidget.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/shared/LocationPicker.dart';

int numberOfTimesCalled = 0;

Function iWasCalled(TermineFilter _) {
  numberOfTimesCalled++;
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

  testWidgets('Days Selection selects initially days from filter',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    filterWidget.filter.tage = [DateTime.now()];

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('days button')));
    await tester.pump();

    var calendarro = tester.widget(find.byType(Calendarro)) as Calendarro;
    expect(calendarro.state.isDateSelected(DateTime.now()), true);
  ***REMOVED***);

  testWidgets('Days Selection selects no days when filter is empty',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('days button')));
    await tester.pump();

    var calendarro = tester.widget(find.byType(Calendarro)) as Calendarro;
    expect(calendarro.selectedDates.isEmpty, true);
  ***REMOVED***);

  // FIXME Geht nüch...
  /*testWidgets('Days Selection changes displayed month with buttons',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('days button')));
    await tester.pump();

    var monthLabel = tester.widget(find.byKey(Key('current month'))) as Text;

    var currentMonthName = ChronoHelfer.monthName(DateTime.now().month);
    expect(monthLabel.data.startsWith(currentMonthName), true);

    var calendarro = tester.widget(find.byType(Calendarro)) as Calendarro;

    print('Vorher: ' + calendarro.startDate.toString());
    expect(find.byKey(Key('next month button')), findsOneWidget);
    await tester.tap(find.byKey(Key('next month button')));
    await tester.pump();
    print('Nachher: ' + calendarro.startDate.toString());

    var nextMonthName =
        ChronoHelfer.monthName(Jiffy(DateTime.now()).add(months: 1).month);
    expect(monthLabel.data.startsWith(nextMonthName), true);

    await tester.tap(find.byKey(Key('previous month button')));
    await tester.pump();

    expect(monthLabel.data.startsWith(currentMonthName), true);
  ***REMOVED***);*/

  testWidgets('Days Selection saves selected days to filter on Auswaehlen',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('days button')));
    await tester.pump();

    await tester.tap(find.text(DateTime.now().day.toString()));
    await tester.pump();

    await tester.tap(find.byKey(Key('days dialog accept button')));
    await tester.pump();

    var heute =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    expect(filterWidget.filter.tage, containsAll([heute]));
  ***REMOVED***);

  testWidgets('Days Selection empties days from filter on Keine',
      (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));
    filterWidget.filter.tage = [DateTime.now()];

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.byKey(Key('filter button')));
    await tester.pump();

    await tester.tap(find.byKey(Key('days button')));
    await tester.pump();

    await tester.tap(find.text(DateTime.now().day.toString()));
    await tester.pump();

    await tester.tap(find.byKey(Key('days dialog none button')));
    await tester.pump();

    expect(filterWidget.filter.tage, isEmpty);
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

  MaterialApp WidgetWithLocationPicker(LocationPicker locationPicker,
      WidgetTester tester, List<Ort> previousSelection) {
    return MaterialApp(
      home: Material(
        child: Builder(builder: (BuildContext context) {
          return Center(
            child: RaisedButton(
              child: const Text('X'),
              onPressed: () {
                locationPicker.showLocationPicker(context, previousSelection,
                    multiple: true);
              ***REMOVED***,
            ),
          );
        ***REMOVED***),
      ),
    );
  ***REMOVED***

  testWidgets('LocationPicker shows correct list of districts and places',
      (WidgetTester tester) async {
    await tester.pumpWidget(WidgetWithLocationPicker(
        LocationPicker(locations: [
          Ort(0, 'district1', 'place1'),
          Ort(1, 'district2', 'place2')
        ]),
        tester,
        []));

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    expect(find.text('district1'), findsOneWidget);
    expect(find.text('      place1'), findsOneWidget);
    expect(find.text('district2'), findsOneWidget);
    expect(find.text('      place2'), findsOneWidget);
  ***REMOVED***);

  testWidgets('LocationPicker shows correct places with correct districts',
      (WidgetTester tester) async {
    await tester.pumpWidget(WidgetWithLocationPicker(
        LocationPicker(locations: [
          Ort(0, 'district1', 'place1'),
          Ort(1, 'district1', 'place2'),
          Ort(2, 'district2', 'place3')
        ]),
        tester,
        []));

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    expect(find.text('district1'), findsOneWidget);

    var captions = tester
        .widgetList(find.descendant(
            of: find.byType(ExpansionPanelList), matching: find.byType(Text)))
        .map((t) => (t as Text).data)
        .toList();

    expect(
        captions,
        containsAllInOrder([
          'district1',
          '      place1',
          '      place2',
          'district2',
          '      place3'
        ]));
  ***REMOVED***);

  testWidgets(
      'LocationPicker opens/closes places tiles on click of parent district',
      (WidgetTester tester) async {
    var locationPicker = LocationPicker(locations: [
      Ort(0, 'district1', 'place1'),
      Ort(0, 'district1', 'place2'),
      Ort(0, 'district2', 'place3')
    ]);
    var widgetWithlocationPicker =
        WidgetWithLocationPicker(locationPicker, tester, []);
    await tester.pumpWidget(widgetWithlocationPicker);

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    expect(find.text('district1'), findsOneWidget);

    // check for expansion by variable because checking real expansion is a mess
    // see: https://github.com/flutter/flutter/blob/master/packages/flutter/test/material/expansion_panel_test.dart
    expect(locationPicker.districts[0].expanded, false);
    expect(locationPicker.districts[1].expanded, false);

    //expect(find.text('      place1'), findsNothing);

    var expandButtons = find.byType(IconButton);

    //open first
    await tester.tap(expandButtons.first);
    await tester.pump();
    expect(locationPicker.districts[0].expanded, true);
    expect(locationPicker.districts[1].expanded, false);

    //close first
    await tester.tap(expandButtons.first);
    await tester.pump();

    expect(locationPicker.districts[0].expanded, false);
    expect(locationPicker.districts[1].expanded, false);

    // open second
    await tester.tap(expandButtons.last);
    await tester.pump();

    expect(locationPicker.districts[0].expanded, false);
    expect(locationPicker.districts[1].expanded, true);

    // open both
    await tester.tap(expandButtons.first);
    await tester.pump();

    expect(locationPicker.districts[0].expanded, true);
    expect(locationPicker.districts[1].expanded, true);
  ***REMOVED***);

  testWidgets('LocationPicker selects district on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(WidgetWithLocationPicker(
        LocationPicker(locations: [
          Ort(0, 'district1', 'place1'),
          Ort(1, 'district1', 'place2'),
          Ort(2, 'district2', 'place3')
        ]),
        tester,
        []));

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    expect(find.text('district1'), findsOneWidget);

    expect(find.byType(ExpansionPanelList), findsWidgets);

    expect(
        tester
            .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
            .where((ct) => (ct.title as Text).data == 'district1')
            .first
            .value,
        isFalse);

    expect(
        tester
            .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
            .where((ct) => (ct.title as Text).data == 'district2')
            .first
            .value,
        isFalse);

    await tester.tap(find.text('district1'));
    await tester.pump();

    expect(
        tester
            .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
            .where((ct) => (ct.title as Text).data == 'district1')
            .first
            .value,
        isTrue);

    expect(
        tester
            .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
            .where((ct) => (ct.title as Text).data == 'district2')
            .first
            .value,
        isFalse);
  ***REMOVED***);

  testWidgets('LocationPicker selects according places with tap on district',
      (WidgetTester tester) async {
    await tester.pumpWidget(WidgetWithLocationPicker(
        LocationPicker(locations: [
          Ort(0, 'district1', 'place1'),
          Ort(1, 'district1', 'place2'),
          Ort(2, 'district2', 'place3')
        ]),
        tester,
        []));

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    expect(find.text('district1'), findsOneWidget);

    expect(find.byType(ExpansionPanelList), findsWidgets);

    tester
        .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
        .forEach((ct) => expect(ct.value, isFalse));

    await tester.tap(find.text('district1'));
    await tester.pump();

    expect(
        tester
            .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
            .where((ct) => (ct.title as Text).data == '      place1')
            .first
            .value,
        isTrue);

    expect(
        tester
            .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
            .where((ct) => (ct.title as Text).data == '      place2')
            .first
            .value,
        isTrue);

    expect(
        tester
            .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
            .where((ct) => (ct.title as Text).data == '      place3')
            .first
            .value,
        isFalse);
  ***REMOVED***);
***REMOVED***
