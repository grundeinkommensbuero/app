import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/FilterWidget.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

import '../shared/mocks.trainer.dart';
import '../shared/mocks.mocks.dart';
import '../shared/TestdatenVorrat.dart';

int numberOfTimesCalled = 0;
TermineFilter? iWasCalledResult;

Future iWasCalled(TermineFilter result) async {
  numberOfTimesCalled++;
  iWasCalledResult = result;
  return Future.value();
}

final _stammdatenService = MockStammdatenService();
final _storageService = MockStorageService();

void main() {
  trainTranslation(MockTranslations());
  trainStammdatenService(_stammdatenService);
  initializeDateFormatting('de');

  group('ui', () {
    setUpUI((WidgetTester tester) async {
      when(_storageService.loadFilter()).thenAnswer((_) async => Future.value(null));
      when(_storageService.saveFilter(any)).thenAnswer((_) async => Future.value(true));
      await pumpFilterWidget(tester);
    });

    testUI('Filter starts successfully', (WidgetTester tester) async {
      expect(find.byKey(Key('filter')), findsOneWidget);
    });

    testUI('Filter opens with click', (WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.filter_alt_sharp));

      await tester.pump();

      expect(find.byKey(Key('type button')), findsOneWidget);
      expect(find.byKey(Key('days button')), findsOneWidget);
      expect(find.byKey(Key('time button')), findsOneWidget);
      expect(find.byKey(Key('locations button')), findsOneWidget);
    });

    testUI('Filter closes with click', (WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.filter_alt_sharp));

      await tester.pump();

      await tester.tap(find.text('Anwenden'));

      await tester.pump();

      expect(find.byKey(Key('type button')), findsNothing);
      expect(find.byKey(Key('days button')), findsNothing);
      expect(find.byKey(Key('time button')), findsNothing);
      expect(find.byKey(Key('locations button')), findsNothing);
    });

    testUI('Filter changes caption with click', (WidgetTester tester) async {
      await tester.pump(Duration(seconds: 1));
      expect(find.text('Anwenden'), findsNothing);
      expect(find.text('Aktualisieren'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump(Duration(seconds: 1));

      expect(find.text('Aktualisieren'), findsNothing);
      expect(find.text('Anwenden'), findsOneWidget);

      await tester.tap(find.byKey(Key('filter button')));
      await tester.pump(Duration(seconds: 1));

      expect(find.text('Anwenden'), findsNothing);
      expect(find.text('Aktualisieren'), findsOneWidget);
    });

    testUI('Filter opens Type selection with click at type button',
            (WidgetTester tester) async {
          await tester.tap(find.byIcon(Icons.filter_alt_sharp));
          await tester.pump();

          await tester.tap(find.byKey(Key('type button')));
          await tester.pump();

          expect(find.byKey(Key('type selection dialog')), findsOneWidget);
        });

    testUI('Type Selection shows all types', (WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump();

      await tester.tap(find.byKey(Key('type button')));
      await tester.pump();

      // currently hardcoded
      expect(find.text('Sammeln'), findsOneWidget);
      expect(find.text('Infoveranstaltung'), findsOneWidget);
    });

    testUI('Type Selection selects initially types from filter',
            (WidgetTester tester) async {
          FilterWidgetState filterState = tester.state(find.byKey(Key('filter')));

          filterState.filter.typen = ['Sammeln'];

          await tester.tap(find.byIcon(Icons.filter_alt_sharp));
          await tester.pump();

          await tester.tap(find.byKey(Key('type button')));
          await tester.pump();

          var checkboxTiles =
          tester.widgetList<CheckboxListTile>(find.byType(CheckboxListTile));
          var sammelTermin = checkboxTiles
              .firstWhere((ct) => (ct.title as Text).data == 'Sammeln');
          var andere = checkboxTiles.where((ct) => ct != sammelTermin);

          expect(sammelTermin.value, isTrue);
          expect(andere.every((ct) => ct.value == false), true);
        });

    testUI('Type Selection selects initially nothing if filter is empty',
            (WidgetTester tester) async {
          await tester.tap(find.byIcon(Icons.filter_alt_sharp));
          await tester.pump();

          await tester.tap(find.byKey(Key('type button')));
          await tester.pump();

          var checkboxTiles =
          tester.widgetList<CheckboxListTile>(find.byType(CheckboxListTile));

          expect(checkboxTiles.every((ct) => ct.value == false), true);
        });

    testUI('Type Selection saves selected types to filter',
            (WidgetTester tester) async {
          FilterWidgetState filterState = tester.state(find.byKey(Key('filter')));

          await tester.tap(find.byIcon(Icons.filter_alt_sharp));
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

    testUI('Filter opens Days selection with click at days button',
            (WidgetTester tester) async {
          await tester.tap(find.byIcon(Icons.filter_alt_sharp));
          await tester.pump();

          await tester.tap(find.byKey(Key('days button')));
          await tester.pump();

          expect(find.byKey(Key('days selection dialog')), findsOneWidget);
        });

    // FIXME
    /*testUI('Filter opens Locations selection with click at locations button',
        (WidgetTester tester) async {
      await pumpFilterWidget(tester);

      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump();

      await tester.tap(find.byKey(Key('locations button')));
      await tester.pump(Duration(seconds: 1));

      expect(find.byKey(Key('kiez picker')), findsOneWidget);
    });

    testUI('Filter passes locations to Locations selection',
        (WidgetTester tester) async {
      await tester.tap(find.byKey(Key('filter button')));
      await tester.pump();

      await tester.tap(find.byKey(Key('locations button')));
      await tester.pump();

      expect(find.text('district1'), findsOneWidget);
      expect(find.text('district2'), findsOneWidget);
    });*/

    testUI('Filter opens From Time selection with click at Zeit button',
            (WidgetTester tester) async {
          await tester.tap(find.byIcon(Icons.filter_alt_sharp));
          await tester.pump();

          await tester.tap(find.byKey(Key('time button')));
          await tester.pump();

          expect(find.text('Startzeit'), findsOneWidget);
          expect(find.byKey(Key('from time picker')), findsOneWidget);
        });

    testUI('Filter opens To Time selection when From Time selection is closed',
            (WidgetTester tester) async {
          await tester.tap(find.byIcon(Icons.filter_alt_sharp));
          await tester.pump();

          await tester.tap(find.byKey(Key('time button')));
          await tester.pump();

          await tester.tap(find.text('Weiter'));
          await tester.pump();

          expect(find.text('Endzeit'), findsOneWidget);
          expect(find.byKey(Key('to time picker')), findsOneWidget);
        });

    testUI('Filter intially shows time from filter in from time selection',
            (WidgetTester tester) async {
          FilterWidgetState filterState = tester.state(find.byKey(Key('filter')));

          filterState.filter.von = TimeOfDay(hour: 19, minute: 15);
          filterState.filter.bis = TimeOfDay(hour: 20, minute: 21);

          await tester.tap(find.byIcon(Icons.filter_alt_sharp));
          await tester.pump();

          await tester.tap(find.byKey(Key('time button')));
          await tester.pump();

          expect(find.text('19'), findsOneWidget);
          expect(find.text('15'), findsOneWidget);

          await tester.tap(find.text('Weiter'));
          await tester.pump();

          expect(find.text('20'), findsOneWidget);
          expect(find.text('21'), findsOneWidget);
        });

    testUI('Filter intially shows default time if filter is empty',
            (WidgetTester tester) async {
          await tester.tap(find.byIcon(Icons.filter_alt_sharp));
          await tester.pump();

          await tester.tap(find.byKey(Key('time button')));
          await tester.pump();

          expect(find.text('12'), findsOneWidget);
          expect(find.text('00'), findsOneWidget);

          await tester.tap(find.text('Weiter'));
          await tester.pump();

          expect(find.text('12'), findsOneWidget);
          expect(find.text('00'), findsOneWidget);
        });

    testUI('Filter saves selected time to filter', (WidgetTester tester) async {
      FilterWidgetState filterState = tester.state(find.byKey(Key('filter')));

      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump();

      await tester.tap(find.byKey(Key('time button')));
      await tester.pump();

      expect(find.byKey(Key('from time picker')), findsOneWidget);

      await tester.tap(find.text('Weiter'));
      await tester.pump();

      expect(find.byKey(Key('to time picker')), findsOneWidget);

      await tester.tap(find.text('Fertig'));
      await tester.pump();

      expect(ChronoHelfer.timeToStringHHmm(filterState.filter.von), '12:00');
      expect(ChronoHelfer.timeToStringHHmm(filterState.filter.von), '12:00');
    });

    testUI('Filter is applied on Anwenden button', (WidgetTester tester) async {
      FilterWidgetState filterState = tester.state(find.byKey(Key('filter')));

      await tester.tap(find.byKey(Key('filter button')));
      await tester.pump();

      filterState.filter = TermineFilter(
          ['Sammeln'],
          [DateTime(2019, 12, 16)],
          TimeOfDay(hour: 19, minute: 15),
          TimeOfDay(hour: 20, minute: 21),
          ['kiez'],
          false,
          false);

      numberOfTimesCalled = 0;
      iWasCalledResult = null;

      await tester.tap(find.byKey(Key('filter button')));
      await tester.pump();

      expect(numberOfTimesCalled, 1);
      expect(iWasCalledResult?.typen, containsAll(['Sammeln']));
      expect(ChronoHelfer.timeToStringHHmm(iWasCalledResult?.von), '19:15');
      expect(ChronoHelfer.timeToStringHHmm(iWasCalledResult?.bis), '20:21');
      expect(iWasCalledResult?.tage.map((t) => DateFormat.yMd().format(t)),
          containsAll(['12/16/2019']));
      expect(iWasCalledResult?.orte, containsAll(['kiez']));
    });
  });

  group('storage function', () {
    setUpUI((WidgetTester tester) async {});

    testUI('initializes filter with default values if no storage is found',
            (WidgetTester tester) async {
          when(_storageService.loadFilter()).thenAnswer((_) async => Future.value(null));

          await pumpFilterWidget(tester);

          FilterWidgetState filterState = tester.state(find.byKey(Key('filter')));

          expect(filterState.filter.typen, []);
          expect(filterState.filter.tage, []);
          expect(filterState.filter.von, null);
          expect(filterState.filter.bis, null);
          expect(filterState.filter.orte, []);
        });

    testUI('loads initially filter from storage if found',
            (WidgetTester tester) async {
          when(_storageService.loadFilter()).thenAnswer((_) async => TermineFilter(
              ['Sammeln', 'Infoveranstaltung'],
              [DateTime(2020, 1, 14), DateTime(2020, 1, 16)],
              TimeOfDay(hour: 12, minute: 30),
              TimeOfDay(hour: 15, minute: 0),
              [ffAlleeNord().name, tempVorstadt().name],
              false,
              false));

          await pumpFilterWidget(tester);

          FilterWidgetState filterState = tester.state(find.byKey(Key('filter')));
          var filter = filterState.filter;

          expect(filter.typen, containsAll(['Sammeln', 'Infoveranstaltung']));
          expect(filter.tage.length, 2);
          expect(filter.tage,
              containsAll([DateTime(2020, 1, 14), DateTime(2020, 1, 16)]));
          expect(filter.von, TimeOfDay(hour: 12, minute: 30));
          expect(filter.bis, TimeOfDay(hour: 15, minute: 0));
          expect(filter.orte,
              containsAll(['Frankfurter Allee Nord', 'Tempelhofer Vorstadt']));
        });
  });

  trainTranslation(MockTranslations());
  trainStammdatenService(_stammdatenService);
  initializeDateFormatting('de');

  group('ui', () {
    setUpUI((WidgetTester tester) async {
      when(_storageService.loadFilter()).thenAnswer((_) async => null);
      await pumpFilterWidget(tester);
    });

    testUI('Filter starts successfully', (WidgetTester tester) async {
      expect(find.byKey(Key('filter')), findsOneWidget);
    });

    testUI('Filter opens with click', (WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.filter_alt_sharp));

      await tester.pump();

      expect(find.byKey(Key('type button')), findsOneWidget);
      expect(find.byKey(Key('days button')), findsOneWidget);
      expect(find.byKey(Key('time button')), findsOneWidget);
      expect(find.byKey(Key('locations button')), findsOneWidget);
    });

    testUI('Filter closes with click', (WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.filter_alt_sharp));

      await tester.pump();

      await tester.tap(find.text('Anwenden'));

      await tester.pump();

      expect(find.byKey(Key('type button')), findsNothing);
      expect(find.byKey(Key('days button')), findsNothing);
      expect(find.byKey(Key('time button')), findsNothing);
      expect(find.byKey(Key('locations button')), findsNothing);
    });

    testUI('Filter changes caption with click', (WidgetTester tester) async {
      await tester.pump(Duration(seconds: 1));
      expect(find.text('Anwenden'), findsNothing);
      expect(find.text('Aktualisieren'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump(Duration(seconds: 1));

      expect(find.text('Aktualisieren'), findsNothing);
      expect(find.text('Anwenden'), findsOneWidget);

      await tester.tap(find.byKey(Key('filter button')));
      await tester.pump(Duration(seconds: 1));

      expect(find.text('Anwenden'), findsNothing);
      expect(find.text('Aktualisieren'), findsOneWidget);
    });

    testUI('Filter opens Type selection with click at type button',
        (WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump();

      await tester.tap(find.byKey(Key('type button')));
      await tester.pump();

      expect(find.byKey(Key('type selection dialog')), findsOneWidget);
    });

    testUI('Type Selection shows all types', (WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump();

      await tester.tap(find.byKey(Key('type button')));
      await tester.pump();

      // currently hardcoded
      expect(find.text('Sammeln'), findsOneWidget);
      expect(find.text('Infoveranstaltung'), findsOneWidget);
    });

    testUI('Type Selection selects initially types from filter',
        (WidgetTester tester) async {
      FilterWidgetState filterState = tester.state(find.byKey(Key('filter')));

      filterState.filter.typen = ['Sammeln'];

      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump();

      await tester.tap(find.byKey(Key('type button')));
      await tester.pump();

      var checkboxTiles =
          tester.widgetList<CheckboxListTile>(find.byType(CheckboxListTile));
      var sammelTermin = checkboxTiles
          .firstWhere((ct) => (ct.title as Text).data == 'Sammeln');
      var andere = checkboxTiles.where((ct) => ct != sammelTermin);

      expect(sammelTermin.value, isTrue);
      expect(andere.every((ct) => ct.value == false), true);
    });

    testUI('Type Selection selects initially nothing if filter is empty',
        (WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump();

      await tester.tap(find.byKey(Key('type button')));
      await tester.pump();

      var checkboxTiles =
          tester.widgetList<CheckboxListTile>(find.byType(CheckboxListTile));

      expect(checkboxTiles.every((ct) => ct.value == false), true);
    });

    testUI('Type Selection saves selected types to filter',
        (WidgetTester tester) async {
      FilterWidgetState filterState = tester.state(find.byKey(Key('filter')));

      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
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

    testUI('Filter opens Days selection with click at days button',
        (WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump();

      await tester.tap(find.byKey(Key('days button')));
      await tester.pump();

      expect(find.byKey(Key('days selection dialog')), findsOneWidget);
    });

    // FIXME
    /*testUI('Filter opens Locations selection with click at locations button',
        (WidgetTester tester) async {
      await pumpFilterWidget(tester);

      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump();

      await tester.tap(find.byKey(Key('locations button')));
      await tester.pump(Duration(seconds: 1));

      expect(find.byKey(Key('kiez picker')), findsOneWidget);
    });

    testUI('Filter passes locations to Locations selection',
        (WidgetTester tester) async {
      await tester.tap(find.byKey(Key('filter button')));
      await tester.pump();

      await tester.tap(find.byKey(Key('locations button')));
      await tester.pump();

      expect(find.text('district1'), findsOneWidget);
      expect(find.text('district2'), findsOneWidget);
    });*/

    testUI('Filter opens From Time selection with click at Zeit button',
        (WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump();

      await tester.tap(find.byKey(Key('time button')));
      await tester.pump();

      expect(find.text('Startzeit'), findsOneWidget);
      expect(find.byKey(Key('from time picker')), findsOneWidget);
    });

    testUI('Filter opens To Time selection when From Time selection is closed',
        (WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump();

      await tester.tap(find.byKey(Key('time button')));
      await tester.pump();

      await tester.tap(find.text('Weiter'));
      await tester.pump();

      expect(find.text('Endzeit'), findsOneWidget);
      expect(find.byKey(Key('to time picker')), findsOneWidget);
    });

    testUI('Filter intially shows time from filter in from time selection',
        (WidgetTester tester) async {
      FilterWidgetState filterState = tester.state(find.byKey(Key('filter')));

      filterState.filter.von = TimeOfDay(hour: 19, minute: 15);
      filterState.filter.bis = TimeOfDay(hour: 20, minute: 21);

      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump();

      await tester.tap(find.byKey(Key('time button')));
      await tester.pump();

      expect(find.text('19'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);

      await tester.tap(find.text('Weiter'));
      await tester.pump();

      expect(find.text('20'), findsOneWidget);
      expect(find.text('21'), findsOneWidget);
    });

    testUI('Filter intially shows default time if filter is empty',
        (WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump();

      await tester.tap(find.byKey(Key('time button')));
      await tester.pump();

      expect(find.text('12'), findsOneWidget);
      expect(find.text('00'), findsOneWidget);

      await tester.tap(find.text('Weiter'));
      await tester.pump();

      expect(find.text('12'), findsOneWidget);
      expect(find.text('00'), findsOneWidget);
    });

    testUI('Filter saves selected time to filter', (WidgetTester tester) async {
      FilterWidgetState filterState = tester.state(find.byKey(Key('filter')));

      await tester.tap(find.byIcon(Icons.filter_alt_sharp));
      await tester.pump();

      await tester.tap(find.byKey(Key('time button')));
      await tester.pump();

      expect(find.byKey(Key('from time picker')), findsOneWidget);

      await tester.tap(find.text('Weiter'));
      await tester.pump();

      expect(find.byKey(Key('to time picker')), findsOneWidget);

      await tester.tap(find.text('Fertig'));
      await tester.pump();

      expect(ChronoHelfer.timeToStringHHmm(filterState.filter.von), '12:00');
      expect(ChronoHelfer.timeToStringHHmm(filterState.filter.von), '12:00');
    });

    testUI('Filter is applied on Anwenden button', (WidgetTester tester) async {
      FilterWidgetState filterState = tester.state(find.byKey(Key('filter')));

      await tester.tap(find.byKey(Key('filter button')));
      await tester.pump();

      filterState.filter = TermineFilter(
          ['Sammeln'],
          [DateTime(2019, 12, 16)],
          TimeOfDay(hour: 19, minute: 15),
          TimeOfDay(hour: 20, minute: 21),
          ['kiez'],
          false,
          false);

      numberOfTimesCalled = 0;
      iWasCalledResult = null;

      await tester.tap(find.byKey(Key('filter button')));
      await tester.pump();

      expect(numberOfTimesCalled, 1);
      expect(iWasCalledResult?.typen, containsAll(['Sammeln']));
      expect(ChronoHelfer.timeToStringHHmm(iWasCalledResult?.von), '19:15');
      expect(ChronoHelfer.timeToStringHHmm(iWasCalledResult?.bis), '20:21');
      expect(iWasCalledResult?.tage.map((t) => DateFormat.yMd().format(t)),
          containsAll(['12/16/2019']));
      expect(iWasCalledResult?.orte, containsAll(['kiez']));
    });
  });

  group('storage function', () {
    setUpUI((WidgetTester tester) async {});

    testUI('initializes filter with default values if no storage is found',
        (WidgetTester tester) async {
      when(_storageService.loadFilter()).thenAnswer((_) async => null);

      await pumpFilterWidget(tester);

      FilterWidgetState filterState = tester.state(find.byKey(Key('filter')));

      expect(filterState.filter.typen, []);
      expect(filterState.filter.tage, []);
      expect(filterState.filter.von, null);
      expect(filterState.filter.bis, null);
      expect(filterState.filter.orte, []);
    });

    testUI('loads initially filter from storage if found',
        (WidgetTester tester) async {
      when(_storageService.loadFilter()).thenAnswer((_) async => TermineFilter(
          ['Sammeln', 'Infoveranstaltung'],
          [DateTime(2020, 1, 14), DateTime(2020, 1, 16)],
          TimeOfDay(hour: 12, minute: 30),
          TimeOfDay(hour: 15, minute: 0),
          [ffAlleeNord().name, tempVorstadt().name],
          false,
          false));

      await pumpFilterWidget(tester);

      FilterWidgetState filterState = tester.state(find.byKey(Key('filter')));
      var filter = filterState.filter;

      expect(filter.typen, containsAll(['Sammeln', 'Infoveranstaltung']));
      expect(filter.tage.length, 2);
      expect(filter.tage,
          containsAll([DateTime(2020, 1, 14), DateTime(2020, 1, 16)]));
      expect(filter.von, TimeOfDay(hour: 12, minute: 30));
      expect(filter.bis, TimeOfDay(hour: 15, minute: 0));
      expect(filter.orte,
          containsAll(['Frankfurter Allee Nord', 'Tempelhofer Vorstadt']));
    });
  });
}

Future pumpFilterWidget(WidgetTester tester) async {
  FilterWidget filterWidget = FilterWidget(iWasCalled, key: Key('filter'));
  await tester.pumpWidget(MultiProvider(providers: [
    Provider<StammdatenService>.value(value: _stammdatenService),
    Provider<StorageService>.value(value: _storageService)
  ], child: MaterialApp(home: filterWidget)));
}
