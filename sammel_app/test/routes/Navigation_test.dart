import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/FAQService.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/PlacardsService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/services/VisitedHouseView.dart';
import 'package:sammel_app/services/VisitedHousesService.dart';

import '../model/Termin_test.dart';
import '../shared/TestdatenVorrat.dart';
import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.trainer.dart';
import 'ActionEditor_test.dart';

final _stammdatenService = MockStammdatenService();
final _termineService = MockTermineService();
final _listLocationService = MockListLocationService();
final _storageService = MockStorageService();
final _pushService = MockPushSendService();
final _userService = MockUserService();
final _chatService = MockChatMessageService();
final _placardService = MockPlacardsService();
final _pushManager = MockPushNotificationManager();
final _faqService = MockFAQService();
final _geoService = MockGeoService();
final _visitedHousesService = MockVisitedHousesService();

void main() {
  trainTranslation(MockTranslations());
  trainUserService(_userService);
  trainStammdatenService(_stammdatenService);
  trainChatMessageService(_chatService);
  trainStorageService(_storageService);
  initializeDateFormatting('de');

  setUp(() => HttpOverrides.global = MapHttpOverrides());

  group('Navigation', () {
    late Navigation navigation;
    var actionPageKey = GlobalKey<TermineSeiteState>(debugLabel: 'action page');
    var actionCreatorKey =
        GlobalKey<ActionEditorState>(debugLabel: 'action creator');

    setUpUI((WidgetTester tester) async {
      navigation = Navigation(actionPageKey, actionCreatorKey);
      reset(_visitedHousesService);
      when(_storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => []);
      when(_storageService.loadMyKiez()).thenAnswer((_) async => []);
      when(_storageService.loadNotificationInterval())
          .thenAnswer((_) async => 'nie');
      when(_listLocationService.getActiveListLocations())
          .thenAnswer((_) async => []);
      when(_storageService.loadFilter())
          .thenAnswer((_) async => TermineFilter.leererFilter());
      when(_termineService.loadActions(any)).thenAnswer((_) async => []);
      when(_pushManager.pushToken).thenAnswer((_) async => 'Token');
      trainFAQService(_faqService);
      when(_placardService.loadPlacards())
          .thenAnswer((_) async => Future.value([]));
      when(_visitedHousesService.loadVisitedHouses())
          .thenAnswer((_) => Future.value([]));
      when(_visitedHousesService.getVisitedHousesInArea(any))
          .thenReturn(VisitedHouseView(BoundingBox(0, 0, 0, 0), []));

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<StammdatenService>.value(value: _stammdatenService),
        Provider<AbstractTermineService>.value(value: _termineService),
        Provider<AbstractListLocationService>.value(
            value: _listLocationService),
        Provider<StorageService>.value(value: _storageService),
        Provider<AbstractPushSendService>.value(value: _pushService),
        Provider<AbstractUserService>.value(value: _userService),
        Provider<ChatMessageService>.value(value: _chatService),
        Provider<AbstractPushNotificationManager>.value(value: _pushManager),
        Provider<AbstractFAQService>.value(value: _faqService),
        Provider<AbstractPlacardsService>.value(value: _placardService),
        Provider<GeoService>.value(value: _geoService),
        Provider<AbstractVisitedHousesService>.value(
            value: _visitedHousesService),
      ], child: MaterialApp(home: navigation)));
    });

    testUI('starts and shows correct Titel', (WidgetTester tester) async {
      expect(find.text('Aktionen'), findsOneWidget);
    });

    testUI('shows all items', (WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action page navigation button')), findsOneWidget);
      expect(
          find.byKey(Key('action creator navigation button')), findsOneWidget);
      expect(find.byKey(Key('faq navigation button')), findsOneWidget);
    });

    testUI('starts with ActionPage ', (WidgetTester tester) async {
      NavigationState state = tester.state(find.byWidget(navigation));
      expect(state.navigation, 0);
      expect(find.byKey(actionPageKey), findsOneWidget);
    });

    testUI('creates ActionPage and ActionCreator', (WidgetTester tester) async {
      expect(find.byKey(actionPageKey), findsOneWidget);
      expect(find.byKey(actionCreatorKey), findsOneWidget);
    });

    testUI('switches to Action Creator with tap on Create Action Button',
        (WidgetTester tester) async {
      NavigationState state = tester.state(find.byWidget(navigation));
      expect(state.navigation, isNot(1));

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('action creator navigation button')));
      await tester.pumpAndSettle();

      expect(state.navigation, 1);
      expect(find.byKey(actionCreatorKey), findsOneWidget);
      expect(find.text('Zum Sammeln einladen'), findsOneWidget);
    });

    testUI('switches to FAQ page with tap on FAQ Button',
        (WidgetTester tester) async {
      NavigationState state = tester.state(find.byWidget(navigation));
      expect(state.navigation, isNot(2));

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('faq navigation button')));
      await tester.pumpAndSettle();

      expect(state.navigation, 2);
      expect(find.byKey(Key('faq page')), findsOneWidget);
      expect(find.text('Tipps und Argumente'), findsOneWidget);
    });

    testUI('returns to same ActionPage page with tap on Actions-Button',
        (WidgetTester tester) async {
      NavigationState state = tester.state(find.byWidget(navigation));
      state.navigation = 1;
      await tester.pump();

      expect(state.navigation, isNot(0));

      await openActionPage(tester);

      expect(state.navigation, 0);
      expect(find.byKey(actionPageKey), findsOneWidget);
    });

    testUI('stores navigation history', (WidgetTester tester) async {
      await openActionCreator(tester);
      await openActionPage(tester);

      NavigationState state = tester.state(find.byWidget(navigation));
      expect(state.history, [0, 1]);
    });

    testUI('returns to last page and pops history with back button',
        (WidgetTester tester) async {
      await openActionCreator(tester);
      await openActionPage(tester);

      NavigationState state = tester.state(find.byWidget(navigation));
      expect(state.history, [0, 1]);

      await maybePop(state, tester);

      expect(state.navigation, 1);
      expect(state.history, [0]);

      await maybePop(state, tester);

      expect(state.navigation, 0);
      expect(state.history, isEmpty);

      await maybePop(state, tester);

      // Test auf Schließen der App scheint nicht möglich
      expect(state.navigation, 0);
      expect(state.history, isEmpty);
    });

    testUI('returns action page after action creation',
        (WidgetTester tester) async {
      when(_termineService.createAction(any, any))
          .thenAnswer((_) async => TerminTestDaten.einTermin());
      await openActionCreator(tester);

      ActionEditorState editor = tester.state(find.byKey(actionCreatorKey));
      editor.action = testActionData();

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      NavigationState navigation = tester.state(find.byKey(Key('navigation')));
      expect(navigation.navigation, 0);
    });

    testUI('navigateToActionCreator changes page to ActionCreator',
        (tester) async {
      when(_geoService.getDescriptionToPoint(any)).thenAnswer(
          (_) => Future.value(GeoData('Nightmare', 'Elm Street', '12')));
      when(_stammdatenService.getKiezAtLocation(any))
          .thenAnswer((_) => Future.value(plaenterwald()));

      await openActionCreator(tester);

      NavigationState state = tester.state(find.byType(Navigation));
      (state).navigateToActionCreator(LatLng(52.5749413, 13.3762427));
      await tester.pumpAndSettle();

      expect(state.navigation, 1);
      expect(state.history, containsAll([0]));
      expect(state.history, containsAll([0]));
      expect(find.byKey(actionCreatorKey), findsOneWidget);
      expect(find.text('Zum Sammeln einladen'), findsOneWidget);
    });
  });

  group('menuEntry', () {
    final title = 'Title';
    final subtitle = 'Subtitle';

    setUpUI((WidgetTester tester) async {
      var navigationState = NavigationState();
      var menuEntry = navigationState.menuEntry(
        key: Key('menu entry'),
        title: title,
        subtitle: subtitle,
      );
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: menuEntry)));
    });

    testUI('shows title and subtitle', (WidgetTester _) async {
      expect(find.byKey(Key('menu entry')), findsOneWidget);
      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
    });
  });
}

Future openActionCreator(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('action creator navigation button')));
  await tester.pumpAndSettle();
}

Future openActionPage(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('action page navigation button')));
  await tester.pumpAndSettle();
}

Future maybePop(NavigationState state, WidgetTester tester) async {
  Navigator.of(state.context).maybePop();
  await tester.pumpAndSettle();
}
