import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:sammel_app/services/AuthFehler.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/RestFehler.dart';

import '../shared/mocks.trainer.dart';
import '../shared/mocks.mocks.dart';

void main() {
  trainTranslation(MockTranslations());

  setUp(() {
    ErrorService.errorQueue = [];
    ErrorService.setContext(null);
    ErrorService.displayedTypes = [];
  });

  group('pushMessage', () {
    test('stores error message when waiting for build context', () {
      ErrorService.pushError('Titel', 'Nachricht');
      ErrorService.pushError('Titel', 'Nachricht');
      ErrorService.pushError('Titel', 'Nachricht');

      expect(ErrorService.errorQueue.length, 3);
    });

    testUI('shows error message immediately with build context',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: Builder(builder: (BuildContext context) {
            ErrorService.setContext(context);
            return Center(
              child: ElevatedButton(
                  key: Key('starter'),
                  child: const Text('Starter'),
                  onPressed: () async => await ErrorService.showErrorDialog(
                      'Titel', 'Nachricht',
                      key: Key('error dialog'))),
            );
          }),
        ),
      ));

      ErrorService.pushError('Titel', 'Nachricht');
      await tester.pumpAndSettle();

      expect(find.byKey(Key('error dialog')), findsOneWidget);
      expect(ErrorService.errorQueue, isEmpty);
    });
  });

  group('handleError', () {
    test('recognizes and handles AuthFehler', () {
      ErrorService.handleError(AuthFehler('Nachricht'), StackTrace.empty);

      expect(ErrorService.errorQueue.length, 1);
      expect(ErrorService.errorQueue[0][0],
          'Fehler bei Nutzer-Authentifizierung');
      expect(ErrorService.errorQueue[0][1],
          'Nachricht \n\nWenn du Hilfe brauchst, schreib uns doch einfach per Mail an app@dwenteignen.de');
    });

    test('recognizes and handles RestFehler', () {
      ErrorService.handleError(RestFehler('Nachricht'), StackTrace.empty);

      expect(ErrorService.errorQueue.length, 1);
      expect(ErrorService.errorQueue[0][0],
          'Bei der Kommunikation mit dem Server ist ein Fehler aufgetreten');
      expect(ErrorService.errorQueue[0][1],
          'Nachricht \n\nWenn du Hilfe brauchst, schreib uns doch einfach per Mail an app@dwenteignen.de');
    });

    test('recognizes and handles WrongResponseFormatException', () {
      ErrorService.handleError(
          WrongResponseFormatException('Nachricht'), StackTrace.empty);

      expect(ErrorService.errorQueue.length, 1);
      expect(ErrorService.errorQueue[0][0],
          'Bei der Kommunikation mit dem Server ist ein technischer Fehler aufgetreten');
      expect(ErrorService.errorQueue[0][1],
          'Nachricht \n\nWenn du Hilfe brauchst, schreib uns doch einfach per Mail an app@dwenteignen.de');
    });

    test('adds optional message to Error text', () {
      ErrorService.handleError(RestFehler('Nachricht.'), StackTrace.empty,
          context: 'Zus??tzliche Info.');

      expect(ErrorService.errorQueue.length, 1);
      expect(
          ErrorService.errorQueue[0][1],
          'Zus??tzliche Info. Nachricht. \n\n'
          'Wenn du Hilfe brauchst, schreib uns doch einfach per Mail an app@dwenteignen.de');
    });
  });

  group('showErrorDialog', () {
    setUpUI((WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: Builder(builder: (BuildContext context) {
            ErrorService.setContext(context);
            return Center(
              child: ElevatedButton(
                  key: Key('starter'),
                  child: const Text('Starter'),
                  onPressed: () async => await ErrorService.showErrorDialog(
                      'Titel', 'Nachricht',
                      key: Key('error dialog'))),
            );
          }),
        ),
      ));

      await tester.tap(find.byKey(Key('starter')));
      await tester.pumpAndSettle();
    });

    testUI('starts and shows data', (WidgetTester tester) async {
      expect(find.byKey(Key('error dialog')), findsOneWidget);
      expect(find.text('Titel'), findsOneWidget);
      expect(find.text('Nachricht'), findsOneWidget);
    });

    testUI('closes on close button', (WidgetTester tester) async {
      await tester.tap(find.byKey(Key('error dialog close button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('error dialog')), findsNothing);
    });
  });

  group('setContext', () {
    late BuildContext context;
    setUpUI((WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Material(
        child: Builder(builder: (BuildContext newContext) {
          context = newContext;
          return Placeholder();
        }),
      )));
    });

    testUI('shows dialog for every stored message',
        (WidgetTester tester) async {
      ErrorService.pushError('Titel1', 'Nachricht');
      ErrorService.pushError('Titel2', 'Nachricht');
      ErrorService.pushError('Titel3', 'Nachricht');

      ErrorService.setContext(context);
      await tester.pumpAndSettle();

      expect(find.text('Titel1'), findsOneWidget);
      expect(find.text('Titel2'), findsOneWidget);
      expect(find.text('Titel3'), findsOneWidget);
    });

    testUI('shows only one dialog for every stored message, when called twice',
        (WidgetTester tester) async {
      ErrorService.pushError('Titel1', 'Nachricht');
      ErrorService.pushError('Titel2', 'Nachricht');
      ErrorService.pushError('Titel3', 'Nachricht');

      ErrorService.setContext(context);
      ErrorService.setContext(context);
      await tester.pumpAndSettle();

      expect(find.text('Titel1'), findsOneWidget);
      expect(find.text('Titel2'), findsOneWidget);
      expect(find.text('Titel3'), findsOneWidget);
    });

    testUI('shows no dialog with empty queue', (WidgetTester tester) async {
      ErrorService.setContext(context);
      await tester.pumpAndSettle();

      expect(find.byKey(Key('error dialog')), findsNothing);
    });
  });
}
