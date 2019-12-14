import 'dart:math';

import 'package:calendarro/calendarro.dart';
import 'package:calendarro/default_day_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/FilterWidget.dart';

int numberOfTimesCalled = 0;

Function iWasCalled(TermineFilter _) {
  numberOfTimesCalled++;
***REMOVED***

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
***REMOVED***
