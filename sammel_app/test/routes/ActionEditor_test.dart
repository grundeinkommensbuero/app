import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/services/ChatMessageService.dart';

import '../model/Termin_test.dart';
import '../shared/Mocks.dart';
import '../shared/TestdatenVorrat.dart';

final _stammdatenService = StammdatenServiceMock();
final _terminService = TermineServiceMock();
final _listLocationService = ListLocationServiceMock();
final _storageService = StorageServiceMock();
final _pushService = PushSendServiceMock();
final _userService = ConfiguredUserServiceMock();
final _chatService = ChatMessageServiceMock();
final _pushManager = PushNotificationManagerMock();

void main() {
  setUp(() {
    Localization.load(Locale('en'), translations: TranslationsMock());
    reset(_storageService);
    reset(_listLocationService);
    reset(_terminService);
    reset(_pushManager);
    reset(_chatService);
    when(_storageService.loadFilter()).thenAnswer((_) async => null);
    when(_storageService.loadAllStoredActionIds()).thenAnswer((_) async => []);
    when(_storageService.loadMyKiez()).thenAnswer((_) async => []);
    when(_storageService.loadNotificationInterval())
        .thenAnswer((_) async => 'nie');
    when(_storageService.loadContact()).thenAnswer((_) => Future.value());
    when(_listLocationService.getActiveListLocations())
        .thenAnswer((_) async => []);
    when(_terminService.loadActions(any)).thenAnswer((_) async => []);
    when(_pushManager.pushToken).thenAnswer((_) async => 'Token');
    when(_chatService.getTopicChannel('global'))
        .thenAnswer((_) async => ChatChannel('channel:global'));
    when(_storageService.loadAllStoredEvaluations())
        .thenAnswer((_) async => []);
  });

  testWidgets('Navigation opens CreateTerminDialog',
      (WidgetTester tester) async {
    await (WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
          providers: [
            Provider<StammdatenService>.value(value: _stammdatenService),
            Provider<AbstractTermineService>.value(value: _terminService),
            Provider<StorageService>.value(value: _storageService),
            Provider<AbstractListLocationService>(
                create: (context) => _listLocationService),
            Provider<AbstractPushSendService>.value(value: _pushService),
            Provider<AbstractUserService>.value(value: _userService),
            Provider<ChatMessageService>.value(value: _chatService),
            Provider<AbstractPushNotificationManager>.value(
                value: _pushManager),
            Provider<ChatMessageService>.value(value: _chatService),
          ],
          child: MaterialApp(
            home: Navigation(GlobalKey(debugLabel: 'action page')),
          )));
    }(tester);

    var nav = tester.state<NavigationState>(find.byKey(Key('navigation')));

    expect(nav.navigation, isNot(1));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('action creator navigation button')));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('action creator')), findsOneWidget);
    expect(nav.navigation, 1);
  });

  group('shows all data', () {
    setUp(() async {
      when(_terminService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
          ]);
      when(_terminService.getActionWithDetails(any)).thenAnswer(
          (_) async => TerminTestDaten.einTerminMitTeilisUndDetails());

      when(_storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [0]);
    });

    testWidgets('Type dialog opens correctly', (WidgetTester tester) async {
      await _pumpActionCreator(tester);

      expect(find.byKey(Key('type selection dialog')), findsNothing);

      await tester.tap(find.byKey(Key('open type selection dialog')));
      await tester.pump();

      expect(find.byKey(Key('type selection dialog')), findsOneWidget);
    });

    testWidgets('Type dialog shows correct typ', (WidgetTester tester) async {
      await _pumpActionCreator(tester);
      ActionEditorState actionData =
          tester.state(find.byKey(Key('action creator')));
      // ignore: invalid_use_of_protected_member
      actionData.setState(() {
        actionData.action.typ = TerminTestDaten.einTermin().typ;
        actionData.validateAllInput();
      });
      await tester.pump();
      expect(
          find.descendant(
              of: find.byType(ActionEditor), matching: find.text('Sammeln')),
          findsOneWidget);
    });

    testWidgets('Type dialog shows Sammeln as default',
        (WidgetTester tester) async {
      await _pumpActionCreator(tester);

      expect(find.byKey(Key('action creator')), findsOneWidget);
      expect(
          find.descendant(
              of: find.byKey(Key('action creator')),
              matching: find.text('Sammeln')),
          findsOneWidget);
    });

    testWidgets('Zeitraum dialog opens correctly', (WidgetTester tester) async {
      await _pumpActionCreator(tester);
      expect(find.byKey(Key('from time picker')), findsNothing);
      await tester.tap(find.byKey(Key('open time span dialog')));
      await tester.pump();
      expect(find.byKey(Key('from time picker')), findsOneWidget);
    });

    testWidgets('Zeitraum is correctly shown', (WidgetTester tester) async {
      await _pumpActionCreator(tester);
      ActionEditorState actionData =
          tester.state(find.byKey(Key('action creator')));
      expect(find.text('von 12:05 bis 13:09'), findsNothing);
      TimeOfDay von = TimeOfDay(hour: 12, minute: 5);
      TimeOfDay bis = TimeOfDay(hour: 13, minute: 9);
      // ignore: invalid_use_of_protected_member
      actionData.setState(() {
        actionData.action.von = von;
        actionData.action.bis = bis;
        actionData.validateAllInput();
      });
      await tester.pump();
      expect(find.text('von 12:05 bis 13:09'), findsOneWidget);
    });

    testWidgets('No Zeitraum is correctly shown', (WidgetTester tester) async {
      await _pumpActionCreator(tester);
      ActionEditorState actionData =
          tester.state(find.byKey(Key('action creator')));
      // ignore: invalid_use_of_protected_member
      actionData.setState(() {
        actionData.action.von = null;
        actionData.action.bis = null;
        actionData.validateAllInput();
      });
      await tester.pump();
      expect(find.text('Wähle eine Uhrzeit'), findsOneWidget);
    });

    testWidgets('Location dialog opens correctly', (WidgetTester tester) async {
      await _pumpActionCreator(tester);
      expect(find.byKey(Key('Location Picker')), findsNothing);
      await tester.tap(find.byKey(Key('Open location dialog')));
      await tester.pump();
      expect(find.byKey(Key('location dialog')), findsOneWidget);
    });

    testWidgets('location caption is correctly shown',
        (WidgetTester tester) async {
      await _pumpActionCreator(tester);
      ActionEditorState actionData =
          tester.state(find.byKey(Key('action creator')));
      expect(
          find.text('${tempVorstadt().name} in ${tempVorstadt().ortsteil}\n'
              ' Treffpunkt: ${actionData.action.terminDetails.treffpunkt}'),
          findsNothing);
      // ignore: invalid_use_of_protected_member
      actionData.setState(() {
        actionData.action.ort = tempVorstadt();
        actionData.action.terminDetails.treffpunkt = 'Hier';
        actionData.action.coordinates = LatLng(52.5170365, 13.3888599);
        actionData.validateAllInput();
      });
      await tester.pumpAndSettle();
      expect(
          find.text('${tempVorstadt().name} in ${tempVorstadt().ortsteil}\n'
              ' Treffpunkt: ${actionData.action.terminDetails.treffpunkt}'),
          findsOneWidget);
    });

    testWidgets('changing kontakt is correctly shown',
        (WidgetTester tester) async {
      await _pumpActionCreator(tester);
      ActionEditorState actionData =
          tester.state(find.byKey(Key('action creator')));
      // ignore: invalid_use_of_protected_member
      actionData.setState(() {
        actionData.action.terminDetails.kontakt = 'test1';
        actionData.validateAllInput();
      });
      await tester.pump();
      expect(find.text('test1'), findsOneWidget);
    });

    testWidgets('venue decription w/o coordinates is not displayed',
        (WidgetTester tester) async {
      await _pumpActionCreator(tester);
      ActionEditorState actionData =
          tester.state(find.byKey(Key('action creator')));
      // ignore: invalid_use_of_protected_member
      actionData.setState(() {
        actionData.action.terminDetails.treffpunkt = 'test1';
        actionData.validateAllInput();
      });
      await tester.pump();
      expect(find.text('Gib einen Treffpunkt an'), findsOneWidget);
    });

    testWidgets('changing beschreibung is correctly shown',
        (WidgetTester tester) async {
      await _pumpActionCreator(tester);
      ActionEditorState actionData =
          tester.state(find.byKey(Key('action creator')));
      // ignore: invalid_use_of_protected_member
      actionData.setState(() {
        actionData.action.terminDetails.beschreibung = 'test1';
        actionData.validateAllInput();
      });
      await tester.pump();
      expect(find.text('Beschreibung: test1'), findsOneWidget);
    });

    testWidgets('changing tage is correctly shown',
        (WidgetTester tester) async {
      await _pumpActionCreator(tester);
      ActionEditorState actionData =
          tester.state(find.byKey(Key('action creator')));
      // ignore: invalid_use_of_protected_member
      actionData.setState(() {
        actionData.action.tage = [DateTime(2019, 12, 1)];
        actionData.validateAllInput();
      });
      await tester.pump();
      expect(find.text('am 01.12.,'), findsOneWidget);
    });

    testWidgets('no tage selection is correctly shown',
        (WidgetTester tester) async {
      await _pumpActionCreator(tester);

      expect(find.text("Wähle einen Tag"), findsOneWidget);
    });

    testWidgets(
        'All widgets show the correct data in action editor of existing action',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      expect(find.text('Ruft an unter 012345678'), findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(ActionEditor), matching: find.text('Sammeln')),
          findsOneWidget);
      expect(
          find.text(
              'Frankfurter Allee Nord in Friedrichshain\n Treffpunkt: Weltzeituhr'),
          findsOneWidget);
      expect(find.text('Beschreibung: Bringe Westen und Klämmbretter mit'),
          findsOneWidget);
      expect(find.text('am 04.11.,'), findsOneWidget);
    });

    testWidgets('Cancel button closes correctly', (WidgetTester tester) async {
      await _pumpActionCreator(tester);
      await tester.tap(find.byKey(Key('action editor cancel button')));
      await tester.pumpAndSettle();
      verifyNever(_terminService.createAction(any, any));
    });

    testWidgets('Termin adds a day if bis before von',
        (WidgetTester tester) async {
      await _openActionEditor(tester);
      ActionEditorState actionData =
          tester.state(find.byKey(Key('action editor')));
      actionData.action.tage = [DateTime(2019, 12, 1)];
      actionData.action.von = TimeOfDay(hour: 10, minute: 32);
      actionData.action.bis = TimeOfDay(hour: 10, minute: 31);
      List<Termin> newTermine = await actionData.generateActions();
      expect(newTermine[0].ende.day, 2);
    });

    testWidgets('shows motivation text in ActionCreator',
        (WidgetTester tester) async {
      await _pumpActionCreator(tester);

      expect(find.byKey(Key('motivation text')), findsOneWidget);
    });

    testWidgets('shows no motivation text in ActionEditor',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      expect(find.byKey(Key('motivation text')), findsNothing);
    });
  });

  group('validates', () {
    ActionEditorState actionEditor;
    setUp(() {
      actionEditor =
          ActionEditorState(TerminTestDaten.einTerminMitTeilisUndDetails());
    });

    test('all inputs valid with correct values', () {
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['all'], ValidationState.ok);
    });

    test('von', () {
      actionEditor.action.von = null;
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['von'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);
    });

    test('bis', () {
      actionEditor.action.bis = null;
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['bis'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);
    });

    test('ort', () {
      actionEditor.action.ort = null;
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['ort'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);
    });

    test('typ', () {
      actionEditor.action.typ = null;
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['typ'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);

      actionEditor.action.typ = '';
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['typ'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);
    });

    test('venue', () {
      actionEditor.action.terminDetails.treffpunkt = null;
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['venue'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);

      actionEditor.action.terminDetails.treffpunkt = '';
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['venue'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);

      actionEditor.action.terminDetails.treffpunkt = 'treffpunkt';
      actionEditor.action.coordinates = null;
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['venue'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);
    });

    test('description', () {
      actionEditor.action.terminDetails.beschreibung = null;
      actionEditor.validateAllInput();

      expect(
          actionEditor.action.validated['beschreibung'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);

      actionEditor.action.terminDetails.beschreibung = '';
      actionEditor.validateAllInput();

      expect(
          actionEditor.action.validated['beschreibung'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);
    });

    test('contact', () {
      actionEditor.action.terminDetails.kontakt = null;
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['kontakt'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);

      actionEditor.action.terminDetails.kontakt = '';
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['kontakt'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);
    });

    testWidgets('triggers validation on Fertig button',
        (WidgetTester tester) async {
      ActionEditorState state = await _pumpActionEditor(tester);

      expect(state.action.validated['all'], ValidationState.ok);

      state.action = testActionData()..tage = null;

      when(_terminService.createAction(any, any))
          .thenAnswer((_) async => TerminTestDaten.einTermin());
      await tester.tap(find.byKey(Key('action editor finish button')));

      expect(state.action.validated['all'], ValidationState.error);
    });
  });

  group('determineMapCenter', () {
    test('returns coordinates, if given', () {
      var actionData = testActionData();

      expect(ActionEditorState.determineMapCenter(actionData),
          LatLng(52.51579, 13.45399));
    });

    test('returns null, if no coordinates given', () {
      var actionData = ActionData(null, null, null, null, null, null, null);

      expect(ActionEditorState.determineMapCenter(actionData), null);

      actionData = ActionData(null, null, null,
          Kiez('Kiez', 'Region', 'Ortsteil', []), null, null, null);

      expect(ActionEditorState.determineMapCenter(actionData), null);
    });
  });
  group('generateActions generates actions', () {
    setUp(() async {
      when(_terminService.loadActions(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
          ]);
      when(_terminService.getActionWithDetails(any)).thenAnswer(
          (_) async => TerminTestDaten.einTerminMitTeilisUndDetails());

      when(_storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [0]);
    });

    testWidgets('with old start, w/o changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = (await state.generateActions())[0];

      expect(action.beginn, TerminTestDaten.einTermin().beginn);
    });

    testWidgets('with old end, w/o changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = (await state.generateActions())[0];

      expect(action.ende, TerminTestDaten.einTermin().ende);
    });

    testWidgets('with old location, w/o changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = (await state.generateActions())[0];

      expect(action.ort.equals(TerminTestDaten.einTermin().ort), true);
    });

    testWidgets('with old type, w/o changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = (await state.generateActions())[0];

      expect(action.typ, TerminTestDaten.einTermin().typ);
    });

    testWidgets('with old id', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = (await state.generateActions())[0];

      expect(action.id, TerminTestDaten.einTermin().id);
    });

    testWidgets('with old contact, w/o changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = (await state.generateActions())[0];

      expect(action.details.kontakt,
          TerminTestDaten.einTerminMitTeilisUndDetails().details.kontakt);
    });

    testWidgets('with old description, w/o changes',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = (await state.generateActions())[0];

      expect(action.details.beschreibung,
          TerminTestDaten.einTerminMitTeilisUndDetails().details.beschreibung);
    });

    testWidgets('with old venue description, w/o changes',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = (await state.generateActions())[0];

      expect(action.details.treffpunkt,
          TerminTestDaten.einTerminMitTeilisUndDetails().details.treffpunkt);
    });

    testWidgets('with old coordinates, w/o changes',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = (await state.generateActions())[0];

      expect(action.latitude,
          TerminTestDaten.einTerminMitTeilisUndDetails().latitude);
      expect(action.longitude,
          TerminTestDaten.einTerminMitTeilisUndDetails().longitude);
    });

    testWidgets('with new start, w/ changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      var now = TimeOfDay.now();
      state.action.von = now;
      Termin action = (await state.generateActions())[0];

      expect(action.beginn, DateTime(2019, 11, 04, now.hour, now.minute));
    });

    testWidgets('with new end, w/ changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      var now = TimeOfDay(hour: 23, minute: 0);
      state.action.bis = now;
      Termin action = (await state.generateActions())[0];

      expect(action.ende, DateTime(2019, 11, 04, now.hour, now.minute));
    });

    testWidgets('with new location, w/ changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      state.action.ort = ffAlleeNord();
      Termin action = (await state.generateActions())[0];

      expect(action.ort.equals(ffAlleeNord()), true);
    });

    testWidgets('with new type, w/ changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      state.action.typ = 'Neuer Typ';
      Termin action = (await state.generateActions())[0];

      expect(action.typ, 'Neuer Typ');
    });

    testWidgets('with new contact, w/ changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      state.action.terminDetails.kontakt = 'Neuer Kontakt';
      Termin action = (await state.generateActions())[0];

      expect(action.details.kontakt, 'Neuer Kontakt');
    });

    testWidgets('with new description, w/ changes',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      state.action.terminDetails.beschreibung = 'Neue Beschreibung';
      Termin action = (await state.generateActions())[0];

      expect(action.details.beschreibung, 'Neue Beschreibung');
    });

    testWidgets('with new venue description, w/ changes',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      state.action.terminDetails.treffpunkt = 'Neuer Treffpunkt';
      Termin action = (await state.generateActions())[0];

      expect(action.details.treffpunkt, 'Neuer Treffpunkt');
    });

    testWidgets('with new coordinates, w/ changes',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      state.action.coordinates = LatLng(52.5170365, 13.3888599);
      Termin action = (await state.generateActions())[0];

      expect(action.latitude, 52.5170365);
      expect(action.longitude, 13.3888599);
    });

    testWidgets('stores user from UserService to participants list',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = (await state.generateActions())[0];

      expect(action.participants.length, 1);
      expect(action.participants[0].id, 11);
      expect(action.participants[0].name, 'Karl Marx');
      expect(action.participants[0].color.value, 4294198070);
    });
  });
  group('finish button', () {
    testWidgets('fires onFinish', (WidgetTester tester) async {
      bool fired = false;
      await _pumpActionEditor(tester, onFinish: (_) => fired = true);

      expect(fired, isFalse);

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      expect(fired, isTrue);
    });

    testWidgets('clears data', (WidgetTester tester) async {
      var state = await _pumpActionCreator(tester);
      state.action = testActionData();

      expect(state.action.von, isNotNull);
      expect(state.action.bis, isNotNull);
      expect(state.action.ort, isNotNull);
      expect(state.action.typ, isNotNull);
      expect(state.action.tage, isNotEmpty);
      expect(state.action.terminDetails.beschreibung, isNotEmpty);
      expect(state.action.terminDetails.kontakt, isNotEmpty);
      expect(state.action.terminDetails.treffpunkt, isNotEmpty);
      expect(state.action.coordinates, isNotNull);

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pump();

      expect(state.action.von, isNull);
      expect(state.action.bis, isNull);
      expect(state.action.ort, isNull);
      expect(state.action.typ, 'Sammeln');
      expect(state.action.tage, isEmpty);
      expect(state.action.terminDetails.beschreibung, isEmpty);
      expect(state.action.terminDetails.kontakt, 'Ich bin ich');
      expect(state.action.terminDetails.treffpunkt, isEmpty);
      expect(state.action.coordinates, isNull);
    });

    testWidgets('cancel clears data', (WidgetTester tester) async {
      var state = await _pumpActionCreator(tester);
      state.action = testActionData();

      expect(state.action.von, isNotNull);
      expect(state.action.bis, isNotNull);
      expect(state.action.ort, isNotNull);
      expect(state.action.typ, isNotNull);
      expect(state.action.tage, isNotEmpty);
      expect(state.action.terminDetails.beschreibung, isNotEmpty);
      expect(state.action.terminDetails.kontakt, isNotEmpty);
      expect(state.action.terminDetails.treffpunkt, isNotEmpty);
      expect(state.action.coordinates, isNotNull);

      await tester.tap(find.byKey(Key('action editor cancel button')));
      await tester.pumpAndSettle();

      expect(state.action.von, isNull);
      expect(state.action.bis, isNull);
      expect(state.action.ort, isNull);
      expect(state.action.typ, 'Sammeln');
      expect(state.action.tage, isEmpty);
      expect(state.action.terminDetails.beschreibung, isEmpty);
      expect(state.action.terminDetails.kontakt, 'Ich bin ich');
      expect(state.action.terminDetails.treffpunkt, isEmpty);
      expect(state.action.coordinates, isNull);
    });

    testWidgets('opens name dialog if no username', (tester) async {
      var userService = UserServiceMock();
      when(userService.user)
          .thenAnswer((_) => Stream.value(User(13, null, Colors.red)));
      await _pumpActionEditor(tester, userService: userService);

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('username dialog')), findsOneWidget);
    });

    testWidgets('opens name dialog not if username exists', (tester) async {
      await _pumpActionEditor(tester);

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('username dialog')), findsNothing);
    });

    testWidgets('creates action with new username', (tester) async {
      var userService = UserServiceMock();
      when(userService.user)
          .thenAnswer((_) => Stream.value(User(13, null, Colors.red)));
      var fired = false;
      await _pumpActionEditor(tester,
          onFinish: (_) => fired = true, userService: userService);

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('username dialog')), findsOneWidget);

      await tester.enterText(find.byKey(Key('user name input')), 'Karl Marx');
      await tester.pump();
      await tester.tap(find.byKey(Key('username dialog finish button')));

      await tester.pumpAndSettle();

      expect(find.byKey(Key('username dialog')), findsNothing);

      verify(userService.updateUsername('Karl Marx')).called(1);
      expect(fired, isTrue);
    });

    testWidgets(
        'cancel username does not close action creator and keeps inputs',
        (tester) async {
      var userService = UserServiceMock();
      when(userService.user)
          .thenAnswer((_) => Stream.value(User(13, null, Colors.red)));
      bool fired = false;
      await _pumpActionEditor(tester,
          onFinish: (_) => fired = true, userService: userService);

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('username dialog')), findsOneWidget);

      await tester.tap(find.byKey(Key('username dialog cancel button')));
      await tester.pumpAndSettle();

      verifyNever(userService.updateUsername('Karl Marx'));
      expect(fired, isFalse);
      expect(find.byKey(Key('username dialog')), findsNothing);
      expect(find.byKey(Key('action creator')), findsNothing);
      expect(find.text('Ruft an unter 012345678'), findsOneWidget);
    });
  });

  group('contact persistence', () {
    testWidgets('loads contact from storage with new action', (tester) async {
      when(_storageService.loadContact())
          .thenAnswer((_) async => 'Ick bin ein Berliner');
      await _pumpActionCreator(tester);

      verify(_storageService.loadContact());
      expect(find.text('Ick bin ein Berliner'), findsOneWidget);
    });

    testWidgets('loads null contact from storage with new action',
        (tester) async {
      await _pumpActionCreator(tester);

      verify(_storageService.loadContact());
      expect(find.text('Ein paar Worte über dich'), findsOneWidget);
    });

    testWidgets('loads no contact from storage with initial action',
        (tester) async {
      await _pumpActionEditor(tester);

      verifyNever(_storageService.loadContact());
      expect(find.text('Ruft an unter 012345678'), findsOneWidget);
    });

    testWidgets('keeps contact on Abbrechen with new action', (tester) async {
      await _pumpActionCreator(tester);

      await tester.tap(find.byKey(Key('action editor contact button')));
      await tester.pump();
      await tester.enterText(
          find.byKey(Key('text input dialog field')), 'Ick bin ein Berliner');
      await tester.pump();
      await tester
          .tap(find.byKey(Key('action editor text input accept button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('action editor cancel button')));
      await tester.pump();

      expect(find.text('Ick bin ein Berliner'), findsOneWidget);
    });

    testWidgets('saves contact to storage on finish with new action',
        (tester) async {
      final state = await _pumpActionCreator(tester);
      state.action = testActionData();

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pump();

      verify(_storageService.saveContact('Ich bin ich'));
    });

    testWidgets('saves contact to storage on finish with initial action',
        (tester) async {
      final state = await _pumpActionEditor(tester);
      state.action.terminDetails.kontakt = 'Ick bin ein Berliner';

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pump();

      verify(_storageService.saveContact('Ick bin ein Berliner'));
    });
  });
}

Future<ActionEditorState> _pumpActionCreator(WidgetTester tester) async {
  await tester.pumpWidget(MultiProvider(
      providers: [
        Provider<StorageService>.value(value: _storageService),
        Provider<AbstractUserService>.value(value: _userService),
      ],
      child: MaterialApp(
          home: WillPopScope(
        onWillPop: () => Future.value(false),
        child: ActionEditor(key: Key('action creator')),
      ))));
  await tester.pumpAndSettle();
  return tester.state(find.byType(ActionEditor));
}

_pumpActionPage(WidgetTester tester) async {
  await tester.pumpWidget(MultiProvider(
      providers: [
        Provider<StammdatenService>.value(value: _stammdatenService),
        Provider<AbstractTermineService>.value(value: _terminService),
        Provider<StorageService>.value(value: _storageService),
        Provider<AbstractListLocationService>(
            create: (context) => _listLocationService),
        Provider<AbstractUserService>.value(value: _userService),
        Provider<PushSendService>.value(value: _pushService),
        Provider<ChatMessageService>.value(value: _chatService),
      ],
      child: MaterialApp(
        home: TermineSeite(),
      )));
  await tester.pumpAndSettle();
}

Future _openActionEditor(WidgetTester tester) async {
  await _pumpActionPage(tester);
  // Warten bis asynchron Termine geladen wurden
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(Key('action card')).first);
  await tester.pump();
  await tester.tap(find.byKey(Key('action details menu button')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('action details edit menu item')));
  await Future.value(); // nötig für irgendein kryptisches Asynchronitätsproblem
  await tester.pumpAndSettle();
}

Future<ActionEditorState> _pumpActionEditor(WidgetTester tester,
    {Function onFinish, UserServiceMock userService}) async {
  onFinish = onFinish ?? (_) {};

  final action = TerminTestDaten.einTerminMitTeilisUndDetails();
  var actionEditor = ActionEditor(initAction: action, onFinish: onFinish);
  await tester.pumpWidget(MultiProvider(providers: [
    Provider<StorageService>.value(value: _storageService),
    Provider<AbstractUserService>.value(value: userService ?? _userService),
  ], child: MaterialApp(home: actionEditor)));

  ActionEditorState state = tester.state(find.byWidget(actionEditor));
  await tester.pumpAndSettle();
  return state;
}

ActionData testActionData() => ActionData(
    'Sammeln',
    TimeOfDay.fromDateTime(DateTime.now()),
    TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1))),
    ffAlleeNord(),
    [DateTime.now()],
    TerminDetails('Weltzeituhr', 'Es gibt Kuchen', 'Ich bin ich'),
    LatLng(52.51579, 13.45399));
