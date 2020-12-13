import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/services/ChatMessageService.dart';

import '../model/Ort_test.dart';
import '../model/Termin_test.dart';
import '../shared/Mocks.dart';

final _stammdatenService = StammdatenServiceMock();
final _terminService = TermineServiceMock();
final _listLocationService = ListLocationServiceMock();
final _storageService = StorageServiceMock();
final _pushService = PushSendServiceMock();
final _userService = ConfiguredUserServiceMock();
final _chatService = ChatMessageServiceMock();

void main() {
  setUp(() {
    when(_storageService.loadFilter()).thenAnswer((_) async => null);
    when(_storageService.loadAllStoredActionIds()).thenAnswer((_) async => []);
    when(_listLocationService.getActiveListLocations())
        .thenAnswer((_) async => []);
    when(_terminService.loadActions(any)).thenAnswer((_) async => []);
    when(_stammdatenService.ladeOrte()).thenAnswer((_) async => []);
  });

  testWidgets('TermineSeite opens CreateTerminDialog on click at menu button',
      (WidgetTester tester) async {
    await _pumpNavigation(tester);

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
      await _openActionCreator(tester);

      expect(find.byKey(Key('type selection dialog')), findsNothing);

      await tester.tap(find.byKey(Key('open type selection dialog')));
      await tester.pump();

      expect(find.byKey(Key('type selection dialog')), findsOneWidget);
    });

    testWidgets('Type dialog shows correct typ', (WidgetTester tester) async {
      await _openActionCreator(tester);
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

    testWidgets('Type dialog shows correct no typ',
        (WidgetTester tester) async {
      await _openActionCreator(tester);

      expect(find.byKey(Key('action creator')), findsOneWidget);
      expect(
          find.descendant(
              of: find.byKey(Key('action creator')),
              matching: find.text('Wähle die Art der Aktion')),
          findsOneWidget);
    });

    testWidgets('Zeitraum dialog opens correctly', (WidgetTester tester) async {
      await _openActionCreator(tester);
      expect(find.byKey(Key('from time picker')), findsNothing);
      await tester.tap(find.byKey(Key('open time span dialog')));
      await tester.pump();
      expect(find.byKey(Key('from time picker')), findsOneWidget);
    });

    testWidgets('Zeitraum is correctly shown', (WidgetTester tester) async {
      await _openActionCreator(tester);
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
      await _openActionCreator(tester);
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
      await _openActionCreator(tester);
      when(_stammdatenService.ladeOrte()).thenAnswer((_) async => [goerli()]);
      expect(find.byKey(Key('Location Picker')), findsNothing);
      await tester.tap(find.byKey(Key('Open location dialog')));
      await tester.pump();
      expect(find.byKey(Key('Location Picker')), findsOneWidget);
    });

    testWidgets('Location dialog are correctly shown',
        (WidgetTester tester) async {
      await _openActionCreator(tester);
      ActionEditorState actionData =
          tester.state(find.byKey(Key('action creator')));
      expect(find.text("in Görlitzer Park und Umgebung"), findsNothing);
      when(_stammdatenService.ladeOrte()).thenAnswer((_) async => [goerli()]);
      // ignore: invalid_use_of_protected_member
      actionData.setState(() {
        actionData.action.ort = goerli();
        actionData.validateAllInput();
      });
      await tester.pumpAndSettle();
      expect(find.text("in Görlitzer Park und Umgebung"), findsOneWidget);
    });

    testWidgets('changing kontakt is correctly shown',
        (WidgetTester tester) async {
      await _openActionCreator(tester);
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

    testWidgets('changing treffpunkt is correctly shown',
        (WidgetTester tester) async {
      await _openActionCreator(tester);
      ActionEditorState actionData =
          tester.state(find.byKey(Key('action creator')));
      // ignore: invalid_use_of_protected_member
      actionData.setState(() {
        actionData.action.terminDetails.treffpunkt = 'test1';
        actionData.action.coordinates = LatLng(52.5170365, 13.3888599);
        actionData.validateAllInput();
      });
      await tester.pump();
      expect(find.text('Treffpunkt: test1'), findsOneWidget);
    });

    testWidgets('venue decription w/o coordinates is not displayed',
        (WidgetTester tester) async {
      await _openActionCreator(tester);
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
      await _openActionCreator(tester);
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
      await _openActionCreator(tester);
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
      await _openActionCreator(tester);

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
      expect(find.text('in Friedrichshain Nordkiez'), findsOneWidget);
      expect(find.text('Beschreibung: Bringe Westen und Klämmbretter mit'),
          findsOneWidget);
      expect(find.text('am 04.11.,'), findsOneWidget);
    });

    testWidgets('Cancel button closes correctly', (WidgetTester tester) async {
      await _openActionCreator(tester);
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
      await _openActionCreator(tester);

      expect(find.byKey(Key('motivation text')), findsOneWidget);
    });

    testWidgets('shows no motivation text in ActionEditor',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      expect(find.byKey(Key('motivation text')), findsNothing);
    });
  });

  group('validates', () {
    var actionEditor;
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
      var actionEditor = ActionEditor(
          initAction: TerminTestDaten.einTerminMitTeilisUndDetails());
      await tester.pumpWidget(MaterialApp(home: actionEditor));
      ActionEditorState state = tester.state(find.byWidget(actionEditor));

      expect(state.action.validated['all'], ValidationState.ok);

      state.action = ActionData(
          TimeOfDay.now(),
          TimeOfDay.now(),
          nordkiez(),
          '',
          [DateTime.now()],
          TerminDetails('treffpunkt', 'beschreibung', 'kontakt'),
          LatLng(52.48993, 13.46839));

      when(_terminService.createAction(any, any))
          .thenAnswer((_) async => TerminTestDaten.einTermin());
      await tester.tap(find.byKey(Key('action editor finish button')));

      expect(state.action.validated['all'], ValidationState.error);
    });
  });
  group('determineMapCenter', () {
    test('returns coordinates, if given', () {
      var actionData = ActionData(
          null,
          null,
          Ort(0, 'Bezirk', 'Ort', 52.1, 43.1),
          null,
          null,
          null,
          LatLng(52.2, 43.2));

      expect(
          ActionEditorState.determineMapCenter(actionData), LatLng(52.2, 43.2));
    });

    test('returns location, if given and no coordinates', () {
      var actionData = ActionData(null, null,
          Ort(0, 'Bezirk', 'Ort', 52.1, 43.1), null, null, null, null);

      expect(
          ActionEditorState.determineMapCenter(actionData), LatLng(52.1, 43.1));
    });

    test('returns null, if neither coordinates nor location given', () {
      var actionData = ActionData(null, null, null, null, null, null, null);

      expect(ActionEditorState.determineMapCenter(actionData), null);

      actionData = ActionData(null, null, Ort(0, 'Bezirk', 'Ort', null, null),
          null, null, null, null);

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
      state.action.ort = nordkiez();
      Termin action = (await state.generateActions())[0];

      expect(action.ort.equals(nordkiez()), true);
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
    Future<ActionEditorState> pumpActionEditor(
        WidgetTester tester, UserService userServiceMock,
        {Function onFinish}) async {
      onFinish = onFinish ?? (_) {};

      var actionEditor = ActionEditor(onFinish: onFinish);
      await tester.pumpWidget(MultiProvider(providers: [
        Provider<AbstractStammdatenService>.value(value: _stammdatenService),
        Provider<AbstractUserService>.value(value: userServiceMock),
      ], child: MaterialApp(home: actionEditor)));

      ActionEditorState state = tester.state(find.byWidget(actionEditor));
      state.action = ActionData.testDaten();
      await tester.pumpAndSettle();
      return state;
    }

    Future<ActionEditorState> pumpActionEditorConfigured(WidgetTester tester,
            {Function onFinish}) async =>
        pumpActionEditor(tester, ConfiguredUserServiceMock(),
            onFinish: onFinish);

    Future<ActionEditorState> pumpActionEditorUnconfigured(
            WidgetTester tester, UserServiceMock userServiceMock,
            {Function onFinish}) async =>
        pumpActionEditor(tester, userServiceMock, onFinish: onFinish);

    testWidgets('fires onFinish', (WidgetTester tester) async {
      bool fired = false;
      await pumpActionEditorConfigured(tester, onFinish: (_) => fired = true);

      expect(fired, isFalse);

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      expect(fired, isTrue);
    });

    testWidgets('clears data', (WidgetTester tester) async {
      var state = await pumpActionEditorConfigured(tester);

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
      await tester.pumpAndSettle();

      expect(state.action.von, isNull);
      expect(state.action.bis, isNull);
      expect(state.action.ort, isNull);
      expect(state.action.typ, isNull);
      expect(state.action.tage, isEmpty);
      expect(state.action.terminDetails.beschreibung, isEmpty);
      expect(state.action.terminDetails.kontakt, isEmpty);
      expect(state.action.terminDetails.treffpunkt, isEmpty);
      expect(state.action.coordinates, isNull);
    });

    testWidgets('cancel clears data', (WidgetTester tester) async {
      var state = await pumpActionEditorConfigured(tester);

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
      expect(state.action.typ, isNull);
      expect(state.action.tage, isEmpty);
      expect(state.action.terminDetails.beschreibung, isEmpty);
      expect(state.action.terminDetails.kontakt, isEmpty);
      expect(state.action.terminDetails.treffpunkt, isEmpty);
      expect(state.action.coordinates, isNull);
    });

    testWidgets('opens name dialog if no username', (tester) async {
      var userService = UserServiceMock();
      when(userService.user)
          .thenAnswer((_) => Stream.value(User(13, null, Colors.red)));
      await pumpActionEditorUnconfigured(tester, userService);

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('username dialog')), findsOneWidget);
    });

    testWidgets('opens name dialog not if username exists', (tester) async {
      await pumpActionEditorConfigured(tester);

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('username dialog')), findsNothing);
    });

    testWidgets('creates action with new username', (tester) async {
      var userService = UserServiceMock();
      when(userService.user)
          .thenAnswer((_) => Stream.value(User(13, null, Colors.red)));
      var fired = false;
      await pumpActionEditorUnconfigured(tester, userService,
          onFinish: (_) => fired = true);

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
      await pumpActionEditorUnconfigured(tester, userService,
          onFinish: (_) => fired = true);

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('username dialog')), findsOneWidget);

      await tester.tap(find.byKey(Key('username dialog cancel button')));
      await tester.pumpAndSettle();

      verifyNever(userService.updateUsername('Karl Marx'));
      expect(fired, isFalse);
      expect(find.byKey(Key('username dialog')), findsNothing);
      expect(find.byKey(Key('action creator')), findsNothing);
      expect(find.text(ActionData.testDaten().terminDetails.kontakt),
          findsOneWidget);
    });
  });
}

_pumpNavigation(WidgetTester tester) async {
  await tester.pumpWidget(MultiProvider(
      providers: [
        Provider<AbstractTermineService>.value(value: _terminService),
        Provider<StorageService>.value(value: _storageService),
        Provider<AbstractListLocationService>(
            create: (context) => _listLocationService),
        Provider<AbstractStammdatenService>.value(value: _stammdatenService),
        Provider<AbstractPushSendService>.value(value: _pushService),
        Provider<AbstractUserService>.value(value: _userService),
        Provider<ChatMessageService>.value(value: _chatService),
      ],
      child: MaterialApp(
        home: Navigation(),
      )));
  await tester.pumpAndSettle();
}

_pumpActionPage(WidgetTester tester) async {
  await tester.pumpWidget(MultiProvider(
      providers: [
        Provider<AbstractTermineService>.value(value: _terminService),
        Provider<StorageService>.value(value: _storageService),
        Provider<AbstractListLocationService>(
            create: (context) => _listLocationService),
        Provider<AbstractStammdatenService>.value(value: _stammdatenService),
        Provider<AbstractUserService>.value(value: _userService),
        Provider<PushSendService>.value(value: _pushService),
        Provider<ChatMessageService>.value(value: _chatService),
      ],
      child: MaterialApp(
        home: TermineSeite(),
      )));
  await tester.pumpAndSettle();
}

Future _openActionCreator(WidgetTester tester) async {
  await _pumpNavigation(tester);
  await tester.pumpAndSettle();

  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('action creator navigation button')));
  await tester.pumpAndSettle();
}

Future _openActionEditor(WidgetTester tester) async {
  await _pumpActionPage(tester);
  // Warten bis asynchron Termine geladen wurden
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(Key('action card')).first);
  await tester.pump();
  await tester.tap(find.byKey(Key('action edit button')));
  await tester.pump();
}
