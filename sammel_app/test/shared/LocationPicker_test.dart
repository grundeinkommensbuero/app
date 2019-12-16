import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/shared/LocationPicker.dart';

void main() {
  MaterialApp WidgetWithLocationPicker(LocationPicker locationPicker,
      WidgetTester tester, List<Ort> previousSelection, Function result) {
    return MaterialApp(
      home: Material(
        child: Builder(builder: (BuildContext context) {
          return Center(
            child: RaisedButton(
              child: const Text('X'),
              onPressed: () async {
                result(await locationPicker.showLocationPicker(
                    context, previousSelection));
              },
            ),
          );
        }),
      ),
    );
  }

  testWidgets('LocationPicker shows correct list of districts and places',
          (WidgetTester tester) async {
        await tester.pumpWidget(WidgetWithLocationPicker(
            LocationPicker(locations: [
              Ort(0, 'district1', 'place1'),
              Ort(1, 'district2', 'place2')
            ], multiMode: true),
            tester,
            [],
                (_) {}));

        await tester.tap(find.text('X'));
        await tester.pumpAndSettle();

        expect(find.text('district1'), findsOneWidget);
        expect(find.text('      place1'), findsOneWidget);
        expect(find.text('district2'), findsOneWidget);
        expect(find.text('      place2'), findsOneWidget);
      });

  testWidgets('LocationPicker shows correct places with correct districts',
          (WidgetTester tester) async {
        await tester.pumpWidget(WidgetWithLocationPicker(
            LocationPicker(locations: [
              Ort(0, 'district1', 'place1'),
              Ort(1, 'district1', 'place2'),
              Ort(2, 'district2', 'place3')
            ], multiMode: true),
            tester,
            [],
                (_) {}));

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
      });

  testWidgets(
      'LocationPicker opens/closes places tiles on click of parent district',
          (WidgetTester tester) async {
        var locationPicker = LocationPicker(locations: [
          Ort(0, 'district1', 'place1'),
          Ort(0, 'district1', 'place2'),
          Ort(0, 'district2', 'place3')
        ], multiMode: true);
        var widgetWithlocationPicker =
        WidgetWithLocationPicker(locationPicker, tester, [], (_) {});
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
      });

  CheckboxListTile findCheckboxTileWithName(WidgetTester tester, String name) {
    return tester
        .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
        .where((ct) => (ct.title as Text).data == name)
        .first;
  }

  testWidgets('LocationPicker selects district on tap',
          (WidgetTester tester) async {
        await tester.pumpWidget(WidgetWithLocationPicker(
            LocationPicker(locations: [
              Ort(0, 'district1', 'place1'),
              Ort(1, 'district1', 'place2'),
              Ort(2, 'district2', 'place3')
            ], multiMode: true),
            tester,
            [],
                (_) {}));

        await tester.tap(find.text('X'));
        await tester.pumpAndSettle();

        expect(findCheckboxTileWithName(tester, 'district1').value, isFalse);
        expect(findCheckboxTileWithName(tester, 'district2').value, isFalse);

        await tester.tap(find.text('district1'));
        await tester.pump();

        expect(findCheckboxTileWithName(tester, 'district1').value, isTrue);
        expect(findCheckboxTileWithName(tester, 'district2').value, isFalse);
      });

  testWidgets('LocationPicker selects according places with tap on district',
          (WidgetTester tester) async {
        await tester.pumpWidget(WidgetWithLocationPicker(
            LocationPicker(locations: [
              Ort(0, 'district1', 'place1'),
              Ort(1, 'district1', 'place2'),
              Ort(2, 'district2', 'place3')
            ], multiMode: true),
            tester,
            [],
                (_) {}));

        await tester.tap(find.text('X'));
        await tester.pumpAndSettle();

        expect(find.text('district1'), findsOneWidget);

        expect(findCheckboxTileWithName(tester, '      place1').value, isFalse);
        expect(findCheckboxTileWithName(tester, '      place2').value, isFalse);
        expect(findCheckboxTileWithName(tester, '      place3').value, isFalse);

        await tester.tap(find.text('district1'));
        await tester.pump();

        expect(findCheckboxTileWithName(tester, '      place1').value, isTrue);
        expect(findCheckboxTileWithName(tester, '      place2').value, isTrue);
        expect(findCheckboxTileWithName(tester, '      place3').value, isFalse);
      });

  testWidgets('LocationPicker selects initially selected places on startup',
          (WidgetTester tester) async {
        await tester.pumpWidget(WidgetWithLocationPicker(
            LocationPicker(locations: [
              Ort(0, 'district1', 'place1'),
              Ort(1, 'district1', 'place2'),
              Ort(2, 'district2', 'place3')
            ], multiMode: true),
            tester,
            [Ort(2, 'district2', 'place3')],
                (_) {}));

        await tester.tap(find.text('X'));
        await tester.pumpAndSettle();

        expect(findCheckboxTileWithName(tester, '      place1').value, isFalse);
        expect(findCheckboxTileWithName(tester, '      place2').value, isFalse);
        expect(findCheckboxTileWithName(tester, '      place3').value, isTrue);
      });

  testWidgets(
      'LocationPicker selects no places on startup with empty previous selection',
          (WidgetTester tester) async {
        await tester.pumpWidget(WidgetWithLocationPicker(
            LocationPicker(locations: [
              Ort(0, 'district1', 'place1'),
              Ort(1, 'district1', 'place2'),
              Ort(2, 'district2', 'place3')
            ], multiMode: true),
            tester,
            [],
                (_) {}));

        await tester.tap(find.text('X'));
        await tester.pumpAndSettle();

        expect(findCheckboxTileWithName(tester, 'district1').value, isFalse);
        expect(findCheckboxTileWithName(tester, '      place1').value, isFalse);
        expect(findCheckboxTileWithName(tester, '      place2').value, isFalse);
        expect(findCheckboxTileWithName(tester, 'district2').value, isFalse);
        expect(findCheckboxTileWithName(tester, '      place3').value, isFalse);
      });

  testWidgets('LocationPicker uses multi/single mode',
          (WidgetTester tester) async {
        await tester.pumpWidget(WidgetWithLocationPicker(
            LocationPicker(locations: [
              Ort(0, 'district1', 'place1'),
              Ort(1, 'district1', 'place2'),
              Ort(2, 'district2', 'place3')
            ], multiMode: true),
            tester,
            [],
                (_) {}));

        await tester.tap(find.text('X'));
        await tester.pumpAndSettle();

        expect(
            find.descendant(
                of: find.byType(ExpansionPanelList),
                matching: find.byType(CheckboxListTile)),
            findsNWidgets(5));

        await tester.pumpWidget(WidgetWithLocationPicker(
            LocationPicker(locations: [
              Ort(0, 'district1', 'place1'),
              Ort(1, 'district1', 'place2'),
              Ort(2, 'district2', 'place3')
            ], multiMode: false),
            tester,
            [],
                (_) {}));

        await tester.tap(find.text('X'));
        await tester.pumpAndSettle();

        expect(
            find.descendant(
                of: find.byType(ExpansionPanelList),
                matching: find.byType(ListTile)),
            findsNWidgets(5));
      });

  testWidgets('LocationPicker returns selected locations',
          (WidgetTester tester) async {
        var result = List<Ort>();
        await tester.pumpWidget(WidgetWithLocationPicker(
            LocationPicker(locations: [
              Ort(0, 'district1', 'place1'),
              Ort(1, 'district1', 'place2'),
              Ort(2, 'district2', 'place3')
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

        expect(
            result.map((ort) => ort.ort),
            containsAll(
                ['place1', 'place2']));
      });
}