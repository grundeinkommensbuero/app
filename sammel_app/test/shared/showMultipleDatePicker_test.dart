import 'package:calendarro/calendarro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sammel_app/shared/showMultipleDatePicker.dart';

import 'Mocks.dart';

Widget createWidgetWithMultipleDatePicker(List<DateTime> previousSelection,
    Function result) {
  return MaterialApp(
    locale: Locale('en'),
    home: Builder(builder: (BuildContext context) {
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
  );
}

void main() {
  mockTranslation();
  initializeDateFormatting('en', null);

  testWidgets('Days Selection selects initially days from filter',
          (WidgetTester tester) async {
        await tester.pumpWidget(
            createWidgetWithMultipleDatePicker([DateTime.now()], () {}));

        await tester.tap(find.text('X'));
        await tester.pumpAndSettle();

        var calendarro = tester.widget(find.byType(Calendarro)) as Calendarro;
        expect(calendarro.state.isDateSelected(DateTime.now()), true);
      });

  testWidgets('Days Selection selects no days when filter is empty',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetWithMultipleDatePicker([], () {}));

        await tester.tap(find.text('X'));
        await tester.pump();

        var calendarro = tester.widget(find.byType(Calendarro)) as Calendarro;
        expect(calendarro.selectedDates.isEmpty, true);
      });

  testWidgets('Days Selection changes displayed month with buttons',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetWithMultipleDatePicker([], () {}));

        await tester.tap(find.text('X'));
        await tester.pump();

        var currentMonthName = DateFormat.MMMM('en').format(DateTime.now());
        expect((tester.widget(find.byKey(Key('current month'))) as Text).data,
            currentMonthName);

        expect(
            DateFormat.yMd().format(
                (tester.widget(find.byType(Calendarro)) as Calendarro)
                    .startDate),
            '${DateTime
                .now()
                .month}/'
                '1/'
                '${DateTime
                .now()
                .year}');

        expect(find.byKey(Key('next month button')), findsOneWidget);
        await tester.tap(find.byKey(Key('next month button')));
        await tester.pump();

        var nextMonthName = DateFormat.MMMM('en')
            .format((Jiffy(DateTime.now())
          ..add(months: 1)).dateTime);
        expect((tester.widget(find.byKey(Key('current month'))) as Text).data,
            nextMonthName);

        expect(
            DateFormat.yMd().format(
                (tester.widget(find.byType(Calendarro)) as Calendarro)
                    .startDate),
            '${(Jiffy(DateTime.now())
              ..add(months: 1)).dateTime.month}/'
                '1/'
                '${(Jiffy(DateTime.now())
              ..add(months: 1)).dateTime.year}');

        await tester.tap(find.byKey(Key('previous month button')));
        await tester.pump();

        expect(
            (tester.widget(find.byKey(Key('current month'))) as Text)
                .data!
                .startsWith(currentMonthName),
            true);

        expect(
            DateFormat.yMd().format(
                (tester.widget(find.byType(Calendarro)) as Calendarro)
                    .startDate),
            '${DateTime
                .now()
                .month}/'
                '1/'
                '${DateTime
                .now()
                .year}');
      });

  testWidgets('Days Selection selects dates from multiple months',
          (WidgetTester tester) async {
        List<DateTime>? result;

        await tester
            .pumpWidget(
            createWidgetWithMultipleDatePicker([], (r) => result = r));

        await tester.tap(find.text('X'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('1'));
        await tester.pump();

        await tester.tap(find.byKey(Key('next month button')));
        await tester.pump();

        await tester.tap(find.text('1'));
        await tester.pumpAndSettle(Duration(seconds: 2));

        await tester.tap(find.byKey(Key('days dialog accept button')));
        await tester.pumpAndSettle();

        expect(
            result!.map((t) => DateFormat.yMd().format(t)),
            containsAll([
              '${DateTime
                  .now()
                  .month}/'
                  '1/'
                  '${DateTime
                  .now()
                  .year}',
              '${(Jiffy(DateTime.now())
                ..add(months: 1)).dateTime.month}/'
                  '1/'
                  '${(Jiffy(DateTime.now())
                ..add(months: 1)).dateTime.year}'
            ]));
      });

  testWidgets('Days Selection saves selected days to filter on Auswaehlen',
  (WidgetTester tester) async {
  var result;

  await tester
      .pumpWidget(createWidgetWithMultipleDatePicker([], (r) => result = r));

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

  testWidgets('Days Selection uses previous days from filter on Abbrechen',
  (WidgetTester tester) async {
  var result;
  var today = DateTime.now();

  await tester.pumpWidget(
  createWidgetWithMultipleDatePicker([today], (r) => result = r));

  await tester.tap(find.text('X'));
  await tester.pump();

  await tester.tap(find.text(DateTime.now().day.toString()));
  await tester.pump();

  await tester.tap(find.byKey(Key('days dialog cancel button')));
  await tester.pump();

  expect(result, containsAll([today]));
  });

  group('initially displayed month', () {
  testWidgets('is current month with null initial dates', (tester) async {
  await tester.pumpWidget(createWidgetWithMultipleDatePicker([], (_) {}));

  await tester.tap(find.text('X'));
  await tester.pump();

  final currentMonth = DateFormat.MMMM().format(DateTime.now());
  expect(find.text(currentMonth), findsOneWidget);
  });

  testWidgets('is current month with empty initial dates', (tester) async {
  await tester.pumpWidget(createWidgetWithMultipleDatePicker([], (_) {}));

  await tester.tap(find.text('X'));
  await tester.pump();

  final currentMonth = DateFormat.MMMM().format(DateTime.now());
  expect(find.text(currentMonth), findsOneWidget);
  });

  testWidgets('is month of single initial date', (tester) async {
  var initDate = (Jiffy(DateTime.now())..add(months: 1)).dateTime;
  await tester
      .pumpWidget(createWidgetWithMultipleDatePicker([initDate], (_) {}));

  await tester.tap(find.text('X'));
  await tester.pump();

  final currentMonth = DateFormat.MMMM().format(initDate);
  expect(find.text(currentMonth), findsOneWidget);
  });

  testWidgets('is first month of multiple initial dates', (tester) async {
  var initDate = (Jiffy(DateTime.now())..add(months: 1)).dateTime;
  await tester.pumpWidget(createWidgetWithMultipleDatePicker(
  [initDate, (Jiffy(DateTime.now())..add(months: 2)).dateTime], (_) {}));

  await tester.tap(find.text('X'));
  await tester.pump();

  final currentMonth = DateFormat.MMMM().format(initDate);
  expect(find.text(currentMonth), findsOneWidget);
  });
  });
}
