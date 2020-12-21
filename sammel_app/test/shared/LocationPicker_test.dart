import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/shared/LocationPicker.dart';

void main() {
  MaterialApp createWidgetWithLocationPicker(LocationPicker locationPicker,
      WidgetTester tester, List<Kiez> previousSelection, Function result) {
    return MaterialApp(
      home: Material(
        child: Builder(builder: (BuildContext context) {
          return Center(
            child: RaisedButton(
              child: const Text('X'),
              onPressed: () async {
                result(await locationPicker.showLocationPicker(
                    context, previousSelection));
              ***REMOVED***,
            ),
          );
        ***REMOVED***),
      ),
    );
  ***REMOVED***

  testWidgets('LocationPicker shows correct list of districts and locations',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetWithLocationPicker(
        LocationPicker(locations: [
          Kiez(0, 'district1ExpandButton', 'area1', 52.51579, 13.45399),
          Kiez(1, 'district2ExpandButton', 'area2', 52.51579, 13.45399)
        ], multiMode: false),
        tester,
        [],
        (_) {***REMOVED***));

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    // find and expand district tiles
    var district1 = find.text('district1ExpandButton');
    expect(district1, findsOneWidget);
    await tester.tap(district1);
    var district2 = find.text('district2ExpandButton');
    expect(district2, findsOneWidget);
    await tester.tap(district2);
    await tester.pump();

    expect(find.text('      area1'), findsOneWidget);
    expect(find.text('      area2'), findsOneWidget);
  ***REMOVED***);

  testWidgets('LocationPicker shows correct locations with correct districts',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetWithLocationPicker(
        LocationPicker(locations: [
          Kiez(0, 'district1ExpandButton', 'area1', 52.51579, 13.45399),
          Kiez(1, 'district1ExpandButton', 'area2', 52.51579, 13.45399),
          Kiez(2, 'district2ExpandButton', 'area3', 52.51579, 13.45399)
        ], multiMode: false),
        tester,
        [],
        (_) {***REMOVED***));

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    // find and expand district tiles
    var district1 = find.text('district1ExpandButton');
    expect(district1, findsOneWidget);
    await tester.tap(district1);
    var district2 = find.text('district2ExpandButton');
    expect(district2, findsOneWidget);
    await tester.tap(district2);
    await tester.pump();

    var captions = tester
        .widgetList(find.descendant(
            of: find.byType(ExpansionTile), matching: find.byType(Text)))
        .map((t) => (t as Text).data)
        .toList();

    expect(
        captions,
        containsAllInOrder([
          'district1ExpandButton',
          '      area1',
          '      area2',
          'district2ExpandButton',
          '      area3'
        ]));
  ***REMOVED***);

  testWidgets(
      'LocationPicker opens/closes locations tiles on click of parent district',
      (WidgetTester tester) async {
    var locationPicker = LocationPicker(locations: [
      Kiez(0, 'district1ExpandButton', 'area1', 52.51579, 13.45399),
      Kiez(0, 'district1ExpandButton', 'area2', 52.51579, 13.45399),
      Kiez(0, 'district2ExpandButton', 'area3', 52.51579, 13.45399)
    ], multiMode: false);
    var widgetWithLocationPicker =
        createWidgetWithLocationPicker(locationPicker, tester, [], (_) {***REMOVED***);
    await tester.pumpWidget(widgetWithLocationPicker);

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    // initially only district tile are visible
    expect(find.text('district1ExpandButton'), findsOneWidget);
    expect(find.text('district2ExpandButton'), findsOneWidget);
    expect(find.text('      area1'), findsNothing);
    expect(find.text('      area2'), findsNothing);
    expect(find.text('      area3'), findsNothing);

    // expand first district tile
    await tester.tap(find.text('district1ExpandButton'));
    await tester.pump();

    // only area tiles of district1ExpandButton are visible
    expect(find.text('      area1'), findsOneWidget);
    expect(find.text('      area2'), findsOneWidget);
    expect(find.text('      area3'), findsNothing);

    //close first district tile again
    await tester.tap(find.text('district1ExpandButton'));
    await tester.pump();

    // all area tiles are invisible again
    expect(find.text('      area1'), findsNothing);
    expect(find.text('      area2'), findsNothing);
    expect(find.text('      area3'), findsNothing);

    // expand second district tile
    await tester.tap(find.text('district2ExpandButton'));
    await tester.pump();

    // only area tiles of district2ExpandButton are visible
    expect(find.text('      area1'), findsNothing);
    expect(find.text('      area2'), findsNothing);
    expect(find.text('      area3'), findsOneWidget);

    // expand first district tile too
    await tester.tap(find.text('district1ExpandButton'));
    await tester.pump();

    // all area tiles are visible
    expect(find.text('      area1'), findsOneWidget);
    expect(find.text('      area2'), findsOneWidget);
    expect(find.text('      area3'), findsOneWidget);
  ***REMOVED***);

  CheckboxListTile findCheckboxTileWithName(WidgetTester tester, String name) {
    return tester
        .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
        .where((ct) => (ct.title as Text).data == name)
        .first;
  ***REMOVED***

  testWidgets('LocationPicker selects district on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetWithLocationPicker(
        LocationPicker(locations: [
          Kiez(0, 'district1ExpandButton', 'area1', 52.51579, 13.45399),
          Kiez(1, 'district1ExpandButton', 'area2', 52.51579, 13.45399),
          Kiez(2, 'district2ExpandButton', 'area3', 52.51579, 13.45399)
        ], multiMode: true),
        tester,
        [],
        (_) {***REMOVED***));

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    expect(findCheckboxTileWithName(tester, 'district1ExpandButton').value,
        isFalse);
    expect(findCheckboxTileWithName(tester, 'district2ExpandButton').value,
        isFalse);

    await tester.tap(find.text('district1ExpandButton'));
    await tester.pump();

    expect(findCheckboxTileWithName(tester, 'district1ExpandButton').value,
        isTrue);
    expect(findCheckboxTileWithName(tester, 'district2ExpandButton').value,
        isFalse);
  ***REMOVED***);

  testWidgets('LocationPicker selects according locations with tap on district',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetWithLocationPicker(
        LocationPicker(locations: [
          Kiez(0, 'district1ExpandButton', 'area1', 52.51579, 13.45399),
          Kiez(1, 'district1ExpandButton', 'area2', 52.51579, 13.45399),
          Kiez(2, 'district2ExpandButton', 'area3', 52.51579, 13.45399)
        ], multiMode: true),
        tester,
        [],
        (_) {***REMOVED***));

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    // expand district tiles by finding and pressing the expand buttons
    var districtExpandButtons = find.descendant(
        of: find.byType(ExpansionTile), matching: find.byType(Icon));
    expect(districtExpandButtons, findsNWidgets(2));
    await tester.tap(districtExpandButtons.first);
    await tester.tap(districtExpandButtons.last);
    await tester.pump();

    expect(find.byType(CheckboxListTile), findsNWidgets(5));

    expect(findCheckboxTileWithName(tester, '      area1').value, isFalse);
    expect(findCheckboxTileWithName(tester, '      area2').value, isFalse);
    expect(findCheckboxTileWithName(tester, '      area3').value, isFalse);

    await tester.tap(find.text('district1ExpandButton'));
    await tester.pump();

    expect(findCheckboxTileWithName(tester, '      area1').value, isTrue);
    expect(findCheckboxTileWithName(tester, '      area2').value, isTrue);
    expect(findCheckboxTileWithName(tester, '      area3').value, isFalse);
  ***REMOVED***);

  testWidgets('LocationPicker selects initially selected locations on startup',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetWithLocationPicker(
        LocationPicker(locations: [
          Kiez(0, 'district1ExpandButton', 'area1', 52.51579, 13.45399),
          Kiez(1, 'district1ExpandButton', 'area2', 52.51579, 13.45399),
          Kiez(2, 'district2ExpandButton', 'area3', 52.51579, 13.45399)
        ], multiMode: true),
        tester,
        [Kiez(2, 'district2ExpandButton', 'area3', 52.51579, 13.45399)],
        (_) {***REMOVED***));

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    // expand district tiles by finding and pressing the expand buttons
    var districtExpandButtons = find.descendant(
        of: find.byType(ExpansionTile), matching: find.byType(Icon));
    expect(districtExpandButtons, findsNWidgets(2));
    await tester.tap(districtExpandButtons.first);
    await tester.tap(districtExpandButtons.last);
    await tester.pump();

    expect(findCheckboxTileWithName(tester, '      area1').value, isFalse);
    expect(findCheckboxTileWithName(tester, '      area2').value, isFalse);
    expect(findCheckboxTileWithName(tester, '      area3').value, isTrue);
  ***REMOVED***);

  testWidgets(
      'LocationPicker selects no locations on startup with empty previous selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetWithLocationPicker(
        LocationPicker(locations: [
          Kiez(0, 'district1', 'area1', 52.51579, 13.45399),
          Kiez(1, 'district1', 'area2', 52.51579, 13.45399),
          Kiez(2, 'district2', 'area3', 52.51579, 13.45399)
        ], multiMode: true),
        tester,
        [],
        (_) {***REMOVED***));

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    // expand district tiles by finding and pressing the expand buttons
    var districtExpandButtons = find.descendant(
        of: find.byType(ExpansionTile), matching: find.byType(Icon));
    expect(districtExpandButtons, findsNWidgets(2));
    await tester.tap(districtExpandButtons.first);
    await tester.tap(districtExpandButtons.last);
    await tester.pump();

    expect(findCheckboxTileWithName(tester, 'district1').value, isFalse);
    expect(findCheckboxTileWithName(tester, '      area1').value, isFalse);
    expect(findCheckboxTileWithName(tester, '      area2').value, isFalse);
    expect(findCheckboxTileWithName(tester, 'district2').value, isFalse);
    expect(findCheckboxTileWithName(tester, '      area3').value, isFalse);
  ***REMOVED***);

  testWidgets('LocationPicker uses multi mode', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetWithLocationPicker(
        LocationPicker(locations: [
          Kiez(0, 'district1', 'area1', 52.51579, 13.45399),
          Kiez(1, 'district1', 'area2', 52.51579, 13.45399),
          Kiez(2, 'district2', 'area3', 52.51579, 13.45399)
        ], multiMode: true),
        tester,
        [],
        (_) {***REMOVED***));

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    // expand district tiles by finding and pressing the expand buttons
    var districtExpandButtons = find.descendant(
        of: find.byType(ExpansionTile), matching: find.byType(Icon));
    expect(districtExpandButtons, findsNWidgets(2));
    await tester.tap(districtExpandButtons.first);
    await tester.tap(districtExpandButtons.last);
    await tester.pump();

    expect(find.byType(CheckboxListTile), findsNWidgets(5));

    await tester.pumpWidget(createWidgetWithLocationPicker(
        LocationPicker(locations: [
          Kiez(0, 'district1', 'area1', 52.51579, 13.45399),
          Kiez(1, 'district1', 'area2', 52.51579, 13.45399),
          Kiez(2, 'district2', 'area3', 52.51579, 13.45399)
        ], multiMode: false),
        tester,
        [],
        (_) {***REMOVED***));

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    // find and expand district tiles
    var district1 = find.text('district1');
    expect(district1, findsOneWidget);
    await tester.tap(district1);
    var district2 = find.text('district2');
    expect(district2, findsOneWidget);
    await tester.tap(district2);
    await tester.pump();

    // TODO Wieso 7?! hat nichts zu tun mit dem multi-Picker open
    expect(find.byType(ListTile), findsNWidgets(7));
  ***REMOVED***);

  testWidgets('LocationPicker returns selected locations',
      (WidgetTester tester) async {
    var result = List<Kiez>();
    await tester.pumpWidget(createWidgetWithLocationPicker(
        LocationPicker(locations: [
          Kiez(0, 'district1', 'area1', 52.51579, 13.45399),
          Kiez(1, 'district1', 'area2', 52.51579, 13.45399),
          Kiez(2, 'district2', 'area3', 52.51579, 13.45399)
        ], multiMode: true),
        tester,
        [],
        (selection) => result = selection));

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('district1'));
    await tester.pump();
    await tester.tap(find.text('Fertig'));
    await tester.pump();

    expect(result.map((ort) => ort.id), containsAll(['area1', 'area2']));
  ***REMOVED***);
***REMOVED***
