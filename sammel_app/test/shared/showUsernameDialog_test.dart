import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/showUsernameDialog.dart';

import 'Mocks.dart';
import 'TestdatenVorrat.dart';

void main() {
  var user = karl();
  user.name = null;

  bool result;
  var userService = UserServiceMock();

  setUpUI((tester) async {
    result = null;

    await tester.pumpWidget(Provider<AbstractUserService>(
        create: (_) => userService,
        child: MaterialApp(home: Material(
          child: Builder(
            builder: (BuildContext context) {
              return Center(
                  child: RaisedButton(
                      child: const Text('X'),
                      onPressed: () async => result = await showUsernameDialog(
                          context: context, user: user)));
            ***REMOVED***,
          ),
        ))));

    reset(userService);
    when(userService.updateUsername(any)).thenAnswer((_) async => user);
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

  testUI('Fertig calls userSerivice and returns true', (tester) async {
    await openDialog(tester);

    await tester.enterText(
        find.byKey(Key('user name input')), 'Mein neuer Name');
    await tester.pump();
    await tester.tap(find.byKey(Key('username dialog finish button')));
    await tester.pump();

    verify(userService.updateUsername('Mein neuer Name')).called(1);
    expect(result, isTrue);
  ***REMOVED***);

  testUI('Fertig returns false on UserService error', (tester) async {
    when(userService.updateUsername(any)).thenThrow(Error());
    await openDialog(tester);

    await tester.enterText(
        find.byKey(Key('user name input')), 'Mein neuer Name');
    await tester.pump();
    await tester.tap(find.byKey(Key('username dialog finish button')));
    await tester.pump();

    expect(result, isFalse);
  ***REMOVED***);

  testUI('Abbrechen returns does not call UserService and returns false',
      (tester) async {
    await openDialog(tester);

    await tester.enterText(
        find.byKey(Key('user name input')), 'Mein neuer Name');
    await tester.pump();
    await tester.tap(find.byKey(Key('username dialog cancel button')));
    await tester.pump();

    verifyNever(userService.updateUsername(any));
    expect(result, isFalse);
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
