import 'package:calendarro/calendarro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/showMultipleDatePicker.dart';

MaterialApp WidgetWithMultipleDatePicker(
    List<DateTime> previousSelection, Function result) {
  return MaterialApp(
    home: Material(
      child: Builder(builder: (BuildContext context) {
        return Center(
          child: RaisedButton(
            child: const Text('X'),
            onPressed: () async {
              result(await showMultipleDatePicker(previousSelection, context,
                  key: Key('days picker')));
            },
          ),
        );
      }),
    ),
  );
}

void main() {
  testWidgets('Days Selection selects initially days from filter',
      (WidgetTester tester) async {
    var widget = WidgetWithMultipleDatePicker([DateTime.now()], () {});

    await tester.pumpWidget(MaterialApp(home: widget));

    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    var calendarro = tester.widget(find.byType(Calendarro)) as Calendarro;
    expect(calendarro.state.isDateSelected(DateTime.now()), true);
  });

  testWidgets('Days Selection selects no days when filter is empty',
      (WidgetTester tester) async {
    var widget = WidgetWithMultipleDatePicker([], () {});

    await tester.pumpWidget(MaterialApp(home: widget));

    await tester.tap(find.text('X'));
    await tester.pump();

    var calendarro = tester.widget(find.byType(Calendarro)) as Calendarro;
    expect(calendarro.selectedDates.isEmpty, true);
  });

  testWidgets('Days Selection changes displayed month with buttons',
      (WidgetTester tester) async {
    var widget = WidgetWithMultipleDatePicker([], () {});

    await tester.pumpWidget(MaterialApp(home: widget));

    await tester.tap(find.text('X'));
    await tester.pump();

    var currentMonthName = ChronoHelfer.monthName(DateTime.now().month);
    expect(
        (tester.widget(find.byKey(Key('current month'))) as Text)
            .data
            .startsWith(currentMonthName),
        true);

    expect(
        DateFormat.yMd().format(
            (tester.widget(find.byType(Calendarro)) as Calendarro).startDate),
        '${DateTime.now().month}/'
        '1/'
        '${DateTime.now().year}');

    expect(find.byKey(Key('next month button')), findsOneWidget);
    await tester.tap(find.byKey(Key('next month button')));
    await tester.pump();

    var nextMonthName =
        ChronoHelfer.monthName(Jiffy(DateTime.now()).add(months: 1).month);
    expect(
        (tester.widget(find.byKey(Key('current month'))) as Text)
            .data
            .startsWith(nextMonthName),
        true);

    expect(
        DateFormat.yMd().format(
            (tester.widget(find.byType(Calendarro)) as Calendarro).startDate),
        '${Jiffy(DateTime.now()).add(months: 1).month}/'
        '1/'
        '${Jiffy(DateTime.now()).add(months: 1).year}');

    await tester.tap(find.byKey(Key('previous month button')));
    await tester.pump();

    expect(
        (tester.widget(find.byKey(Key('current month'))) as Text)
            .data
            .startsWith(currentMonthName),
        true);

    expect(
        DateFormat.yMd().format(
            (tester.widget(find.byType(Calendarro)) as Calendarro).startDate),
        '${DateTime.now().month}/'
        '1/'
        '${DateTime.now().year}');
  });

  testWidgets('Days Selection selects dates from multiple months',
      (WidgetTester tester) async {
    List<DateTime> result;
    var widget = WidgetWithMultipleDatePicker([], (r) => result = r);

    await tester.pumpWidget(MaterialApp(home: widget));

    await tester.tap(find.text('X'));
    await tester.pump();

    await tester.tap(find.text('1'));
    await tester.pump();

    await tester.tap(find.byKey(Key('next month button')));
    await tester.pump();

    await tester.tap(find.text('1'));
    await tester.pump();

    await tester.tap(find.byKey(Key('days dialog accept button')));
    await tester.pump();

    expect(
        result.map((t) => DateFormat.yMd().format(t)),
        containsAll([
          '${DateTime.now().month}/'
              '1/'
              '${DateTime.now().year}',
          '${Jiffy(DateTime.now()).add(months: 1).month}/'
              '1/'
              '${Jiffy(DateTime.now()).add(months: 1).year}'
        ]));
  });

  testWidgets('Days Selection saves selected days to filter on Auswaehlen',
      (WidgetTester tester) async {
    var result;
    var widget = WidgetWithMultipleDatePicker([], (r) => result = r);

    await tester.pumpWidget(MaterialApp(home: widget));

    await tester.tap(find.text('X'));
    await tester.pump();

    await tester.tap(find.text(DateTime.now().day.toString()));
    await tester.pump();

    await tester.tap(find.byKey(Key('days dialog accept button')));
    await tester.pump();

    var heute =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    expect(result, containsAll([heute]));
  });

  testWidgets('Days Selection empties days from filter on Keine',
      (WidgetTester tester) async {
    var result;
    var widget =
        WidgetWithMultipleDatePicker([DateTime.now()], (r) => result = r);

    await tester.pumpWidget(MaterialApp(home: widget));

    await tester.tap(find.text('X'));
    await tester.pump();

    await tester.tap(find.text(DateTime.now().day.toString()));
    await tester.pump();

    await tester.tap(find.byKey(Key('days dialog none button')));
    await tester.pump();

    expect(result, isEmpty);
  });
}
