import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';

import '../shared/Mocks.dart';

final termineService = TermineServiceMock();
final listLocationService = ListLocationServiceMock();
final storageService = StorageServiceMock();

void main() {
  Navigation navigation;

  setUp(() {
    navigation = Navigation();
    when(storageService.loadAllStoredActionIds()).thenAnswer((_) async => []);
    when(listLocationService.getActiveListLocations())
        .thenAnswer((_) async => []);
    when(storageService.loadFilter())
        .thenAnswer((_) async => TermineFilter.leererFilter());
    when(termineService.ladeTermine(any)).thenAnswer((_) async => []);
  });

  pumpNavigation(WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(providers: [
      Provider<AbstractTermineService>.value(value: termineService),
      Provider<AbstractListLocationService>.value(value: listLocationService),
      Provider<StorageService>.value(value: storageService),
    ], child: MaterialApp(home: navigation)));
  }

  testWidgets('Navigation-Seite startet fehlerfrei und zeigt richtigen Titel',
      (WidgetTester tester) async {
    await pumpNavigation(tester);
    expect(find.text('Aktionen'), findsOneWidget);
  });

  testWidgets('start with ActionPage ',
          (WidgetTester tester) async {
        await pumpNavigation(tester);

        NavigationState state = tester.state(find.byWidget(navigation));
        expect(state.navigation, 0);
        expect(find.byKey(state.actionPage), findsOneWidget);
      });

  testWidgets('creates ActionPage and ActionCreator',
          (WidgetTester tester) async {
        await pumpNavigation(tester);

        NavigationState state = tester.state(find.byWidget(navigation));
        expect(find.byKey(state.actionPage), findsOneWidget);
        expect(find.byKey(Key('action creator')), findsOneWidget);
      });

  testWidgets('switches to Action Creator with tap on Create Action Button',
      (WidgetTester tester) async {
        await pumpNavigation(tester);

    NavigationState state = tester.state(find.byWidget(navigation));
    expect(state.navigation, isNot(1));

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('action creator button')));
    await tester.pumpAndSettle();

    expect(state.navigation, 1);
    expect(find.byKey(Key('action creator')), findsOneWidget);
      });

  testWidgets('returns to same ActionPage page with tap on Actions-Button',
      (WidgetTester tester) async {
    await pumpNavigation(tester);

    NavigationState state = tester.state(find.byWidget(navigation));
    state.setState(() => state.navigation = 1);
    await tester.pump();

    expect(state.navigation, isNot(0));

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('action page button')));
    await tester.pumpAndSettle();

    expect(state.navigation, 0);
    expect(find.byKey(state.actionPage), findsOneWidget);
  });

  testWidgets('stores navigation history',
      (WidgetTester tester) async {
    await pumpNavigation(tester);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('action creator button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('action page button')));
    await tester.pumpAndSettle();

    NavigationState state = tester.state(find.byWidget(navigation));
    expect(state.history, [0,1]);
  });

  testWidgets('returns to last page and pops history with back button',
      (WidgetTester tester) async {
    await pumpNavigation(tester);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('action creator button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('action page button')));
    await tester.pumpAndSettle();

    NavigationState state = tester.state(find.byWidget(navigation));
    expect(state.history, [0,1]);

    Navigator.of(state.context).maybePop();
    await tester.pumpAndSettle();

    expect(state.navigation, 1);
    expect(state.history, [0]);

    Navigator.of(state.context).maybePop();
    await tester.pumpAndSettle();

    expect(state.navigation, 0);
    expect(state.history, isEmpty);

    Navigator.of(state.context).maybePop();
    await tester.pumpAndSettle();

    // Test auf Schließen der App scheint nicht möglich
    expect(state.navigation, 0);
    expect(state.history, isEmpty);
  });
}
