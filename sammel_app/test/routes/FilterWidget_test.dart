import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/FilterWidget.dart';

int numberOfTimesCalled = 0;

Function iWasCalled(TermineFilter _) {
  numberOfTimesCalled++;
}

void main() {
  testWidgets('Filter starts successfully', (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"),);

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    expect(find.byKey(Key("filter")), findsOneWidget);
    expect(find.text('Filter'), findsOneWidget);
  });

  testWidgets('Filter opens with click', (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.text("Filter"));

    await tester.pump();

    expect(find.byKey(Key("type")), findsOneWidget);
    expect(find.byKey(Key("days")), findsOneWidget);
    expect(find.byKey(Key("time")), findsOneWidget);
    expect(find.byKey(Key("locations")), findsOneWidget);

    expect(find.text('Filter'), findsNothing);
    expect(find.text('Anwenden'), findsOneWidget);
  });

  testWidgets('Filter closes with click', (WidgetTester tester) async {
    FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key("filter"));

    await tester.pumpWidget(MaterialApp(home: filterWidget));

    await tester.tap(find.text("Filter"));

    await tester.pump();

    await tester.tap(find.text('Anwenden'));

    await tester.pump();

    expect(find.byKey(Key("type")), findsNothing);
    expect(find.byKey(Key("days")), findsNothing);
    expect(find.byKey(Key("time")), findsNothing);
    expect(find.byKey(Key("locations")), findsNothing);

    expect(find.text('Anwenden'), findsNothing);
    expect(find.text('Filter'), findsOneWidget);
  });
}
