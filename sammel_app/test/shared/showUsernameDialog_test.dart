import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/showUsernameDialog.dart';

import 'mocks.trainer.dart';
import 'TestdatenVorrat.dart';
import '../shared/mocks.mocks.dart';

void main() {
  trainTranslation(MockTranslations());

  String? result;
  var _userService = MockUserService();
  var hideHint = false;

  setUpUI((tester) async {
    result = null;
    reset(_userService);
    when(_userService.user)
        .thenAnswer((_) => Stream.value(karl()..name = null));
    when(_userService.updateUsername(any)).thenAnswer((_) async => karl());

    await tester.pumpWidget(Provider<AbstractUserService>(
        create: (_) => _userService,
        child: MaterialApp(home: Material(
          child: Builder(
            builder: (BuildContext context) {
              return Center(
                  child: RaisedButton(
                      child: const Text('X'),
                      onPressed: () async => result = await showUsernameDialog(
                          context: context, hideHint: hideHint)));
            ***REMOVED***,
          ),
        ))));
  ***REMOVED***);

  testUI('opens Username Dialog and shows Title, Hint and Input Field',
      (tester) async {
    await openDialog(tester);

    expect(find.text('Benutzer*in-Name'), findsOneWidget);
    expect(
        find.text(
            'Um diese Aktion auszuführen musst du dir einen Benutzer*in-Name geben'),
        findsOneWidget);
    expect(find.byKey(Key('user name input')), findsOneWidget);
  ***REMOVED***);

  testUI('hides Hint with flag true', (tester) async {
    hideHint = true;

    await openDialog(tester);

    expect(
        find.text(
            'Um diese Aktion auszuführen musst du dir einen Benutzer*in-Name geben'),
        findsNothing);
    hideHint = false;
  ***REMOVED***);

  testUI('Fertig calls userSerivice and returns true', (tester) async {
    await openDialog(tester);

    await tester.enterText(
        find.byKey(Key('user name input')), 'Mein neuer Name');
    await tester.pump();
    await tester.tap(find.byKey(Key('username dialog finish button')));
    await tester.pump();

    verify(_userService.updateUsername('Mein neuer Name')).called(1);
    expect(result, isNotNull);
  ***REMOVED***);

  testUI('Fertig returns false on UserService error', (tester) async {
    when(_userService.updateUsername(any)).thenThrow(Error());
    await openDialog(tester);

    await tester.enterText(
        find.byKey(Key('user name input')), 'Mein neuer Name');
    await tester.pump();
    await tester.tap(find.byKey(Key('username dialog finish button')));
    await tester.pump();

    expect(result, isNull);
  ***REMOVED***);

  testUI('Abbrechen returns does not call UserService and returns false',
      (tester) async {
    await openDialog(tester);

    await tester.enterText(
        find.byKey(Key('user name input')), 'Mein neuer Name');
    await tester.pump();
    await tester.tap(find.byKey(Key('username dialog cancel button')));
    await tester.pump();

    verifyNever(_userService.updateUsername(any));
    expect(result, isNull);
  ***REMOVED***);

  testUI('Fertig button validates against empty/blank', (tester) async {
    await openDialog(tester);
    var valid =
        (tester.state(find.byType(UsernameDialog)) as UsernameDialogState)
            .isValid;

    var fertigButtonFinder = find.byKey(Key('username dialog finish button'));

    expect(valid.call(), false);
    expect(find.byType(UsernameDialog), findsOneWidget);
    await tester.tap(fertigButtonFinder);
    await tester.pump();
    expect(find.byType(UsernameDialog), findsOneWidget);

    await tester.enterText(find.byKey(Key('user name input')), '     ');
    await tester.pump();

    await tester.tap(fertigButtonFinder);
    await tester.pump();
    expect(find.byType(UsernameDialog), findsOneWidget);

    expect(valid.call(), false);
    await tester.enterText(find.byKey(Key('user name input')), 'valider Name');
    await tester.pump();

    expect(valid.call(), true);
    await tester.tap(fertigButtonFinder);
    await tester.pump();
    expect(find.byType(UsernameDialog), findsNothing);
  ***REMOVED***);
***REMOVED***

Future openDialog(WidgetTester tester) async {
  await tester.tap(find.text('X'));
  await tester.pump();
***REMOVED***
