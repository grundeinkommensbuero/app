import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jiffy/jiffy.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Placard.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/ActionMap.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/AuthFehler.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/PlacardsService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../model/Termin_test.dart';
import '../shared/TestdatenVorrat.dart';
import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.trainer.dart';

final _stammdatenService = MockStammdatenService();
final _termineService = MockTermineService();
final _listLocationService = MockListLocationService();
final _storageService = MockStorageService();
final _pushService = MockPushSendService();
final _userService = MockUserService();
final _chatMessageService = MockChatMessageService();
final _pushManager = MockPushNotificationManager();
final _placardsService = MockPlacardsService();
final _geoService = MockGeoService();

final actionCreatorKey =
    GlobalKey<ActionEditorState>(debugLabel: 'action creator');

void main() {
  trainTranslation(MockTranslations());
  trainUserService(_userService);
  trainStammdatenService(_stammdatenService);
  trainStorageService(_storageService);
  trainChatMessageService(_chatMessageService);
  initializeDateFormatting('de');

  late MultiProvider termineSeiteWidget;

  LatLng? switchParameter;
  Function(LatLng) switchToActionCreator =
      (parameter) => switchParameter = parameter;

  setUp(() {
    HttpOverrides.global = MapHttpOverrides();
    when(_storageService.loadFilter()).thenAnswer((_) async => null);
    when(_storageService.loadAllStoredActionIds()).thenAnswer((_) async => []);
    when(_storageService.loadMyKiez()).thenAnswer((_) async => []);
    when(_storageService.loadNotificationInterval())
        .thenAnswer((_) async => 'nie');
    when(_listLocationService.getActiveListLocations())
        .thenAnswer((_) async => []);
    reset(_termineService);
    when(_termineService.loadActions(any)).thenAnswer((_) async => []);
    when(_termineService.deleteAction(any, any)).thenReturn(null);
    when(_pushManager.pushToken).thenAnswer((_) => Future.value('Token'));
    when(_placardsService.loadPlacards())
        .thenAnswer((_) async => Future.value([]));
    ErrorService.displayedTypes = [];

    termineSeiteWidget = MultiProvider(
        providers: [
          Provider<StammdatenService>.value(value: _stammdatenService),
          Provider<AbstractTermineService>.value(value: _termineService),
          Provider<AbstractListLocationService>.value(
              value: _listLocationService),
          Provider<StorageService>.value(value: _storageService),
          Provider<AbstractUserService>.value(value: _userService),
          Provider<ChatMessageService>.value(value: _chatMessageService),
          Provider<AbstractPlacardsService>.value(value: _placardsService),
          Provider<GeoService>.value(value: _geoService),
        ],
        child: MaterialApp(home: Builder(builder: (BuildContext context) {
          ErrorService.setContext(context);
          return TermineSeite(
            switchToActionCreator: switchToActionCreator,
          );
        })));
  });

  group('presentation', () {
    testWidgets('TermineSeite sorts actions by From Date',
        (WidgetTester tester) async {
      var today = DateTime.now();
      var tomorrow = today.add(Duration(days: 1));
      var yesterday = today.subtract(Duration(days: 1));
      var me = karl();

      var userService = MockUserService();
      when(userService.user).thenAnswer((_) => Stream.value(me));

      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(today)..ort = tempVorstadt(),
            TerminTestDaten.anActionFrom(tomorrow)..ort = ffAlleeNord(),
            TerminTestDaten.anActionFrom(yesterday)..ort = plaenterwald(),
          ]);

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byType(TerminCard).first,
              matching: find.text(TerminCard.erzeugeOrtText(plaenterwald()))),
          findsOneWidget);

      expect(
          find.descendant(
              of: find.byType(TerminCard).at(1),
              matching: find.text(TerminCard.erzeugeOrtText(tempVorstadt()))),
          findsOneWidget);

      expect(
          find.descendant(
              of: find.byType(TerminCard).last,
              matching: find.text(TerminCard.erzeugeOrtText(ffAlleeNord()))),
          findsOneWidget);
    });

    testWidgets(
        'shows edit and delete button in Detail Dialog only at own actions',
        (WidgetTester tester) async {
      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin()..id = 1,
            TerminTestDaten.einTermin()..id = 2,
            TerminTestDaten.einTermin()..id = 3,
          ]);
      when(_termineService.getActionWithDetails(any)).thenAnswer((_) async =>
          TerminTestDaten.einTerminMitTeilisUndDetails()
            ..ende = Jiffy(DateTime.now()).add(days: 1).dateTime);

      when(_storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [2]);

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).at(0));
      await tester.pump();

      // no buttons at first action
      await tester.tap(find.byKey(Key('action details menu button')));
      await tester.pump();

      expect(find.byKey(Key('action details delete menu item')), findsNothing);
      expect(find.byKey(Key('action details edit menu item')), findsNothing);

      await tester.tap(find.byKey(Key('action details menu button')));
      await tester.pump();
      await tester.tap(find.byKey(Key('action details close button')));
      await tester.pump();

      // buttons at second action
      await tester.tap(find.byKey(Key('action card')).at(1));
      await tester.pump();

      await tester.tap(find.byKey(Key('action details menu button')));
      await tester.pump();

      expect(
          find.byKey(Key('action details delete menu item')), findsOneWidget);
      expect(find.byKey(Key('action details edit menu item')), findsOneWidget);

      await tester.tap(find.byKey(Key('action details menu button')));
      await tester.pump();
      await tester.tap(find.byKey(Key('action details close button')));
      await tester.pump();

      // no buttons at third action
      await tester.tap(find.byKey(Key('action card')).at(2));
      await tester.pump();

      await tester.tap(find.byKey(Key('action details menu button')));
      await tester.pump();

      expect(find.byKey(Key('action details delete menu item')), findsNothing);
      expect(find.byKey(Key('action details edit menu item')), findsNothing);
    });
  });

  group('Filter', () {
    testWidgets('is displayed', (WidgetTester tester) async {
      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
          ]);

      await tester.pumpWidget(termineSeiteWidget);
      await tester.pumpAndSettle(Duration(seconds: 1));
      // await StammdatenService.kieze;

      expect(find.text('Aktualisieren'), findsOneWidget);
    });

    testWidgets('opens on tap', (WidgetTester tester) async {
      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
          ]);

      await tester.pumpWidget(termineSeiteWidget);

      await tester.tap(find.byIcon(Icons.filter_alt_sharp));

      await tester.pump();

      expect(find.text('Anwenden'), findsOneWidget);
    });
  });

  group('ActionDetailsDialog', () {
    testWidgets('opens with tap on TermineCard', (WidgetTester tester) async {
      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
          ]);
      when(_termineService.getActionWithDetails(any)).thenAnswer(
          (_) async => TerminTestDaten.einTerminMitTeilisUndDetails());

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      expect(find.byKey(Key('termin details dialog')), findsOneWidget);
      expect(find.byKey(Key('action details page')), findsOneWidget);
      expect(find.byKey(Key('action details close button')), findsOneWidget);
    });

    testWidgets('loads Termin with details with tap on TermineCard',
        (WidgetTester tester) async {
      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
          ]);
      when(_termineService.getActionWithDetails(any)).thenAnswer(
          (_) async => TerminTestDaten.einTerminMitTeilisUndDetails());

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      verify(_termineService.getActionWithDetails(0));
    });

    testWidgets('closes TerminDetails dialog with tap on Schliessen button',
        (WidgetTester tester) async {
      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
          ]);
      when(_termineService.getActionWithDetails(any)).thenAnswer(
          (_) async => TerminTestDaten.einTerminMitTeilisUndDetails());

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      await tester.tap(find.byKey(Key('action details close button')));
      await tester.pump();

      expect(find.byKey(Key('termin details dialog')), findsNothing);
    });

    testWidgets('closes TerminDetails dialog on tap at map',
        (WidgetTester tester) async {
      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
          ]);
      when(_termineService.getActionWithDetails(any)).thenAnswer(
          (_) async => TerminTestDaten.einTerminMitTeilisUndDetails());

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      await tester.tap(find.byKey(Key('action details map marker')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('termin details dialog')), findsNothing);
    });

    testWidgets('switches to map view and centers at action on tap at map',
        (WidgetTester tester) async {
      when(_termineService.loadActions(any)).thenAnswer((_) => Future.value([
            TerminTestDaten.einTermin(),
          ]));
      when(_termineService.getActionWithDetails(any)).thenAnswer(
          (_) => Future.value(TerminTestDaten.einTerminMitTeilisUndDetails()));

      await tester.pumpWidget(termineSeiteWidget);
      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      TermineSeiteState page = tester.state(find.byKey(Key('action page')));
      expect(page.navigation, 0);

      await tester.tap(find.byKey(Key('action details map marker')));
      await tester.pumpAndSettle();

      expect(page.navigation, 1);
      expect(find.byKey(Key('action map map')), findsOneWidget);
      var actionPosition = LatLng(TerminTestDaten.einTermin().latitude,
          TerminTestDaten.einTermin().longitude);
      TermineSeiteState actionPage =
          tester.state(find.byKey(Key('action page')));
      expect(actionPage.mapController.zoom, 15);
      expect(actionPage.mapController.center, actionPosition);
    });

    testWidgets(
        'triggers server call and highlights action with tap on join button',
        (WidgetTester tester) async {
      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
          ]);
      var action = TerminTestDaten.einTerminOhneTeilisMitDetails()
        ..beginn = DateTime.now().add(new Duration(hours: 24))
        ..ende = DateTime.now().add(new Duration(hours: 26));
      when(_termineService.getActionWithDetails(any))
          .thenAnswer((_) async => action);
      when(_termineService.joinAction(any)).thenAnswer((_) => null);

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      var state = tester.state<TermineSeiteState>(find.byType(TermineSeite));
      expect(state.termine[0].participants, isEmpty);

      await tester.tap(find.byKey(Key('join action button')));
      await tester.pump();

      verify(_termineService.joinAction(action.id!)).called(1);
      expect(state.termine[0].participants![0].name, equals('Karl Marx'));
      expect(find.byKey(Key('join action button')), findsNothing);
      expect(find.byKey(Key('open chat window')), findsOneWidget);
    });

    testWidgets(
        'triggers server call and highlihgts action with tap on leave button',
        (WidgetTester tester) async {
      var me = karl();
      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin()..participants = [me],
            TerminTestDaten.einTermin(),
            TerminTestDaten.einTermin(),
          ]);
      var action = TerminTestDaten.einTerminMitTeilisUndDetails()
        ..beginn = DateTime.now().add(new Duration(hours: 24))
        ..ende = DateTime.now().add(new Duration(hours: 26));
      when(_termineService.getActionWithDetails(any))
          .thenAnswer((_) async => action);
      when(_termineService.leaveAction(any)).thenAnswer((_) => null);

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      var state = tester.state<TermineSeiteState>(find.byType(TermineSeite));
      expect(state.termine[0].participants, containsAll([me]));

      await tester.tap(find.byKey(Key('action details menu button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('action details menu leave item')));
      await tester.pumpAndSettle();

      verify(_termineService.leaveAction(action.id!)).called(1);
      expect(state.termine[0].participants, isEmpty);
      expect(find.byKey(Key('join action button')), findsOneWidget);
    });
  });

  group('ActionCreator', () {
    testWidgets('new actions are added and sorted into action list',
        (WidgetTester tester) async {
      var today = DateTime.now();
      var yesterday = today.subtract(Duration(days: 1));
      var tomorrow = today.add(Duration(days: 1));
      var dayAfterTomorrow = today.add(Duration(days: 2));

      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(yesterday),
            TerminTestDaten.anActionFrom(tomorrow),
            TerminTestDaten.anActionFrom(dayAfterTomorrow),
          ]);

      await _pumpNavigation(tester);
      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action card')), findsNWidgets(3));

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('action creator navigation button')));
      await tester.pumpAndSettle();

      ActionEditorState editorState =
          tester.state(find.byKey(actionCreatorKey));

      editorState.action = ActionData(
          'Infoveranstaltung',
          TimeOfDay.fromDateTime(today),
          TimeOfDay.fromDateTime(today.add(Duration(hours: 2))),
          tempVorstadt(),
          [today],
          'test1',
          'test2',
          'test3',
          LatLng(52.49653, 13.43762));

      when(_termineService.createAction(any, any)).thenAnswer((_) async =>
          Termin(
              1337,
              today,
              today.add(Duration(hours: 2)),
              tempVorstadt(),
              'Infoveranstaltung',
              52.52116,
              13.41331,
              [],
              TerminDetails(
                  editorState.action.treffpunkt!,
                  editorState.action.beschreibung!,
                  editorState.action.kontakt!)));

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action card')), findsNWidgets(4));

      expect(find.text('Infoveranstaltung'), findsOneWidget);

      expect(
          find.descendant(
              of: find.byKey(Key('action card')).at(1),
              matching: find.text('Infoveranstaltung')),
          findsWidgets);
    });

    testWidgets('uses created action from server with id',
        (WidgetTester tester) async {
      var today = DateTime.now();
      var yesterday = today.subtract(Duration(days: 1));
      var tomorrow = today.add(Duration(days: 1));
      var dayAfterTomorrow = today.add(Duration(days: 2));

      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(yesterday),
            TerminTestDaten.anActionFrom(tomorrow),
            TerminTestDaten.anActionFrom(dayAfterTomorrow),
          ]);

      await _pumpNavigation(tester);
      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action card')), findsNWidgets(3));

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('action creator navigation button')));
      await tester.pumpAndSettle();

      ActionEditorState editorState =
          tester.state(find.byKey(actionCreatorKey));

      editorState.action = ActionData(
          'Sammeln',
          TimeOfDay.fromDateTime(today),
          TimeOfDay.fromDateTime(today.add(Duration(hours: 2))),
          tempVorstadt(),
          [today],
          'test1',
          'test2',
          'test3',
          LatLng(52.49653, 13.43762));

      when(_termineService.createAction(any, any)).thenAnswer(
        (_) async => Termin(
            1337,
            today,
            today.add(Duration(hours: 2)),
            tempVorstadt(),
            'Infoveranstaltung',
            52.52116,
            13.41331,
            [],
            TerminDetails(editorState.action.treffpunkt!,
                editorState.action.beschreibung!, editorState.action.kontakt!)),
      );

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      TerminCard newCard = tester.widget(find.ancestor(
          of: find.text('Infoveranstaltung'),
          matching: find.byKey(Key('action card'))));

      expect(newCard.termin.id, 1337);
    });

    testWidgets('new actions are saved to server', (WidgetTester tester) async {
      reset(_termineService);

      var today = DateTime.now();
      var yesterday = today.subtract(Duration(days: 1));
      var tomorrow = today.subtract(Duration(days: 1));
      var dayAfterTomorrow = today.add(Duration(days: 2));

      when(_termineService.createAction(any, any)).thenAnswer(
          (_) async => TerminTestDaten.einTerminMitTeilisUndDetails());

      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(yesterday),
            TerminTestDaten.anActionFrom(tomorrow),
            TerminTestDaten.anActionFrom(dayAfterTomorrow),
          ]);

      await _pumpNavigation(tester);
      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action card')), findsNWidgets(3));

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('action creator navigation button')));
      await tester.pumpAndSettle();

      ActionEditorState editorState =
          tester.state(find.byKey(actionCreatorKey));

      editorState.action = ActionData(
          'Infoveranstaltung',
          TimeOfDay.fromDateTime(today),
          TimeOfDay.fromDateTime(today.add(Duration(hours: 2))),
          tempVorstadt(),
          [today],
          'test1',
          'test2',
          'test3',
          LatLng(52.49653, 13.43762));

      when(_termineService.createAction(any, any)).thenAnswer((_) async =>
          Termin(
              1337,
              today,
              today.add(Duration(hours: 2)),
              tempVorstadt(),
              'Infoveranstaltung',
              52.52116,
              13.41331,
              [],
              TerminDetails(
                  editorState.action.treffpunkt!,
                  editorState.action.beschreibung!,
                  editorState.action.kontakt!)));

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      verify(_termineService.createAction(any, any)).called(1);
    });

    testWidgets('shows alert popup on RestFehler from create request',
        (WidgetTester tester) async {
      var today = DateTime.now();
      var yesterday = today.subtract(Duration(days: 1));
      var tomorrow = today.add(Duration(days: 1));

      when(_termineService.createAction(any, any)).thenAnswer(
          (_) async => TerminTestDaten.einTerminMitTeilisUndDetails());

      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(yesterday),
            TerminTestDaten.anActionFrom(today),
            TerminTestDaten.anActionFrom(tomorrow)
              ..id = 1337
              ..typ = 'Infoveranstaltung',
          ]);

      when(_termineService.getActionWithDetails(any)).thenAnswer(
        (_) async => TerminTestDaten.einTerminMitTeilisUndDetails()
          ..id = 1337
          ..typ = 'Infoveranstaltung',
      );

      when(_storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [1337]);

      await _pumpNavigation(tester);
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('action creator navigation button')));
      await tester.pumpAndSettle();

      ActionEditorState editorState =
          tester.state(find.byKey(actionCreatorKey));

      editorState.action = ActionData(
          'Infoveranstaltung',
          TimeOfDay.fromDateTime(today),
          TimeOfDay.fromDateTime(today.add(Duration(hours: 2))),
          tempVorstadt(),
          [today],
          'test1',
          'test2',
          'test3',
          LatLng(52.49653, 13.43762));

      when(_termineService.createAction(any, any))
          .thenThrow(RestFehler('Fehlerbeschreibung.'));

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('error dialog')), findsOneWidget);
      expect(
          find.text(
              'Aktion konnte nicht erzeugt werden. Fehlerbeschreibung. \n\nWenn du Hilfe brauchst, schreib uns doch einfach per Mail an app@dwenteignen.de'),
          findsOneWidget);
    });
  });

  group('ActionEditor', () {
    setUpUI((WidgetTester tester) async {
      var myAction = TerminTestDaten.einTermin()
        ..id = 3
        ..beginn = DateTime.now().add(Duration(days: 1));

      when(_termineService.loadActions(any)).thenAnswer((_) async {
        return [
          TerminTestDaten.einTermin()
            ..id = 1
            ..beginn = DateTime.now().subtract(Duration(days: 2)),
          TerminTestDaten.einTermin()
            ..id = 2
            ..beginn = DateTime.now(),
          myAction
        ];
      });
      when(_termineService.getActionWithDetails(any)).thenAnswer(
          (_) async => TerminTestDaten.einTerminMitTeilisUndDetails());
      when(_storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [1]);

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();
    });

    testUI('closes after action edit', (WidgetTester tester) async {
      when(_storageService.loadActionToken(any))
          .thenAnswer((_) async => '1234');

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      await tester.tap(find.byKey(Key('action details menu button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('action details edit menu item')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action editor')), findsOneWidget);

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action editor')), findsNothing);
    });

    testUI('re-sorts edited actions into action list',
        (WidgetTester tester) async {
      TermineSeiteState termineSeite =
          tester.state(find.byKey(Key('action page')));

      expect(termineSeite.termine.map((action) => action.id),
          containsAllInOrder([1, 2, 3]));

      termineSeite.saveAction(TerminTestDaten.einTermin()
        ..id = 3
        ..beginn = DateTime.now().subtract(Duration(days: 1)));
      await tester.pump();

      expect(termineSeite.termine.map((action) => action.id),
          containsAllInOrder([1, 3, 2]));
    });

    testUI('shows alert popup on AuthFehler from save request',
        (WidgetTester tester) async {
      TermineSeiteState termineSeite =
          tester.state(find.byKey(Key('action page')));

      when(_termineService.saveAction(any, any))
          .thenThrow(AuthFehler('message'));

      termineSeite
          .saveAction(TerminTestDaten.einTermin()..typ = 'Infoveranstaltung');

      expect(
          find.byKey(Key('edit authentication failed dialog')), findsNothing);
      expect(termineSeite.termine[0].typ, 'Sammeln');
    });

    testUI('shows alert popup on RestFehler from save request',
        (WidgetTester tester) async {
      TermineSeiteState termineSeite =
          tester.state(find.byKey(Key('action page')));

      when(_termineService.saveAction(any, any))
          .thenThrow(RestFehler('message'));

      termineSeite
          .saveAction(TerminTestDaten.einTermin()..typ = 'Infoveranstaltung');

      expect(find.byKey(Key('edit request failed dialog')), findsNothing);
      expect(termineSeite.termine[0].typ, 'Sammeln');
    });
  });

  group('now-line', () {
    testWidgets('lies between past and future actions',
        (WidgetTester tester) async {
      DateTime today = DateTime.now();
      DateTime twoDaysAgo = today.subtract(Duration(days: 2));
      DateTime yesterday = today.subtract(Duration(days: 1));
      DateTime tomorrow = today.add(Duration(days: 1));

      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(yesterday),
            TerminTestDaten.anActionFrom(tomorrow),
            TerminTestDaten.anActionFrom(twoDaysAgo),
          ]);

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      var list = find.byType(ScrollablePositionedList);

      List<String?> keys = tester
          .widgetList(find.descendant(of: list, matching: find.byType(Text)))
          .map((widget) => (widget as Text).data)
          .where((key) => key == 'Sammeln' || key == 'Jetzt')
          .toList();

      expect(
          keys,
          containsAll([
            'Sammeln',
            'Sammeln',
            'Jetzt',
            'Sammeln',
          ]));
    });

    testWidgets('hides if no past actions present',
        (WidgetTester tester) async {
      DateTime today = DateTime.now();
      DateTime nextHour = today.add(Duration(hours: 1));
      DateTime nextDay = today.add(Duration(days: 1));
      DateTime nextWeek = today.add(Duration(days: 7));

      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(nextDay),
            TerminTestDaten.anActionFrom(nextHour),
            TerminTestDaten.anActionFrom(nextWeek),
          ]);

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action card')), findsNWidgets(3));

      expect(find.byKey(Key('action list now line')), findsNothing);
    });

    testWidgets('is at end if no future actions present',
        (WidgetTester tester) async {
      DateTime today = DateTime.now();
      DateTime threeHoursAgo = today.subtract(Duration(hours: 3));
      DateTime lastDay = today.subtract(Duration(days: 1));
      DateTime lastWeek = today.subtract(Duration(days: 7));

      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(lastDay),
            TerminTestDaten.anActionFrom(threeHoursAgo),
            TerminTestDaten.anActionFrom(lastWeek),
          ]);

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      var list = find.byType(ScrollablePositionedList);

      List<String?> keys = tester
          .widgetList(find.descendant(of: list, matching: find.byType(Text)))
          .map((widget) => (widget as Text).data)
          .where((key) => key == 'Sammeln' || key == 'Jetzt')
          .toList();

      expect(
          keys,
          containsAll([
            'Sammeln',
            'Sammeln',
            'Sammeln',
            'Jetzt',
          ]));
    });

    testWidgets('hides if no actions are present', (WidgetTester tester) async {
      when(_termineService.loadActions(any)).thenAnswer((_) async => []);

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action list now line')), findsNothing);
    });

    testWidgets(
        'lies behind actions that started in the past but end in the future',
        (WidgetTester tester) async {
      DateTime today = DateTime.now();
      DateTime oneMinuteAgo = today.subtract(Duration(minutes: 1));
      DateTime twentyMinutesAgo = today.subtract(Duration(minutes: 20));
      DateTime inTwentyMinutes = today.add(Duration(minutes: 20));

      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.anActionFrom(inTwentyMinutes),
            TerminTestDaten.anActionFrom(twentyMinutesAgo),
            TerminTestDaten.anActionFrom(oneMinuteAgo),
          ]);

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      var list = find.byType(ScrollablePositionedList);

      List<String?> keys = tester
          .widgetList(find.descendant(of: list, matching: find.byType(Text)))
          .map((widget) => (widget as Text).data)
          .where((key) => key == 'Sammeln' || key == 'Jetzt')
          .toList();

      expect(
          keys,
          containsAll([
            'Sammeln',
            'Sammeln',
            'Jetzt',
            'Sammeln',
          ]));
    });
  });

  group('delete button', () {
    testWidgets('opens confirmation dialog', (WidgetTester tester) async {
      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
          ]);
      when(_termineService.getActionWithDetails(any)).thenAnswer(
          (_) async => TerminTestDaten.einTerminMitTeilisUndDetails());

      when(_storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [0]);

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      await tester.tap(find.byKey(Key('action details menu button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('action details delete menu item')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('deletion confirmation dialog')), findsOneWidget);
    });

    testWidgets('closes confirmation dialog on tap at No button',
        (WidgetTester tester) async {
      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
          ]);
      when(_termineService.getActionWithDetails(any)).thenAnswer(
          (_) async => TerminTestDaten.einTerminMitTeilisUndDetails());
      when(_storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [0]);

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      await tester.tap(find.byKey(Key('action details menu button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('action details delete menu item')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('delete confirmation no button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('deletion confirmation dialog')), findsNothing);
    });

    testWidgets('does not trigger deletion on tap at No button',
        (WidgetTester tester) async {
      when(_termineService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
          ]);
      when(_termineService.getActionWithDetails(any)).thenAnswer(
          (_) async => TerminTestDaten.einTerminMitTeilisUndDetails());

      when(_storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [0]);

      await tester.pumpWidget(termineSeiteWidget);

      // Warten bis asynchron Termine geladen wurden
      await tester.pumpAndSettle();

      expect(find.byKey(Key('action card')), findsOneWidget);

      await tester.tap(find.byKey(Key('action card')).first);
      await tester.pump();

      expect(find.byKey(Key('action details page')), findsOneWidget);

      await tester.tap(find.byKey(Key('action details menu button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('action details delete menu item')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('deletion confirmation dialog')), findsOneWidget);

      await tester.tap(find.byKey(Key('delete confirmation no button')));
      await tester.pump();

      expect(find.byKey(Key('action details page')), findsOneWidget);
      verifyNever(_termineService.deleteAction(any, any));
      expect(find.byKey(Key('action card')), findsOneWidget);
    });

    group('on confirmed', () {
      var myAction;

      setUp(() {
        DateTime today = DateTime.now();
        DateTime yesterday = today.subtract(Duration(days: 1));
        DateTime tomorrow = today.add(Duration(days: 1));

        when(_termineService.loadActions(any)).thenAnswer((_) async => [
              TerminTestDaten.einTermin()
                ..id = 1
                ..beginn = yesterday,
              TerminTestDaten.einTermin()
                ..id = 2
                ..beginn = today
                ..typ = 'Infoveranstaltung',
              TerminTestDaten.einTermin()
                ..id = 3
                ..beginn = tomorrow,
            ]);

        // mittlere Aktion um sicherzustellen, dass nicht einfach immer die erste oder letzte Aktion gel??scht wird
        myAction = TerminTestDaten.einTerminMitTeilisUndDetails()..id = 2;
        when(_termineService.getActionWithDetails(any))
            .thenAnswer((_) async => myAction);

        clearInteractions(_storageService);
        when(_storageService.loadAllStoredActionIds())
            .thenAnswer((_) async => [2]);
      });

      testWidgets('deletes action in backend', (WidgetTester tester) async {
        when(_storageService.loadActionToken(any))
            .thenAnswer((_) async => '1234');

        await tester.pumpWidget(termineSeiteWidget);

        // Warten bis asynchron Termine geladen wurden
        await tester.pumpAndSettle();

        await tester.tap(find.text('Infoveranstaltung'));
        await tester.pump();

        await tester.tap(find.byKey(Key('action details menu button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key('action details delete menu item')));
        await tester.pumpAndSettle();

        expect(find.byKey(Key('deletion confirmation dialog')), findsOneWidget);

        await tester.tap(find.byKey(Key('delete confirmation yes button')));
        await tester.pump();

        verify(_termineService.deleteAction(myAction, any)).called(1);
      });

      testWidgets('deletes action in action list', (WidgetTester tester) async {
        await tester.pumpWidget(termineSeiteWidget);

        // Warten bis asynchron Termine geladen wurden
        await tester.pumpAndSettle();

        // mittleren Dialog um sicherzustellen, dass nicht einfach immer die erste Aktion gel??scht wird
        await tester.tap(find.byKey(Key('action card')).at(1));
        await tester.pump();

        await tester.tap(find.byKey(Key('action details menu button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key('action details delete menu item')));
        await tester.pumpAndSettle();

        expect(find.byKey(Key('deletion confirmation dialog')), findsOneWidget);

        await tester.tap(find.byKey(Key('delete confirmation yes button')));
        await tester.pump();

        expect(find.byKey(Key('action card')), findsNWidgets(2));
        expect(find.text('Infoveranstaltung'), findsNothing);
      });

      testWidgets('deletes action id storage', (WidgetTester tester) async {
        await tester.pumpWidget(termineSeiteWidget);

        // Warten bis asynchron Termine geladen wurden
        await tester.pumpAndSettle();

        // mittleren Dialog um sicherzustellen, dass nicht einfach immer die erste Aktion gel??scht wird
        await tester.tap(find.byKey(Key('action card')).at(1));
        await tester.pump();

        await tester.tap(find.byKey(Key('action details menu button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key('action details delete menu item')));
        await tester.pumpAndSettle();

        expect(find.byKey(Key('deletion confirmation dialog')), findsOneWidget);

        await tester.tap(find.byKey(Key('delete confirmation yes button')));
        await tester.pump();

        verify(_storageService.deleteActionToken(2)).called(1);
      });

      testWidgets('closes confirmation dialog and action details',
          (WidgetTester tester) async {
        await tester.pumpWidget(termineSeiteWidget);

        // Warten bis asynchron Termine geladen wurden
        await tester.pumpAndSettle();

        // mittleren Dialog um sicherzustellen, dass nicht einfach immer die erste Aktion gel??scht wird
        await tester.tap(find.byKey(Key('action card')).at(1));
        await tester.pump();

        await tester.tap(find.byKey(Key('action details menu button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key('action details delete menu item')));
        await tester.pumpAndSettle();

        expect(find.byKey(Key('deletion confirmation dialog')), findsOneWidget);

        await tester.tap(find.byKey(Key('delete confirmation yes button')));
        await tester.pumpAndSettle();

        expect(find.byKey(Key('deletion confirmation dialog')), findsNothing);
        expect(find.byKey(Key('action details page')), findsNothing);
      });

      testWidgets('shows alert popup on RestFehler',
          (WidgetTester tester) async {
        await tester.pumpWidget(termineSeiteWidget);

        // Warten bis asynchron Termine geladen wurden
        await tester.pumpAndSettle();

        // mittleren Dialog um sicherzustellen, dass nicht einfach immer die erste Aktion gel??scht wird
        await tester.tap(find.byKey(Key('action card')).at(1));
        await tester.pump();

        await tester.tap(find.byKey(Key('action details menu button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key('action details delete menu item')));
        await tester.pumpAndSettle();

        when(_termineService.deleteAction(any, any))
            .thenThrow(RestFehler('message'));

        await tester.tap(find.byKey(Key('delete confirmation yes button')));
        await tester.pumpAndSettle(Duration(seconds: 10));

        expect(find.byKey(Key('error dialog')), findsOneWidget);
        expect(
            find.text(
                'Aktion konnte nicht gel??scht werden. message \n\nWenn du Hilfe brauchst, schreib uns doch einfach per Mail an app@dwenteignen.de'),
            findsOneWidget);
      });

      testWidgets('shows alert popup on AuthFehler',
          (WidgetTester tester) async {
        await tester.pumpWidget(termineSeiteWidget);

        // Warten bis asynchron Termine geladen wurden
        await tester.pumpAndSettle();

        // mittleren Dialog um sicherzustellen, dass nicht einfach immer die erste Aktion gel??scht wird
        await tester.tap(find.byKey(Key('action card')).at(1));
        await tester.pump();

        await tester.tap(find.byKey(Key('action details menu button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key('action details delete menu item')));
        await tester.pumpAndSettle();

        when(_termineService.deleteAction(any, any))
            .thenThrow(AuthFehler('message'));

        await tester.tap(find.byKey(Key('delete confirmation yes button')));
        await tester.pump();

        expect(find.byKey(Key('error dialog')), findsOneWidget);
        expect(
            find.text(
                'Aktion konnte nicht gel??scht werden. message \n\nWenn du Hilfe brauchst, schreib uns doch einfach per Mail an app@dwenteignen.de'),
            findsOneWidget);
      });
    });
  });

  group('action token', () {
    late TermineSeiteState actionPageState;
    setUp(() {
      actionPageState = TermineSeiteState();
      actionPageState.storageService = _storageService;
      actionPageState.termineService = _termineService;
    });

    test('is uniquely generated at action creation and sent to server', () {
      when(_termineService.createAction(any, any)).thenAnswer(
          (_) async => TerminTestDaten.einTerminMitTeilisUndDetails());

      actionPageState.createNewAction(TerminTestDaten.einTermin());
      actionPageState.createNewAction(TerminTestDaten.einTermin());

      List<dynamic> uuids =
          verify(_termineService.createAction(any, captureAny)).captured;

      expect(uuids[0], isNotEmpty);
      expect(uuids[1], isNotEmpty);
      expect(uuids[0], isNot(uuids[1]));
    });

    testWidgets('is passed to server when action is edited',
        (WidgetTester tester) async {
      Termin action1 = TerminTestDaten.einTermin()..id = 1;
      Termin action2 = TerminTestDaten.einTermin()..id = 2;
      when(_termineService.loadActions(any))
          .thenAnswer((_) async => [action1, action2]);

      await tester.pumpWidget(termineSeiteWidget);
      actionPageState = tester.state(find.byKey(Key('action page')));

      when(_storageService.loadActionToken(1))
          .thenAnswer((_) async => 'storedToken1');
      when(_storageService.loadActionToken(2))
          .thenAnswer((_) async => 'storedToken2');
      when(_termineService.saveAction(any, any)).thenAnswer((_) async => null);

      await actionPageState.saveAction(action1);
      await actionPageState.saveAction(action2);

      verify(_termineService.saveAction(action1, 'storedToken1')).called(1);
      verify(_termineService.saveAction(action2, 'storedToken2')).called(1);
    });

    testWidgets('is passed to server when action is deleted',
        (WidgetTester tester) async {
      Termin action1 = TerminTestDaten.einTermin()..id = 1;
      Termin action2 = TerminTestDaten.einTermin()..id = 2;
      when(_termineService.loadActions(any))
          .thenAnswer((_) async => [action1, action2]);

      await tester.pumpWidget(termineSeiteWidget);
      actionPageState = tester.state(find.byKey(Key('action page')));

      when(_storageService.loadActionToken(1))
          .thenAnswer((_) async => 'storedToken1');
      when(_storageService.loadActionToken(2))
          .thenAnswer((_) async => 'storedToken2');

      await actionPageState.deleteAction(action1);
      await actionPageState.deleteAction(action2);

      verify(_termineService.deleteAction(action1, 'storedToken1')).called(1);
      verify(_termineService.deleteAction(action2, 'storedToken2')).called(1);
    });
  });

  group('updateAction', () {
    var actionPageState = TermineSeiteState();
    setUp(() {
      actionPageState.termine = [
        TerminTestDaten.einTermin()..id = 1,
        TerminTestDaten.einTermin()..id = 2,
        TerminTestDaten.einTermin()..id = 3,
      ];
      actionPageState.myActions = [2, 3];
    });

    test('removes action w/ remove flag', () {
      actionPageState.updateAction(TerminTestDaten.einTermin()..id = 2, true);
      expect(actionPageState.termine.map((action) => action.id),
          containsAll([1, 3]));
    });

    test('removes action from myAction list w/ remove flag', () {
      actionPageState.updateAction(TerminTestDaten.einTermin()..id = 2, true);
      expect(actionPageState.myActions, containsAll([3]));
    });

    test('only updates action w/o remove flag', () {
      var newAction = TerminTestDaten.einTermin()
        ..id = 2
        ..ort = tempVorstadt();

      actionPageState.updateAction(newAction, false);

      expect(actionPageState.termine.map((action) => action.id),
          containsAll([1, 2, 3]));
      expect(
          actionPageState.termine
              .where((action) => action.id == 2)
              .toList()[0]
              .ort
              .name,
          tempVorstadt().name);
    });

    test('sorts new list by date', () {
      var newAction = TerminTestDaten.einTermin()
        ..id = 2
        ..beginn = DateTime.now().subtract(Duration(days: 1));
      actionPageState.updateAction(newAction, false);
      expect(actionPageState.termine.map((action) => action.id),
          containsAll([3, 1, 2]));
    });

    test('does nothing with unknown actions', () {
      actionPageState.updateAction(TerminTestDaten.einTermin()..id = 4, true);
      expect(actionPageState.termine.map((action) => action.id),
          containsAll([1, 2, 3]));
      expect(actionPageState.myActions, containsAll([2, 3]));
    });
  });

  group('createAndAddAction', () {
    late TermineSeiteState state;
    setUpUI((tester) async {
      await tester.pumpWidget(termineSeiteWidget);

      state = tester.state(find.byType(TermineSeite));
      state.termine = [
        TerminTestDaten.einTermin()..id = 1,
        TerminTestDaten.einTermin()..id = 2,
        TerminTestDaten.einTermin()..id = 3,
      ];
    });

    testUI('adds new action to list', (tester) async {
      var initialAction = TerminTestDaten.einTermin();
      var savedAction = TerminTestDaten.einTermin()..id = 4;
      when(_termineService.createAction(initialAction, any))
          .thenAnswer((_) async => savedAction);

      state.createAndAddAction(initialAction);
      await tester.pumpAndSettle();

      expect(
          state.termine.map((action) => action.id), containsAll([1, 2, 3, 4]));
    });

    testUI('sorts list', (tester) async {
      var initialAction = TerminTestDaten.einTermin()
        ..beginn = DateTime.now().subtract(Duration(days: 1));
      var savedAction = TerminTestDaten.einTermin()
        ..id = 4
        ..beginn = DateTime.now().subtract(Duration(days: 1));
      when(_termineService.createAction(initialAction, any))
          .thenAnswer((_) async => savedAction);

      state.createAndAddAction(initialAction);
      await tester.pumpAndSettle();

      expect(
          state.termine.map((action) => action.id), containsAll([4, 1, 2, 3]));
    });

    testUI('marks action as own', (tester) async {
      var initialAction = TerminTestDaten.einTermin();
      var savedAction = TerminTestDaten.einTermin()..id = 4;
      when(_termineService.createAction(initialAction, any))
          .thenAnswer((_) async => savedAction);

      state.createAndAddAction(initialAction);
      await tester.pumpAndSettle();

      expect(state.myActions, containsAll([4]));
    });
  });

  group('navgation button', () {
    testWidgets('for list view is active on start',
        (WidgetTester tester) async {
      when(_termineService.loadActions(any))
          .thenAnswer((_) async => [(TerminTestDaten.einTermin())]);

      await tester.pumpWidget(termineSeiteWidget);

      TermineSeiteState state = tester.state(find.byKey(Key('action page')));
      expect(state.navigation, 0);
    });

    testWidgets('for map view switches to map view',
        (WidgetTester tester) async {
      when(_termineService.loadActions(any))
          .thenAnswer((_) async => [(TerminTestDaten.einTermin())]);

      await tester.pumpWidget(termineSeiteWidget);

      await tester.tap(find.byKey(Key('map view navigation button')));
      await tester.pumpAndSettle();

      TermineSeiteState state = tester.state(find.byKey(Key('action page')));
      expect(state.navigation, 1);
    });
  });

  group('unilink processing', () {
    testUI('shows action on start', (tester) async {
      await tester.pumpWidget(termineSeiteWidget);

      TermineSeiteState state = tester.state(find.byKey(Key('action page')));
      await state.showAction(Uri(
          scheme: 'https',
          host: 'dwenteignen.de',
          queryParameters: {"aktion": "4"}));

      print('### Vorbei 3!');
      verify(_termineService.loadAndShowAction(4)).called(1);
    });

    testUI('ignores path without action parameter', (tester) async {
      await tester.pumpWidget(termineSeiteWidget);

      TermineSeiteState state = tester.state(find.byKey(Key('action page')));
      await state.showAction(Uri(scheme: 'https', host: 'dwenteignen.de'));

      verifyNever(_termineService.loadAndShowAction(any));
    });

    testUI('ignores path with invalid action parameter', (tester) async {
      await tester.pumpWidget(termineSeiteWidget);

      TermineSeiteState state = tester.state(find.byKey(Key('action page')));
      await state.showAction(Uri(
          scheme: 'https',
          host: 'dwenteignen.de',
          queryParameters: {"aktion": "vier"}));

      verifyNever(_termineService.loadAndShowAction(any));
    });

    testUI('shows action while running', (tester) async {
      var controller = StreamController<Uri?>();
      await tester.pumpWidget(termineSeiteWidget);

      TermineSeiteState state = tester.state(find.byKey(Key('action page')));
      state.registerUriListener(controller.stream);
      controller.add(Uri(
          scheme: 'https',
          host: 'dwenteignen.de',
          queryParameters: {"aktion": "4"}));

      await tester.pumpAndSettle();

      verify(_termineService.loadAndShowAction(4)).called(1);
    });
  });

  group('placard delete dialog', () {
    setUpUI((tester) async {
      when(_placardsService.loadPlacards())
          .thenAnswer((_) async => Future.value([placard1()]));

      await tester.pumpWidget(termineSeiteWidget);

      await tester.tap(find.byKey(Key('map view navigation button')));
      await tester.pump();

      ActionMap map = tester.widget<ActionMap>(find.byKey(Key('action map')));
      map.mapController
          .move(LatLng(placard1().latitude, placard1().longitude), 15);
      await tester.pumpAndSettle();
    });

    testUI('opens placard dialog on tap at placard', (tester) async {
      await tester.tap(find.byKey(Key('placard marker')));
      await tester.pump();

      expect(find.byKey(Key('delete placard dialog')), findsOneWidget);
    });

    testUI('closes placard dialog on abort and does not delete placard',
        (tester) async {
      await tester.tap(find.byKey(Key('placard marker')));
      await tester.pump();

      expect(find.byKey(Key('delete placard dialog')), findsOneWidget);

      await tester.tap(find.byKey(Key('delete placard dialog abort button')));
      await tester.pump();

      verifyNever(_placardsService.deletePlacard(any));
      expect(find.byKey(Key('placard marker')), findsOneWidget);
    });

    testUI('closes placard dialog on confirm and deletes placard',
        (tester) async {
      when(_placardsService.deletePlacard(any))
          .thenAnswer((_) => Future.value());

      await tester.tap(find.byKey(Key('placard marker')));
      await tester.pump();

      expect(find.byKey(Key('delete placard dialog')), findsOneWidget);

      await tester.tap(find.byKey(Key('delete placard dialog confirm button')));
      await tester.pump();

      verify(_placardsService.deletePlacard(1)).called(1);
      expect(find.byKey(Key('placard marker')), findsNothing);
    });
  });

  group('mapAction dialog', () {
    setUpUI((tester) async {
      await tester.pumpWidget(termineSeiteWidget);

      await tester.tap(find.byKey(Key('map view navigation button')));
      await tester.pumpAndSettle();

      ActionMap map = tester.widget<ActionMap>(find.byKey(Key('action map')));
      map.mapController
          .move(LatLng(placard1().latitude, placard1().longitude), 15);
      await tester.pump();

      await tester.longPress(find.byKey(Key('action map map')));
      await tester.pump();
    });

    testUI('opens mapAction dialog on long press at map', (tester) async {
      expect(find.byKey(Key('map action dialog')), findsOneWidget);
    });

    testUI('closes mapAction dialog on abort and does nothing', (tester) async {
      await tester.tap(find.byKey(Key('map action dialog abort button')));
      await tester.pump();

      verifyNever(_placardsService.createPlacard(any));
      expect(switchParameter, isNull);
    });

    testUI('closes mapAction dialog and switches to Action Creator',
        (tester) async {
      await tester.tap(find.byKey(Key('map action dialog action button')));
      await tester.pump();

      verifyNever(_placardsService.createPlacard(any));
      expect(switchParameter?.latitude.floor(), 52);
      expect(switchParameter?.longitude.floor(), 13);
    });

    testUI('closes mapAction dialog and creates placard with geo data',
        (tester) async {
      when(_placardsService.createPlacard(any))
          .thenAnswer((_) => Future.value(placard1()));
      when(_geoService.getDescriptionToPoint(any)).thenAnswer((_) =>
          Future.value(
              GeoData('Nightmare', 'Elm Street', '12', '12345', 'Berlin')));
      await tester.tap(find.byKey(Key('map action dialog placard button')));
      await tester.pumpAndSettle();

      verify(_geoService.getDescriptionToPoint(any)).called(1);
      Placard placard =
          verify(_placardsService.createPlacard(captureAny)).captured.single;
      expect(placard.id, isNull);
      expect(placard.latitude.floor(), 52);
      expect(placard.longitude.floor(), 13);
      expect(placard.adresse, 'Elm Street 12, 12345 Berlin');
      expect(placard.benutzer, 11);
      expect(find.byKey(Key('placard marker')), findsOneWidget);
    });

    testUI('creates no placard with missing user',
        (tester) async {
      when(_placardsService.createPlacard(any))
          .thenAnswer((_) => Future.value(placard1()));
      when(_geoService.getDescriptionToPoint(any)).thenAnswer((_) =>
          Future.value(
              GeoData('Nightmare', 'Elm Street', '12', '12345', 'Berlin')));

      (tester.state(find.byType(TermineSeite)) as TermineSeiteState).me = null;

      await tester.tap(find.byKey(Key('map action dialog placard button')));
      await tester.pumpAndSettle();

      verifyNever(_geoService.getDescriptionToPoint(any));
      verifyNever(_placardsService.createPlacard(any));
      expect(find.byKey(Key('placard marker')), findsNothing);
    });
  });
}

_pumpNavigation(WidgetTester tester) async {
  await tester.pumpWidget(MultiProvider(
      providers: [
        Provider<StammdatenService>.value(value: _stammdatenService),
        Provider<AbstractTermineService>.value(value: _termineService),
        Provider<StorageService>.value(value: _storageService),
        Provider<AbstractListLocationService>(
            create: (context) => _listLocationService),
        Provider<PushSendService>.value(value: _pushService),
        Provider<AbstractUserService>.value(value: _userService),
        Provider<AbstractPushSendService>.value(value: _pushService),
        Provider<ChatMessageService>.value(value: _chatMessageService),
        Provider<AbstractPushNotificationManager>.value(value: _pushManager),
        Provider<AbstractPlacardsService>.value(value: _placardsService),
        Provider<AbstractPlacardsService>.value(value: _placardsService),
      ],
      child: MaterialApp(
        home:
            Navigation(GlobalKey(debugLabel: 'action page'), actionCreatorKey),
      )));
  await tester.pumpAndSettle();
}
