import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';

import '../model/Ort_test.dart';
import '../model/Termin_test.dart';
import '../shared/Mocks.dart';

final stammdatenService = StammdatenServiceMock();
final terminService = TermineServiceMock();
final listLocationService = ListLocationServiceMock();
final storageService = StorageServiceMock();

void main() {
  setUp(() {
    when(storageService.loadFilter()).thenAnswer((_) async => null);
    when(storageService.loadAllStoredActionIds()).thenAnswer((_) async => []);
    when(listLocationService.getActiveListLocations())
        .thenAnswer((_) async => []);
    when(terminService.ladeTermine(any)).thenAnswer((_) async => []);
  ***REMOVED***);

  testWidgets('TermineSeite opens CreateTerminDialog on click at menu button',
      (WidgetTester tester) async {
    await _pumpNavigation(tester);

    var nav = tester.state<NavigationState>(find.byKey(Key('navigation')));

    expect(nav.navigation, isNot(1));

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('action creator button')));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('action creator')), findsOneWidget);
    expect(nav.navigation, 1);
  ***REMOVED***);

  group('shows all data', () {
    setUp(() async {
      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
          ]);
      when(terminService.getTerminMitDetails(any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());

      when(storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [0]);
    ***REMOVED***);

    testWidgets('Type dialog opens correctly', (WidgetTester tester) async {
      await _openActionCreator(tester);

      expect(find.byKey(Key('type selection dialog')), findsNothing);

      await tester.tap(find.byKey(Key('open type selection dialog')));
      await tester.pump();

      expect(find.byKey(Key('type selection dialog')), findsOneWidget);
    ***REMOVED***);

    testWidgets('Type dialog shows correct typ', (WidgetTester tester) async {
      await _openActionCreator(tester);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action creator')));
      // ignore: invalid_use_of_protected_member
      action_data.setState(() {
        action_data.action.typ = TerminTestDaten.einTermin().typ;
        action_data.validateAllInput();
      ***REMOVED***);
      await tester.pump();
      expect(
          find.descendant(
              of: find.byType(ActionEditor), matching: find.text('Sammeln')),
          findsOneWidget);
    ***REMOVED***);

    testWidgets('Type dialog shows correct no typ',
        (WidgetTester tester) async {
      await _openActionCreator(tester);

      expect(find.byKey(Key('action creator')), findsOneWidget);
      expect(
          find.descendant(
              of: find.byKey(Key('action creator')),
              matching: find.text('Wähle die Art der Aktion')),
          findsOneWidget);
    ***REMOVED***);

    testWidgets('Zeitraum dialog opens correctly', (WidgetTester tester) async {
      await _openActionCreator(tester);
      expect(find.byKey(Key('from time picker')), findsNothing);
      await tester.tap(find.byKey(Key('open time span dialog')));
      await tester.pump();
      expect(find.byKey(Key('from time picker')), findsOneWidget);
    ***REMOVED***);

    testWidgets('Zeitraum is correctly shown', (WidgetTester tester) async {
      await _openActionCreator(tester);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action creator')));
      expect(find.text('von 12:05 bis 13:09'), findsNothing);
      TimeOfDay von = TimeOfDay(hour: 12, minute: 5);
      TimeOfDay bis = TimeOfDay(hour: 13, minute: 9);
      // ignore: invalid_use_of_protected_member
      action_data.setState(() {
        action_data.action.von = von;
        action_data.action.bis = bis;
        action_data.validateAllInput();
      ***REMOVED***);
      await tester.pump();
      expect(find.text('von 12:05 bis 13:09'), findsOneWidget);
    ***REMOVED***);

    testWidgets('No Zeitraum is correctly shown', (WidgetTester tester) async {
      await _openActionCreator(tester);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action creator')));
      // ignore: invalid_use_of_protected_member
      action_data.setState(() {
        action_data.action.von = null;
        action_data.action.bis = null;
        action_data.validateAllInput();
      ***REMOVED***);
      await tester.pump();
      expect(find.text('Wähle eine Uhrzeit'), findsOneWidget);
    ***REMOVED***);

    testWidgets('Location dialog opens correctly', (WidgetTester tester) async {
      await _openActionCreator(tester);
      when(stammdatenService.ladeOrte()).thenAnswer((_) async => [goerli()]);
      expect(find.byKey(Key('Location Picker')), findsNothing);
      await tester.tap(find.byKey(Key('Open location dialog')));
      await tester.pump();
      expect(find.byKey(Key('Location Picker')), findsOneWidget);
    ***REMOVED***);

    testWidgets('Location dialog are correctly shown',
        (WidgetTester tester) async {
      await _openActionCreator(tester);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action creator')));
      expect(find.text("in Görlitzer Park und Umgebung"), findsNothing);
      when(stammdatenService.ladeOrte()).thenAnswer((_) async => [goerli()]);
      // ignore: invalid_use_of_protected_member
      action_data.setState(() {
        action_data.action.ort = goerli();
        action_data.validateAllInput();
      ***REMOVED***);
      await tester.pumpAndSettle();
      expect(find.text("in Görlitzer Park und Umgebung"), findsOneWidget);
    ***REMOVED***);

    testWidgets('changing kontakt is correctly shown',
        (WidgetTester tester) async {
      await _openActionCreator(tester);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action creator')));
      // ignore: invalid_use_of_protected_member
      action_data.setState(() {
        action_data.action.terminDetails.kontakt = 'test1';
        action_data.validateAllInput();
      ***REMOVED***);
      await tester.pump();
      expect(find.text('test1'), findsOneWidget);
    ***REMOVED***);

    testWidgets('changing treffpunkt is correctly shown',
        (WidgetTester tester) async {
      await _openActionCreator(tester);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action creator')));
      // ignore: invalid_use_of_protected_member
      action_data.setState(() {
        action_data.action.terminDetails.treffpunkt = 'test1';
        action_data.action.coordinates = LatLng(52.5170365, 13.3888599);
        action_data.validateAllInput();
      ***REMOVED***);
      await tester.pump();
      expect(find.text('Treffpunkt: test1'), findsOneWidget);
    ***REMOVED***);

    testWidgets('venue decription w/o coordinates is not displayed',
        (WidgetTester tester) async {
      await _openActionCreator(tester);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action creator')));
      // ignore: invalid_use_of_protected_member
      action_data.setState(() {
        action_data.action.terminDetails.treffpunkt = 'test1';
        action_data.validateAllInput();
      ***REMOVED***);
      await tester.pump();
      expect(find.text('Gib einen Treffpunkt an'), findsOneWidget);
    ***REMOVED***);

    testWidgets('changing beschreibung is correctly shown',
        (WidgetTester tester) async {
      await _openActionCreator(tester);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action creator')));
      // ignore: invalid_use_of_protected_member
      action_data.setState(() {
        action_data.action.terminDetails.kommentar = 'test1';
        action_data.validateAllInput();
      ***REMOVED***);
      await tester.pump();
      expect(find.text('Beschreibung: test1'), findsOneWidget);
    ***REMOVED***);

    testWidgets('changing tage is correctly shown',
        (WidgetTester tester) async {
      await _openActionCreator(tester);
      ActionEditorState action_data =
          tester.state(find.byKey(Key('action creator')));
      // ignore: invalid_use_of_protected_member
      action_data.setState(() {
        action_data.action.tage = [DateTime(2019, 12, 1)];
        action_data.validateAllInput();
      ***REMOVED***);
      await tester.pump();
      expect(find.text('am 01.12.,'), findsOneWidget);
    ***REMOVED***);

    testWidgets('no tage selection is correctly shown',
        (WidgetTester tester) async {
      await _openActionCreator(tester);

      expect(find.text("Wähle einen Tag"), findsOneWidget);
    ***REMOVED***);

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
    ***REMOVED***);

    testWidgets('Cancel button closes correctly', (WidgetTester tester) async {
      await _openActionCreator(tester);
      await tester.tap(find.byKey(Key('action editor cancel button')));
      await tester.pumpAndSettle();
      verifyNever(terminService.createTermin(any, any));
    ***REMOVED***);

    testWidgets('Termin adds a day if bis before von',
        (WidgetTester tester) async {
      await _openActionEditor(tester);
      ActionEditorState actionData =
          tester.state(find.byKey(Key('action editor')));
      actionData.action.tage = [DateTime(2019, 12, 1)];
      actionData.action.von = TimeOfDay(hour: 10, minute: 32);
      actionData.action.bis = TimeOfDay(hour: 10, minute: 31);
      List<Termin> newTermine = actionData.generateActions();
      expect(newTermine[0].ende.day, 2);
    ***REMOVED***);

    testWidgets('shows motivation text in ActionCreator',
        (WidgetTester tester) async {
      await _openActionCreator(tester);

      expect(find.byKey(Key('motivation text')), findsOneWidget);
    ***REMOVED***);

    testWidgets('shows no motivation text in ActionEditor',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      expect(find.byKey(Key('motivation text')), findsNothing);
    ***REMOVED***);
  ***REMOVED***);

  group('validates', () {
    var actionEditor;
    setUp(() {
      actionEditor = ActionEditorState(TerminTestDaten.einTerminMitDetails());
    ***REMOVED***);

    test('all inputs valid with correct values', () {
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['all'], ValidationState.ok);
    ***REMOVED***);

    test('von', () {
      actionEditor.action.von = null;
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['von'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);
    ***REMOVED***);

    test('bis', () {
      actionEditor.action.bis = null;
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['bis'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);
    ***REMOVED***);

    test('ort', () {
      actionEditor.action.ort = null;
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['ort'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);
    ***REMOVED***);

    test('typ', () {
      actionEditor.action.typ = null;
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['typ'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);

      actionEditor.action.typ = '';
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['typ'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);
    ***REMOVED***);

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
    ***REMOVED***);

    test('description', () {
      actionEditor.action.terminDetails.kommentar = null;
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['kommentar'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);

      actionEditor.action.terminDetails.kommentar = '';
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['kommentar'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);
    ***REMOVED***);

    test('contact', () {
      actionEditor.action.terminDetails.kontakt = null;
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['kontakt'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);

      actionEditor.action.terminDetails.kontakt = '';
      actionEditor.validateAllInput();

      expect(actionEditor.action.validated['kontakt'], ValidationState.error);
      expect(actionEditor.action.validated['all'], ValidationState.error);
    ***REMOVED***);

    testWidgets('triggers validation on Fertig button',
        (WidgetTester tester) async {
      var actionEditor =
          ActionEditor(initAction: TerminTestDaten.einTerminMitDetails());
      await tester.pumpWidget(MaterialApp(home: actionEditor));
      ActionEditorState state = tester.state(find.byWidget(actionEditor));

      expect(state.action.validated['all'], ValidationState.ok);

      state.action = ActionData(
          TimeOfDay.now(),
          TimeOfDay.now(),
          nordkiez(),
          '',
          [DateTime.now()],
          TerminDetails('treffpunkt', 'kommentar', 'kontakt'),
          LatLng(52.48993, 13.46839));

      when(terminService.createTermin(any, any))
          .thenAnswer((_) async => TerminTestDaten.einTermin());
      await tester.tap(find.byKey(Key('action editor finish button')));

      expect(state.action.validated['all'], ValidationState.error);
    ***REMOVED***);
  ***REMOVED***);
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
    ***REMOVED***);

    test('returns location, if given and no coordinates', () {
      var actionData = ActionData(null, null,
          Ort(0, 'Bezirk', 'Ort', 52.1, 43.1), null, null, null, null);

      expect(
          ActionEditorState.determineMapCenter(actionData), LatLng(52.1, 43.1));
    ***REMOVED***);

    test('returns null, if neither coordinates nor location given', () {
      var actionData = ActionData(null, null, null, null, null, null, null);

      expect(ActionEditorState.determineMapCenter(actionData), null);

      actionData = ActionData(null, null, Ort(0, 'Bezirk', 'Ort', null, null),
          null, null, null, null);

      expect(ActionEditorState.determineMapCenter(actionData), null);
    ***REMOVED***);
  ***REMOVED***);
  group('generateActions generates actions', () {
    setUp(() async {
      when(terminService.ladeTermine(any)).thenAnswer((_) async => [
            TerminTestDaten.einTermin(),
          ]);
      when(terminService.getTerminMitDetails(any))
          .thenAnswer((_) async => TerminTestDaten.einTerminMitDetails());

      when(storageService.loadAllStoredActionIds())
          .thenAnswer((_) async => [0]);
    ***REMOVED***);

    testWidgets('with old start, w/o changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = state.generateActions()[0];

      expect(action.beginn, TerminTestDaten.einTermin().beginn);
    ***REMOVED***);

    testWidgets('with old end, w/o changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = state.generateActions()[0];

      expect(action.ende, TerminTestDaten.einTermin().ende);
    ***REMOVED***);

    testWidgets('with old location, w/o changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = state.generateActions()[0];

      expect(action.ort.equals(TerminTestDaten.einTermin().ort), true);
    ***REMOVED***);

    testWidgets('with old type, w/o changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = state.generateActions()[0];

      expect(action.typ, TerminTestDaten.einTermin().typ);
    ***REMOVED***);

    testWidgets('with old id', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = state.generateActions()[0];

      expect(action.id, TerminTestDaten.einTermin().id);
    ***REMOVED***);

    testWidgets('with old contact, w/o changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = state.generateActions()[0];

      expect(action.details.kontakt,
          TerminTestDaten.einTerminMitDetails().details.kontakt);
    ***REMOVED***);

    testWidgets('with old description, w/o changes',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = state.generateActions()[0];

      expect(action.details.kommentar,
          TerminTestDaten.einTerminMitDetails().details.kommentar);
    ***REMOVED***);

    testWidgets('with old venue description, w/o changes',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = state.generateActions()[0];

      expect(action.details.treffpunkt,
          TerminTestDaten.einTerminMitDetails().details.treffpunkt);
    ***REMOVED***);

    testWidgets('with old coordinates, w/o changes',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      Termin action = state.generateActions()[0];

      expect(action.latitude, TerminTestDaten.einTerminMitDetails().latitude);
      expect(action.longitude, TerminTestDaten.einTerminMitDetails().longitude);
    ***REMOVED***);

    testWidgets('with new start, w/ changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      var now = TimeOfDay.now();
      state.action.von = now;
      Termin action = state.generateActions()[0];

      expect(action.beginn, DateTime(2019, 11, 04, now.hour, now.minute));
    ***REMOVED***);

    testWidgets('with new end, w/ changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      var now = TimeOfDay(hour: 23, minute: 0);
      state.action.bis = now;
      Termin action = state.generateActions()[0];

      expect(action.ende, DateTime(2019, 11, 04, now.hour, now.minute));
    ***REMOVED***);

    testWidgets('with new location, w/ changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      state.action.ort = nordkiez();
      Termin action = state.generateActions()[0];

      expect(action.ort.equals(nordkiez()), true);
    ***REMOVED***);

    testWidgets('with new type, w/ changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      state.action.typ = 'Neuer Typ';
      Termin action = state.generateActions()[0];

      expect(action.typ, 'Neuer Typ');
    ***REMOVED***);

    testWidgets('with new contact, w/ changes', (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      state.action.terminDetails.kontakt = 'Neuer Kontakt';
      Termin action = state.generateActions()[0];

      expect(action.details.kontakt, 'Neuer Kontakt');
    ***REMOVED***);

    testWidgets('with new description, w/ changes',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      state.action.terminDetails.kommentar = 'Neuer Kommentar';
      Termin action = state.generateActions()[0];

      expect(action.details.kommentar, 'Neuer Kommentar');
    ***REMOVED***);

    testWidgets('with new venue description, w/ changes',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      state.action.terminDetails.treffpunkt = 'Neuer Treffpunkt';
      Termin action = state.generateActions()[0];

      expect(action.details.treffpunkt, 'Neuer Treffpunkt');
    ***REMOVED***);

    testWidgets('with new coordinates, w/ changes',
        (WidgetTester tester) async {
      await _openActionEditor(tester);

      ActionEditorState state = tester.state(find.byType(ActionEditor));
      state.action.coordinates = LatLng(52.5170365, 13.3888599);
      Termin action = state.generateActions()[0];

      expect(action.latitude, 52.5170365);
      expect(action.longitude, 13.3888599);
    ***REMOVED***);
  ***REMOVED***);
  group('finish button', () {
    Future<ActionEditorState> pumActionEditor(WidgetTester tester,
        {Function onFinish***REMOVED***) async {
      onFinish = onFinish ?? (_) {***REMOVED***

      var actionEditor = ActionEditor(onFinish: onFinish);
      await tester.pumpWidget(Provider<AbstractStammdatenService>.value(
          value: stammdatenService, child: MaterialApp(home: actionEditor)));

      ActionEditorState state = tester.state(find.byWidget(actionEditor));
      state.action = ActionData.testDaten();
      await tester.pumpAndSettle();
      return state;
    ***REMOVED***

    testWidgets('fires onFinish', (WidgetTester tester) async {
      bool fired = false;
      await pumActionEditor(tester, onFinish: (_) => fired = true);

      expect(fired, isFalse);

      await tester.tap(find.byKey(Key('action editor finish button')));
      await tester.pumpAndSettle();

      expect(fired, isTrue);
    ***REMOVED***);

    testWidgets('clears data', (WidgetTester tester) async {
      var state = await pumActionEditor(tester);

      expect(state.action.von, isNotNull);
      expect(state.action.bis, isNotNull);
      expect(state.action.ort, isNotNull);
      expect(state.action.typ, isNotNull);
      expect(state.action.tage, isNotEmpty);
      expect(state.action.terminDetails.kommentar, isNotEmpty);
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
      expect(state.action.terminDetails.kommentar, isEmpty);
      expect(state.action.terminDetails.kontakt, isEmpty);
      expect(state.action.terminDetails.treffpunkt, isEmpty);
      expect(state.action.coordinates, isNull);
    ***REMOVED***);

    testWidgets('cancel clears data', (WidgetTester tester) async {
      var state = await pumActionEditor(tester);

      expect(state.action.von, isNotNull);
      expect(state.action.bis, isNotNull);
      expect(state.action.ort, isNotNull);
      expect(state.action.typ, isNotNull);
      expect(state.action.tage, isNotEmpty);
      expect(state.action.terminDetails.kommentar, isNotEmpty);
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
      expect(state.action.terminDetails.kommentar, isEmpty);
      expect(state.action.terminDetails.kontakt, isEmpty);
      expect(state.action.terminDetails.treffpunkt, isEmpty);
      expect(state.action.coordinates, isNull);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

_pumpNavigation(WidgetTester tester) async {
  await tester.pumpWidget(MultiProvider(
      providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService),
        Provider<AbstractListLocationService>(
            create: (context) => listLocationService),
        Provider<AbstractStammdatenService>.value(value: stammdatenService)
      ],
      child: MaterialApp(
        home: Navigation(),
      )));
  await tester.pumpAndSettle();
***REMOVED***

_pumpActionPage(WidgetTester tester) async {
  await tester.pumpWidget(MultiProvider(
      providers: [
        Provider<AbstractTermineService>.value(value: terminService),
        Provider<StorageService>.value(value: storageService),
        Provider<AbstractListLocationService>(
            create: (context) => listLocationService),
        Provider<AbstractStammdatenService>.value(value: stammdatenService)
      ],
      child: MaterialApp(
        home: TermineSeite(),
      )));
  await tester.pumpAndSettle();
***REMOVED***

Future _openActionCreator(WidgetTester tester) async {
  await _pumpNavigation(tester);
  await tester.pumpAndSettle();

  await tester.tap(find.byType(IconButton));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('action creator button')));
  await tester.pumpAndSettle();
***REMOVED***

Future _openActionEditor(WidgetTester tester) async {
  await _pumpActionPage(tester);
  // Warten bis asynchron Termine geladen wurden
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(Key('action card')).first);
  await tester.pump();
  await tester.tap(find.byKey(Key('action edit button')));
  await tester.pump();
***REMOVED***
